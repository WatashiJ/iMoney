//
//  Item+CoreDataProperties.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-01-17.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var date: NSDate?
    @NSManaged var name: String?
    @NSManaged var price: NSDecimalNumber?
    @NSManaged var category: Category?

}
