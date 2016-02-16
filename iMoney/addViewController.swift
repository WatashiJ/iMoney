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
    
    weak var delegate: addViewControllerDelegate?// Delegate, should be HomeViewController
    
    // MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var moneyField: UITextField!
    @IBOutlet weak var countField: UITextField!
    @IBOutlet weak var vibrancyView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var nameLabel: UILabel?
    private var priceLabel: UILabel?
    private var countLabel: UILabel?
    var datePicker: ActionSheetDatePicker!
    
    // MARK: modules
    var cate: String!
    var money: NSDecimalNumber!
    var date: NSDate!
    var name: String!
    var count = 1
    var nameOfCate: [String]!
    
    var edit = false // Switch determing if it's adding new item or modifying existing item
    var indexOfEditingItem: Int?// index of the modifying item
    
    // MARK: controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set different text depends on it's adding new item or modifying an existing item
        dateField.text = date == nil ? NSDate().dateOnly : "\(date.dateOnly)"
        date = date ?? NSDate().removeTime()
        categoryField.text = cate ?? ""
        nameField.text = name ?? ""
        moneyField.text = "\(money)" == "nil" ? "":"\(money)"
        countField.text = edit ? "\(count)":""
        
        self.navigationController?.transparentNavigationBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animateCancelButton(false)// Rotate the cancel button
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func animateCancelButton(clockWise: Bool) {// Rotate the cancel button
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")// Rotate around z axis, like normal 2D animation
        guard let layer = cancelButton.imageView?.layer else {return}// Get layer
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.fromValue = 0
        animation.toValue = clockWise ? (M_PI/2) : (-3 * M_PI / 4)// Clockwise will rotate back from X to 十
        animation.removedOnCompletion = false// Keep the view after ratation
        animation.fillMode = kCAFillModeForwards
        layer.addAnimation(animation, forKey: "rotationAnimation")// Animate
    }
    
    @IBAction func CancelButtonPressed(sender: AnyObject) {// Cancel button will dismiss the view and discard the info
        nameField.delegate = nil// The delegate pointing to nil will cause crash
        moneyField.delegate = nil
        countField.delegate = nil
        animateCancelButton(true)// Animate back
        
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))// Delay 0.3 sec for the animation
        dispatch_after(delay, dispatch_get_main_queue()) { [unowned self] _ in
            self.dismissViewControllerAnimated(true, completion: nil)// Dismiss the view
        }
    }
    
    @IBAction func DoneButtonPressed(sender: AnyObject) {// Done button will save information
        resignAllFirstResponder()// Close keyboard
        if name == nil {
            if let text = nameField.text?.trim(by: " ") {// Delete the last space of name
                name = text
            }
        }
        if let moneyText = moneyField.text {
            let numFmt = NSNumberFormatter()
            numFmt.generatesDecimalNumbers = true
            money = numFmt.numberFromString(moneyText) as? NSDecimalNumber ?? 0// Generate money, otherwise set to 0
        }
        if countField.text == "" {// Default value for count is 1
            count = 1
            countField.text = "1"
        } else {
            count = Int.init(countField.text!) ?? 1// Generate count from string, assign 1 to count if fails
        }
        if nameField.text!.isEmpty || moneyField.text!.isEmpty {
            // All fields need to be filled, otherwise send an alert
            let alert = UIAlertController(title: "Warning", message: "Information is not filled", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {// Everything is fine, then
            if let newItem = iMoney.Item.initialize(name: name, category: cate, date: date, money: money, count: count) {
                // Create a new item
                delegate?.newItemDidAdd(newItem, editingMode: edit, at: indexOfEditingItem)// Send back to delegate
            }
            dismissViewControllerAnimated(true, completion:  nil)// Dismiss the view
        }
    }
    
    private func resignAllFirstResponder() {// Close keyboard
        nameField.resignFirstResponder()
        moneyField.resignFirstResponder()
        countField.resignFirstResponder()
    }

    @IBAction func dateFieldTouched() {// Touched date field
        resignAllFirstResponder()// Close keyboard
        dateField.inputView = UIView()// Prevent the keyboard pop up
        let datePicker = ActionSheetDatePicker(title: "Date", datePickerMode: .Date, selectedDate: NSDate(), doneBlock: {[unowned self] (picker, value, index) -> Void in
            self.date = (value as! NSDate).removeTime()// Only save date
            self.dateField.text = self.date.dateOnly// Set text
            }, cancelBlock: { (picker) -> Void in
                return
            }, origin: dateField)
        datePicker.showActionSheetPicker()// Show picker
    }
    
    @IBAction func cateFieldTouched() {// Touched the cate field
        resignAllFirstResponder()// Close keyboard
        categoryField.inputView = UIView()// Prevent the keyboard pop up
        let catePicker = ActionSheetStringPicker(title: "Category", rows: nameOfCate, initialSelection: 0, doneBlock: {[unowned self] (picker, index, value)  -> Void in
            self.cate = self.nameOfCate[index]
            self.categoryField.text = self.cate
            }, cancelBlock: { (picker) -> Void in
                return
            }, origin: self.categoryField)
        
        catePicker.showActionSheetPicker()
    }
}
// MARK: - Add View Delegate
protocol addViewControllerDelegate: class {
    func newItemDidAdd(item: iMoney.Item, editingMode: Bool, at index: Int?)
    // the working item, editingMode decides it's adding new item or modifying an existing one
}

// MARK: - Extension of NSDate
extension NSDate {
    func removeTime() -> NSDate {// Only save date
        let dateFmt = NSDateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"// Formatter
        let dateString = dateFmt.stringFromDate(self)// Get string
        return dateFmt.dateFromString(dateString)!// Get date back from string
    }
    
    var dateOnly: String {// Same as the function above, but it returns string
        let dateFmt = NSDateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        return dateFmt.stringFromDate(self)
    }
}

// MARK: - TextField override
extension UITextField {
    override public func awakeFromNib() {
        // Drew an underline below textfields
        super.awakeFromNib()
        
        let border = CALayer()// New layer
        let width = CGFloat(0.7)
        border.borderColor = UIColor.grayColor().CGColor// Colour
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width + 10, height: self.frame.size.height)// Set frame. y is the set the line
        
        border.borderWidth = width// the height of the line
        
        self.layer.addSublayer(border)// Add to sublayer
        self.layer.masksToBounds = true
    }
}

// MARK: - TextField delegate
extension addViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        moveDownLabels(of: textField)
    }
    
    private func moveDownLabels(of textField: UITextField) {// Move labels down
        if let labelForField = priceLabel ?? nameLabel ?? countLabel where textField.text == "" {// Find the current label
            UIView.animateWithDuration(0.15, animations: {// Animate
                _ in
                labelForField.center.y += 30// Move down
                }) {
                    [unowned self] _ in
                    textField.placeholder = labelForField.text// Reset the placeholder text
                    labelForField.removeFromSuperview()// Remove label
                    if labelForField === self.priceLabel {// Set the label to nil
                        self.priceLabel = nil
                    } else if labelForField === self.nameLabel {
                        self.nameLabel = nil
                    } else if labelForField === self.countLabel {
                        self.countLabel = nil
                    }
            }
        }
    }
    
    private func moveUpLabels(of textField: UITextField) {// Move up  the label
        let label = UILabel(frame: textField.frame)// Create a new label based on the textField
        label.font = UIFont.systemFontOfSize(20, weight: 0.3)// Set font
        label.textColor = UIColor.whiteColor()// Set colour
        label.text = textField.placeholder// Set text to the text of the placeholder
        vibrancyView.addSubview(label)// Add to vibracyView
        let identifier = textField.tag
        textField.placeholder = ""// Empty the placeholder
        UIView.animateWithDuration(0.15, animations: {// Animate
            () -> Void in
            label.center.y = label.center.y - 30// Move up
            }) {
                [unowned self] _ in
                switch identifier {// Set the pointer
                case 0: self.nameLabel = label
                case 1: self.priceLabel = label
                case 2: self.countLabel = label
                default: break
                }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {// Move up the label when the textfield starts being edited
        moveUpLabels(of: textField)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {// Check input
        if string == "\n" {// When enter is pressed
            textField.resignFirstResponder()// Close the keyboard
            if !textField.text!.isEmpty {// It can only be the name field
                if setFields(by: textField.text!.trim(by: " ")) == false {// If set field is false
                    moneyField.becomeFirstResponder()// Start inputing money
                }
            }
        }
        return true
    }
    
    private func setFields(by name: String) -> Bool {// Auto detection for items
        let list = buyList()
        guard let item = list.searchItem(by: name) else {// Search for the item
            return false
        }
        // Set all info about this item
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
    mutating func trim(by component: String) -> String {// Clear the last characters
        if self.hasSuffix(component) && !self.isEmpty {// If it has the substring and it's not empty
            self.removeAtIndex(self.endIndex.predecessor())// Clear the last one
            self.trim(by: component)// Recursion
        }
        return self
    }
}
