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

// Insert code here to add functionality to your managed object subclass

}

func == (left: iMoney.Category, right: iMoney.Category) -> Bool {
    return left.name == right.name
}