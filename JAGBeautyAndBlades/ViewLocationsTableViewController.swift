//
//  ViewLocationsTableViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/3/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import RealmSwift

class ViewLocationsTableViewController: UITableViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    var provider:HCProvider?
    var realm:Realm?
    
    override func viewDidLoad() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = UIColor.blackColor()
        
        self.navigationController?.navigationBarHidden = false
        
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: nil, action: "addButtonPressed")
        if(provider?.locations.count > 0) {
            
        
        navigationItem.rightBarButtonItem = barButton
        }
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
    }
    
    func addButtonPressed(){
        let alertController = UIAlertController(title: "Add a Location", message: "Enter by map or text", preferredStyle: .Alert)
        
        let mapAction = UIAlertAction(title: "Map", style: .Default) { (action) in
            // ...
            self.performSegueWithIdentifier("locationFromMap", sender: nil)
        }
        alertController.addAction(mapAction)
        
        let enterAction = UIAlertAction(title: "Text", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(enterAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No locations exist"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
  /*
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = "addLocation"
      //  let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
*/    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        self.performSegueWithIdentifier("locationFromMap", sender: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        let count = provider?.locations.count
        
        
        if let count = count {
            return count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //    var totalRows:Int
        // find out how many are for each day
        let count = provider?.locations.count
        
        
        if let count = count {
        return count
        }
        return 1
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
    //    if (indexPath.section == 7 ) {
      //      cell.textLabel?.text = "Finished"
       // }
       
        // show location title and proximity
        return cell
    }
   
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        addButtonPressed()
    }
}
