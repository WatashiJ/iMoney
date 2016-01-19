//
//  Item.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-01-17.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit
import CoreData

class Item: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func initialize(name name: String, category: String, date: NSDate, money: NSDecimalNumber) -> iMoney.Item? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        if let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as? iMoney.Item {
            item.name = name
            item.price = money
            let fetch = NSFetchRequest(entityName: "Category")
            fetch.predicate = NSPredicate(format: "name = \"\(category)\"")
            if let category = try? context.executeFetchRequest(fetch) as? [iMoney.Category] where category != nil {
                item.category = category![0]
            }
            item.date = date
            return item
        }
        return nil
    }
}
