//
//  AppointmentsFormViewController.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 3/9/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import XLForm
import SwiftyJSON
import Alamofire
class AppointmentsFormViewController: XLFormViewController {
    var results:JSON?
    var customer:HCCustomer?
    var array:Array<AnyObject>?
    var chosenAppointment:JSON?
    var appointments:JSON?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
      //  let token = customer?.token
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    func initializeForm() {
        appointments = UserInformation.sharedInstance.appointments

        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        var appointmentsMaking = [JSON]()
        var appointmentsCreated = [JSON]()
        var appointmentsConfirmed = [JSON]()
        var appointmentsDone = [JSON]()
        
      //  var theseAppointments = JSON.null
        if let app = appointments {
            
      //      print(app.URL)
            for appointment in app {
                
                let status = appointment.1["status"].stringValue
                
                
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
                
                if status == "done" {
                    appointmentsDone.append(jsonObj)
                }
            }
        }
        
        form = XLFormDescriptor(title: "Appointments")
        
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Created")
        
       
        for jsonObject in appointmentsCreated {
            //  row = XLFormRowDescriptor(tag: jsonObject[""], rowType: rowStrings[1], title: rowStrings[0])
            
            let name = jsonObject["category"]["display_name"].stringValue
            let price = jsonObject["appointment_price"].intValue
            var titleString = "\(name) - $\(price)"
            let appointmentID = jsonObject["id"].intValue
            var fontSize = CGFloat()
            fontSize = 17
            if let time = jsonObject["requested_start_by"].stringValue as? String {
               var startTime = time
                
                startTime = String(startTime.characters.dropLast(10))
                titleString = titleString + " - \(startTime)"
//                if titleString.characters.count > 23 {
//                    fontSize = 14
//                }
       //         print(startTime)
         //       print(titleString)
                
            }
         //   print(titleString)
            row = XLFormRowDescriptor(tag:"\(appointmentID)", rowType: XLFormRowDescriptorTypeButton, title: titleString)
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: fontSize)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            row.cellConfig["textLabel.textAlignment"] = NSTextAlignment.Left.rawValue
            row.cellConfig["accessoryType"] = UITableViewCellAccessoryType.DisclosureIndicator.rawValue
            
            var token = ""
            let defaults = NSUserDefaults.standardUserDefaults()
            if let name = defaults.stringForKey(kJAGToken)
            {
                token = name
            }
  //       //   row.action.formSelector = #selector(AppointmentsFormViewController.setChosenAppointment(_:))
            
            row.action.formBlock = {
                
                [weak self] (sender: XLFormRowDescriptor!) -> Void in
                
           //     dispatch_async(dispatch_get_main_queue(), {
                    self?.chosenAppointment = jsonObject
                   // row.action.formSelector = #selector(AppointmentsFormViewController.showDetail)
                    self?.performSegueWithIdentifier("showDetails", sender: nil)
              //      stringToAppointmentStatus(String(json["status"].stringValue.capitalizedString))
             //   })
              //  row.action.formSelector = #selector(AppointmentsFormViewController.showDetail)
            }
           
            // create block for adding the row object to chosenappointment 
            
            
            /* 
                                Block For Cancelling Appointment
             
            row.action.formBlock = { [weak self] (sender: XLFormRowDescriptor!) -> Void in
                let alertController = UIAlertController(title: nil, message: "Would you like to cancel this appointment?", preferredStyle: .ActionSheet)
                
                let cancelAction = UIAlertAction(title: "No, keep this appointment", style: .Cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                
                let destroyAction = UIAlertAction(title: "Yes, cancel this appointment", style: .Destructive) { (action) in
             //       print(action)
                    let headers = ["Authorization":  "Token  \(token)"]
                    Alamofire.request(.POST, kAppointmentCancelURL, parameters:["appointment_id":"\(appointmentID)"], headers:headers)
                        .responseJSON { response in
                            switch response.result {
                            case .Success(let json):
                              //  print(json)
                                Alamofire.request(.GET, kAppointmentsURL, headers: headers).responseJSON {
                                    response in switch response.result {
                                        
                                    case .Success(let json):
                                        self?.appointments = JSON(json)
                                        UserInformation.sharedInstance.appointments = JSON(json)//self.?appointments
                                        self?.initializeForm()
                                    case .Failure(let error): print(error)
                                        
                                    }
                                }
                                
                            case .Failure(let error):
                                print(error)
                            }
                    }
                    
 
                }
 
                alertController.addAction(destroyAction)
                
                self!.presentViewController(alertController, animated: true) {
                    // ...
                }
 
            }
            */
            section.addFormRow(row)
        }
        
        form.addFormSection(section)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Confirmed")
        
        for jsonObject in appointmentsConfirmed {
          //  row = XLFormRowDescriptor(tag: jsonObject[""], rowType: rowStrings[1], title: rowStrings[0])
          let name = jsonObject["category"]["display_name"].stringValue
          let price = jsonObject["appointment_price"].intValue
        //  var startTime = ""
          var titleString = "\(name) - $\(price)"
          let appointmentID = jsonObject["id"].intValue
          if let time = jsonObject["requested_start_by"].stringValue as? String {
            var startTime = time
        
            startTime = String(startTime.characters.dropLast(10))
            titleString = titleString + " - \(startTime)"
       //     print(startTime)
         //   print(titleString)
          
            }
            
   //      print(titleString)
          row = XLFormRowDescriptor(tag:"\(appointmentID)", rowType: XLFormRowDescriptorTypeButton, title: titleString)
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            row.cellConfig["textLabel.textAlignment"] = NSTextAlignment.Left.rawValue
            row.cellConfig["accessoryType"] = UITableViewCellAccessoryType.DisclosureIndicator.rawValue
            row.disabled = false
            
            row.action.formBlock = {
                
                [weak self] (sender: XLFormRowDescriptor!) -> Void in
                
                //     dispatch_async(dispatch_get_main_queue(), {
                self?.chosenAppointment = jsonObject
                // row.action.formSelector = #selector(AppointmentsFormViewController.showDetail)
                self?.performSegueWithIdentifier("showDetails", sender: nil)
                
                //   })
                //  row.action.formSelector = #selector(AppointmentsFormViewController.showDetail)
            }
          section.addFormRow(row)
        }
        form.addFormSection(section)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Past Appointments")
        
        for jsonObject in appointmentsDone {
            //  row = XLFormRowDescriptor(tag: jsonObject[""], rowType: rowStrings[1], title: rowStrings[0])
            let name = jsonObject["category"]["display_name"].stringValue
            let price = jsonObject["appointment_price"].intValue
            //  var startTime = ""
            var titleString = "\(name) - $\(price)"
            let appointmentID = jsonObject["id"].intValue
            if let time = jsonObject["requested_start_by"].stringValue as? String {
                var startTime = time
                
                startTime = String(startTime.characters.dropLast(10))
                titleString = titleString + " - \(startTime)"
            //    print(startTime)
              //  print(titleString)
                
            }
            
         //   print(titleString)
            row = XLFormRowDescriptor(tag:"\(appointmentID)", rowType: XLFormRowDescriptorTypeButton, title: titleString)
            row.cellConfig.setObject(0, forKey: "textLabel.numberOfLines")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 15)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            row.cellConfig["textLabel.textAlignment"] = NSTextAlignment.Left.rawValue
            row.cellConfig["accessoryType"] = UITableViewCellAccessoryType.DisclosureIndicator.rawValue
            row.disabled = false
            
            row.action.formBlock = {
                
                [weak self] (sender: XLFormRowDescriptor!) -> Void in
                
                //     dispatch_async(dispatch_get_main_queue(), {
                self?.chosenAppointment = jsonObject
                // row.action.formSelector = #selector(AppointmentsFormViewController.showDetail)
                self?.performSegueWithIdentifier("showDetails", sender: nil)
                
                //   })
                //  row.action.formSelector = #selector(AppointmentsFormViewController.showDetail)
            }
            section.addFormRow(row)
        }
        
        
        form.addFormSection(section)

        self.form = form
    }
    
    func appointmentCellPressed() {
        // bring transition to the detail view
    }
    func showDetail() {
        performSegueWithIdentifier("showDetails", sender: nil)
    }
    
    func setChosenAppointment(appointment: JSON) {
        chosenAppointment = appointment
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetails" {
            if let vc = segue.destinationViewController as? AppointmentDetailFormViewController {
                if let json = chosenAppointment {
                    vc.appointmentJson = json
                    
                    
                    vc.categoryName = String(json["category"]["name"].stringValue.capitalizedString)
                    
                    vc.appointmentStatus = stringToAppointmentStatus(json["status"].stringValue)
                    vc.price = json["appointment_price"].stringValue
                 //   vc.appointmentStatus = String(json["status"].stringValue.capitalizedString)
                    vc.services = chosenAppointment!["service_requests"]
                    print(chosenAppointment)
                    
                    if let appointment = chosenAppointment {
                  //      vc.price = appointment["appointment_price"].stringValue
                        
                       vc.services = appointment["service_requests"]
                        
                    }
              ///      print(chosenAppointment!["appointment_price"])
                    
                    vc.priceTier = json["requested_tier"].intValue
                }
                
            }
        }
    }
    override func viewDidAppear(animated: Bool) {
        
        
        initializeForm()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "APPOINTMENTS"
        
        appointments = UserInformation.sharedInstance.appointments
        
        self.navigationController?.navigationBar.translucent = false
              initializeForm()
    }
}
