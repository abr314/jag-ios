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
    dynamic var phoneNumber = 0
    dynamic var email = ""
    dynamic var level = 0
    dynamic var dateJoined = NSDate()
    dynamic var applicationAccepted = false
    dynamic var licenses = []
    dynamic var preferredLocation = []
    dynamic var proximityRadiusInMiles = 0
    
}
