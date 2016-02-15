//
//  LoginFormViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/4/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm

class LoginFormViewController: XLFormViewController {

    
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
        
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("")
        
        form.addFormSection(section)
        
        let emailArray = [kEmail, XLFormRowDescriptorTypeEmail]
        let passwordArray = [kPassword, XLFormRowDescriptorTypePassword]
        let bookNowArray = [kBookNow, XLFormRowDescriptorTypeButton]
        let signUpArray = [kSignUp, XLFormRowDescriptorTypeButton]
        let loginArray = [kLogin, XLFormRowDescriptorTypeButton]
        
        let arrayOfRows = [emailArray, passwordArray, loginArray, bookNowArray, signUpArray]
        
        for rowStrings in arrayOfRows {
            
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
            // add row customizations here
            
            if (row.tag == kLogin) {
                row.action.formSelector = "loginButtonPressed"
            }
            if (row.tag == kBookNow) {
                row.action.formSelector = "bookNowPressed"
                row.cellConfig.setObject("", forKey: "self.selectionStyle")
            }
            
            if (row.tag == kSignUp) {
                row.action.formSelector = "signUpPressed"
                row.cellConfig.setObject("", forKey: "self.selectionStyle")
            }
            if (row.tag != kBookNow && row.tag != kSignUp && row.tag != kLogin) {
                row.required = true
                
                row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textField.font")
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textField.textColor")
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
        // email
        
        // password
        
        // book now
        
        // sign up
    }
    override func viewDidLoad() {
    super.viewDidLoad()
        
     
    if let font = UIFont(name: kHeaderFont, size: 25) {
    
        self.navigationController?.navigationBar.titleTextAttributes =
                [NSFontAttributeName: font,
                    NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        self.tableView.backgroundColor = UIColor.blackColor()
     
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signUpPressed() {
        
        // validate email and password and check for login
        // check email, if the not empty, validate. if valid, pass data to next controller
        // UserType is Unknown
        performSegueWithIdentifier("SignUp", sender: nil)
    }
    
    func bookNowPressed() {
        
        performSegueWithIdentifier("BookNow", sender: nil)
        // validate email and password and check for login
        // check email, if the not empty, validate. if valid, pass data to next controller
        // UserType is customer
    }
    
    func loginButtonPressed() {
        // verify fields and signin
        performSegueWithIdentifier("dashboard", sender: nil)
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
