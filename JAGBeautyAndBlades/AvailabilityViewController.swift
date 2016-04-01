//
//  AvailabilityViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/29/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm


class AvailabilityViewController: XLFormViewController {
// sections are days of the week
    
    var professional:HCProvider?
    var realm:Realm?
    var availability = HCAvailability()
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
   // let availability =  HCAvailability()
    
    
    override func viewDidLoad() {
       // print(self.tableView)
     //   self.navigationItem.backBarButtonItem?.title = "Back"
     //   tableView.backgroundColor = UIColor.blackColor()
    }
    override func viewWillAppear(animated: Bool) {
     //   self.inputViewController?.view.backgroundColor = UIColor.blackColor()
        
   //     self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
     //   self.tableView.backgroundColor = UIColor.blackColor()
    }
    
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Availability")
        
        form.assignFirstResponderOnShow = true
        
        // Section 1 = Day of the Week selector
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Hello World")
        form.addFormSection(section)
        
        let dayArray = [kDay, XLFormRowDescriptorTypeSelectorPickerViewInline]
        let startTimesArray = [kStartTime, XLFormRowDescriptorTypeTimeInline]
        let endTimeArray = [kEndTime, XLFormRowDescriptorTypeTimeInline]
        let allDayArray = [kAllDay, XLFormRowDescriptorTypeBooleanSwitch]
        let saveArray = [kSave, XLFormRowDescriptorTypeButton]
       // let cancelArray = [kCancel, XLFormRowDescriptorTypeButton]
        
        let arrayOfRows = [dayArray, startTimesArray, endTimeArray, allDayArray, saveArray]//, cancelArray]
       
        for rowStrings in arrayOfRows {
            
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
            // add row customizations here
            
            if (row.tag == kDay) {
                row.selectorOptions = [DayOfWeek.Sunday.rawValue, DayOfWeek.Monday.rawValue, DayOfWeek.Tuesday.rawValue, DayOfWeek.Wednesday.rawValue, DayOfWeek.Thursday.rawValue, DayOfWeek.Friday.rawValue, DayOfWeek.Saturday.rawValue]
                row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.backgroundColor")
                row.value = DayOfWeek.Monday.rawValue
            }
            if (row.tag == kStartTime || row.tag == kEndTime) {
             //   form.addFormSection(section)
                row.cellConfigAtConfigure["minuteInterval"] = 5
                row.value = NSDate()
            }
            
            if (row.tag == kAllDay) {
                row.cellConfig.setObject(UIColor.purpleColor(), forKey: "accessoryView.onTintColor")
            }
            
            if (row.tag == kSave) {
                row.action.formSelector = "didTouchSaveButton"
            }
            
         //   if (row.tag == kCancel) {
       //         row.action.formSelector = "didTouchCancelButton"
           // }
            
         section.addFormRow(row)
        }
    //    let timesArray = [
        // row 1 = day
        /*
        // Selector Picker View
        row = XLFormRowDescriptor(tag: "Day", rowType:XLFormRowDescriptorTypeSelectorPickerViewInline, title:"Day")
        row.selectorOptions = [DayOfWeek.Sunday.rawValue, DayOfWeek.Monday.rawValue, DayOfWeek.Tuesday.rawValue, DayOfWeek.Wednesday.rawValue, DayOfWeek.Thursday.rawValue, DayOfWeek.Friday.rawValue, DayOfWeek.Saturday.rawValue]
        row.value = DayOfWeek.Monday.rawValue
        
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfigAtConfigure["textLabel.backgroundColor"] = UIColor.blackColor()
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
     //   row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textField.font")
        section.addFormRow(row)
        
        // Section 2 = Times
        section = XLFormSectionDescriptor.formSectionWithTitle("")
        form.addFormSection(section)
        // row 1 = Start(Label) startTime(detail) not selectable
        row = XLFormRowDescriptor(tag: "StartTime", rowType: XLFormRowDescriptorTypeTimeInline)
        row.title = "Start Time"
        row.cellConfigAtConfigure["minuteInterval"] = 5
        row.value = NSDate()
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfigAtConfigure["textLabel.backgroundColor"] = UIColor.blackColor()
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
        
        section.addFormRow(row)
        
        // row 2 = End(Label) endTime(detail)
        
        row = XLFormRowDescriptor(tag: "EndTime", rowType: XLFormRowDescriptorTypeTimeInline)
        row.title = "End Time"
        row.cellConfigAtConfigure["minuteInterval"] = 5
        row.value = NSDate()
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfigAtConfigure["textLabel.backgroundColor"] = UIColor.blackColor()
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
        section.addFormRow(row)
        
        //section 3 = Time selector
        section = XLFormSectionDescriptor.formSectionWithTitle("")
        form.addFormSection(section)
        // row 1 = start/end segmented controller
        
        // row 2 = all day slider button
        row = XLFormRowDescriptor(tag: "All-Day", rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "All-Day")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.purpleColor(), forKey: "accessoryView.onTintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfigAtConfigure["textLabel.backgroundColor"] = UIColor.blackColor()
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
        section.addFormRow(row)
        // row 3 = time selector
        
        // section 4 = save and cancel
        section = XLFormSectionDescriptor.formSectionWithTitle("")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: "Save", rowType: XLFormRowDescriptorTypeButton, title: "Save")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfigAtConfigure["textLabel.backgroundColor"] = UIColor.blackColor()
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
        row.action.formSelector = "didTouchSaveButton"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Cancel", rowType: XLFormRowDescriptorTypeButton, title: "Cancel")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfigAtConfigure["textLabel.backgroundColor"] = UIColor.blackColor()
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
        row.action.formSelector = "didTouchCancelButton"
        section.addFormRow(row)
        
        // row 1 = save
        // row 2 =cancel
        */
        self.form = form
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
        var minutes = "\(comp.minute)"
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
    
    func validateStringMinutesForDifference()-> Bool {
        var startMinutes:Int = Int()
        var endMinutes:Int = Int()
        
        if let startTime = form.formRowWithTag("StartTime")?.value as? NSDate {
           startMinutes = formatToMinuteInt(startTime)
        }
        
        if let endTime = form.formRowWithTag("EndTime")?.value as? NSDate {
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
    
    func dateStringToInt(date: String) -> Int {
        if (date == "Sunday") { return DayOfWeek.Sunday.dayNumber }
        if (date == "Monday") { return DayOfWeek.Monday.dayNumber }
        if (date == "Tuesday") { return DayOfWeek.Tuesday.dayNumber }
        if (date == "Wednesday") { return DayOfWeek.Wednesday.dayNumber }
        if (date == "Thursday") { return DayOfWeek.Thursday.dayNumber }
        if (date == "Friday") { return DayOfWeek.Friday.dayNumber }
        if (date == "Saturday") { return DayOfWeek.Saturday.dayNumber }
        else {
            return 0}
    
    }
    
    func synchronizeData () {
     //   let startTime:NSDate = NSDate()
        
        if let day = form.formRowWithTag("DayOfTheWeek")?.value as? String {
            availability.dayNumber = dateStringToInt(day)
        }
        if let startTime = form.formRowWithTag("StartTime")?.value as? NSDate {
            let timeString:String = formatHourAndMinuteToString(startTime)
            availability.startTime = timeString
            
        }
        if let endTime = form.formRowWithTag("EndTime")?.value as? NSDate {
            let timeString:String = formatHourAndMinuteToString(endTime)
            availability.endTime = timeString
        }
        
        if let allDayEnabled = form.formRowWithTag("All-Day")?.value as? Bool {
            availability.allDay = allDayEnabled
        }
    }
    
    func validationSuccessful() -> Bool {
        
        if (!validateStringMinutesForDifference()) {
            return false
        }
        
        return true
        
    }
    
    func didTouchSaveButton () {
    // validate
    
        if (validationSuccessful()) {
            synchronizeData()
            // add to provider availability array
            
            professional?.availabilities.append(availability)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
     
    
    // pop VC
   
    }
    
    func didTouchCancelButton () {
        
        self.navigationController?.popToRootViewControllerAnimated(true)    
    }
}
