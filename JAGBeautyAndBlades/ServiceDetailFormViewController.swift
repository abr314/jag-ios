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
 //   var serviceDetailDictionary = NSArray()
    var priceTier = 3
    var newString = ""
    var newName = ""
    var appointmentID:Int?
    var checkedServicesTags = [String]()
    var serviceRequets = [HCServiceRequest]()
    var customer:HCCustomer?
    var bookingID = 0
    var categoryID = 0
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
        
        
    //    serviceDetailDictionary = ServiceTypes().proceduresForServiceName(service)
        
        // Do any additional setup after loading the view.
        for (key, object) in services {
            //Do something you want
            let name = object["name"]
            
            if (name.stringValue == newName) {
              services = object
            }
            
            let jsonString = services["services"][0]//["name"]
        }
     //   let jsonString = services["services"]//[0]//["name"]

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
        // row.cellConfig.setObject(kPurpleColor, forKey: "stepControl.textLabel.textColor")
        
        
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
        //    row.value = procedurePrice
            
            row.otherValue = Int(procedurePrice)
            
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            //    row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            if (cellString.characters.count > 43) {
                row.cellConfig.setObject(UIFont(name: kBodyFont, size: 10)!, forKey: "textLabel.font")
            // first rows are clickable cells for the procedures
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
        //    row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
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
    //    var appointment = HCAppointment()
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
        // synchronize form and add services to cart
        
        
   //     var something = [XLFormRowDescriptor?]()
        var  something = self.form.formSections[1].formRows //as? [
        
        var selectedAppointments = Array<String>()
        var i = 0
        for row in something {
        //    if let descriptor = row as? XLFormRowDescriptor {
            if let newRow = row as? XLFormRowDescriptor{
              
                let value = newRow.value as? Int
                print(value)
                print(newRow.tag)
       //         let tag = newRow.tag as? String
                if value == 1 {
                    checkedServicesTags.append(newRow.tag!)
                    
                }
                
            }
            
            }
        
        // create service requests
        
        for service in checkedServicesTags {
          //  let newService = HCServiceRequest()
          var serviceRequest = HCServiceRequest()
            
            for newService in services["services"] {
                //Do something you want
               /// let name = subJson["name"]
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
            
            // send service requests to server
            
        }
        
        var creationSuccessful = false
        for request in serviceRequets {
            Alamofire.request(.POST, kCreateServiceRequestURL, parameters:["appointment":appointmentID!,"service":request.serviceID,"requested_price_tier":priceTier])
            .responseJSON { response in
                switch response.result {
                    
                //response.result {
                case .Success(let JSON):
                    print(response)
                    creationSuccessful = true
                    
                case .Failure(let error):
                    
                    break
                }
            }
            
        }
       self.performSegueWithIdentifier("schedule", sender: nil)
        if creationSuccessful == true {
            

        }
        // segue to schedule
     //   performSegueWithIdentifier("schedule", sender: nil)
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
      //      self.tableView.reloadData()
      //     initializeForm()
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
                  //  let tag = formRow?.tag as String
                //    if let string = String(formRow.tag!)  {
                    checkedServicesTags.append(formRow.tag!)
                  //      }
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
        // send appointment to next VC
        if appointmentID != 0 {
            appointment.appointmentID = appointmentID!
        }
        if bookingID != 0 {
            appointment.bookingNumber = bookingID
        }
        
        if (segue.identifier == "schedule") {
            let vc:ScheduleFormViewController = segue.destinationViewController as! ScheduleFormViewController
        //    let indexPath = self.tableView.indexPathForSelectedRow()
            vc.appointment = appointment
            vc.categoryID = categoryID
            // pass data to next view
        }
    }
    
    }
