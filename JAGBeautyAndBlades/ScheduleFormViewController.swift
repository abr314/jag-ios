//
//  ScheduleFormViewController.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 3/18/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm
import Braintree
import Alamofire
import SwiftyJSON

extension NSDate {
    struct Date {
        static let formatterISO8601: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss:SSX"
            return formatter
        }()
    }
    var formattedISO8601: String { return Date.formatterISO8601.stringFromDate(self) }
}

//NSDate().formattedISO8601  // "2015-12-22T18:22:57.345Z"

class ScheduleFormViewController: XLFormViewController, BTDropInViewControllerDelegate {

    var appointment:HCAppointment?
    var braintreeClient: BTAPIClient?
    var customer: HCCustomer?
    var customerID = String()
    var braintreeToken = ""
    var clientNonce = ""
    var bookingID = 0
    var categoryID = 0
    /* 
        To Do:
            Set address and time frame
    */
    
    func dropInViewController(viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        // ...
        
        clientNonce = paymentMethodNonce.nonce
        // send to server and get confirmation
        var token = ""
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey(kJAGToken)
        {
            token = name
        }
        let headers = ["Authorization":  "Token  \(token)"]
        var parameter = ["":""]
        let newParameters = ["":""]
        if let newParameter = appointment?.bookingNumber {
            parameter = ["booking_id":"\(newParameter)","nonce":"\(clientNonce)"]
            bookingID = newParameter
        }
        
        Alamofire.request(.POST, kCheckoutURL, headers:headers, parameters:parameter)
            
            .validate()
            
            .responseJSON { response in
                switch response.result {
                    case .Success(let json):
                        print(response)
                        // call compete booking
                        let parameters = ["id":self.bookingID]
                        // add address and time to appointment
                        Alamofire.request(.POST, kCompleteBookingURL, parameters: parameters, headers:headers)
                            .responseJSON { response in
                                switch response.result {
                                    case .Success(let json):
                                        print(json)
                                    // booking completed, push back to root VC
                                        let alertController = UIAlertController(title: "Booking Completed", message: "Your appointment has been successfully booked. You will recieve a confirmation via SMS once a service provider has accepted your ticket.", preferredStyle: .Alert)
                                        
                                        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                                            // pop to root
                                            self.navigationController?.popToRootViewControllerAnimated(true)
                                            
                                            
                                        }
                                        
                                        alertController.addAction(cancelAction)
                                        self.presentViewController(alertController, animated: true) {
                                            // ...
                                    }
                                    case .Failure(let error):
                                        print(error)
                                }
                    }
                    case .Failure(let error):
                        print(error)
                        
                    break
                }
            }
        dismissViewControllerAnimated(true, completion: nil)
        // booking completed page, transition back to dashboard
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        // ...
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        
        var token = ""
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey(kJAGToken)
            {
                token = name
            }
        
        let headers = ["Authorization":  "Token  \(token)"]
        print("TOKEN: \(token)")
        // get customer ID
       // let customerIDResponse:Response = Response()
        Alamofire.request(.GET, kSiteUserInfoURL, headers:headers)
            
            .validate()
            
            .responseJSON { response in
                switch response.result {
                    
                //response.result {
                case .Success(let json):
                    let newResponse = JSON(json)// {
                    print("userInfo \(newResponse["detail"]["id"])")
                    self.customerID = newResponse["detail"]["id"].stringValue
                    print(self.customerID)
                    // get customer token
                    Alamofire.request(.GET, "\(kRequestBraintreeClientTokenURL)\(self.customerID)/clienttoken/", headers: headers).responseJSON { response in
                        switch response.result {
                            case .Success(let responsJSON):
                                print(responsJSON["detail"])
                                if let newToken = responsJSON["detail"]["client_token"] as? String {
                                    self.braintreeToken = newToken
                                    self.braintreeClient = BTAPIClient(authorization: newToken)
                                }
                            case .Failure(let error):
                                break
                            }
                    }
                case .Failure(let error):
                    break
                }
        }
        
        // Do any additional setup after loading the view.
        initializeForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
       // appointment = HCAppointment()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
       // appointment = HCAppointment()
    }
    
    
    func initializeForm() {
       // let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        let form:XLFormDescriptor = XLFormDescriptor(title: "Schedule")
        
        // Section 1 Start and End Time
        
        section = XLFormSectionDescriptor.formSectionWithTitle("")
        
        /**
         Add a tag and XLFormRowDescriptorType to an array to add a row.
         
         let exampleArray = [kRowTag, RowDescriptorType]
         
        */
        
        let startTimeArray = [kStartTime, XLFormRowDescriptorTypeDateTimeInline]
        let endTimeArray = [kEndTime, XLFormRowDescriptorTypeDateTimeInline]
        
        let arrayOfRows = [startTimeArray, endTimeArray]
        
        for rows in arrayOfRows {
            row = XLFormRowDescriptor(tag: rows[0], rowType: rows[1], title: rows[0])
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            
            section.addFormRow(row)
        }
        
        form.addFormSection(section)
        
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Address")
        
        let firstLineArray = [kFirstLine,XLFormRowDescriptorTypeText]
        let secondLineArray = [kSecondLine, XLFormRowDescriptorTypeText]
        let zipArray = [kZipCode, XLFormRowDescriptorTypeNumber]
        let cityStateArray = [kCityState, XLFormRowDescriptorTypeText]
        
        let arrayOfRows1 = [firstLineArray, secondLineArray, zipArray, cityStateArray]
        
        for rows in arrayOfRows1 {
            row = XLFormRowDescriptor(tag: rows[0], rowType: rows[1], title: rows[0])
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            
            if (row.tag == kCityState) {
                row.value = "Austin, TX"
                row.disabled = true
            }
            section.addFormRow(row)
        }
        
        form.addFormSection(section)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("")
        
        row = XLFormRowDescriptor(tag: "Book", rowType: XLFormRowDescriptorTypeButton, title: "Book Now")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
        row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
        row.action.formSelector = #selector(ScheduleFormViewController.bookNowPressed)
        section.addFormRow(row)
        
        form.addFormSection(section)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Payment Information")
        
        row = XLFormRowDescriptor(tag: "Payment Information", rowType: XLFormRowDescriptorTypeButton, title: "Payment Information")
        self.form = form
    }
    
    func paymentInformationButtonChecked() {
        
    }

    
    func validationSuccessful() -> Bool {
        
        // turned off
        if (!validateStringMinutesForDifference()) {
           // return false
        }
        
        return true
        
    }
    
    func validateStringMinutesForDifference()-> Bool {
        var startMinutes:Int = Int()
        var endMinutes:Int = Int()
        
        if let startTime = form.formRowWithTag(kStartTime)?.value as? NSDate {
            startMinutes = formatToMinuteInt(startTime)
        }
        
        if let endTime = form.formRowWithTag(kEndTime)?.value as? NSDate {
            endMinutes = formatToMinuteInt(endTime)
        }
        
        if ((endMinutes - startMinutes) < 30) {
            print("validation error, time is too short")
            return false
        }
        
        
        if (startMinutes > endMinutes) {
            print("Validation error, start time is after end time")
            return false
        }
        
        return true
    }
    
    func formatToMinuteInt(date:NSDate) -> Int {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        //   let newDateString = dateFormatter.stringFromDate(date)
        //  let newDate = dateFormatter.dateFromString(newDateString)
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: date)
        
        let minutes:Int = comp.minute
        
        let hoursToMinutes:Int = comp.hour*60
        
        return minutes + hoursToMinutes
    }
    
    func formatHourAndMinuteToString(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        //   let newDateString = dateFormatter.stringFromDate(date)
        //  let newDate = dateFormatter.dateFromString(newDateString)
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: date)
        var clockType = ""
        
        if (comp.hour > 12) {
            clockType = "PM"
        } else {
            clockType = "AM"
        }
        let minutes = "\(comp.minute)"
        var hour = "\(comp.hour)"
        
        if (Int(hour) > 12) {
            if let newInt = Int(hour) {
                newInt - 12
                hour = String(newInt)
            }
        }
        
        print(hour + ":" + minutes + " " + clockType)
        
        return hour + ":" + minutes + " " + clockType
    }
    
    func bookNowPressed() {
        if (validationSuccessful()) {
          //  appointment = HCAppointment()
            synchronizeData()
            // update appointment with address and time info
            var token = ""

            let defaults = NSUserDefaults.standardUserDefaults()
            if let name = defaults.stringForKey(kJAGToken)
            {
                token = name
            }
            let headers = ["Authorization":  "Token  \(token)"]
            
            let appointmentStart = appointment?.requestedStartBy
            var reqAppSta = ""
         //   appointmentStart?.characters.dropLast(3)
            if let startTime = appointmentStart {
               reqAppSta = "2016-09-22T12:12"
            }
            //reqAppSta.characters.dropLast(3)
            let appointmentEnd = appointment?.requestedEndBy
            
            var reqAppEnd = ""
            if let end = appointmentStart {
                reqAppEnd = "2016-09-22T16:12"
            }
           // reqAppEnd.characters.dropLast(3)
            print(reqAppEnd)
          //  var reqAppEnd = ""
            var appointmentID = 0
            var bookingNumber = 0
            var appPrice = ""
            if let new = appointment?.bookingNumber {
                bookingNumber = new
                print("bookingnumber:\(bookingNumber)")
            }
            if let new = appointment?.appointmentID {
                appointmentID = new
            }
            let appointmendRequestURL = "\(kAppointmentUpdateURL)\(appointmentID)/"
            print("\(appointmendRequestURL)")
            /**
             Booking and Category are required
            */
            var requestedStartBy = NSDate()
            
            if let time = appointment?.requestedStartBy {
                requestedStartBy = time
            }
            
            var requestedEndBy = NSDate()
            
            if let time = appointment?.requestedEndBy {
                requestedEndBy = time
                print(time.formattedISO8601)
            }
            
            if let price = appointment?.appointmentPrice {
                appPrice = price
            }
            let newHeader = ["requested_start_by": "2016-04-03T16:30:00Z","requested_end_by":"2016-04-03T16:30:00Z","id":"\(appointmentID)","category":categoryID, "booking":"\(bookingNumber)", "service_provider":[:], "address":[:], "confirmed_customer":"false", "confirmed_provider":"false", "appointment_price": appPrice, "actual_start_time":[:],"actual_end_time":[:], "customer":"\(customerID)"]
            
            
        //    let newHeader = JSON(["Authorization":  "Token  \(token)","Content-Type":"application/json"])
            Alamofire.request(.PUT, appointmendRequestURL, headers:["Authorization":  "Token  \(token)"], parameters: ["requested_start_by": "2016-04-03T16:30:00Z","requested_end_by":"2016-04-03T16:30:00Z","id":"\(appointmentID)","category":categoryID, "booking":"\(bookingNumber)", "service_provider":"", "address":"", "confirmed_customer":"false", "confirmed_provider":"false", "appointment_price": appPrice, "actual_start_time":"","actual_end_time":"", "customer":"\(customerID)"])
                
                .responseString { response in
                    print(response)
                    print(response.result.description)
                    
                    
                    switch response.result {
                    case .Success(let json):
                        print(response)
                        var line1con = ""
                        var line2con = ""
                        var zip = ""
                        if let line1 = self.appointment?.address.line1 {
                            line1con = line1
                        }
                        
                        if let line2 = self.appointment?.address.line2 {
                            line2con = line2
                        }
                        
                        if let zip1 = self.appointment?.address.zipcode {
                            zip = zip1
                        }
                        Alamofire.request(.POST, kAddressCreateOnAppointmentURL, headers:headers, parameters: ["appointment":"\(self.appointment!.appointmentID)","line1":line1con,"line2":line2con,"city":"austin","state":"texas","zip_code":zip])
                           // print(appointmentID)
                            .responseString { response in
                                switch response.result {
                                case .Success(let json):
                                print(response)
                                case .Failure(let json):
                                print(response)
                                break
                                }
                            }
                    case .Failure(let error):
                        print(error)
                        print(appointmentID)
                        break
                    }
            }
 
            var parameter = ["":""]
            // call braintree
            
            // If you haven't already, create and retain a `BTAPIClient` instance with a
            // tokenization key OR a client token from your server.
            // Typically, you only need to do this once per session.
            // braintreeClient = BTAPIClient(authorization: aClientToken)
            
            // Create a BTDropInViewController
            let dropInViewController = BTDropInViewController(APIClient: braintreeClient!)
            dropInViewController.delegate = self
            var paymentRequest = BTPaymentRequest()
         
            if let string = appointment?.appointmentPrice {
               paymentRequest.displayAmount = "$\(string)"
            }
            
            
            paymentRequest.summaryDescription = "Ships in five days"
            paymentRequest.summaryTitle = "Total"
            paymentRequest.callToActionText = "Book Now"

            dropInViewController.paymentRequest = paymentRequest
            
            // This is where you might want to customize your view controller (see below)
            
            // The way you present your BTDropInViewController instance is up to you.
            // In this example, we wrap it in a new, modally-presented navigation controller:
            dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonSystemItem.Cancel,
                target: self, action: #selector(ScheduleFormViewController.userDidCancelPayment))
            let navigationController = UINavigationController(rootViewController: dropInViewController)
            presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    func userDidCancelPayment() {
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    private func synchronizeData () {
        //   let startTime:NSDate = NSDate()
        
        if let startTime:NSDate = form.formRowWithTag(kStartTime)?.value as? NSDate {
          //  let soethign = formatterShortDate
           // let time = startTime.stringValue//formatHourAndMinuteToString(startTime)
        //    let time = startTime.shortDate
    
            appointment?.requestedStartBy = startTime
            
        }
        
        if let endTime:NSDate = form.formRowWithTag(kEndTime)?.value as? NSDate {
            
            appointment?.requestedEndBy = endTime
            
        }
        
        if let date:NSDate = form.formRowWithTag("Date")?.value as? NSDate {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            let something = components.month
        
            print(something)
         //   let realDate = date
          //  appointment?.date = date
            
        }
        
        if let firstLine:String = form.formRowWithTag(kFirstLine)?.value as? String {
            appointment?.address.line1 = firstLine
        }
        
        if let secondLine:String = form.formRowWithTag(kSecondLine)?.value as? String {
            appointment?.address.line2 = secondLine
        }
        
        if let zip:Int = form.formRowWithTag(kZipCode)?.value as? Int {
            appointment?.address.zipcode = "\(zip)"
        }
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
