//
//  Record+CoreDataProperties.swift
//  
//
//  Created by Yaxin Cheng on 2016-02-07.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Record {

    @NSManaged var count: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var month: String?
    @NSManaged var cost: Price?
    @NSManaged var deal: Item?

}
