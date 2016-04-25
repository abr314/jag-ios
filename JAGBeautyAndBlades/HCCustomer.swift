//
//  HCCustomer.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/18/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit


class HCCustomer: NSObject {
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var email = ""
    var isProfessional = false
    var password = ""
    var referralCode = ""
    var token = ""
    var customerID = ""
    var preferredAddress:HCAddress?
    // additional questions
    // address, payment information, D/L

}

class HCProvider : HCCustomer {
    var image:UIImage?
    var averageRating = 0
    var category = ""
    
    //var isProfessional: Bool = true
    
}
