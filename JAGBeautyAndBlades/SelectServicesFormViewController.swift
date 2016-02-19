//
//  SelectServicesFormViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/17/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import XLForm

class SelectServicesFormViewController: XLFormViewController {

    var professional:HCProvider?
    var customer:HCCustomer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeProfessionalForm()
        
        self.inputViewController?.view.backgroundColor = UIColor.blackColor()
        //   self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.sectionIndexBackgroundColor = UIColor.blackColor()
        self.tableView.backgroundColor = UIColor.blackColor()
  //      self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "pressedCancel")
        
        self.navigationItem.leftBarButtonItem?.enabled = true
        
    //    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "pressedDone")
    }
    /*
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Services")
        
        form.assignFirstResponderOnShow = true
        
        let providerSectionTitleString = "Please select the services you want to offer"
        let customerSectionTitleString = "Please select your favorite services"
        var sectionTitleString = ""
        
        if(professional != nil) {
            sectionTitleString = providerSectionTitleString
        }
        
        if(customer != nil) {
            sectionTitleString = customerSectionTitleString
        }
        
        section = XLFormSectionDescriptor.formSectionWithTitle(sectionTitleString)
        
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
    }
    */
    func initializeProfessionalForm(){
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Services")
        
        form.assignFirstResponderOnShow = true
        
        let sectionTitleString = "Please select the services you want to offer"
  //      let customerSectionTitleString = "Please select your favorite services"
    //    var sectionTitleString = ""
        
        section = XLFormSectionDescriptor.formSectionWithTitle(sectionTitleString)
        
        form.addFormSection(section)
        
        var i = 0
        
        var serviceNames = Array<String>()
        
        if (professional != nil) {
            for license in professional!.licenseTypes {
                serviceNames.appendContentsOf(ServiceTypes().serviceNamesForLicense(license.string))
            }
        }
   
        for name in serviceNames {
         //   let licenseType:LicenseType = LicenseType.fromNumber(i)
            let serviceName:String = name
            row = XLFormRowDescriptor(tag: "\(serviceName)", rowType: XLFormRowDescriptorTypeBooleanCheck, title: serviceName)
            
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
            
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            
            section.addFormRow(row)
        }
        
        self.form = form

    }
    
    func initializeCustomerForm() {
        
    }
}
