//
//  BasicSignupViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/20/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm
//import UIColor_Hex_Swift

class BasicSignupViewController: XLFormViewController {
    
    
    var validationIsOn = false
    
    var userType:UserType?
    var personType:String = ""
    var provider:HCProvider?
    var customer:HCCustomer = HCCustomer()
    var isProviderType:Bool = false
    var formMode:FormMode?
    
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
        
        form = XLFormDescriptor(title: "Signup")
        
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Please Enter this Basic Information")
  
        form.addFormSection(section)
      
        // turn rows into arrays
        let firstNameArray = [kFirstName, XLFormRowDescriptorTypeName]
        let lastNameArray = [kLastName, XLFormRowDescriptorTypeName]
        let phoneNumberArray = [kPhone, XLFormRowDescriptorTypeText]
        let emailArray = [kEmail, XLFormRowDescriptorTypeEmail]
        let nextArray = [kNext, XLFormRowDescriptorTypeButton]
        // create array of rows
        let arrayOfRows = [firstNameArray, lastNameArray, phoneNumberArray, emailArray, nextArray]
        // add array of rows to form with parameters
        
        for rowStrings in arrayOfRows {
     
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
            // add row customizations here
            
            if (row.tag == kNext) {
                row.action.formSelector = "nextButtonPressed"
                row.cellConfig.setObject("", forKey: "self.selectionStyle")
            }
            if (row.tag != kNext) {
                row.required = true

                row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textField.font")
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textField.textColor")
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
            
            section.addFormRow(row)
        }
        
        self.form = form
    
    }
    
    func didTouchNextButton() {
        // do validation
        
        // go to next screen or not depending on validation result
    }
    
    func nextButtonPressed() {
        
        if validationIsOn {
            let result:Bool = validateForm(self)
            
            if (result) {
                synchronizeData()
        
                performSegueWithIdentifier("ProfessionalDetail", sender: nil)
         
            }
        } else {
            synchronizeData()
            
            performSegueWithIdentifier("ProfessionalDetail", sender: nil) 
        }
        
    }
    
    func synchronizeData() {
        
            if let firstName = form.formRowWithTag(kFirstName)?.value as? String {
                provider?.firstName = firstName
            }
        
            if let lastName = form.formRowWithTag(kLastName)?.value as? String {
                provider?.lastName = lastName
            }
        
            if let phoneNumber = form.formRowWithTag(kPhone)?.value as? String {
                provider?.phoneNumber = phoneNumber
            }
        
            if let email = form.formRowWithTag(kEmail)?.value as? String {
                provider?.email = email
            }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.inputViewController?.view.backgroundColor = UIColor.blackColor()
   //     self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor.blackColor()
        if (userType == UserType.Provider && formMode == FormMode.CreateMode) {
            provider = HCProvider()
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
        
        if segue.identifier == "ProfessionalDetail" {
            if let svc = segue.destinationViewController as? ProfessionalDetailSignUpViewController {
                
                if let provider = provider {
                svc.provider = provider
                }
            }
        }
    }

}
