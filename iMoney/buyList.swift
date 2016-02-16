//
//  buyList.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-01-17.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//TODO: - Grouping
//TODO: - Setting

class buyList {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate// AppDelegate
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext// Context
    
    var allItem: [iMoney.Category: [iMoney.Item]]? {// All items
        let catFetch = NSFetchRequest(entityName: "Category")
        guard let categories = try? self.context.executeFetchRequest(catFetch) as? [iMoney.Category] else {// Get all categories
            return nil
        }
        var all = Dictionary<iMoney.Category,Array<iMoney.Item>>()
        for category in categories! {// For each category
            if let items = category.items?.allObjects as? [iMoney.Item] {// Get all items in that category
                all.updateValue(items, forKey: category)// Add to the dictionary
            }
        }
        return all// Return
    }
    
    var workingList: [iMoney.Item]?// The items in the current category
    var categoryList: [iMoney.Category]?// All categories

    var namesOfCategories: [String] {// Get names of all categories
        var names = [String]()
        if categoryList == nil {// If there's no category
            return names// Return an empty array
        }
        for cate in categoryList! {// For each category
            names.append(cate.name!)// Add the name to the array
        }
        return names
    }
    
    var numberOfCategories: Int? {// Use fetch to count how many categories are there
        let fetch = NSFetchRequest(entityName: "Category")
        return context.countForFetchRequest(fetch, error: nil)
    }
    
    init(at listName: String) {// Switch to a category, init.
        workingList = Array()// working items

        // View by All
        if listName == "All" && allItem != nil {// If chose All, show all categories
            for key in Array(allItem!.keys) {// For all keys
                if let content = allItem![key] {// Get the items
                    workingList!.appendContentsOf(content)// Add to the workingList
                }
            }
            return// End
        }
        
        // View by categories
        let itemFetch = NSFetchRequest(entityName: "Item")// Category Name
        itemFetch.predicate = NSPredicate(format: "(category.name = \"\(listName)\")AND(record.date >= %@)AND(record.date <= %@)", NSDate().startOfTheMonth(), NSDate().endOfTheMonth())// Search for items in the category and must be in this month
        do {
            guard let items = try context.executeFetchRequest(itemFetch) as? [iMoney.Item] else {
                return
            }
            workingList = items
        } catch {// If error occurs
            print("No such category")
        }
    }
    
    init() {
        renewCategory()// Reparse all items in the category
    }
    
    func addCategory(by name: String) -> Bool? {// Add a category
        let checkRedundant = NSFetchRequest(entityName: "Category")// No category allows to have the same name with another one
        checkRedundant.predicate = NSPredicate(format: "name = \"\(name)\"")// Check
        if context.countForFetchRequest(checkRedundant, error: nil) > 0 {// If the name is already used
            return false// Return false
        }
        guard let cate = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context) as? iMoney.Category else {
            // Insert a category
            return nil
        }
        cate.name = name// Set name
        saveContext()// Save
        renewCategory()// Renew the category list
        return true
    }
    
    func addItem(item: iMoney.Item) {// Add item
        workingList?.append(item)// Add to the working List
        saveContext()// save
    }
    
    func costOf(category cate: String, from start: NSDate, to end: NSDate) -> NSDecimalNumber {
        let itemFetch = NSFetchRequest(entityName: "Item")// Category Name
        itemFetch.predicate = NSPredicate(format: "(category.name = \"\(cate)\")AND(record.date >= %@)AND(record.date <= %@)", start, end)
        do {
            guard let items = try context.executeFetchRequest(itemFetch) as? [iMoney.Item] else {
                return 0
            }
            var sum = NSDecimalNumber(integer: 0)
            for item in items {// For each item
                if item.price != nil && item.record != nil {
                    let count = item.record!.count?.integerToDecimalNumber()// NSNumber to NSDecimalNumber
                    let cost = item.price!.price!.decimalNumberByMultiplyingBy(count!)// Unit price * count
                    sum = sum.decimalNumberByAdding(cost) // Total price instead of single price
                }
            }
            return sum
        } catch {
            return 0
        }
    }
    
    func searchItem(by name: String) -> iMoney.Item? {// Search items from db
        let fetch = NSFetchRequest(entityName: "Item")
        fetch.predicate = NSPredicate(format: "name CONTAINS[cd] \"\(name)\"")// fuzzy search
        do {
            let item = try context.executeFetchRequest(fetch) as! [iMoney.Item]
            if item.isEmpty {
                return nil
            }
            return item[0]
        } catch {
            return nil
        }
    }
    
    private func renewCategory() {// Refresh category array, used when category is updated
        let fetch = NSFetchRequest(entityName: "Category")
        guard let cates = try? context.executeFetchRequest(fetch) as? [iMoney.Category] else {// Get all categories
            categoryList = []
            return
        }
        categoryList = cates// Assign to the categoryList
    }
    
    func summaryOf(category Category: String) -> NSDecimalNumber {// Count the summary of the category
        let summaryCategory = NSFetchRequest(entityName: "Category")
        summaryCategory.predicate = NSPredicate(format: "name = \"\(Category)\"")
        var cate: [iMoney.Category]? = nil
        do {
            cate = (try context.executeFetchRequest(summaryCategory) as? [iMoney.Category])// Find the category
        } catch {
            return 0
        }
        if cate == nil {
            return 0
        }
        if cate!.isEmpty {
            return 0
        }
        var sum: NSDecimalNumber = 0
        if let itemsIn = cate![0].items?.allObjects as? [iMoney.Item] {// Get all items
            for item in itemsIn {// For each item
                if item.price != nil && item.record != nil {
                    let count = item.record!.count?.integerToDecimalNumber()// NSNumber to NSDecimalNumber
                    let cost = item.price!.price!.decimalNumberByMultiplyingBy(count!)// Unit price * count
                    sum = sum.decimalNumberByAdding(cost) // Total price instead of single price
                }
            }
        }
        return sum
    }
    
    func deleteCategory(by name: String) {// Delete a category
        let fetch = NSFetchRequest(entityName: "Category")
        fetch.predicate = NSPredicate(format: "name = \"\(name)\"")// Find the category
        guard let category = (try? context.executeFetchRequest(fetch) as? [iMoney.Category]) else {
            // Since I've set cascade in the CoreData, so delete the category will automatically delete all items in the category
            return
        }
        context.deleteObject(category![0])// Delete the category
        saveContext()// Save
    }
    
    func deleteItem(item: iMoney.Item) {// Delete item
        context.deleteObject(item)
        saveContext()
    }
    
    func saveContext() {
        appDelegate.saveContext()
    }
}

extension NSDate {
    func startOfTheMonth() -> NSDate {// Get the first day of the month
        let calendar = NSCalendar.currentCalendar()// Calendar
        let components = calendar.components([.Year,.Month,.Day], fromDate: self)
        components.day = 1// First day
        if let date = calendar.dateFromComponents(components) {
            return date
        } else {
            return NSDate()
        }
    }
    
    func endOfTheMonth() -> NSDate {// Get the first day of the next month
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year,.Month,.Day], fromDate: self)
        components.day = 1// Set the day to the first day
        guard let date = calendar.dateFromComponents(components) else {
            return NSDate()
        }
        let month = NSDateComponents()
        month.month = 1// Set the month to one month
        guard let nextMonth = calendar.dateByAddingComponents(month, toDate: date, options: .MatchFirst) else {
            // This month + one month
            return date
        }
        return nextMonth
    }
}