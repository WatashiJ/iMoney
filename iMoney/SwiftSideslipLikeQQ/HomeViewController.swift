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
        } get {
            let userDefault = NSUserDefaults.standardUserDefaults()
            return (userDefault.objectForKey("currentCate") as? String) ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = currentCate
        itemList = buyList(at: currentCate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func newItemDidAdd(item: iMoney.Item) {
        itemList.addItem(item)
        tableView.reloadData()
    }
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("ItemListCell") else {
            let tempCell = UITableViewCell()
            tempCell.textLabel?.text = (itemList.workingList![indexPath.row].name) ?? ""
            return tempCell
        }
        cell.textLabel?.text = itemList.workingList![indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemList == nil {
            return 0
        }
        return itemList.workingList?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addSegue" {
            if let destinationVC = (segue.destinationViewController as? UINavigationController)?.viewControllers[0] as? addViewController {
                destinationVC.nameOfCate = ["Groceries", "Vegetables"]
                destinationVC.numOfCate = 1
                destinationVC.delegate = self
            }
        }
    }
    

}
