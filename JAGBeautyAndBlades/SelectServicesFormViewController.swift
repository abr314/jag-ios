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
    var licenses:Array<String>?
    
    
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
        
       // var i = 0
        
        var serviceNames = Array<String>()
        
        if (professional != nil) {
            for license in professional!.licenseTypes {
                serviceNames.appendContentsOf(ServiceTypes().serviceNamesForLicense(license.string))
            }
        }
   
        /* show the services as sections. show the procedures boolean check cells
        */
        for name in serviceNames {
         //   let licenseType:LicenseType = LicenseType.fromNumber(i)
            let rowsOfProcedures = Array<String>() // = ServiceTypes().proceduresForServiceName(name)
            section = XLFormSectionDescriptor.formSectionWithTitle(name)
            
            form.addFormSection(section)
            let serviceName:String = name
            
            for newRow in rowsOfProcedures {
                row = XLFormRowDescriptor(tag: "\(newRow)", rowType: XLFormRowDescriptorTypeBooleanCheck, title: "\(newRow)")
            
                let array:NSArray = ServiceTypes().proceduresForServiceName(serviceName)
                
                
                row.selectorOptions = rowsOfProcedures as [AnyObject]
            
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
                row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
            
                row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            
                section.addFormRow(row)
            }
        }
        
        self.form = form

    }
    
    func initializeCustomerForm() {
        
    }
}
