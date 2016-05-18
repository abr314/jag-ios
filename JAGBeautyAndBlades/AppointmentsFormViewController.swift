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
    var isPro:Bool?
    var array:Array<AnyObject>?
    var chosenAppointment:JSON?
    var appointments:JSON?
    var availableAppointments:JSON?
    
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
        var appointmentsAvailable = [JSON]()
        var appointmentsConfirmed = [JSON]()
        var appointmentsDone = [JSON]()
        
        if (isPro == true) {
            availableAppointments = UserInformation.sharedInstance.availableAppointments
            if (availableAppointments?.count > 0) {
                for appointment in availableAppointments! {
                    
                    let status = appointment.1["status"].stringValue
                    
                    
                    let jsonObj = appointment.1
                    
                    
                    if status == "created" {
                        appointmentsAvailable.append(jsonObj)
                    }
                }
            }
        }
        
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
        
        var appointmentsCreatedOrAvailable:[JSON]
        if isPro == true {
            section = XLFormSectionDescriptor.formSectionWithTitle("Available for Pickup")
            appointmentsCreatedOrAvailable = appointmentsAvailable
        } else {
            section = XLFormSectionDescriptor.formSectionWithTitle("Created")
            appointmentsCreatedOrAvailable = appointmentsCreated
        }
        
        
       
        for jsonObject in appointmentsCreatedOrAvailable {
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
            row.cellConfig.setObject(kPrimaryColor, forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
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
            row.cellConfig.setObject(kPrimaryColor, forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
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
            row.cellConfig.setObject(kPrimaryColor, forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
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
    override func viewWillAppear(animated: Bool) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("role") as? String == "pro" {
            retrieveAvailableAppointments()
        } else {initializeForm()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Appointments"
        
        appointments = UserInformation.sharedInstance.appointments
        //customer = UserInformation.sharedInstance.customerProfile
        
        self.navigationController?.navigationBar.translucent = false
              //initializeForm()
    }
    
    func retrieveAvailableAppointments() {
        var token = ""
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey(kJAGToken)
        {
            token = name
            //     customerToken = name
        }
        
        let headers = ["Authorization":  "Token  \(token)"]
        Alamofire.request(.GET, kAvailableAppointmentsURL, headers: headers).responseJSON {
            response in switch response.result {
                
            case .Success(let json):
                
                dispatch_async(dispatch_get_main_queue(), {
                    UserInformation.sharedInstance.availableAppointments = JSON(json)
                    print(JSON(json))
                    
                    self.isPro = true
                    self.initializeForm()
                })
                
            case .Failure(let error): print(error)
                
            }
        }
    }
}
