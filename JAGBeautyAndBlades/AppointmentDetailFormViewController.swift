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

class AppointmentDetailFormViewController: XLFormViewController, UIPopoverPresentationControllerDelegate {
  
    var appointmentJson = JSON.null
    var appointmentID = ""
    var categoryName:String?
    var appointmentStatus:AppointmentStatus?
    var price:String?
    var services = JSON.null
    var priceTier:Int?
    var token = ""
    var user = HCCustomer()
    var appointmentInProgress:Bool?
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
        //let actualStartTimeString = createReadableStringFromDateString(appointmentJson["actual_start_by"].stringValue)
        //let actualEndTimeString = createReadableStringFromDateString(appointmentJson["actual_end_by"].stringValue)
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
        let shouldShowStartAppointmentButton = (defaults.stringForKey("role") == "pro" && appointmentStatus == AppointmentStatus.Confirmed)
        let shouldShowEndAppointmentButton = (defaults.stringForKey("role") == "pro" && appointmentStatus == AppointmentStatus.InProgress)

        if (shouldShowAcceptButton || shouldShowCancelButton || shouldShowStartAppointmentButton || shouldShowEndAppointmentButton) {
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
            } else if shouldShowCancelButton {
                alertMessage = "Would you like to cancel this appointment?"
                alertConfirmMessage = "Yes, cancel this appointment"
                alertCancelMessage = "No, keep this appointment"
                buttonTitle = kCancel
                requestType = .POST
                endpointURL = kAppointmentCancelURL
                
                params = ["appointment_id":self.appointmentID]
            } else if shouldShowStartAppointmentButton{
                alertMessage = "Are you about to begin the appointment?"
                alertConfirmMessage = "Yes, I am starting services"
                alertCancelMessage = "No, I am not ready"
                buttonTitle = kStartAppointment
                requestType = .POST
                endpointURL = kAppointmentStartURL + self.appointmentID + "/"
                
                params = nil
            } else {
                alertMessage = "Appointment completed?"
                alertConfirmMessage = "Yes, I have finished the appointment"
                alertCancelMessage = "No, I am still working"
                buttonTitle = kEndAppointment
                requestType = .POST
                endpointURL = kAppointmentEndURL + self.appointmentID + "/"
                
                params = ["appointment_provider_rates_customer":self.appointmentID]
                
                appointmentInProgress = true
            }
            
            section = XLFormSectionDescriptor.formSectionWithTitle("")
            
            row = XLFormRowDescriptor(tag: buttonTitle, rowType: XLFormRowDescriptorTypeButton, title: buttonTitle)
            
            row.action.formBlock = { [weak self] (sender: XLFormRowDescriptor!) -> Void in
                let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .ActionSheet)
                
                let cancelAction = UIAlertAction(title: alertCancelMessage, style: .Cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                
                let finishAppointmentAction = UIAlertAction(title: alertConfirmMessage, style: .Destructive) { (action) in
                    self?.performSegueWithIdentifier("proFinishedAppointment", sender: nil)
                }

                
                let appointmentAction = UIAlertAction(title: alertConfirmMessage, style: .Destructive) { (action) in
                    //       print(action)
                    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
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
                                            
                                            UserInformation.sharedInstance.appointments = JSON(item)
                                            
                                            activityView.stopAnimating()
                                            if shouldShowStartAppointmentButton {
                                                //self?.performSegueWithIdentifier("appointmentInProgressSegue", sender: nil)
                                                //self?.navigationItem.setHidesBackButton(true, animated: true)
                                                self?.appointmentInProgress = true
                                                self?.refreshDetailView()
                                            } else {
                                                self?.navigationController?.popViewControllerAnimated(true)
                                                NSNotificationCenter.defaultCenter().postNotificationName(kCheckForAppointmentNeedingCustomerRatingNotification, object: nil)
                                            }
                                            
                                        }
                                        
                                        
                                        
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
                let action = shouldShowEndAppointmentButton ? finishAppointmentAction : appointmentAction
                alertController.addAction(action)
                
                self!.presentViewController(alertController, animated: true) {
                    // ...
                }
                
            }
            
            let textColor = (shouldShowCancelButton || shouldShowEndAppointmentButton) ? UIColor.redColor() : UIColor.greenColor()
            row.cellConfig.setObject(textColor, forKey: "textLabel.textColor")
            section.addFormRow(row)

        }
        
        form.addFormSection(section)
        self.form = form
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "<Back", style: UIBarButtonItemStyle.Bordered, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton;

        
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
    
    func back() {
        if appointmentInProgress == true  {
            let alert = UIAlertController(title: "Appointment in Progress", message: "You must complete the current appointment first", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Gotya!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func refreshDetailView() {
        let appointments = UserInformation.sharedInstance.appointments
        
        for appointment in appointments {
            
            let status = appointment.1["status"].stringValue
            
            
            let jsonObj = appointment.1
            
            
            if status == "in_progress" {
                appointmentJson = jsonObj
                
                categoryName = String(appointmentJson["category"]["name"].stringValue.capitalizedString)
                
                appointmentStatus = stringToAppointmentStatus(appointmentJson["status"].stringValue)
                price = appointmentJson["appointment_price"].stringValue
                //   vc.appointmentStatus = String(json["status"].stringValue.capitalizedString)
                services = appointmentJson["service_requests"]
                
                priceTier = appointmentJson["requested_tier"].intValue
                
                
                
                
                break
            }
        }
        
        initializeForm()
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "proFinishedAppointment" {
            let popoverViewController = segue.destinationViewController //as! UIViewController
            
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            
            
            popoverViewController.popoverPresentationController?.sourceRect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1)
            popoverViewController.popoverPresentationController?.sourceView = self.view
            
            
            if let vc = segue.destinationViewController as? RatingsPopoverController {
                vc.isProRatingCustomer = true
                vc.appointmentID = appointmentJson["id"].stringValue
                let lastName = appointmentJson["customer"]["last_name"].stringValue
                vc.userToRateName = appointmentJson["customer"]["first_name"].stringValue + " " + String(lastName[lastName.startIndex]) + "."
                vc.userToRateImageURL = appointmentJson["customer"]["profile_picture"].URL
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        appointmentInProgress = false
        back()
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
