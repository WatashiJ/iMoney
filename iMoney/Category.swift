//
//  Category.swift
//  
//
//  Created by Yaxin Cheng on 2016-01-29.
//
//

import Foundation
import CoreData


class Category: NSManagedObject {

    override var hashValue: Int {
        return name?.hashValue ?? super.hashValue
    }
    
}

func == (left: Category, right: Category) -> Bool {
    return left.name == right.name
}