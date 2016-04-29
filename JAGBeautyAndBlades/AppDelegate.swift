//
//  AppDelegate.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/18/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
//import Locksmith
import AlamofireNetworkActivityIndicator
//import Alamofire
import Alamofire
import SwiftyJSON
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userInfo = UserInformation.sharedInstance

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
     //   userInfo = UserInformation.sharedInstance()
       Fabric.with([Crashlytics.self])
        NetworkActivityIndicatorManager.sharedManager.isEnabled = true
        
        
        
    //    UserInformation.sharedInstance.devEnviroment = kDevelopmentURL
        
        if (retrieveUserToken().0 == true) {
            
            let headers = ["Authorization":  "Token  \(userInfo.token)"]
            print(headers)
            
            Alamofire.request(.GET, kAppointmentsURL, headers: headers).responseJSON {
                
                response in switch response.result {
                    
                case .Success(let json):
                    
                    UserInformation.sharedInstance.appointments = JSON(json)
                    print("APPOINTMENTS:\(self.userInfo.appointments)")
                    UserInformation.sharedInstance.userAlreadyExists = true
                
                case .Failure(let error):
           
                    print(error)
                }
                
            }
            
            Alamofire.request(.GET, kSiteUserInfoURL, headers:headers)
                
                .validate()
                
                .responseJSON { response in
                    
                    switch response.result {
                        
                        case .Success(let json):
                        
                            print(json)
                            let userJSON = JSON(json)
                            print(userJSON)
                            let userTypeInt = userJSON["detail"]["user_type"].intValue
                            print(userTypeInt)
                            let userID = userJSON["detail"]["id"].stringValue
                            
                            
                            
                          //  dispatch_async(dispatch_get_main_queue(), {
                                
                            
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            UserInformation.sharedInstance.userAlreadyExists = true
                            if userTypeInt == 0 {
                                UserInformation.sharedInstance.customerProfile?.isProfessional = false
                                defaults.setObject("customer", forKey: "role")
                                
                            }
                            if userTypeInt == 1 {
                                
                                
                                UserInformation.sharedInstance.customerProfile?.isProfessional = true
                               
                                
                                defaults.setObject("pro", forKey: "role")
                            }
                          //  })
                            UserInformation.sharedInstance.customerProfile?.customerID = userID
                        
                        
                            
                        
                             
                           // dispatch_async(dispatch_get_main_queue(), {
                             //   return true
                           // })
            
                        case .Failure(let error):
               
                            print(error)
                    }
                }
        }
        
        
        return true
    }
    
    func retrieveUserToken() -> (Bool, String) {
        /**
 
        returns false if no token is found
         
        */
 
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        if let token = defaults.stringForKey(kJAGToken)  {
            UserInformation.sharedInstance.token = token
        }
        
        if let value = defaults.stringForKey("role") {
            if value == "customer" {
                UserInformation.sharedInstance.customerProfile?.isProfessional = false
            }
            if value == "pro" {
                UserInformation.sharedInstance.customerProfile?.isProfessional = true
            }
        }
 
        if let name = UserInformation.sharedInstance.token as? String
        {
            if name == "" {
                print("No token found")
                return (false, "No token found")
            }
            return (true, name)
      
        } else {
            return (false, "No token found")
        }
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

