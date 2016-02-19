//
//  SelectLicenses.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/2/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm

class SelectLicenses: XLFormViewController {

    var professional:HCProvider = HCProvider()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.inputViewController?.view.backgroundColor = UIColor.blackColor()
     //   self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
       
        self.tableView.sectionIndexBackgroundColor = UIColor.blackColor()
        self.tableView.backgroundColor = UIColor.blackColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "pressedCancel")
        
        self.navigationItem.leftBarButtonItem?.enabled = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "pressedDone")
    }
    
    
    func pressedCancel() {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    func pressedDone() {
        
        var oneHasBeenPressed = false
        // create provider
        print("\(formValues)")
        
        var i = 0
        var selectedLicenses = Array<RLMStringWrapper>()
        // validation
      
        for (i = 0; i <= self.formValues().count-1; i++) {
            let license:LicenseType = LicenseType.fromNumber(i)
            if let value = form.formRowWithTag(license.rawValue)?.value {
                
                if (value as! Bool == true) {
                    oneHasBeenPressed = true
                // ADd license from rawvalue
                    var stringWrapper = RLMStringWrapper()
                    stringWrapper.string = license.rawValue
                    
                    for obj in selectedLicenses where obj.string != "\(license.rawValue)" {
                        selectedLicenses.append(stringWrapper)
                    }
                  
                }
            }
        }

        // create array of licenses
        
        // add selected licenses to provider licenses
        professional.licenseTypes.appendContentsOf(selectedLicenses)
        // navigate to next view controller
        
        if (oneHasBeenPressed) {
        // display possible services 
            self.performSegueWithIdentifier("SelectServices", sender:nil)
        }
    }
    override func viewWillAppear(animated: Bool) {
 
    }
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Licenses")
        
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Please Select The Licenses You Hold")
 
        form.addFormSection(section)
        
        var i = 0
        
        for (i = 0; i <= LicenseType.count.typeNumber-1; i++) {
            let licenseType:LicenseType = LicenseType.fromNumber(i)
            row = XLFormRowDescriptor(tag: "\(licenseType.rawValue)", rowType: XLFormRowDescriptorTypeBooleanCheck, title: licenseType.rawValue)
            
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
            
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
     
            section.addFormRow(row)
        }
     
        self.form = form
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SignUp" {
            if let svc = segue.destinationViewController as? BasicSignupViewController {
                          svc.isProviderType = true
                          svc.provider = professional
            }
        }
        
        if segue.identifier == "SelectServices" {
            if let svc = segue.destinationViewController as? SelectServicesFormViewController {
     //           svc.isProviderType = true
                svc.professional = professional
            }
        }
    }
}
