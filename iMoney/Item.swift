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

    class func initialize(name name: String, category: String, date: NSDate, money: NSDecimalNumber, count: NSDecimalNumber) -> iMoney.Item? {
        // Init function
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate// App delegate
        let context = appDelegate.managedObjectContext// Context
        if let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as? iMoney.Item {// Create a new item in CoreData
            item.name = name// Set name
            guard let itemPrice = NSEntityDescription.insertNewObjectForEntityForName("Price", inManagedObjectContext: context) as? iMoney.Price else {
                // Create a new price in CoreData
                return nil
            }
            itemPrice.price = money// Set the price I need
            itemPrice.buy = item// Price connects to the Item
            item.price = itemPrice// Item connects to the price
            let fetch = NSFetchRequest(entityName: "Category")// Find the category
            fetch.predicate = NSPredicate(format: "name = \"\(category)\"")
            if let category = try? context.executeFetchRequest(fetch) as? [iMoney.Category] where category != nil {// Get the category
                item.category = category![0]// Item is put in the category
            }
            guard let record = NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: context) as? iMoney.Record else {
                // Create a new record
                return nil
            }
            record.date = date// Set date of the record
            record.month = "\(date.startOfTheMonth())"
            record.count = count// Set count
            record.cost = itemPrice// Connects price with the record
            record.deal = item// Connect item with the record
            item.record = record// Connect the record with the item
            appDelegate.saveContext()// Save
            return item// Return item
        }
        return nil// If the step fails, return nil
    }
    
    func totalPrice() -> String {// Unit price * count
        guard let unitPrice = price?.price, let count = record?.count else {
            return ""
        }
        let totalPrice: NSDecimalNumber!
        let unit = count
        totalPrice = unitPrice.decimalNumberByMultiplyingBy(unit)
        return "\(totalPrice)"
    }
}
