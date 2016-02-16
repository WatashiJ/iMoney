//
//  addCateViewDelegate.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-02-10.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

protocol addCateViewDelegate: class {// Add category view protocol. 
    func addCateViewDidCanceled()
    func addCateViewDidSubmit()
}