//
//  HCTimeSlot.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/26/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import RealmSwift

class HCTimeSlot: Object {
    dynamic var startTime = ""
    dynamic var endTime = ""
    dynamic var dayNumber = DayOfWeek.Monday.dayNumber
}
