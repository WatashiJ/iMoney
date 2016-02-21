//
//  DetailsViewController.swift
//  iMoney
//
//  Created by Yaxin Cheng on 2016-02-10.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class DetailsViewController: UITableViewController {
    
    var dateDuration: (NSDate, NSDate)!
    private let summaryDataSource = summaryCore()
    private let itemList = buyList()
    private var items: [iMoney.Item]!
    private var categories: [iMoney.Category]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = summaryDataSource.itemsByMonth(from: dateDuration.0, to: dateDuration.1)// Get all items from the time duration
        categories = Array(itemList.categoryList!)// Find all categories
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count + 1// summary for categories, and a total one
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sumCell") as! SummaryTableViewCell
        if indexPath.row == 0 {// First section for total cost
            cell.summaryLabel.text = "Total Cost"
            cell.moneyLabel.text = "$\(summaryDataSource.sumByMonth(from: dateDuration.0, to: dateDuration.1))"
        } else {// The other section for categories' cost
            cell.summaryLabel.text = categories[indexPath.row - 1].name
            cell.moneyLabel.text = "$\(itemList.costOf(category: categories[indexPath.row - 1].name!, from: dateDuration.0, to: dateDuration.1))"
            cell.iconView.image = Common.icons[categories[indexPath.row - 1].name!]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 77
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
