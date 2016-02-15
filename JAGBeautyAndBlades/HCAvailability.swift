//
//  HCAvailability.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/26/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import RealmSwift

class HCAvailability: Object {
    dynamic var dayNumber = DayOfWeek.Monday.dayNumber
 //   dynamic var availableSlotByHalfHour
    dynamic var allDay = false
    dynamic var startTime = ""
    dynamic var endTime = ""
    dynamic var dayString = ""
}
