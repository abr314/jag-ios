//
//  HCErrorMessageManager.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 4/22/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit


    
    func returnAlertControllerForErrorCode(errorCode: Int) -> UIAlertController {
        
        var string = "Error: Please try again later."
        
        if errorCode == -1004 {
            string = "Could not connect to the server. Please try again later."
        }
        
        if errorCode == -1009 {
            string = "The Internet connection appears to be offline. You must be connected to the internet to use JAG services. Please reconnect and try again."
        }
       
        if errorCode == -6003 {
            
            string = "Login failed. Could not authenticate user credentials."
        }
        let alertController = UIAlertController(title: nil, message: string, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(okAction)
        
        return alertController
    }
    
    

