//
//  HomeViewController.swift
//  SwiftSideslipLikeQQ
//
//  Created by JohnLui on 15/4/10.
//  Copyright (c) 2015年 com.lvwenhan. All rights reserved.
//

import UIKit

// 主页
class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    private var itemList: buyList!
    
    var currentCate: String { // Indication for category
        set {// Information is synced with iCloud
            let userDefault = NSUbiquitousKeyValueStore.defaultStore()
            userDefault.setString(newValue, forKey: "currentCate")
            userDefault.synchronize()
            itemList = buyList(at: newValue)
            if tableView != nil {
                tableView.reloadData()
            }
        } get {
            let userDefault = NSUbiquitousKeyValueStore.defaultStore()
            return userDefault.stringForKey("currentCate") ?? ""
        }
    }
    
    var groupByDate: Bool {// Indication for headers
        let userDefault = NSUbiquitousKeyValueStore.defaultStore()
        return userDefault.boolForKey("groupByDate")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = currentCate
        itemList = buyList(at: currentCate)
        tableView.estimatedRowHeight = 50
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tapSwitchedNotification:", name: "switchTap", object: nil)
    }
    
    func tapSwitchedNotification(notification: NSNotification) {
        // When switch to summary view tab, disable the pan gesture
        panGesture.enabled = !panGesture.enabled
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {// Section 0 is always for summary
            guard let cell = tableView.dequeueReusableCellWithIdentifier("sumCell") as? SummaryTableViewCell else {
                let tempCell = UITableViewCell()
                tempCell.textLabel?.text = "ERROR!"
                return tempCell
            }
            cell.summaryLabel.text = "Summary of \(currentCate)"
            cell.moneyLabel.text = "$" + "\(itemList.summaryOf(category: currentCate) ?? 0)"
            return cell
        } else if groupByDate == true {
            guard let cell = tableView.dequeueReusableCellWithIdentifier("itemCell") as? DetailTableViewCell else {
                let tempCell = UITableViewCell()
                tempCell.textLabel?.text = ""
                return tempCell
            }
            cell.title = currentCate// Title is here to set the icon
            cell.itemLabel.text = itemList[indexPath.section - 1][indexPath.row].name
            let price = itemList[indexPath.section - 1][indexPath.row].totalPrice()
            cell.moneyLabel.text = "$" + price
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCellWithIdentifier("itemCell") as? DetailTableViewCell else {
                let tempCell = UITableViewCell()
                tempCell.textLabel?.text = ""
                return tempCell
            }
            cell.title = currentCate// Title is here to set the icon
            cell.itemLabel.text = itemList.workingList[indexPath.row].name
            let price = itemList.workingList[indexPath.row].totalPrice()
            cell.moneyLabel.text = "$" + price
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemList == nil {
            return 0
        }
        if section == 0 {
            return 1
        } else if groupByDate == true {
            return itemList[section - 1].count ?? 0
        } else {
            return itemList.workingList.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section != 0 {
            return 57
        } else {
            return 77
        }
    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || groupByDate == false {
            return 0
        }
        if itemList[section - 1].isEmpty {// If there's no row in this section, remove the header
            return 0
        }
        return groupByDate ? 30 : 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if groupByDate == false || section == 0 {
            return ""
        }
        return itemList.dateForTheList[section - 1].dateOnly
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if groupByDate == false {// If not group by date, only needs two sections
            return 2
        } else {
            guard let keysCount = itemList.listWithDate?.keys.count else { return 2 }
            return 1 + keysCount
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
        return indexPath.section != 0
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: " Edit ") {
            [unowned self] (rowAction, indexPath) -> Void  in
            let editItem: iMoney.Item!
            if self.groupByDate == true {
                editItem = self.itemList[indexPath.section - 1][indexPath.row]
            } else {
                editItem = self.itemList.workingList[indexPath.row]
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("addSegue", sender: editItem)
        }
        edit.backgroundColor = Common.commonColour
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") {
            [unowned self] (rowAction, indexPath) -> Void in
            var list: [iMoney.Item]!
            if self.groupByDate == true {
                list = self.itemList[indexPath.section - 1]
            } else {
                list = self.itemList.workingList
            }
            let removeItem = list.removeAtIndex(indexPath.row)
            self.itemList.deleteItem(removeItem)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            let summaryCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))! as! SummaryTableViewCell
            summaryCell.moneyLabel.text = "$" + "\(self.itemList.summaryOf(category: self.currentCate) ?? 0)"
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        return [delete,edit]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addSegue" {
            if let destinationVC = (segue.destinationViewController as? UINavigationController)?.viewControllers[0] as? addViewController {
                destinationVC.nameOfCate = ["Groceries", "Vegetables"].sort()
                destinationVC.cate = currentCate
                destinationVC.delegate = self
                destinationVC.navigationItem.title = "New item"
                if let item = sender as? iMoney.Item {
                    destinationVC.edit = true
                    let date = item.record?.date!
                    guard let list = itemList.listWithDate![date!], let index = list.indexOf(item) else { return }
                    destinationVC.indexOfEditingItem = (date!, index)
                    destinationVC.count = item.record?.count ?? 1
                    destinationVC.name = item.name
                    destinationVC.date = item.record?.date
                    destinationVC.money = item.price?.price
                    destinationVC.cate = item.category?.name
                    destinationVC.navigationItem.title = "Editing"
                }
            }
        } else if segue.identifier == "showSetting" {
            panGesture.enabled = false
            let destinationVC = segue.destinationViewController as! SettingViewController
            destinationVC.navigationItem.title = "Setting"
        } else if segue.identifier == "addCategory" {
            panGesture.enabled = false
            let destinationVC = segue.destinationViewController as! addCateViewController
            destinationVC.navigationItem.title = "Add Category"
            destinationVC.delegate = self
        }
    }
}

// MARK: Delegates

extension HomeViewController: addCateViewDelegate {
    func addCateViewDidSubmit() {
        panGesture.enabled = true
        let viewController = Common.rootViewController
        viewController.mainTabBarController.tabBar.hidden = false
        viewController.mainTabBarController.selectedIndex = 0
//        viewController.showLeft()
    }
    
    func addCateViewDidCanceled() {
        self.panGesture.enabled = true
        let viewController = Common.rootViewController
        viewController.mainTabBarController.tabBar.hidden = false
        viewController.mainTabBarController.selectedIndex = 0
//        viewController.showLeft()
    }
}


extension HomeViewController: addViewControllerDelegate {
    func newItemDidAdd(item: iMoney.Item, editingMode: Bool, at index: (NSDate, Int)?) {
        if editingMode == true {
            guard let date = index?.0, let i = index?.1 else { return }
            if let deleteItem = itemList.listWithDate?[date]?.removeAtIndex(i) {
                itemList.deleteItem(deleteItem)
            }
        }
        if item.category?.name == currentCate {
            itemList.addItem(item)
        }
        itemList.saveContext()
        tableView.reloadData()
        tableView.setEditing(false, animated: true)
    }
    
    func addViewDidCancel() {
        tableView.setEditing(false, animated: true)        
    }
}

