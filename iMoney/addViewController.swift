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
    
    var cate: String!
    var money: NSDecimalNumber!
    var date: NSDate!
    var name: String!
    
    var newItem: iMoney.Item!
    var numOfCate: Int!
    var nameOfCate: [String]!
    
    var datePicker: ActionSheetDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func DoneButtonPressed(sender: AnyObject) {
        if name == nil {
            if let text = nameField.text {
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
        if date == nil || cate == nil || name == nil || money == nil {
            let alert = UIAlertController(title: "Warning", message: "Information is not filled", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            if let newItem = iMoney.Item.initialize(name: name, category: cate, date: date, money: money) {
                delegate?.newItemDidAdd(newItem)// Need to implement
            }
            dismissViewControllerAnimated(true, completion:  nil)
        }
    }

    @IBAction func dateFieldTouched() {
        nameField.resignFirstResponder()
        moneyField.resignFirstResponder()
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
        nameField.resignFirstResponder()
        moneyField.resignFirstResponder()
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

protocol addViewControllerDelegate: class {
    func newItemDidAdd(item: iMoney.Item)
}

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