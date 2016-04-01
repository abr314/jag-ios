//
//  AppointmentsFormViewController.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 3/9/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import XLForm
import SwiftyJSON

class AppointmentsFormViewController: XLFormViewController {
    var results:JSON?
    var customer:HCCustomer?
    var array:Array<AnyObject>?
   
    var appointments = JSON.null
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
        let token = customer?.token
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    //    initializeForm()
      //  results = JSON("")
    }
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        var appointmentsMaking = [JSON]()
        var appointmentsCreated = [JSON]()
        var appointmentsConfirmed = [JSON]()
        var appointmentsCancelled = [JSON]()
        
        
        for appointment in appointments {
            
            let status = appointment.1["status"].stringValue
        //    let he = appointment[1]["status"]
          //  print(appointment[1]["status"].stringValue)
            let jsonObj = appointment.1
            if status == "created" {
            
                appointmentsCreated.append(jsonObj)
            }
            
            if status == "confirmed" {
                appointmentsConfirmed.append(jsonObj)
            }
            
            if status == "making" {
                appointmentsMaking.append(jsonObj)
            }
        }
        form = XLFormDescriptor(title: "Appointments")
        
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Created")
        
        for jsonObject in appointmentsCreated {
            //  row = XLFormRowDescriptor(tag: jsonObject[""], rowType: rowStrings[1], title: rowStrings[0])
            let name = jsonObject["category"]["display_name"].stringValue
            let price = jsonObject["appointment_price"].intValue
            let titleString = "\(name) - $\(price) - Date - StartTime7"
            print(titleString)
            row = XLFormRowDescriptor(tag:name, rowType: XLFormRowDescriptorTypeText, title: titleString)
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            row.disabled = true
            section.addFormRow(row)
        }
        
        form.addFormSection(section)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Confirmed")
        
        for jsonObject in appointmentsConfirmed {
          //  row = XLFormRowDescriptor(tag: jsonObject[""], rowType: rowStrings[1], title: rowStrings[0])
          let name = jsonObject["category"]["display_name"].stringValue
          let price = jsonObject["appointment_price"].intValue
          let titleString = "\(name) - $\(price) - Date - StartTime7"
          print(titleString)
          row = XLFormRowDescriptor(tag:name, rowType: XLFormRowDescriptorTypeText, title: titleString)
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            row.disabled = true
          section.addFormRow(row)
        }
        form.addFormSection(section)
        
        /*
        let sectionNames = []
        let makingSectionArray = []
        let firstNameArray = ["Express Haircut and Neck Trim", XLFormRowDescriptorTypeButton]
        let lastNameArray = ["Beard or Mustache Trim", XLFormRowDescriptorTypeButton]
        let arrayOfRows = [firstNameArray, lastNameArray]
       // let phoneNumberArray = [kPhone, XLFormRowDescriptorTypeText]
      //  results[0]["service_requests"]
        
        for rowStrings in arrayOfRows {
            
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            // add row customizations here
    
            
            section.addFormRow(row)
        }
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Created")
        form.addFormSection(section)
        
   //     let sectionNames = []
   //     let makingSectionArray = []
        let nameArray = ["Express Haircut and Neck Trim", XLFormRowDescriptorTypeButton]
        let lameArray = ["Beard or Mustache Trim", XLFormRowDescriptorTypeButton]
        let arrayOf = [nameArray, lameArray]
        // let phoneNumberArray = [kPhone, XLFormRowDescriptorTypeText]
        //  results[0]["service_requests"]
        
        for rowStrings in arrayOf {
            
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            // add row customizations here
            
            
            section.addFormRow(row)
        }
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Confirmed")
        form.addFormSection(section)
        
        let narray = ["Express Haircut and Neck Trim", XLFormRowDescriptorTypeButton]
        let lArray = ["Beard or Mustache Trim", XLFormRowDescriptorTypeButton]
        let arrayO = [narray, lArray]
        // let phoneNumberArray = [kPhone, XLFormRowDescriptorTypeText]
        //  results[0]["service_requests"]
        
        for rowStrings in arrayOf {
            
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            row.action.formSelector = "showDetail"
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            // add row customizations here
            
            
            section.addFormRow(row)
        }
        */
        self.form = form
    }
    
    func showDetail() {
        performSegueWithIdentifier("showDetail", sender: nil)
    }
      override func viewDidLoad() {
    
        
        let prefs = NSUserDefaults.standardUserDefaults()
        if let string = prefs.objectForKey("JAGAppointmentsJSON") {
            results = JSON(string)
            
        }
        
        if let path = NSBundle.mainBundle().pathForResource("sampleAppointments", ofType:kPlist) {
            results = JSON(NSArray(contentsOfFile:path)!)
          //  return true
        }
       // return false
        
        
        initializeForm()
        super.viewDidLoad()
     //   updateData()
        
        if let font = UIFont(name: kHeaderFont, size: 25) {
            
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSFontAttributeName: font,
                    NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
    }
}
