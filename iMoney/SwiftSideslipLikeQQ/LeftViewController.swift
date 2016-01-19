//
//  LeftViewController.swift
//  SwiftSideslipLikeQQ
//
//  Created by JohnLui on 15/4/11.
//  Copyright (c) 2015年 com.lvwenhan. All rights reserved.
//

import UIKit

// 侧滑菜单 View Controller
class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var titlesDictionary: [String]!
    var itemList: buyList!
    
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var heightLayoutConstraintOfSettingTableView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView()
        
        heightLayoutConstraintOfSettingTableView.constant = Common.screenHeight < 500 ? Common.screenHeight * (568 - 221) / 568 : 347
        self.view.frame = CGRectMake(0, 0, 320 * 0.78, Common.screenHeight)
        
        itemList = buyList()
        titlesDictionary = itemList.namesOfCategories
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 处理点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = Common.rootViewController
        viewController.homeViewController.currentCate = titlesDictionary[indexPath.row]
        viewController.homeViewController.navigationItem.title = titlesDictionary[indexPath.row]
        Common.contactsVC.view.removeFromSuperview()
//        viewController.mainTabBarController.tabBar.hidden = true
//        viewController.mainTabBarController.selectedIndex = 0
        viewController.showHome()
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesDictionary == nil ? 0:titlesDictionary.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("leftViewCell", forIndexPath: indexPath) 
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.text = titlesDictionary[indexPath.row]
        
        return cell
    }

    @IBAction func addCategories(sender: UIButton) {
        let alert = UIAlertController(title: "Add", message: "Input a name for the category", preferredStyle: .Alert)
        var name: String! = ""
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Input name here"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { [unowned self] action in
            let textField = alert.textFields![0]
            name = textField.text
            guard let result = self.itemList.addCategory(by: name) else {
                let fail = UIAlertController(title: "Error", message: "Some Error Occured", preferredStyle: .Alert)
                fail.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(fail, animated: true, completion: nil)
                return
            }
            if result == false {
                let sameName = UIAlertController(title: "Warning", message: "There has been some category with the same name", preferredStyle: .Alert)
                sameName.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(sameName, animated: true, completion: nil)
                return
            }
            self.renewCategories()
            self.tableView.reloadData()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
       
    }
    
    private func renewCategories() {
        titlesDictionary = itemList.namesOfCategories
    }
}

extension Array where Element: iMoney.Category {
    
}