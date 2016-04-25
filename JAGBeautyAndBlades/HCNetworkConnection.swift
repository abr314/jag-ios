//
//  HCNetworkConnection.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 3/1/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//
/*
//import Foundation
import Alamofire
import SwiftyJSON

func sendCustomerSignUpInfoSuccessful(customer: HCCustomer) -> Bool {
    
    let JSONObject = createJSONObjectFromCustomer(customer)
    var url:String
    var bool:Bool = true
    
    if (customer.isProfessional == true) {
        url = kProSignUpURL
    } else {
        url = kCustomerSignUpURL
    }
   
    Alamofire.request(.POST, url, parameters: JSONObject)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .Success:
                bool = true
            case .Failure(let error):
                bool = false
                print(error)
            }
        }
    
    
    return bool
}

func retrieveAuthToken(email:String, password:String) -> String {
    /*
        Don't Use This
    */
    
    var newString = ""
   
    Alamofire.request(.POST, kAPITokenURL, parameters:["username":email,"password":password])
    
        .validate()
        
        .responseJSON { response in
            switch response.result {
            
            //response.result {
            case .Success(let JSON):
                    print(response)
                
                    _ = JSON.valueForKey("token")
                                
                    if let string = response.result.value?.valueForKey("token") as? String {
                        newString = string
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject("\(string)", forKey: kJAGToken)
                    }
            case .Failure(_):
                 break
            }
        }
    
    return newString
}

func retrieveCustomerAppointments(token:String) -> JSON {
    let headers = ["Authorization":  "Token  \(token)"]
    var value = JSON("")
    let queue = dispatch_queue_create("com.cnoon.manager-response-queue", DISPATCH_QUEUE_CONCURRENT)
    let request = Alamofire.request(.GET, kAppointmentsURL, headers: headers, encoding: .JSON)
    
        request.response(
            queue: queue,
            responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
            completionHandler: { response in
          //  switch response.result {
           // case .Success(let new):
              //  print(new)
                if let newValue = response.result.value {
                value = JSON(newValue)
                let defaults = NSUserDefaults.standardUserDefaults()

                defaults.setObject(newValue, forKey: "JAGAppointmentsJSON")
                }
           // case .Failure(let error):
              //  print(error)
           // }
            print(value)
            
          
            }
           )
  //  }
 //   value = ["":""]
    
    return value
}


func returnAuthToken(email:String, password:String) -> Request? {
    return Alamofire.request(.POST, kAPITokenURL, parameters:["username":email,"password":password])
}
func sendCustomerSignUpInfo(customer: HCCustomer) -> Int {
    
    let JSONObject = createJSONObjectFromCustomer(customer)
    var url = ""
   // var bool:Bool = true
    
    if (customer.isProfessional == true) {
        url = kProSignUpURL
    } else {
        url = kCustomerSignUpURL
    }
    
    Alamofire.request(.POST, url, parameters: JSONObject)
       return 0
}

func retrieveCustomerAppointments(token:String) -> Request? {
    
    let headers = ["Authorization":  "Token  \(token)"]
     Alamofire.request(.GET, kAppointmentsURL, headers: headers, encoding: .JSON)
    
        return nil
}

*/