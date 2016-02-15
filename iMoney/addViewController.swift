//
//  addViewController.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-01-17.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class addViewController: UIViewController {

    weak var delegate: addViewControllerDelegate?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var moneyField: UITextField!
    @IBOutlet weak var countField: UITextField!
    @IBOutlet weak var vibrancyView: UIView!
    
    var cate: String!
    var money: NSDecimalNumber!
    var date: NSDate!
    var name: String!
    var count = 1
    
    var edit = false
    var indexOfEditingItem: Int?
    var nameOfCate: [String]!
    
    private var nameLabel: UILabel?
    private var priceLabel: UILabel?
    private var countLabel: UILabel?
    

    @IBOutlet weak var cancelButton: UIButton!
    var datePicker: ActionSheetDatePicker!
    private var Context = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if date == nil {
            dateField.text = NSDate().dateOnly
        } else {
            dateField.text = "\(date.dateOnly)"
        }
        categoryField.text = cate ?? ""
        nameField.text = name ?? ""
        moneyField.text = "\(money)" == "nil" ? "":"\(money)"
        countField.text = edit ? "\(count)":""
        
        transparentNavigationBar()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animateCancelButton(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func transparentNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
    }
    
    private func animateCancelButton(clockWise: Bool) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        guard let layer = cancelButton.imageView?.layer else {return}
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.fromValue = 0
        animation.toValue = clockWise ? (M_PI/2) : (-3 * M_PI / 4)
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        layer.addAnimation(animation, forKey: "rotationAnimation")
    }
    
    @IBAction func CancelButtonPressed(sender: AnyObject) {
        nameField.delegate = nil
        moneyField.delegate = nil
        animateCancelButton(true)
        
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) { [unowned self] _ in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func DoneButtonPressed(sender: AnyObject) {
        resignAllFirstResponder()
        if name == nil {
            if let text = nameField.text?.trim(by: " ") {
                name = text
            }
        }
        if money == nil {
            if let text = moneyField.text {
                let numFmt = NSNumberFormatter()
                numFmt.generatesDecimalNumbers = true
                money = numFmt.numberFromString(text) as? NSDecimalNumber ?? 0
            }
        }
        if countField.text == "" {
            count = 1
            countField.text = "1"
        } else {
            count = Int.init(countField.text!) ?? 1
        }
        if date == nil || cate == nil || name == nil || money == nil {
            let alert = UIAlertController(title: "Warning", message: "Information is not filled", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            if let newItem = iMoney.Item.initialize(name: name, category: cate, date: date, money: money, count: count) {
                delegate?.newItemDidAdd(newItem, editingMode: edit, at: indexOfEditingItem)// Need to implement
            }
            dismissViewControllerAnimated(true, completion:  nil)
        }
    }
    
    private func resignAllFirstResponder() {
        nameField.resignFirstResponder()
        moneyField.resignFirstResponder()
        countField.resignFirstResponder()
    }

    @IBAction func touchDownView(sender: AnyObject) {
        resignAllFirstResponder()
    }
    @IBAction func dateFieldTouched() {
        resignAllFirstResponder()
        dateField.inputView = UIView()
        let datePicker = ActionSheetDatePicker(title: "Date", datePickerMode: .Date, selectedDate: NSDate(), doneBlock: {[unowned self] (picker, value, index) -> Void in
            self.date = (value as! NSDate).removeTime()
            self.dateField.text = self.date.dateOnly
            }, cancelBlock: { (picker) -> Void in
                return
            }, origin: dateField)
        datePicker.showActionSheetPicker()
    }
    
    @IBAction func cateFieldTouched() {
        resignAllFirstResponder()
        categoryField.inputView = UIView()
        let catePicker = ActionSheetStringPicker(title: "Category", rows: nameOfCate, initialSelection: 0, doneBlock: {[unowned self] (picker, index, value)  -> Void in
            self.cate = self.nameOfCate[index]
            self.categoryField.text = self.cate
            }, cancelBlock: { (picker) -> Void in
                return
            }, origin: self.categoryField)
        
        catePicker.showActionSheetPicker()
    }
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: - Add View Delegate
protocol addViewControllerDelegate: class {
    func newItemDidAdd(item: iMoney.Item, editingMode: Bool, at index: Int?)
}

// MARK: - Extension of NSDate
extension NSDate {
    func removeTime() -> NSDate {
        let dateFmt = NSDateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let dateString = dateFmt.stringFromDate(self)
        return dateFmt.dateFromString(dateString)!
    }
    
    var dateOnly: String {
        let dateFmt = NSDateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        return dateFmt.stringFromDate(self)
    }
}

// MARK: - TextField override
extension UITextField {
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        let border = CALayer()
        let width = CGFloat(0.7)
        border.borderColor = UIColor.grayColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width + 10, height: self.frame.size.height)
        
        border.borderWidth = width
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

// MARK: - TextField delegate
extension addViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        moveDownLabels(of: textField)
    }
    
    private func moveDownLabels(of textField: UITextField) {
        if let labelForField = priceLabel ?? nameLabel ?? countLabel where textField.text == "" {
            UIView.animateWithDuration(0.15, animations: {
                _ in
                labelForField.center.y += 30
                }) {
                    [unowned self] _ in
                    textField.placeholder = labelForField.text
                    labelForField.removeFromSuperview()
                    if labelForField === self.priceLabel {
                        self.priceLabel = nil
                    } else if labelForField === self.nameLabel {
                        self.nameLabel = nil
                    } else if labelForField === self.countLabel {
                        self.countLabel = nil
                    }
            }
        }
    }
    
    private func moveUpLabels(of textField: UITextField) {
        let label = UILabel(frame: textField.frame)
//        label.center.x -= 10
        label.font = UIFont.systemFontOfSize(20, weight: 0.3) //UIFont.systemFontOfSize(20)
        label.textColor = UIColor.whiteColor()
        label.text = textField.placeholder
        vibrancyView.addSubview(label)
        let identifier = textField.tag
        textField.placeholder = ""
        UIView.animateWithDuration(0.15, animations: {
            () -> Void in
            label.center.y = label.center.y - 30
            }) {
                [unowned self] _ in
                switch identifier {
                case 0: self.nameLabel = label
                case 1: self.priceLabel = label
                case 2: self.countLabel = label
                default: break
                }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        moveUpLabels(of: textField)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            if !textField.text!.isEmpty {
                if setFields(by: textField.text!.trim(by: " ")) == false {
                    moneyField.becomeFirstResponder()
                }
            }
        }
        return true
    }
    
    private func setFields(by name: String) -> Bool {
        let list = buyList()
        guard let item = list.searchItem(by: name) else {
            return false
        }
        nameField.text = item.name
        moveUpLabels(of: moneyField)
        moneyField.text = "\(item.price!.price!)"
        money = item.price!.price!
        moveUpLabels(of: countField)
        count = 1
        countField.text = "1"
        cate = item.category?.name!
        categoryField.text = "\(item.category!.name!)"
        return true
    }
}


// MARK: - Extension of String
private extension String {
    mutating func trim(by component: String) -> String {
        if self.hasSuffix(component) && !self.isEmpty {
            self.removeAtIndex(self.endIndex.predecessor())
            self.trim(by: component)
        }
        return self
    }
}
