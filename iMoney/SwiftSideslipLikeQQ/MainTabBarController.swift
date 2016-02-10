//
//  MainTabBarController.swift
//  SwiftSideslipLikeQQ
//
//  Created by JohnLui on 15/5/2.
//  Copyright (c) 2015年 com.lvwenhan. All rights reserved.
//

import UIKit

// TabBar Controller，主页所有内容的父容器
class MainTabBarController: UITabBarController {

    private var isSummaryView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.tintColor = Common.commonColour
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 覆写了 TabBar 的点击效果
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let notification = NSNotification(name: "switchTap", object: nil)
        let contactsVC = Common.summaryVC.viewControllers.first!
        switch item.tag {
        case 0:
            if Common.summaryVC.viewControllers.count == 2 {
                Common.summaryVC.viewControllers.removeAtIndex(1)
            }
            if isSummaryView == true {
                isSummaryView = false
                contactsVC.navigationController!.view.removeFromSuperview()
                contactsVC.view.removeFromSuperview()
                NSNotificationCenter.defaultCenter().postNotification(notification)
            }
        case 1:
            // 这里为了省事采用了简单的 addSubView 方案，真正项目中应该采用 TabBar Controller 自带的 self.viewControllers 方案
            if Common.summaryVC.viewControllers.count == 2 {
               Common.summaryVC.popToRootViewControllerAnimated(true)
            }
            if isSummaryView == false {
                isSummaryView = true
                Common.rootViewController.mainTabBarController.view.addSubview(contactsVC.navigationController!.view)
                Common.rootViewController.mainTabBarController.view.addSubview(contactsVC.view)
                Common.rootViewController.mainTabBarController.view.bringSubviewToFront(Common.rootViewController.mainTabBarController.tabBar)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            }
        default:
            break
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        let identifier = segue.identifier!
//        print(identifier)
//    }
//    

}
