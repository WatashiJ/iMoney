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

//TODO: - addVC: Move labels up
//TODO: - Setting
//TODO: - Summary of months

class buyList {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var allItem: [iMoney.Category: [iMoney.Item]]? {
        let catFetch = NSFetchRequest(entityName: "Category")
        guard let categories = try? self.context.executeFetchRequest(catFetch) as? [iMoney.Category] else {
            return nil
        }
        var all = Dictionary<iMoney.Category,Array<iMoney.Item>>()
        for category in categories! {
            if let items = category.items?.allObjects as? [iMoney.Item] {
                all.updateValue(items, forKey: category)
            }
        }
        return all
    }
    
    var workingList: [iMoney.Item]?
    var categoryList: [iMoney.Category]?
    var currentCategory: iMoney.Category!
    var workingItem: iMoney.Item?
    var namesOfCategories: [String] {
        var names = [String]()
        if categoryList == nil {
            return names
        }
        for cate in categoryList! {
            names.append(cate.name!)
        }
        return names
    }
    
    var numberOfCategories: Int? {
        let fetch = NSFetchRequest(entityName: "Category")
        return context.countForFetchRequest(fetch, error: nil)
    }
    
    init(at listName: String) {// Switch to a category, init.
        workingList = Array()
        if listName == "All" && allItem != nil {
            for key in Array(allItem!.keys) {
                if let content = allItem![key] {
                    workingList!.appendContentsOf(content)
                }
            }
            return
        }
        let catFetch = NSFetchRequest(entityName: "Category")
        catFetch.predicate = NSPredicate(format: "name = \"\(listName)\"")
        do {
            guard let category = try context.executeFetchRequest(catFetch) as? [iMoney.Category] else {
                return
            }
            currentCategory = category[0]
            guard let items = category[0].items?.allObjects as? [iMoney.Item] else {
                workingList = Array()
                return
            }
            workingList = items
        } catch {
            print("No such category")
        }
    }
    
    init() {
        renewCategory()
    }
    
    func addCategory(by name: String) -> Bool? {
        let checkRedundant = NSFetchRequest(entityName: "Category")
        checkRedundant.predicate = NSPredicate(format: "name = \"\(name)\"")
        if context.countForFetchRequest(checkRedundant, error: nil) > 0 {
            return false
        }
        guard let cate = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context) as? iMoney.Category else {
            return nil
        }
        cate.name = name
        saveContext()
        renewCategory()
        return true
    }
    
    func addItem(item: iMoney.Item) {
        workingList?.append(item)
        saveContext()
    }
    
    private func renewCategory() {
        let fetch = NSFetchRequest(entityName: "Category")
        guard let cates = try? context.executeFetchRequest(fetch) as? [iMoney.Category] else {
            categoryList = []
            return
        }
        categoryList = cates
    }
    
    func summaryOf(category Category: String) -> NSDecimalNumber {
        let summaryCategory = NSFetchRequest(entityName: "Category")
        summaryCategory.predicate = NSPredicate(format: "name = \"\(Category)\"")
        guard let cate = (try? context.executeFetchRequest(summaryCategory) as? [iMoney.Category]) else {
            return 0
        }
        var sum: NSDecimalNumber = 0
        if let itemsIn = cate![0].items?.allObjects as? [iMoney.Item] {
            for item in itemsIn {
                if item.price != nil {
                    sum = sum.decimalNumberByAdding(item.price!)
                }
            }
        }
        return sum
    }
    
    func deleteCategory(by name: String) {
        let fetch = NSFetchRequest(entityName: "Category")
        fetch.predicate = NSPredicate(format: "name = \"\(name)\"")
        guard let category = (try? context.executeFetchRequest(fetch) as? [iMoney.Category]),
        let items = category![0].items,
        let its = items.allObjects as? [iMoney.Item] else {
            return
        }
        for item in its {
            context.deleteObject(item)
        }
        context.deleteObject(category![0])
        saveContext()
    }
    
    func saveContext() {
        appDelegate.saveContext()
    }
}