//
//  summaryCore.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-02-07.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class summaryCore {
    let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    lazy var months: [String]! = {
        let fetch = NSFetchRequest(entityName: "Record")
        do {
            guard let result = try self.context.executeFetchRequest(fetch) as? [iMoney.Record] else {
                return []
            }
            var months = [String]()
            for record in result {
                if !months.contains(record.month!) {
                    months.append(record.month!)
                }
            }
            return months
        } catch {
            return []
        }
    }()
    
    func allMonths() -> [String] {
        var monthsDescription = [String]()
        for month in months {
            let datePart = month.characters.split(" ").map(String.init)[0]
            let components = datePart.characters.split("-").map(String.init)
            let month: String!
            switch components[1] {
            case "01": month = "Jan"
            case "02": month = "Feb"
            case "03": month = "Mar"
            case "04": month = "Apr"
            case "05": month = "May"
            case "06": month = "Jun"
            case "07": month = "Jul"
            case "08": month = "Aug"
            case "09": month = "Sept"
            case "10": month = "Oct"
            case "11": month = "Nov"
            case "12": month = "Dec"
            default:
                month = "Error"
            }
            monthsDescription.append(month + ", " + components[0])
        }
        return monthsDescription
    }
    
    func updateMonths() {
        let fetch = NSFetchRequest(entityName: "Record")
        do {
            guard let result = try self.context.executeFetchRequest(fetch) as? [iMoney.Record] else {
                return
            }
            for record in result {
                if !months.contains(record.month!) {
                    months.append(record.month!)
                }
            }
        } catch {
            print("Error")
        }
    }
    
    func itemsByMonth(from start: NSDate, to end: NSDate) -> [iMoney.Item] {
        let fetch = NSFetchRequest(entityName: "Item")
        fetch.predicate = NSPredicate(format: "record.date >= %@ AND record.date <= %@", start, end)
        do {
            let queryResult = try context.executeFetchRequest(fetch) as! [iMoney.Item]
            if queryResult.isEmpty {
                return []
            } else {
                return queryResult
            }
        } catch {
            return []
        }
    }
    
    func sumByMonth(from start: NSDate, to end: NSDate) -> NSDecimalNumber {
        let items = itemsByMonth(from: start, to: end)
        var sum = NSDecimalNumber(integer: 0)
        for item in items {
            if let unitPrice = item.price!.price, let count = item.record!.count {
                sum = sum.decimalNumberByAdding(unitPrice.decimalNumberByMultiplyingBy(count.integerToDecimalNumber()))
            }
        }
        return sum
    }
}