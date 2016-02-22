//
//  iMoneyTests.swift
//  iMoneyTests
//
//  Created by Yaxin Cheng on 2016-01-17.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import XCTest
import CoreData
@testable import iMoney

class iMoneyTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        guard let cate1 = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context) as? iMoney.Category else { return }
        cate1.name = "Cate"
        cate1.items = nil
        guard let cate2 = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context) as? iMoney.Category else { return }
        cate2.name = "Cate"
        cate2.items = nil
        let combine = Set<iMoney.Category>([cate1, cate2])
        assert(cate1.hashValue == cate2.hashValue)
        assert(combine.count == 1)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
