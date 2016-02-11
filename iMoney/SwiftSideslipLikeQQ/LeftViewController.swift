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
        guard let cell = tableView.dequeueReusableCellWithIdentifier("leftViewCell", forIndexPath: indexPath) as? CategoryViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor.clearColor()
        cell.title = titlesDictionary[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let alert = UIAlertController(title: "Warning", message: "All the records in this category will be deleted!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { [unowned self] (action) -> Void in
                self.itemList.deleteCategory(by: self.titlesDictionary[indexPath.row])
                self.titlesDictionary.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return true
    }

    @IBAction func addCategories(sender: UIButton) {
        let viewController = Common.rootViewController
//        viewController.homeViewController.titleOfOtherPages = "Add Category"
        viewController.homeViewController.performSegueWithIdentifier("addCategory", sender: self)
        viewController.mainTabBarController.tabBar.hidden = true
        viewController.mainTabBarController.selectedIndex = 0
        Common.contactsVC.view.removeFromSuperview()
        viewController.showHome()
    }
    
    @IBAction func settingButtonPressed(sender: UIButton) {
        let viewController = Common.rootViewController
//        viewController.homeViewController.titleOfOtherPages = "Setting"
        viewController.homeViewController.performSegueWithIdentifier("showSetting", sender: self)
        viewController.mainTabBarController.tabBar.hidden = true
        viewController.mainTabBarController.selectedIndex = 0
        Common.contactsVC.view.removeFromSuperview()
        viewController.showHome()
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

