//
//  SummaryViewController.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-02-07.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var summaryDataSource: summaryCore!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        summaryDataSource = summaryCore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SummaryCell") as? ListTableViewCell else {
            return UITableViewCell()
        }
        cell.summaryLabel.text = summaryDataSource.allMonths()[indexPath.row]
        cell.iconView.image = cell.iconView.image?.imageWithRenderingMode(.AlwaysTemplate)
//        cell.iconView.tintColor = UIColor.
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryDataSource.allMonths().count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 57
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let indexPath = tableView.indexPathForSelectedRow!
        if let identifier = segue.identifier where identifier == "showDetails" {
            let destinationVC = segue.destinationViewController as! DetailsViewController
            destinationVC.navigationItem.title = summaryDataSource.allMonths()[indexPath.row]
            guard let month = NSDate.dateFromString(summaryDataSource.months[indexPath.row]) else {
                return
            }
            destinationVC.dateDuration = (month.startOfTheMonth(), month.endOfTheMonth())
        }
    }
}

extension NSDate {
    class func dateFromString(from: String) -> NSDate? {
        let dateFmt = NSDateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let datePart = from.characters.split(" ").map(String.init)[0]
        return dateFmt.dateFromString(datePart)
    }
}
