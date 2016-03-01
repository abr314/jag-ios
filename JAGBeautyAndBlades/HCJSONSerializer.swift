//
//  HCJSONSerializer.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 3/1/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import Foundation
import SwiftyJSON

func createJSONObjectFromCustomer(customer:HCCustomer) -> [String: AnyObject] {
    
    var jsonObject = [String:AnyObject]()
    if (customer.isProfessional == false ) {
         jsonObject = [
            "email": customer.email,
            "password": customer.password,
            "first_name": customer.firstName,
            "last_name": customer.lastName,
            "phone" : customer.phoneNumber
        ]
    }
    
    if (customer.isProfessional == true ) {
        jsonObject = [
            "email": customer.email,
            "password": customer.password,
            "first_name": customer.firstName,
            "last_name": customer.lastName,
            "phone" : customer.phoneNumber,
            "referral_code" : customer.referralCode
        ]
    }
    return jsonObject
    
}