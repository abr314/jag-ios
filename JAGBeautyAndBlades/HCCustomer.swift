//
//  HCCustomer.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/18/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import RealmSwift

class HCCustomer: Object {
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var phoneNumber = ""
    dynamic var email = ""
    dynamic var isProfessional = false
    dynamic var password = ""
    dynamic var referralCode = ""
    
    // additional questions
    // address, payment information, D/L

}
