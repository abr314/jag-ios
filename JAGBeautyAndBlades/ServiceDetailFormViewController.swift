//
//  ServiceDetailFormViewController.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 3/13/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON
import Alamofire
class ServiceDetailFormViewController: XLFormViewController {
    
    
    var services:JSON = JSON.null
    var runningTotal = 0
    var appointment = HCAppointment()
    var service = ""
    var priceTier = 3
    var newString = ""
    var newName = ""
    var appointmentID:Int?
    var checkedServicesTags = [String]()
    var serviceRequets = [HCServiceRequest]()
    var customer:HCCustomer?
    var bookingID = 0
    var categoryID = 0
    var customerToken = ""
    var bookingInProgress = false
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    //    initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      //  initializeForm()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        for (key, object) in services {
            //Do something you want
            let name = object["name"]
            
            if (name.stringValue == newName) {
              services = object
            }
        }
    
        initializeForm()
    }
    func buildForm() {
        
    }
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "\(service)")
        
        form.assignFirstResponderOnShow = true
        
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Price Tier")
        
        row = XLFormRowDescriptor(tag: "PriceTier", rowType: XLFormRowDescriptorTypeSelectorPickerViewInline, title: "Skill Level")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
        row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
        
        row.selectorOptions = [1, 2, 3, 4, 5]
        row.value = priceTier
    
        section.addFormRow(row)
        
        form.addFormSection(section)
        // load the procedures in the dictionary for the first rows
        section = XLFormSectionDescriptor.formSectionWithTitle("Choose a procedure")
        
        form.addFormSection(section)
        
        for procedure in services["services"] {
      
            let procedureName = procedure.1["name"].stringValue
            let procedureTime = procedure.1["estimated_time"].stringValue
            let procedurePriceTiers = procedure.1["price_tiers"]
            var procedurePrice = ""
            
            for price in procedurePriceTiers {
                
                if (price.1["tier"].intValue == priceTier) {
                    procedurePrice = price.1["price"].stringValue
                }
            }
            
            procedurePrice = String(procedurePrice.characters.dropLast(3))
            let cellString:String = "\(procedureName) - \(procedureTime) mins. - $\(procedurePrice)"
            
            row = XLFormRowDescriptor(tag: "\(procedureName)", rowType: XLFormRowDescriptorTypeBooleanCheck, title: "\(cellString)")
 
            row.otherValue = Int(procedurePrice)
            
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
      
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            if (cellString.characters.count > 43) {
                row.cellConfig.setObject(UIFont(name: kBodyFont, size: 10)!, forKey: "textLabel.font")
       
            }
            section.addFormRow(row)
            
            newString = cellString
            
        }
        
        // stepper to increment the desired cost
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Total Price")
        
        row = XLFormRowDescriptor(tag: "Total Price", rowType:XLFormRowDescriptorTypeText)
        
        row.title = "Total Price: $\(runningTotal)"
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
        row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
        row.disabled = true
        
        section.addFormRow(row)
        
        form.addFormSection(section)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("")
        
        row = XLFormRowDescriptor(tag: "Add", rowType:XLFormRowDescriptorTypeButton)
        row.title = "Add to Cart"
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
        row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
        section.addFormRow(row)
        row.action.formSelector = #selector(ServiceDetailFormViewController.addAndPop)
        form.addFormSection(section)
        self.form = form
    }
    
    func validateForm() {
        
    }
    func addAndPop() {
        if (runningTotal == 0) {
            // Add error message
            let alertController = UIAlertController(title: "No Services Selected", message: "Please select at least 1 service to proceed.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
            return
        }
        appointment.appointmentPrice = "\(runningTotal)"
        
        let formRows = self.form.formSections[1].formRows
        
          for row in formRows {
      
            if let newRow = row as? XLFormRowDescriptor{
              
                let value = newRow.value as? Int
                print(value)
                print(newRow.tag)
      
                if value == 1 {
                    checkedServicesTags.append(newRow.tag!)
                }
            }
        }
    
        for service in checkedServicesTags {

            let serviceRequest = HCServiceRequest()
            
            for newService in services["services"] {
                
                let name:String = newService.1["name"].stringValue
                let serviceId:Int = newService.1["id"].intValue
                var price:String = newService.1["price_tiers"][priceTier-1]["price"].stringValue
                price.characters.dropLast(3)
                
                print(name)
                print(service)
                print(serviceId)
                print(price)
              
                serviceRequest.requestedTier = priceTier
                serviceRequest.appointmentID = appointmentID!
                
                if (name == service) {
                    serviceRequest.serviceName = name
                    serviceRequest.serviceID = serviceId
                    serviceRequest.serviceLinePrice = price
                    var itemExists = false
                    if (serviceRequets.count > 0){
                        for requests in serviceRequets {
                            if requests.serviceName == name {
                                itemExists = true
                            }
                        }
                    }
                    if itemExists == false {
                      print(serviceRequest.serviceName)
                      serviceRequets.append(serviceRequest)
                    }
                }
            }
        }
         let headers = ["Authorization":  "Token  \(customerToken)", "Content-Type":"application/json"]
        Alamofire.request(.POST, kCreateBookingURL, headers: headers, parameters:[:], encoding: .JSON).responseJSON
            { response in switch response.result {
                
            case .Success(let json):
                //   let newResponse = json //as? JSON
                let newJSON:JSON = JSON(json)
                let cusID = newJSON["id"].intValue
                Alamofire.request(.POST, kCreateAppointmentURL, headers: headers, parameters:["booking":cusID, "category":self.categoryID], encoding: .JSON).responseJSON
                    { response in switch response.result {
                    case .Success(let json):
                        //   let newJSON = json
                        // Get and set appointment ID
                        let nJSON:JSON = JSON(json)
                        self.appointmentID = nJSON["id"].intValue
                        self.bookingID = nJSON["booking"].intValue
                        self.appointment.appointmentID = nJSON["id"].intValue
                        self.appointment.bookingNumber = nJSON["booking"].intValue
                        print(nJSON["booking"].stringValue)
                     
                        self.bookingInProgress = true
                        for request in self.serviceRequets {
                            Alamofire.request(.POST, kCreateServiceRequestURL, parameters:["appointment":self.appointmentID!,"service":request.serviceID,"requested_price_tier":self.priceTier])
                                .responseJSON { response in
                                    switch response.result {
                                    case .Success(let JSON):
                                        print(JSON)
                                     //   creationSuccessful = true
                                    case .Failure(_):
                                        break
                                    }
                            }
                        }
                    case .Failure(_): break
                        
                        }
                        
                }
            case .Failure(_): break
                
                }
        }
        /*
        let headers = ["Authorization":  "Token  \(customerToken)", "Content-Type":"application/json"]
        //  let parameters = ["":""]
        Alamofire.request(.POST, kCreateBookingURL, headers: headers, parameters:[:], encoding: .JSON).responseJSON
            { response in switch response.result {
                
            case .Success(let json):
                //   let newResponse = json //as? JSON
                let newJSON:JSON = JSON(json)
                let cusID = newJSON["id"].intValue
                
                Alamofire.request(.POST, kCreateAppointmentURL, headers: headers, parameters:["booking":cusID, "category":self.categoryID], encoding: .JSON).responseJSON
                    { response in switch response.result {
                    case .Success(let json):
                        //   let newJSON = json
                        // Get and set appointment ID
                        let nJSON:JSON = JSON(json)
                        self.appointmentID = nJSON["id"].intValue
                        self.bookingID = nJSON["booking"].intValue
                        
                        print(nJSON["booking"].stringValue)
                      //  self.performSegueWithIdentifier("procedures", sender: nil)
                      //  self.hasBeenTapped = false
                    case .Failure(let error): break
                        
                        }
                        
                }
            case .Failure(let error): break
                
                }
        }
        */
        
       self.performSegueWithIdentifier("schedule", sender: nil)
      //  if creationSuccessful == true {
            

      //  }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
     
        if formRow.tag != "PriceTier" {
            if let string = formRow.otherValue as? Int {//as? String {
             
                if (newValue as? Bool == true) {
                    runningTotal = runningTotal + string
                }
                if (newValue as? Bool == false) {
                    runningTotal = runningTotal - string
                }
                
            }
            var row = self.form.formRowWithTag("Total Price")
            row?.title = "Total Price: $\(runningTotal)"
            self.reloadFormRow(row)
        }
        
        
        if formRow.tag == "PriceTier" {
            
            newValue
            if let thisInt = newValue as? Int {
                priceTier = thisInt
                runningTotal = 0
                initializeForm()
            }
        }
        
        if formRow.tag != "PriceTier" && formRow.tag != "Total Price" && formRow.tag != "Add" {
            if let value = newValue as? Int {
                if value == 1 {
                    checkedServicesTags.append(formRow.tag!)
                }
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        appointment.serviceRequests = serviceRequets
     
        if appointmentID != 0 {
            appointment.appointmentID = appointmentID!
        }
        if bookingID != 0 {
            appointment.bookingNumber = bookingID
        }
        
        if (segue.identifier == "schedule") {
            let vc:ScheduleFormViewController = segue.destinationViewController as! ScheduleFormViewController
      
            vc.appointment = appointment
            vc.categoryID = categoryID
       
        }
    }
    
    }
