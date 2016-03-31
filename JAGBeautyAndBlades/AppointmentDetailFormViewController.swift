//
//  AppointmentDetailFormViewController.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 3/9/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm

class AppointmentDetailFormViewController: XLFormViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
 
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Details")
        
        form.assignFirstResponderOnShow = true
        section = XLFormSectionDescriptor.formSectionWithTitle("Details")
        
        form.addFormSection(section)
        
        // turn rows into arrays
        let firstNameArray = ["Express Hair Cut", XLFormRowDescriptorTypeText]
        let costArray = ["$45.00", XLFormRowDescriptorTypeText]
        let addressArray = ["1400 Rio Grand Street", XLFormRowDescriptorTypeText]

        let lastNameArray = [kLastName, XLFormRowDescriptorTypeText]
        let phoneNumberArray = [kPhone, XLFormRowDescriptorTypeText]
        let cancelButtonArray = [kCancel, XLFormRowDescriptorTypeButton]
        
        let arrayOfRows = [firstNameArray, costArray, addressArray, cancelButtonArray]
        
        for rowStrings in arrayOfRows {
            
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            // add row customizations here
            
            row.disabled = NSNumber(bool: true)
            
            section.addFormRow(row)
        }
        
        self.form = form
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
  //      self.navigationController?.navigationBar.text = ""
        self.inputViewController?.view.backgroundColor = UIColor.blackColor()
        //     self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor.whiteColor()
    
    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
