//
//  AvailabilityTableViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/31/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import RealmSwift

class AvailabilityTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var provider:HCProvider?
    var realm:Realm?
    override func viewDidLoad() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
     //   tableView.backgroundColor = UIColor.clearColor()
        
        self.navigationController?.navigationBarHidden = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.blackColor()
    }
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No availability exists"
        
        let attrs = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        return NSAttributedString(string: str, attributes: attrs)

    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = "Add Availability"
        let attrs = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        self.performSegueWithIdentifier("CreateAvailability", sender: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if (provider?.availabilities.count > 0) {
        return 8
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    //    var totalRows:Int
        // find out how many are for each day
        var arrayOfDayCounts = [0,0,0,0,0,0,0]
  
        if (section == 7) {
            // save or delete alert button
            
            return 1
        }
       
        if (section < 7) {
            if let availabilitiesArray = provider?.availabilities {
                for available in availabilitiesArray {
                    arrayOfDayCounts[available.dayNumber]++
                }
            }
            return arrayOfDayCounts[section]
        }
        
        return 0
        
       
    }
    
    override func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        // days of the week
        
        switch(section) {
        //    let day:String = DayOfTheWeek.Monday.rawValue
        case 0:
            return "Sunday"
           
        case 1:
            return "Monday"
           
        case 2:
            return "Tuesday"
           
        case 3:
            return "Wednesday"
           
        case 4:
            return "Thursday"
           
        case 5:
            return "Friday"
           
        case 6:
            return "Saturday"
       
        default :return ""

        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if (indexPath.section == 7 ) {
            cell.textLabel?.text = "Finished"
        }
        // cell sorted by day of week and start time
        if let provider = provider {
            if (provider.availabilities[indexPath.row].dayNumber == indexPath.section) {
            
                if let something:String? = provider.availabilities[indexPath.row].startTime + "-" + provider.availabilities[indexPath.row].endTime {
      
                    cell.textLabel?.text = something
                }
            
        }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row > provider?.availabilities.count) {
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CreateAvailability" {
            let ViewController: AvailabilityFormViewController = segue.destinationViewController as! AvailabilityFormViewController
            ViewController.professional = provider
            ViewController.realm = realm
        }
    }
}
