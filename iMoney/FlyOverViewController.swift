//
//  FlyOverViewController.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-02-11.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class FlyOverViewController: UIViewController {
    
    weak var delegate: FlyOverDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        switch sender.tag {
        case 1: delegate?.FlyOverEditButtonDidPress(self)
        case 0: delegate?.FlyOverDeleteButtonDidPress(self)
        default: break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
