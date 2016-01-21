//
//  HCServiceRequest.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/19/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import RealmSwift

class HCServiceRequest: NSObject {
    dynamic var serviceRequestID = 0
    dynamic var appointment = ""
    dynamic var service = ""
    dynamic var requestedTier = 0
    dynamic var serviceLinePrice = ""
}
