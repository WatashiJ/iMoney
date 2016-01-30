//
//  Category+CoreDataProperties.swift
//  
//
//  Created by Yaxin Cheng on 2016-01-29.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged var name: String?
    @NSManaged var items: NSSet?

}
