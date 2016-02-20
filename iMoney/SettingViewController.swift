//
//  SettingViewController.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-02-20.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        // When setting view disappear
        super.viewDidDisappear(animated)
        
        let viewController = Common.rootViewController
        viewController.mainTabBarController.tabBar.hidden = false// Get back the tab bar
        viewController.mainTabBarController.selectedIndex = 0
        viewController.homeViewController.panGesture.enabled = true// re-enable the pan gesture
        viewController.homeViewController.tableView.reloadData()// Reload data
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SwitchSettingCell") as? SwitchSettingViewCell else {
            return UITableViewCell()
        }
        cell.infoLabel.text = "Group By Date"
        let userDefault = NSUbiquitousKeyValueStore.defaultStore()
        cell.controlSwitch.on = userDefault.boolForKey("groupByDate")
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Group itmes by date"
        default: return ""
        }
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
