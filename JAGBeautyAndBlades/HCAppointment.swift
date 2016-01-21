//
//  HCAppointment.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/19/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import RealmSwift

class HCAppointment: NSObject {
    dynamic var appointmentID = 0
    dynamic var booking = ""
    dynamic var category = ""
    dynamic var customer = ""
    dynamic var serviceProvider = ""
    dynamic var address = ""
    dynamic var requestedStartBy = ""
    dynamic var requestedEndBy = ""
    dynamic var appointmentPrice = ""
    dynamic var actualStartTime = ""
    dynamic var actualEndTime = ""
    dynamic var confirmedCustomer = false
    dynamic var confirmedProvider = false
}
