//
//  Helpers.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/20/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit

enum UserType {
    case Provider
    case Customer
}

enum FormMode {
    case CreateMode
    case EditMode
    case ViewMode
}

let kName = "Name"
let kLicenseOptions = "License Options"
let kProcedures = "Procedures"
let kPlist = "plist"
let kServiceTypesPlistTitle = "ServiceTypes"


let kFirstName = "First Name"
let kLastName = "Last Name"
let kPhone = "Phone"
let kEmail = "Email"
let kNext = "Next"
let kPassword = "Password"
let kBookNow = "Book Now"
let kSignUp = "Sign Up"
let kLogin = "Login"
let kDay = "Day"
let kStartTime = "Start Time"
let kEndTime = "End Time"
let kAllDay = "All-Day"
let kSave = "Save"
let kCancel = "Cancel"
let kSubmit = "Submit"
let kFirstLine = "First Line"
let kSecondLine = "Second Line"
let kZipCode = "Zip Code"
let kCityState = "City and State"

let kBarberImageString = "HairMan"
let kCosmoImageString = "CosmoMan"
let kMassageImageString = "MassageMan"
let kNailImageString = "NailApp"
let kSpaImageString = "SpaApp"
let kTrainerImageString = "TrainerApp"

let kNetworkAuthorizationString = "Authorization"

let kJAGToken:String = "JAGToken"

let path:String? = NSBundle.mainBundle().pathForResource("ServiceTypes", ofType: "plist")



class ServicesManager {
    
    let servicesArray = NSArray(contentsOfFile: path!)
}



public func isValidPhone(value: String) -> Bool {
    
    let PHONE_REGEX = "^\\+\\d{3}-\\d{2}-\\d{7}$"
    
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    
    let result =  phoneTest.evaluateWithObject(value)
    
    return result
    
}
/*
public enum ServiceCategoryType: String {
    case kHairType = "Hair"
    case kNailsType = "Nails"
    case kMassageType = "Massage"
    case kSpaType = "Spa"
    case kCosmeticType = "Cosmetic"
    case kTrainingType = "Training"
    case kYogaType = "Yoga"
    case count
    
    private static let serviceTypes = [kHairType, kNailsType, kMassageType, kSpaType, kCosmeticType, kTrainingType, kYogaType]
    
    static func fromNumber(number: Int) -> ServiceCategoryType {
        // FIXME check number index out of bounds
        return serviceTypes[number]
    }
}
*/
/*
public enum DayOfWeek: String {
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    case Sunday = "Sunday"
    
    var description: String {
        get {
            return self.rawValue
        }
    }
    
    var dayNumber: Int {
        get {
            return self.hashValue
        }
    }
    
    private static let days = [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]
    
    static func fromNumber(number: Int) -> DayOfWeek {
        // FIXME check number index out of bounds
        return days[number]
    }
}
*/

/*
public enum LicenseType: String {
    
   // var servicesProvided:Array<ServiceCategoryType>
    case BarberType = "Barber"
    case CosmetologyType = "Cosmetology"
    case ManicuristType = "Manicurist"
    case EtheticianType = "Ethetician"
    case EyeLashExtensionsType = "Eye Lash Extensions"
    case ManicuristEsthecticianType = "Manicurist/Esthetician"
    case SprayTansType = "Spray Tans"
    case MassageType = "Massage"
    case FitnessType = "Fitness"
    case YogaType = "Yoga"
    case PersonalTrainerType = "Personal Training"
    case count
    
    static let licenseTypeNames = [BarberType : "Barber", CosmetologyType : "Cosmotology", ManicuristType : "Manicurist", EtheticianType : "Ethetician", EyeLashExtensionsType : "Eye Lash Extensions", ManicuristEsthecticianType : "Manicurist/Esthetician", SprayTansType : "Spray Tans", MassageType : "Massage", FitnessType : "Fitness", YogaType : "Yoga", PersonalTrainerType : "Personal Training"]
    
   
    var description: String {
        get {
            return self.rawValue
        }
    }
    
    var typeNumber: Int {
        get {
            return self.hashValue
        }
    }
    
    private static let licenses = [BarberType, CosmetologyType, ManicuristType, EtheticianType, EyeLashExtensionsType, ManicuristEsthecticianType, SprayTansType, MassageType, FitnessType, YogaType, PersonalTrainerType]
    
    static func fromNumber(number: Int) -> LicenseType {
        // FIXME check number index out of bounds
        return licenses[number]
    }
}
*/
