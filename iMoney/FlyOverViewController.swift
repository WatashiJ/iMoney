//
//  FlyOverViewController.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-02-11.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class FlyOverViewController: UIViewController {
    
    // FlyOverView is used to edit or delete item in the HomeViewController, because of the pan gesture
    
    weak var delegate: FlyOverDelegate?

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        popUpButtons()
    }
    
    private func popUpButtons() {// Animate buttons
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.autoreverses = true
        
        animation.fromValue = 0.4
        animation.toValue = 1.1
        
        editButton.imageView?.layer.addAnimation(animation, forKey: "scaleAnimation")
        deleteButton.imageView?.layer.addAnimation(animation, forKey: "scaleAnimation")
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        switch sender.tag {
        case 1: delegate?.FlyOverEditButtonDidPress(self)
        case 0: delegate?.FlyOverDeleteButtonDidPress(self)
        default: break
        }
    }

    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        delegate?.FlyOverViewDidTapped(self)
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
