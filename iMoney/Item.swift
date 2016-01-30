//
//  Item.swift
//  
//
//  Created by Yaxin Cheng on 2016-01-29.
//
//

import UIKit
import CoreData


class Item: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func initialize(name name: String, category: String, date: NSDate, money: NSDecimalNumber, count: Int) -> iMoney.Item? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        if let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as? iMoney.Item {
            item.name = name
            guard let itemPrice = NSEntityDescription.insertNewObjectForEntityForName("Price", inManagedObjectContext: context) as? iMoney.Price else {
                return nil
            }
            itemPrice.price = money
            itemPrice.buy = item
            item.price = itemPrice
            let fetch = NSFetchRequest(entityName: "Category")
            fetch.predicate = NSPredicate(format: "name = \"\(category)\"")
            if let category = try? context.executeFetchRequest(fetch) as? [iMoney.Category] where category != nil {
                item.category = category![0]
            }
            guard let record = NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: context) as? iMoney.Record else {
                return nil
            }
            record.date = date
            record.count = count
            record.cost = itemPrice
            record.deal = item
            item.record = record
            appDelegate.saveContext()
            return item
        }
        return nil
    }
    
    func totalPrice() -> String {
        guard let unitPrice = price?.price, let count = record?.count else {
            return ""
        }
        let totalPrice: NSDecimalNumber!
        let unit = count.integerToDecimalNumber()
        totalPrice = unitPrice.decimalNumberByMultiplyingBy(unit)
        return "\(totalPrice)"
    }
}

extension NSNumber {
    func integerToDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(integer: (self as Int))
    }
}
