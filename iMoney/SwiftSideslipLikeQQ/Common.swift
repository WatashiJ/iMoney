//
//  Common.swift
//  SwiftSideslipLikeQQ
//
//  Created by JohnLui on 15/4/11.
//  Copyright (c) 2015年 com.lvwenhan. All rights reserved.
//

import UIKit

struct Common {
    // Swift 中， static let 才是真正可靠好用的单例模式
    static let screenWidth = UIScreen.mainScreen().bounds.maxX
    static let screenHeight = UIScreen.mainScreen().bounds.maxY
    static let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as! ViewController
    static let contactsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Contacts")
    static let summaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Summary") as! UINavigationController
    static let commonColour = UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)
    static let icons: [String: UIImage] = ["Vegetables": UIImage(named: "vege")!.imageWithRenderingMode(.AlwaysTemplate), "Groceries": UIImage(named: "grocery")!.imageWithRenderingMode(.AlwaysTemplate)]
}
