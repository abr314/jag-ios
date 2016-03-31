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

class ScheduleFormViewController: XLFormViewController {

    var appointment:HCAppointment?
    var braintreeClient: BTAPIClient?
    var customer: HCCustomer?
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        
        let clientTokenURL = NSURL(string: "https://braintree-sample-merchant.herokuapp.com/client_token")!
     //   let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL)!
  //      clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        if let customer = self.customer {
            
        /*
            Alamofire.request(.GET, "\(kRequestBraintreeClientTokenURL)\(customer.id)/clienttoken/", parameters:  ["username":customer.email,"password":customer.password])
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                print(response)
            /*
  */
            if let something = JSON.valueForKey("token") as? String {
                self.customer.token = something
                // Add token to nsuserdefaults
                NSUserDefaults.standardUserDefaults().setObject(something, forKey: kJAGToken)
                // pop view to dashboard
                self.performSegueWithIdentifier("main", sender: nil)
            }
 
                case .Failure(let error):
            
                break
                }
 */
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
        
        let startTimeArray = [kStartTime, XLFormRowDescriptorTypeTimeInline]
        let endTimeArray = [kEndTime, XLFormRowDescriptorTypeTimeInline]
        
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
        
        
        section = XLFormSectionDescriptor.formSectionWithTitle("")
        row = XLFormRowDescriptor(tag: "Date", rowType: XLFormRowDescriptorTypeDate, title: "Date")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
        row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
        
        section.addFormRow(row)
        
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
        
        if (!validateStringMinutesForDifference()) {
            return false
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
            appointment = HCAppointment()
            synchronizeData()
            // add to provider availability array
            
    //        professional?.availabilities.append(availability)
            
           // self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func synchronizeData () {
        //   let startTime:NSDate = NSDate()
        
        if let startTime:NSDate = form.formRowWithTag(kStartTime)?.value as? NSDate {
            
            let time = formatHourAndMinuteToString(startTime)
            
            appointment?.requestedStartBy = formatHourAndMinuteToString(startTime)
            
        }
        
        if let endTime:NSDate = form.formRowWithTag(kEndTime)?.value as? NSDate {
            
            let time = formatHourAndMinuteToString(endTime)
            
            let timeString:String = formatHourAndMinuteToString(endTime)
            appointment?.requestedEndBy = timeString
            
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
        
        /*
        if let endTime = form.formRowWithTag("EndTime")?.value as? NSDate {
            let timeString:String = formatHourAndMinuteToString(endTime)
            availability.endTime = timeString
        }
        
        if let allDayEnabled = form.formRowWithTag("All-Day")?.value as? Bool {
            availability.allDay = allDayEnabled
        }
        */
        
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
