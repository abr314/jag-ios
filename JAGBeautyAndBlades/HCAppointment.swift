//
//  HCAppointment.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/19/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit


class HCAppointment: NSObject {
    var appointmentID = 0
    var booking = ""
    var category = 0
    var customer = ""
    var serviceProvider = ""
    var address = HCAddress() 
    var requestedStartBy = ""
    var requestedEndBy = ""
    var appointmentPrice = ""
    var actualStartTime = ""
    var actualEndTime = ""
    var confirmedCustomer = false
    var confirmedProvider = false
    var date = ""
    var bookingNumber = 0
    var idNumber = 0
    var paymentConfirmed = false
    var serviceRequests = [HCServiceRequest]()
  //  var category = 0
}
