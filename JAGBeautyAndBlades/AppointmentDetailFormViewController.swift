//
//  AppointmentDetailFormViewController.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 4/27/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit

import XLForm
import SwiftyJSON
import Alamofire

import Foundation

extension NSDate {
    func ToLocalStringWithFormat(dateFormat: String) -> String {
        // change to a readable time format and change to local time zone
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let timeStamp = dateFormatter.stringFromDate(self)
        
        return timeStamp
    }
}

class AppointmentDetailFormViewController: XLFormViewController {
  
    var appointmentJson = JSON.null
    var appointmentID = ""
    var categoryName:String?
    var appointmentStatus:AppointmentStatus?
    var price:String?
    var services = JSON.null
    var priceTier:Int?
    var token = ""
    var user = HCCustomer()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //initializeForm()
        //  let token = customer?.token
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //initializeForm()
    }
    
    func createReadableStringFromDateString(string: String) -> String {
        
        var date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        
        if let date1 = dateFormatter.dateFromString(string) {
            date = date1
        }
        
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
       
        let newString = dateFormatter.stringFromDate(date)
        
        return newString
    }
    
    
    func initializeForm()  {
        self.title = categoryName
   
        var appointmentAddressLines = [String:JSON]()
    
        if let array = appointmentJson["address"].dictionary {
       
            appointmentAddressLines = array
        }
        var form = XLFormDescriptor(title: categoryName)
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        // Appointment Price
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Total Price")
        
        row = XLFormRowDescriptor(tag: "Total Price", rowType: XLFormRowDescriptorTypeText, title: "$")
        row.value = price
        
        row.disabled = true
        section.addFormRow(row)
        form.addFormSection(section)
        
        // Appointment Status
        section = XLFormSectionDescriptor.formSectionWithTitle("Appointment Status")
        
        row = XLFormRowDescriptor(tag: "Appointment Status", rowType: XLFormRowDescriptorTypeText, title: "Status -")
        
        if let status = appointmentStatus {
           row.value = appointmentStatusToReadableString(status)
        }
    
        print(appointmentStatus?.rawValue)
        
        row.disabled = true
        section.addFormRow(row)
        form.addFormSection(section)
        // Provider / Customer Name
        section = XLFormSectionDescriptor.formSectionWithTitle("")
    //    var user = HCCustomer()
      //  if let some = UserInformation.sharedInstance.customerProfile {
            
        
        //    user = some
       // }
        row = XLFormRowDescriptor(tag: "AppointmentWith", rowType: XLFormRowDescriptorTypeText, title: "Appointment With -")
       
        if user.isProfessional == false {
            let name = appointmentJson["service_provider"]["first_name"].stringValue
            row.value = name
            row.disabled = true
            
        }
        
        if user.isProfessional == true {
            
            
            
            let name = appointmentJson["customer"]["first_name"].stringValue
            row.value = name
            row.disabled = true
            
        }
        
        
        section.addFormRow(row)
        if appointmentStatus != AppointmentStatus.Created && row.value as? String != nil{
            
            form.addFormSection(section)
        }
        // Start and End Time Sections
        section = XLFormSectionDescriptor.formSectionWithTitle("Scheduled Times")
        
     
        let requestedStartTimeString = createReadableStringFromDateString(appointmentJson["requested_start_by"].stringValue)
        let requestedEndTimeString = createReadableStringFromDateString(appointmentJson["requested_end_by"].stringValue)
        let actualStartTimeString = createReadableStringFromDateString(appointmentJson["actual_start_by"].stringValue)
        let actualEndTimeString = createReadableStringFromDateString(appointmentJson["actual_end_by"].stringValue)
        print(requestedStartTimeString)
        print(requestedEndTimeString)
        
        var dictionaryOfTimeStrings = [String : String]()
        
        //if appointmentStatus == AppointmentStatus.Created || appointmentStatus == AppointmentStatus.Confirmed {
            dictionaryOfTimeStrings[kStartTime] = requestedStartTimeString
            dictionaryOfTimeStrings[kEndTime] = requestedEndTimeString
          //  dictionaryOfTimeStrings.
          //  arrayOfTimeStrings.append(requestedEndTimeString)
       // }
        
       // if  appointmentStatus == AppointmentStatus.Done {
            
            
         //   dictionaryOfTimeStrings[kStartTime] = actualStartTimeString
            
            
           // dictionaryOfTimeStrings[kEndTime] = actualEndTimeString
      //  }
        
        row = XLFormRowDescriptor(tag: kStartTime, rowType: XLFormRowDescriptorTypeText, title: "\(kStartTime) -")
        row.value = dictionaryOfTimeStrings[kStartTime]
        row.disabled = true
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: kEndTime, rowType: XLFormRowDescriptorTypeText, title: "\(kEndTime) -")
        row.value = dictionaryOfTimeStrings[kEndTime]
        row.disabled = true
        section.addFormRow(row)
        
        form.addFormSection(section)
        
        // check for status type to determine which times to display
        // Address section
        section = XLFormSectionDescriptor.formSectionWithTitle("Address")
        
        var line1Value = ""
        var line2Value = ""
        var zipCodeValue = ""
        var stateValue = ""
        var cityValue = ""
      
        let arrayOfRows = [kFirstLine, kSecondLine, kCityState, kZipCode]
        
        for line in appointmentAddressLines {
            
            if line.0 == "line1" {
                line1Value = line.1.stringValue
            }
            
            if line.0 == "line2" {
                line2Value = line.1.stringValue
            }
            
            if line.0 == "zip_code" {
                zipCodeValue = line.1.stringValue
            }
            
            if line.0 == "state" {
                stateValue = line.1.stringValue
            }
            
            if line.0 == "city" {
                cityValue = line.1.stringValue
            }
            
        }
        
        for arrayRow in arrayOfRows {
            var row = XLFormRowDescriptor(tag: "", rowType: XLFormRowDescriptorTypeText, title: "")
            row.disabled = true
           
            if  arrayRow == kFirstLine {
                row = XLFormRowDescriptor(tag: kFirstLine, rowType: XLFormRowDescriptorTypeText, title: "\(kFirstLine) -")
                row.value = line1Value
            }
            if  arrayRow == kSecondLine {
                row = XLFormRowDescriptor(tag: kSecondLine, rowType: XLFormRowDescriptorTypeText, title: "\(kSecondLine) -")
                row.value = line2Value
            }
            
            if  arrayRow == kZipCode {
                row = XLFormRowDescriptor(tag: kZipCode, rowType: XLFormRowDescriptorTypeText, title: "\(kZipCode) -")
                row.value = zipCodeValue
            }
            
            if  arrayRow == kCityState {
                row = XLFormRowDescriptor(tag: kCityState, rowType: XLFormRowDescriptorTypeText, title: "\(kCityState) -")
                row.value = "\(cityValue), \(stateValue)"
            }
            row.disabled = true
            section.addFormRow(row)
        }
        
        
        
        form.addFormSection(section)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Services")
        
        
        
        print(services)
        
        
        for procedure in services {
            print(procedure)
            
            let procedureName = procedure.1["service"]["name"].stringValue
            print(procedureName)
        
            var procedurePrice = procedure.1["service_line_price"].stringValue
            
            
            procedurePrice = String(procedurePrice.characters.dropLast(3))
            let cellString:String = "$\(procedurePrice) - \(procedureName)"
            
            row = XLFormRowDescriptor(tag: "\(procedureName)", rowType: XLFormRowDescriptorTypeText, title: "\(cellString)")
            
        //    row.otherValue = Int(procedurePrice)
            
          //  row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
          //  row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            
          //  row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
          //  row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
          //  if (cellString.characters.count > 30) {
            //    row.cellConfig.setObject(UIFont(name: kBodyFont, size: 12)!, forKey: "textLabel.font")
                
           // }
            row.disabled = true
            section.addFormRow(row)
            
          //  newString = cellString
            
        }
        form.addFormSection(section)
        // Add Cancel button for customers or Accept button for Pro's
        let defaults = NSUserDefaults.standardUserDefaults()
        let shouldShowAcceptButton = (defaults.stringForKey("role") == "pro" && appointmentStatus == AppointmentStatus.Created)
        let shouldShowCancelButton = (defaults.stringForKey("role") != "pro" && appointmentStatus != AppointmentStatus.Done)
        if (shouldShowAcceptButton || shouldShowCancelButton) {
            var alertMessage:String
            var alertCancelMessage:String
            var alertConfirmMessage:String
            var buttonTitle:String
            var endpointURL:URLStringConvertible
            var requestType:Alamofire.Method
            var params = [String: AnyObject]?()
            
            
            if shouldShowAcceptButton {
                alertMessage = "Would you like to accept this appointment?"
                alertConfirmMessage = "Yes, I accept this appointment"
                alertCancelMessage = "No, I do not accept this appointment"
                buttonTitle = kAccept
                requestType = .POST
                endpointURL = kAppointmentAcceptURL + self.appointmentID + "/"
                
                params = nil
//                params = [
//                          "id":self.appointmentID,
//                          "service_provider":4,
//                          "category":appointmentJson["category"]["id"].stringValue,
//                          "booking":appointmentJson["booking"].stringValue,
//                          "customer" : appointmentJson["customer"]["id"].stringValue,
//                          "status" : "created",
//                          "address": "",
//                          "requested_start_by": "",
//                          "requested_end_by": "",
//                          "appointment_price": appointmentJson["appointment_price"].stringValue,
//                          "actual_start_time": "",
//                          "actual_end_time": "",
//                          "confirmed_customer": appointmentJson["confirmed_customer"].stringValue,
//                          "confirmed_provider": appointmentJson["confirmed_provider"].stringValue,
//                          "payment_status": appointmentJson["payment_status"].stringValue
//                ]
            } else {
                alertMessage = "Would you like to cancel this appointment?"
                alertConfirmMessage = "Yes, cancel this appointment"
                alertCancelMessage = "No, keep this appointment"
                buttonTitle = kCancel
                requestType = .POST
                endpointURL = kAppointmentCancelURL
                
                params = ["appointment_id":self.appointmentID]
            }
            
            section = XLFormSectionDescriptor.formSectionWithTitle("")
            
            row = XLFormRowDescriptor(tag: buttonTitle, rowType: XLFormRowDescriptorTypeButton, title: buttonTitle)
            
            row.action.formBlock = { [weak self] (sender: XLFormRowDescriptor!) -> Void in
                let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .ActionSheet)
                
                let cancelAction = UIAlertAction(title: alertCancelMessage, style: .Cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                
                let appointmentAction = UIAlertAction(title: alertConfirmMessage, style: .Destructive) { (action) in
                    //       print(action)
                    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                    activityView.color = UIColor.blackColor()
                    //  transform = CGAffineTransform(CGAffineTransformMakeScale(1.5f, 1.5f);
                    //  activityIndicator.transform = transform
                    activityView.center = self!.view.center
                    activityView.hidesWhenStopped = true
                    //    activityView.activityIndicatorViewStyle = UIActivityIndicatorView.
                    
                    activityView.startAnimating()
                    
                    self!.view.addSubview(activityView)
                    let headers = ["Authorization":  "Token  \(self!.token)"]
                    Alamofire.request(requestType, endpointURL, parameters:params, headers:headers)
                        .responseJSON { response in
                            switch response.result {
                            case .Success(let json):
                                  print(json)
                                Alamofire.request(.GET, kAppointmentsURL, headers: headers).responseJSON {
                                    response in switch response.result {
                                        
                                    case .Success(let item):
                                        dispatch_async(dispatch_get_main_queue()) { ///[unowned self] in
                                            //   if let newJSON = item as? JSON {
                                            UserInformation.sharedInstance.appointments = JSON(item)
                                            
                                            //  }
                                        }
                                        
                                        activityView.stopAnimating()
                                        
                                        
                                        self?.navigationController?.popViewControllerAnimated(true)
                                        //    UserInformation.sharedInstance.appointments = self!.appointmentJson//self.?appointments
                                    //  self?.initializeForm()
                                    case .Failure(let error): print(error)
                                        
                                    }
                                }
                                
                            case .Failure(let error):
                                print(response.result)
                                print(error)
                                print(error.code)
                                print(error.localizedFailureReason)
                                let alertController = returnAlertControllerForErrorCode(error.code)
                                activityView.stopAnimating()
                                self!.presentViewController(alertController, animated: true) {
                                    // ...
                                }
                            }
                    }
                    
                    
                }
                
                alertController.addAction(appointmentAction)
                
                self!.presentViewController(alertController, animated: true) {
                    // ...
                }
                
            }
            
            let textColor = shouldShowAcceptButton ? UIColor.greenColor() : UIColor.redColor()
            row.cellConfig.setObject(textColor, forKey: "textLabel.textColor")
            section.addFormRow(row)

        }
        
        form.addFormSection(section)
        self.form = form
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profile = UserInformation.sharedInstance.customerProfile {
            
            user = profile
            
            
        }
     //   user =
        token = UserInformation.sharedInstance.token
        appointmentID = appointmentJson["id"].stringValue
        // Do any additional setup after loading the view.
        
        initializeForm()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
