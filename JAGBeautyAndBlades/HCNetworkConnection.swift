//
//  HCNetworkConnection.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 3/1/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import Foundation
import Alamofire

func sendCustomerSignUpInfoSuccessful(customer: HCCustomer) -> Bool {
    
    let JSONObject = createJSONObjectFromCustomer(customer)
    var url:String
    
    if (customer.isProfessional == true) {
        url = kProSignUpURL
    } else {
        url = kCustomerSignUpURL
    }
    Alamofire.request(.POST, url, parameters: JSONObject).responseJSON { (response) -> Void in
        if response.result.value != nil {
            print(response.result.value)
        }
    }
    
    
    
    return true
}