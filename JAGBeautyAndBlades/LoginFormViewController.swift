//
//  LoginFormViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/4/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON
import Alamofire
import Fabric
import Crashlytics

/// This view controller is show on the first start up, or if an authentication token is not found in NSUserDefaults. A user will bypass this VC, directly to the Dashboard/TabBar if a token is found

/**
 
 Login View Controller
 */
class LoginFormViewController: XLFormViewController {
    // MARK: property
    var customer:HCCustomer?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
 
    func initializeForm() {
        
        ///
        /// intializeForm: This builds the form using the XLForm library. Forms require a tag, title and form type.
        
        
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
       
        form = XLFormDescriptor(title: "JAG for Men")
        
        section = XLFormSectionDescriptor.formSectionWithTitle("")
        
        form.addFormSection(section)
        
        let emailArray = [kEmail, XLFormRowDescriptorTypeEmail]
        let passwordArray = [kPassword, XLFormRowDescriptorTypePassword]
    
        let signUpArray = [kSignUp, XLFormRowDescriptorTypeButton]
        let loginArray = [kLogin, XLFormRowDescriptorTypeButton]
        
        let arrayOfRows = [emailArray, passwordArray, loginArray, signUpArray] //bookNowArray, signUpArray]
        
        for rowStrings in arrayOfRows {
            
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            // add row customizations here
            
            if (row.tag == kLogin) {
                row.action.formSelector = #selector(LoginFormViewController.loginButtonPressed)
            //    row.disabled = true
               
            }
            
            if (row.tag == kSignUp) {
                row.action.formSelector = #selector(LoginFormViewController.signUpPressed)
                row.cellConfig.setObject("", forKey: "self.selectionStyle")
                section = XLFormSectionDescriptor.formSectionWithTitle(" ")
                form.addFormSection(section)
            }
            if (row.tag != kSignUp && row.tag != kLogin) {
                row.required = true
                
                row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textField.font")
                row.cellConfig.setObject(UIColor.blackColor(), forKey: "textField.textColor")
            }
            
            if (row.tag == kPhone) {
                row.addValidator(XLFormRegexValidator(msg: "At least 6, max 32 characters", andRegexString: "^[2-9][0-9]{9}$"))
            }
            
            if (row.tag == kEmail) {
                row.addValidator(XLFormRegexValidator(msg: "", andRegexString: "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"))
            }
            
            section.addFormRow(row)
        }
        
        self.form = form
    }
    
    func userAlreadyExist() -> Bool {
        return UserInformation.sharedInstance.token != ""
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 2 {
            return 30
        }
        
        return 20
    }
    
    override func viewDidLoad() {
    
        if UserInformation.sharedInstance.customerProfile?.isProfessional == true {
            
            
            performSegueWithIdentifier("providerAppointments", sender:self)
        }
        if (userAlreadyExist()) {
            
            if let string = NSUserDefaults.standardUserDefaults().stringForKey(kJAGToken) {
                customer?.token = string
                performSegueWithIdentifier("appointments", sender:self)
            }
        }
        
        super.viewDidLoad()
     
        if let font = UIFont(name: kHeaderFont, size: 25) {
    
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSFontAttributeName: font,
                    NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
     
    }
    
    override func viewWillAppear(animated: Bool) {
        let recognizer = UITapGestureRecognizer(target: self, action: "enableDebugTools")
        recognizer.numberOfTapsRequired = 3
        self.navigationController?.navigationBar.addGestureRecognizer(recognizer)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signUpPressed() {
        
        // validate email and password and check for login
        // check email, if the not empty, validate. if valid, pass data to next controller
        // UserType is Unknown
        
        dispatch_async(dispatch_get_main_queue(),{
            self.performSegueWithIdentifier("SignUp",sender: self)
        })
      //  performSegueWithIdentifier("SignUp", sender: nil)
    }
    
    func bookNowPressed() {
        
        performSegueWithIdentifier("BookNow", sender: nil)

    }
    
    func loginButtonPressed() {
        // verify fields and signin
        
        let result:Bool = validateForm(self)
    
        
        
        if (result) {
            
            if let email = form.formRowWithTag(kEmail)?.value as? String, password = form.formRowWithTag(kPassword)?.value as? String {
            
                var activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                activityView.color = UIColor.blackColor()
              //  transform = CGAffineTransform(CGAffineTransformMakeScale(1.5f, 1.5f);
              //  activityIndicator.transform = transform
                activityView.center = self.view.center
                activityView.hidesWhenStopped = true
            //    activityView.activityIndicatorViewStyle = UIActivityIndicatorView.
                
                activityView.startAnimating()
                
                self.view.addSubview(activityView)
                Alamofire.request(.POST, kAPITokenURL, parameters:["username":email,"password":password])
                    
                    .validate()
                    
                    .responseJSON { response in
                        switch response.result {
       
                        
                        case .Success(let object):
                         
                            print(object)
                
                            if let string = response.result.value?.valueForKey("token") as? String {
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject("\(string)", forKey: kJAGToken)
                                UserInformation.sharedInstance.token = string
                                UserInformation.sharedInstance.userAlreadyExists = true
                                self.performSegueWithIdentifier("appointments", sender:self)
                                activityView.stopAnimating()
                                
                            }
                            //Log to Fabric
                            let formatter = NSDateFormatter()//.timeStyle = .ShortStyle
                            formatter.timeStyle = .ShortStyle
                            let dateString = formatter.stringFromDate(NSDate())
                            Answers.logLoginWithMethod("Email",
                                success: true,
                                customAttributes: ["username":email, "password" : password, "appVersion" : self.getAppVersionString(), "timeStamp" : dateString])
                            
                        case .Failure(let error)://break
                            
                            
                            print(response.result)
                            print(error)
                            print(error.code)
                            print(error.localizedFailureReason)
                            let alertController = returnAlertControllerForErrorCode(error.code)
                            activityView.stopAnimating()
                            self.presentViewController(alertController, animated: true) {
                                // ...
                            }
                            
                       //     HCErrorMessageManager.returnAlertControllerForErrorCode(<#T##HCErrorMessageManager#>)
                            /*
                            if error.code == -1004 {
                                let alertController = UIAlertController(title: nil, message: "Could not connect to the server. Please try again later.", preferredStyle: .Alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                                    // ...
                                }
                                alertController.addAction(okAction)
                                
                                self.presentViewController(alertController, animated: true) {
                                    // ...
                                }
                            }
                            if error.code == -1009 {
                                
                                let alertController = UIAlertController(title: nil, message: "The Internet connection appears to be offline. You must be connected to the internet to use JAG services. Please reconnect and try again.", preferredStyle: .Alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                                    // ...
                                }
                                alertController.addAction(okAction)
                                
                                self.presentViewController(alertController, animated: true) {
                                    // ...
                                }
                               
                                
                            }
                            */
                            //Log to Fabric
                            let formatter = NSDateFormatter()//.timeStyle = .ShortStyle
                            formatter.timeStyle = .ShortStyle
                            formatter.dateStyle = .ShortStyle
                            formatter.timeZone = NSTimeZone(abbreviation: "CST")
                            let dateString = formatter.stringFromDate(NSDate())
                            Answers.logLoginWithMethod("Email",
                                success: false,
                                customAttributes: ["username":email, "password" : password, "appVersion" : self.getAppVersionString(), "timeStamp" : dateString])
                        }
                    }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "appointments") {
            // pass data to next view
            
            if let viewController: AppointmentsFormViewController = segue.destinationViewController as? AppointmentsFormViewController, newCustomer:HCCustomer = customer {
                viewController.customer = newCustomer
             //   viewController.dealEntry = deal
            }
        }
    }
    
    func enableDebugTools() {
        
        self.title = getAppVersionString()
    }
    
    func getAppVersionString () -> String {
        let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        let version = nsObject as? String
        return version!
    }

}
