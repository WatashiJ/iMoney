//
//  addCateViewController.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-02-10.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class addCateViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    weak var delegate: addCateViewDelegate?
    var icons: [UIImage]!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let cancelButton = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "backButtonDidClick")
        self.navigationItem.setLeftBarButtonItem(cancelButton, animated: true)
        let confirmButton = UIBarButtonItem(title: "Confirm", style: .Plain, target: self, action: "confirmButtonDidClick")
        self.navigationItem.setRightBarButtonItem(confirmButton, animated: true)
        icons = Array(Common.icons.values)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonDidClick() {
        self.navigationController?.popToRootViewControllerAnimated(true)
        delegate?.addCateViewDidCanceled()
    }
    
    func confirmButtonDidClick() {
        self.navigationController?.popToRootViewControllerAnimated(true)
        delegate?.addCateViewDidSubmit()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("buttons", forIndexPath: indexPath) as! addCateViewCell
        cell.iconView.image = icons[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Common.icons.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
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
