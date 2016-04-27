//
//  UserInformation.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 4/20/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserInformation: NSObject {
    
    
    static let sharedInstance = UserInformation()
    
    var appointments = JSON.null
    var token = ""
    var customerProfile:HCCustomer?
    var userAlreadyExists = false
}
