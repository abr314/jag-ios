//
//  JAGURLs.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 3/1/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import Foundation

// SignUp
let kRealURL = "https://jagbeautyandblades.com/"
let kTestURL = "http://127.0.0.1:8000/"

var URL = kRealURL

//let realURL = true

let kCustomerSignUpURL = "\(URL)profiles/api/customer/register/"
let kProSignUpURL = "\(URL)profiles/api/provider/register/"
let kAPITokenURL = "\(URL)api-token-auth/"
let kAppointmentsURL = "\(URL)api/bookings/appointments/"
let kServiceCategoriesURL = "\(URL)api/services/categories/"
let kCreateBookingURL = "\(URL)api/bookings/bookings/create/"
let kCreateAppointmentURL = "\(URL)api/bookings/appointments/create/"
let kCreateServiceRequestURL = "\(URL)api/bookings/servicerequests/create/"
let kRequestBraintreeClientTokenURL = "\(URL)api/profiles/user/"//<user_id>/clienttoken/"
let kSiteUserInfoURL = "\(URL)api/profiles/siteuser/"
let kCheckoutURL = "\(URL)api/bookings/checkout/"
let kCompleteBookingURL = "\(URL)api/booking/complete/"
let kAppointmentUpdateURL = "\(URL)api/bookings/appointments/update/"
let kAddressCreateOnAppointmentURL = "\(URL)api/address/create/"
let kDeleteAppointmentURL = "\(URL)api/bookings/appointments/delete/" // <appointment_id>/
let kAppointmentCancelURL = "\(URL)api/bookings/appointments/cancel/"