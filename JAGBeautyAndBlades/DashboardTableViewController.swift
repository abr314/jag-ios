//
//  DashboardTableViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/8/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // depends on messages and appointments
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  //      var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        let messagesCell:HCMessagePreviewTableViewCell = tableView.dequeueReusableCellWithIdentifier("messagesCell") as! HCMessagePreviewTableViewCell
        messagesCell.senderNameLabel.font = UIFont(name: kHeaderFont, size: 14)
        messagesCell.messagePreviewTextLabel.font = UIFont(name: kBodyFont, size: 14)
     //   tableView.rowHeight = 83
        
       
       
        if (indexPath.section == 0) {
           return messagesCell
            
        }
   //     tableview.rowHeight = 44
        
        if let appointmentCell = tableView.dequeueReusableCellWithIdentifier("appointmentsCell") {
            appointmentCell.textLabel?.font = UIFont(name: kBodyFont, size: 14)
            appointmentCell.textLabel?.text = "5:30 PM - South Austin"
            appointmentCell.detailTextLabel?.text = "Haircut"
            
            if (indexPath.section == 1 ) {
                
                return appointmentCell
            }
        }
       
        
        // Configure the cell...
        
        

        return messagesCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0 ) {
                return 83
        }
        
        if (indexPath.section == 1 ) {
            return 44
        }
        
        return 44
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Notifications"
        }
        
        if (section == 1) {
            return "Appointments"
        }
        return ""
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sectionTitle: String = self.tableView(tableView, titleForHeaderInSection: section)!
        if sectionTitle == "" {
            return nil
        }
        
        var title: UILabel = UILabel()
        
        title.text = sectionTitle
        title.textColor = UIColor.whiteColor()
        title.backgroundColor = kPurpleColor
        title.tintColor = UIColor(hue: 270, saturation: 100, brightness: 50, alpha: 1)
        title.font = UIFont(name: kHeaderFont, size: 14)
        
        return title
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
