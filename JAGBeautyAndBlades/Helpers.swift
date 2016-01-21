//
//  Helpers.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/20/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit

class Helpers: NSObject {

    
}

public func isValidPhone(value: String) -> Bool {
    
    let PHONE_REGEX = "^\\+\\d{3}-\\d{2}-\\d{7}$"
    
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    
    let result =  phoneTest.evaluateWithObject(value)
    
    return result
    
}
