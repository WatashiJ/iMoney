//
//  HomeViewController.swift
//  SwiftSideslipLikeQQ
//
//  Created by JohnLui on 15/4/10.
//  Copyright (c) 2015年 com.lvwenhan. All rights reserved.
//

import UIKit

// 主页
class HomeViewController: UIViewController, addViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    private var itemList: buyList!
    
    var currentCate: String {
        set {
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(newValue, forKey: "currentCate")
            userDefault.synchronize()
            itemList = buyList(at: newValue)
            if tableView != nil {
                tableView.reloadData()
            }
        } get {
            let userDefault = NSUserDefaults.standardUserDefaults()
            return (userDefault.objectForKey("currentCate") as? String) ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = currentCate
        itemList = buyList(at: currentCate)
        tableView.estimatedRowHeight = 50
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tapSwitchedNotification:", name: "switchTap", object: nil)
    }
    
    func tapSwitchedNotification(notification: NSNotification) {
        panGesture.enabled = !panGesture.enabled
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func newItemDidAdd(item: iMoney.Item) {
        if item.category?.name == currentCate {
            itemList.addItem(item)
        } else {
            itemList.saveContext()
        }
        tableView.reloadData()
    }
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCellWithIdentifier("sumCell") as? SummaryTableViewCell else {
                let tempCell = UITableViewCell()
                tempCell.textLabel?.text = "ERROR!"
                return tempCell
            }
            cell.summaryLabel.text = "Summary of \(currentCate)"
            cell.moneyLabel.text = "$" + "\(itemList.summaryOf(category: currentCate) ?? 0)"
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCellWithIdentifier("itemCell") as? DetailTableViewCell else {
                let tempCell = UITableViewCell()
                tempCell.textLabel?.text = (itemList.workingList![indexPath.row].name) ?? ""
                return tempCell
            }
            cell.title = currentCate
            cell.itemLabel.text = itemList.workingList![indexPath.row].name
            let price = itemList.workingList![indexPath.row].totalPrice()
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
        } else {
            return itemList.workingList?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section != 0 {
//            return UITableViewAutomaticDimension
            return 57
        } else {
            return 77
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addSegue" {
            if let destinationVC = (segue.destinationViewController as? UINavigationController)?.viewControllers[0] as? addViewController {
                destinationVC.nameOfCate = ["Groceries", "Vegetables"]
                destinationVC.numOfCate = 1
                destinationVC.cate = currentCate
                destinationVC.delegate = self
            }
        } else if segue.identifier == "showSetting" {

        } else if segue.identifier == "addCategory" {
            panGesture.enabled = false
            let destinationVC = segue.destinationViewController as! addCateViewController
            destinationVC.navigationItem.title = "Add Category"
            destinationVC.delegate = self
        }
    }
}

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
