//
//  HCProfessional.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/18/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import RealmSwift

class HCProvider: Object {
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var phoneNumber = ""
    dynamic var email = ""
    dynamic var level = 0
    dynamic var dateJoined = NSDate()
    dynamic var applicationAccepted = false
    let licenseTypes = List<RLMStringWrapper>()
    let licenses = List<HCLicense>()
    let services = List<RLMStringWrapper>()
    var availabilities = List<HCAvailability>()
    var locations = List<HCLocation>()
    
    dynamic var proximityRadiusInMiles = 0
    
//    var licenses = RLMArray(objec
}
