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
    var categoryImageName = ""
    var customer:HCCustomer?
    var bookingID = 0
    var categoryID = 0
    var customerToken = ""
    var bookingInProgress = false
    var customerID = ""
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    //    initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      //  initializeForm()
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
        
        let myCustomView = UIImageView()
        let myImage: UIImage = UIImage(named: categoryImageName)!
        myCustomView.image = myImage
            return myCustomView
        }
        
        return nil
    }
    
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if  section == 0 {

        return 80.0
    }
    
    if section == 2 {
        return 30
    }
    
    if section == 3 {
        return 10
    }
    return 20
}
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        serviceRequets.removeAll()
        checkedServicesTags.removeAll()
        runningTotal = 0
        priceTier = 3
        initializeForm()
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var token = ""
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey(kJAGToken)
        {
            token = name
        }
        
        let headers = ["Authorization":  "Token  \(token)"]
    //    print("TOKEN: \(token)")
        // get customer ID
        // let customerIDResponse:Response = Response()
        
        /**
         Braintree is currently disabled in the development build
         */
        
        Alamofire.request(.GET, kSiteUserInfoURL, headers:headers)
            
            .validate()
            
            .responseJSON { response in
                switch response.result {
                    
                //response.result {
                case .Success(let json):
                //    print(json)
                    let newResponse = JSON(json)// {
               //     print("userInfo \(newResponse["detail"]["id"])")
                    self.customerID = newResponse["detail"]["id"].stringValue
                 //   print(self.customerID)
                    
                case .Failure(let something):
                 //   break
                    print(something)
                    
                }
        }
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
        
      //  form.assignFirstResponderOnShow = true
        
        
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
        section = XLFormSectionDescriptor.formSectionWithTitle("Choose a Service")
        
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
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Prices below are all inclusive with built in tip")
        
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
        row.title = "Choose Time and Location"
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
             
                if value == 1 {
                    checkedServicesTags.append(newRow.title!)
                }
            }
        }
    
        for service in checkedServicesTags {
            
            /*
                Build Service Request Object
            */
            
            let serviceRequest = HCServiceRequest()
            
            for newService in services["services"] {
                
                let name:String = newService.1["name"].stringValue
                let serviceId:Int = newService.1["id"].intValue
                var price:String = newService.1["price_tiers"][priceTier-1]["price"].stringValue
                let estimatedTime:String = newService.1["estimated_time"].stringValue
                let newPrice = String(price.characters.dropLast(3))
                
                
                let title:String = "\(name) - \(estimatedTime) mins. - $\(newPrice)"
             //   print(name)
               // print(service)
              //  print(serviceId)
              //  print(price)
              
                serviceRequest.requestedTier = priceTier
                serviceRequest.appointmentID = appointmentID!
                
                if (title == service) {
                    serviceRequest.serviceName = name
                    serviceRequest.serviceID = serviceId
                    serviceRequest.serviceLinePrice = newPrice
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
                 //       print(nJSON["booking"].stringValue)
                     
                        self.bookingInProgress = true
                        
                        for request in self.serviceRequets {
                            var serviceID = ""
                            Alamofire.request(.POST, kCreateServiceRequestURL, parameters:["appointment":self.appointmentID!,"service":request.serviceID,"requested_price_tier":self.priceTier])
                                
                                .responseJSON { response in
                                    print(response)
                                    
                                    
                                    switch response.result {
                                    case .Success(let object):
                                        let jsonObject:JSON = JSON(object)
                                        serviceID = jsonObject["id"].stringValue
                                   //     print(serviceID)
                                        print(response.request?.URL)

                                        
                                        if let idServ = object["id"] as? String {
                                            serviceID = idServ
                                     //       print(serviceID)
                                            
                                        }
                                        print(serviceID)
                                        print("\(kUpdateServiceRequestURL)\(serviceID)")
                                        
                                        
                                        
                                        Alamofire.request(.PUT, "\(kUpdateServiceRequestURL)\(serviceID)/", parameters: ["appointment":self.appointmentID!,"service":request.serviceID,"requested_tier":self.priceTier, "id":serviceID])
                                            
                                            
                                            
                                            .responseJSON { response in
                                                print(response)
                                                
                                                
                                                switch response.result {
                                                case .Success(let JSON):
                                                    print(JSON)
                                                    print(response.request?.URL)
                                                 //   self.creation
                                                case .Failure(let thing):
                                                    print(thing)
                                                    print(response.request?.URL)

                                                }
                                        }
                                    case .Failure(let error):
                                        
                                        print(error)
                                        print(response.request?.URL)

                                    }
                            }
                        }
                    case .Failure(let error):
                        print(error)
                        print(response.request?.URL)

                   //     break
                        
                        }
                        
                }
            case .Failure(let error):
                print(error)
                print(response.request?.URL)

                
              //  break
                
                }
                self.performSegueWithIdentifier("schedule", sender: nil)
        }
        
       
   //     if creationSuccessful == true {
       //     self.performSegueWithIdentifier("schedule", sender: nil)

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
                checkedServicesTags.removeAll()
                initializeForm()
            }
        }
        
        
        if formRow.tag != "PriceTier" && formRow.tag != "Total Price" && formRow.tag != "Add" {
            if let value = newValue as? Int {
                if value == 1 {
                    if !checkedServicesTags.contains( { $0 == formRow.title! } ) {
                        checkedServicesTags.append(formRow.title!)
                        
                        print(checkedServicesTags)
                        
                        
                    }
                }
                if value == 0 {
                    // check if request exists in array
                    if checkedServicesTags.contains( { $0 == formRow.title! } ) {
                        //does contain object
                        
                        checkedServicesTags = checkedServicesTags.filter() { $0 != formRow.title }
                        
                        print(checkedServicesTags)
                    }
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
   //     print(serviceRequets)
        
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
