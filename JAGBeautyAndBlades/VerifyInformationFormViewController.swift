//
//  VerifyInformationFormViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/3/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import XLForm
import RealmSwift
class VerifyInformationFormViewController: XLFormViewController {

    var provider:HCProvider?
    var realm:Realm?
    var customer:HCCustomer?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm()
    }
    func initializeForm() {
        // done: navigation button
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Verify")
        
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Please Verify this information")
        
        form.addFormSection(section)
        
        let emailArray = [kEmail, XLFormRowDescriptorTypeEmail]
        let passwordArray = [kPassword, XLFormRowDescriptorTypePassword]
        let submitArray = [kSubmit, XLFormRowDescriptorTypeButton]
        
        let arrayOfRows = [emailArray, passwordArray, submitArray]
        
        for rowStrings in arrayOfRows {
            
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
            
            section.addFormRow(row)
            
            if (row.tag == kEmail || row.tag == kPassword) {
                row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textField.font")
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textField.textColor")
            }
            if (row.tag == kEmail) {
                row.disabled = true
          
                if let email:String = provider?.email {
                    row.value = email
                }
            }
        }
        // disabled email
        
        // password
        
        // verify password
        
        // cancel
        
        
        
        self.form = form
    }
}
