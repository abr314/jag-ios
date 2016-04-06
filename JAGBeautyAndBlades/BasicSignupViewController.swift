//
//  BasicSignupViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/20/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//
import Auk
import UIKit
import XLForm
import Alamofire
//import UIColor_Hex_Swift

class BasicSignupViewController: XLFormViewController {
    
    var validationIsOn = true
    
    var userType:UserType?
    var personType:String = ""
  //  var provider:HCProvider?
    var customer:HCCustomer = HCCustomer()
    var isProviderType:Bool = false
    var formMode:FormMode?
  //  var alamofireRequest:Alamofire.Response?
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
        
        form = XLFormDescriptor(title: "Sign Up")
        
        form.assignFirstResponderOnShow = true
        section = XLFormSectionDescriptor.formSectionWithTitle("Please Enter this Basic Information")
  
        form.addFormSection(section)
      
        // turn rows into arrays
        let firstNameArray = [kFirstName, XLFormRowDescriptorTypeName]
        let lastNameArray = [kLastName, XLFormRowDescriptorTypeName]
        let phoneNumberArray = [kPhone, XLFormRowDescriptorTypeText]
        let emailArray = [kEmail, XLFormRowDescriptorTypeEmail]
        let passwordArray = [ kPassword, XLFormRowDescriptorTypePassword]
        let nextArray = ["Register Now", XLFormRowDescriptorTypeButton]
        let isProfessionalArray = ["My Role", XLFormRowDescriptorTypeSelectorPickerViewInline]
        let cancelArray = ["Cancel", XLFormRowDescriptorTypeButton]
      //  let referralCodeArray = ["Referral Code", XLFormRowDescriptorTypeText]
        // create array of rows
       
        
        let arrayOfRows = [firstNameArray, lastNameArray, phoneNumberArray, emailArray, passwordArray, isProfessionalArray,nextArray, cancelArray] //referralCodeArray, nextArray]
        // add array of rows to form with parameters
        
        for rowStrings in arrayOfRows {
     
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            // add row customizations here
            
            if (row.tag == "Register Now") {
                row.action.formSelector = "nextButtonPressed"
                row.cellConfig.setObject("", forKey: "self.selectionStyle")
                row.cellConfig.setObject(kPurpleColor, forKey: "textLabel.textColor")
            }
            if (row.tag != "Register Now" && row.tag != "I am a Service Provider" && row.tag != "Cancel" && row.tag != "My Role") {
                row.required = true

                row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textField.font")
                row.cellConfig.setObject(UIColor.blackColor(), forKey: "textField.textColor")
            }
            if (row.tag == kFirstName || row.tag == kLastName) {
                row.addValidator(XLFormRegexValidator(msg: "", andRegexString: "^\\w*$"))
            }
            
            if (row.tag == kPhone) {
                row.addValidator(XLFormRegexValidator(msg: "At least 6, max 32 characters", andRegexString: "^[2-9][0-9]{9}$"))
            }
            
            if (row.tag == kEmail) {
                row.addValidator(XLFormRegexValidator(msg: "", andRegexString: "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"))
            }
            
            if (row.tag == "My Role") {
                row.selectorOptions = ["Customer", "Professional"]
                row.value = "Customer"
            }
            if (row.tag == "Cancel") {
               row.action.formBlock = { [weak self] (sender: XLFormRowDescriptor!) -> Void in
                self?.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            
            section.addFormRow(row)
        }
        
        self.form = form
    
    }
    
    func nextButtonPressed() {
        
        if validationIsOn {
            
            if (validateForm(self)) {
                synchronizeData()
             //   alamofireRequest = sendCustomerSignUpInfo(customer)
                registerWithServer()
         
            }
        } else {
       
        }
        
    }
    
    func registerWithServer() {
        var url = kCustomerSignUpURL
        
        if isProviderType == true {
            url = kProSignUpURL
        }
        
        Alamofire.request(.POST, url, parameters:["email":customer.email,"password":customer.password,"first_name":customer.firstName,"last_name":customer.lastName, "phone":customer.phoneNumber])
            
            .validate()
            
            .responseJSON { response in
                switch response.result {
                    
                    //response.result {
                case .Success(let JSON):
                    print(response)
                    
                    /*
                        Grab the token
                        Add the token to the NSUserDefaults
                    */
                    
                    Alamofire.request(.POST, kAPITokenURL, parameters:["username":self.customer.email,"password":self.customer.password])
                    
                        .responseJSON { response in
                            
                            switch response.result {
                               
                            case .Success(let JSON):
                                print(response)
                                
                                if let something = JSON.valueForKey("token") as? String {
                                    self.customer.token = something
                                    // Add token to nsuserdefaults
                                    NSUserDefaults.standardUserDefaults().setObject(something, forKey: kJAGToken)
                                    // pop view to dashboard
                                    self.performSegueWithIdentifier("main", sender: nil)
                                }
                                
                            case .Failure(let error):
                                
                                break
                            }
                    }
                case .Failure(let error):
                    
                    break
                    }
                }
                

    }
    func synchronizeData() {
        
        if let firstName = form.formRowWithTag(kFirstName)?.value as? String {
      //      provider?.firstName = firstName
            customer.firstName = firstName
        }
        
        if let lastName = form.formRowWithTag(kLastName)?.value as? String {
        //    provider?.lastName = lastName
            customer.lastName = lastName
        }
        
        if let phoneNumber = form.formRowWithTag(kPhone)?.value as? String {
          //  provider?.phoneNumber = phoneNumber
            customer.phoneNumber = phoneNumber
        }
        
        if let email = form.formRowWithTag(kEmail)?.value as? String {
           // provider?.email = email
            customer.email = email
        }
        
        if let isPro = form.formRowWithTag("My Role")?.value as? String {
            if isPro == "Professional" {
                isProviderType == true
            }
            if isPro == "Customer" {
                isProviderType == false
            }
        }
        
        if let password = form.formRowWithTag(kPassword)?.value as? String {
            // provider?.email = email
            customer.password = password
        }
        
        if let referralCode = form.formRowWithTag("Referral Code")?.value as? String {
            customer.referralCode = referralCode
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "main" {
            if let svc = segue.destinationViewController as? LoginFormViewController {
                svc.customer = customer
            }

        }

    }
    
    
}
