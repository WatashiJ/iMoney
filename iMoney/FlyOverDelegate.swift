//
//  FlyOverDelegate.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-02-11.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

protocol FlyOverDelegate: class {
    func FlyOverEditButtonDidPress(flyoverVC: FlyOverViewController)
    func FlyOverDeleteButtonDidPress(flyoverVC: FlyOverViewController)
}