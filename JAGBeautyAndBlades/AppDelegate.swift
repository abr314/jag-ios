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

class AppDelegate: UIResponder, UIApplicationDelegate, GGLInstanceIDDelegate, GCMReceiverDelegate {

    var window: UIWindow?
    var userInfo = UserInformation.sharedInstance
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var connectedToGCM = false
    var subscribedToTopic = false
    var gcmSenderID: String?
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    
    let registrationKey = "onRegistrationCompleted"
    let messageKey = "onMessageReceived"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
     //   userInfo = UserInformation.sharedInstance()
        
        
        //Register with GCM for push notifications
        //registerApplicationWithGCM(application) CALLING FROM DASHBOARD VC NOW TO ENSURE USER IS AUTHENTICATED BEFORE TRYING TO PASS TOKEN TO BACKEND
        
        application.statusBarHidden = false;
        application.statusBarStyle = .LightContent;
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()] 
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
                                
                            
                            
                            
                            UserInformation.sharedInstance.userAlreadyExists = true
                            if userTypeInt == 0 {
                                UserInformation.sharedInstance.customerProfile?.isProfessional = false
                                self.defaults.setObject("customer", forKey: "role")
                                
                            }
                            if userTypeInt == 1 {
                                
                                
                                UserInformation.sharedInstance.customerProfile?.isProfessional = true
                               
                                
                                self.defaults.setObject("pro", forKey: "role")
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
        GCMService.sharedInstance().disconnect()
        
        self.connectedToGCM = false
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        GCMService.sharedInstance().connectWithHandler({(error:NSError?) -> Void in
            if let error = error {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
            }
        })
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Setup and Registration for Push Notifications
    
    func registerApplicationWithGCM(application: UIApplication) {
        // Register for remote notifications
        
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        
        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            // Fallback
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }
        
        let gcmConfig = GCMConfig.defaultConfig()
        gcmConfig.receiverDelegate = self
        GCMService.sharedInstance().startWithConfig(gcmConfig)
    }
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: NSData ) {
        
        
        // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
        let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
        instanceIDConfig.delegate = self
        // Start the GGLInstanceID shared instance with that config and request a registration
        // token to enable reception of notifications
        GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
        let registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,
                               kGGLInstanceIDAPNSServerTypeSandboxOption:true]
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
                                                                 scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
        
    }
    

    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError ) {
        print("Registration for remote notification failed with error: \(error.localizedDescription)")
        // [END receive_apns_token_error]
        let userInfo = ["error": error.localizedDescription]
        NSNotificationCenter.defaultCenter().postNotificationName(
            registrationKey, object: nil, userInfo: userInfo)
    }
    
    
    
    
    func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken
            print("Registration Token: \(registrationToken)")
            
            let userInfo = ["registrationToken": registrationToken]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
            
            if registrationToken != defaults.stringForKey(kGCMToken) {
                defaults.setObject(registrationToken, forKey: kGCMToken)
                
                let token = UserInformation.sharedInstance.token
                let headers = ["Authorization":  "Token  \(token)"]
                var params = [String: AnyObject]?()
                params = ["registration_id":registrationToken]
                Alamofire.request(.POST, kGCMTokenURL, parameters:params, headers:headers)
                    .responseJSON { response in
                        
                        switch response.result {
                            
                        case .Success(let json):
                            print(json)
                            
                        case .Failure(let error):
                            print(response.result)
                            print(error)
                            print(error.code)
                            print(error.localizedFailureReason)
//                            let alertController = returnAlertControllerForErrorCode(error.code)
//                            self.presentViewController(alertController, animated: true) {}
                            
                        }
                        
                        
                }
            }
            
        } else {
            print("Registration to GCM failed with error: \(error.localizedDescription)")
            let userInfo = ["error": error.localizedDescription]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        }
    }
    
    // [START on_token_refresh]
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
                                                                 scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    
    // MARK: - Receiving Push Notifications
    
    func application( application: UIApplication,
                      didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Notification received: \(userInfo)")
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        // Handle the received message
        
        NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
                                                                  userInfo: userInfo)
        
    }
    
    func application( application: UIApplication,
                      didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                                                   fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
        print("Notification received: \(userInfo)")
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        // Handle the received message
        // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
        // [START_EXCLUDE]
        NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
                                                                  userInfo: userInfo)
        handler(UIBackgroundFetchResult.NoData);
        // [END_EXCLUDE]
    }
    
    
}

