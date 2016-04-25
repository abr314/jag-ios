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
class LoginFormViewController: XLFormViewController {
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
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
       
        form = XLFormDescriptor(title: "JAG for Men")
        
        section = XLFormSectionDescriptor.formSectionWithTitle("ENTER LOGIN INFORMATION")
        
        form.addFormSection(section)
        
        let emailArray = [kEmail, XLFormRowDescriptorTypeEmail]
        let passwordArray = [kPassword, XLFormRowDescriptorTypePassword]
    
        let signUpArray = [kSignUp, XLFormRowDescriptorTypeButton]
        let loginArray = [kLogin, XLFormRowDescriptorTypeButton]
        
        let arrayOfRows = [emailArray, passwordArray, loginArray, signUpArray] //bookNowArray, signUpArray]
        
        for rowStrings in arrayOfRows {
            
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            
            
            if (!(row.tag == kLogin || row.tag == kSignUp)) {
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
                row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
                row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
                row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            }
            
            // add row customizations here
            
            if (row.tag == kLogin) {
                row.cellConfig.setObject(UIColor(red: 81/255.0, green: 6/255.0, blue: 133/255.0, alpha: 1.0), forKey: "backgroundColor")
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
                row.action.formSelector = #selector(LoginFormViewController.loginButtonPressed)
            } else if (row.tag == kSignUp) {
                row.cellConfig.setObject(UIColor(red: 81/255.0, green: 6/255.0, blue: 133/255.0, alpha: 1.0), forKey: "backgroundColor")
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
                row.action.formSelector = #selector(LoginFormViewController.signUpPressed)
                row.cellConfig.setObject("", forKey: "self.selectionStyle")
                section = XLFormSectionDescriptor.formSectionWithTitle("NEW TO JAG?")
                //section.multivaluedRowTemplate!.cellConfig["backgroundColor"] = UIColor(red: 81/255.0, green: 6/255.0, blue: 133/255.0, alpha: 1.0)
                
                
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
        return NSUserDefaults.standardUserDefaults().objectForKey(kJAGToken) != nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
//        if section == 1 {
//            return 30
//        }
        
        return 30
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        //header.contentView.backgroundColor = UIColor(red: 0/255, green: 181/255, blue: 229/255, alpha: 1.0) //make the background color light blue
        header.textLabel?.textAlignment = .Center
        header.textLabel!.textColor = UIColor.blackColor() //make the text white
        header.textLabel!.alpha = 0.5 //make the header transparent
        
    }
    
    override func viewDidLoad() {
    
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
        
        //self.tableView.backgroundColor = UIColor.whiteColor()
        
        //self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
     
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
        
        let result:Bool = true //validateForm(self)
    //    performSegueWithIdentifier("dashboard", sender: nil)
        
        
        if (result) {
            
            if let email = form.formRowWithTag(kEmail)?.value as? String, password = form.formRowWithTag(kPassword)?.value as? String {
            
                Alamofire.request(.POST, kAPITokenURL, parameters:["username":email,"password":password])
                    
                    .validate()
                    
                    .responseJSON { response in
                        switch response.result {
                        case .Success(let object):
                            print(response)
                
                            if let string = response.result.value?.valueForKey("token") as? String {
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject("\(string)", forKey: kJAGToken)
                                self.performSegueWithIdentifier("appointments", sender:self)
                            }
                        case .Failure(let error)://break
                            print(response.result)
                            print(error)
                            print(error.code)
                            print(error.localizedFailureReason)
                            let alertController = returnAlertControllerForErrorCode(error.code)
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
    

}
