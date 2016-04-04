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
   
    var appointments = JSON.null
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
        let token = customer?.token
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
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
            var titleString = "\(name) - $\(price)"
            let appointmentID = jsonObject["id"].intValue
            var fontSize = CGFloat()
            fontSize = 17
            if let time = jsonObject["requested_start_by"].stringValue as? String {
               var startTime = time
                
                startTime = String(startTime.characters.dropLast(10))
                titleString = titleString + " - \(startTime)"
                if titleString.characters.count > 23 {
                    fontSize = 14
                }
                print(startTime)
                print(titleString)
                
            }
            print(titleString)
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
            row.action.formBlock = { [weak self] (sender: XLFormRowDescriptor!) -> Void in
                let alertController = UIAlertController(title: nil, message: "Would you like to cancel this appointment?", preferredStyle: .ActionSheet)
                
                let cancelAction = UIAlertAction(title: "No, keep this appointment", style: .Cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                
                let destroyAction = UIAlertAction(title: "Yes, cancel this appointment", style: .Destructive) { (action) in
                    print(action)
                    let headers = ["Authorization":  "Token  \(token)"]
                    Alamofire.request(.DELETE, "\(kDeleteAppointmentURL)\(appointmentID)/", headers:headers)
                        .responseJSON { response in
                            switch response.result {
                            case .Success(let json):
                                print(json)
                                Alamofire.request(.GET, kAppointmentsURL, headers: headers).responseJSON {
                                    response in switch response.result {
                                        
                                    case .Success(let json):
                                        
                                        self?.appointments = JSON(json)
                                        print("APPOINTMENTS:\(self?.appointments)")
                                      //  self.appointmentsDownloaded = true
                                        self?.initializeForm()
                                    case .Failure(let error): break
                                        
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
            // action sheet with delete option. if it is deleted, call the delete endpoint, reload JSON, reload table
           // row.disabled = true
            
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
            print(startTime)
            print(titleString)
          
            }
            
         print(titleString)
          row = XLFormRowDescriptor(tag:"\(appointmentID)", rowType: XLFormRowDescriptorTypeText, title: titleString)
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            row.disabled = true
          section.addFormRow(row)
        }
        form.addFormSection(section)
        
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
