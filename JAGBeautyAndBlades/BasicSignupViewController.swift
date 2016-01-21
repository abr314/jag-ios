//
//  BasicSignupViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/20/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm
import UIColor_Hex_Swift
class BasicSignupViewController: XLFormViewController {

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
        
        
        form = XLFormDescriptor(title: "Basic Signup")
        
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Please Enter this Basic Information")
  //      section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
      //  let goldColor:UIColor = UIColor(rgba: "#E4DDCA")
        // First Name
        row = XLFormRowDescriptor(tag: "FirstName", rowType: XLFormRowDescriptorTypeName, title: "First Name")
        row.required = true
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(goldColor, forKey: "textField.textColor")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textField.font")
        
        section.addFormRow(row)
        // Last Name
        row = XLFormRowDescriptor(tag: "LastName", rowType: XLFormRowDescriptorTypeName, title: "Last Name")
        row.required = true
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textField.textColor")
        row.cellConfig.setObject(goldColor, forKey: "textField.textColor")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textField.font")
        section.addFormRow(row)
        // Phone Number
        row = XLFormRowDescriptor(tag: "Phone", rowType: XLFormRowDescriptorTypeEmail, title: "Phone")
        row.required = true
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textField.textColor")
        row.cellConfig.setObject(goldColor, forKey: "textField.textColor")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textField.font")
        row.addValidator(XLFormRegexValidator(msg: "At least 6, max 32 characters", andRegexString: "(?\\d{3})?\\s\\d{3}-\\d{4}"))
        section.addFormRow(row)
        // Email
        row = XLFormRowDescriptor(tag: "Email", rowType: XLFormRowDescriptorTypeEmail, title: "Email")
        row.required = true
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textField.textColor")
        row.cellConfig.setObject(goldColor, forKey: "textField.textColor")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textField.font")
        section.addFormRow(row)
      
        
        // Button
        row = XLFormRowDescriptor(tag: "Button", rowType: XLFormRowDescriptorTypeButton, title: "Next")
        row.cellConfig["textLabel.textColor"] = goldColor
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.action.formSelector = "didTouchNextButton"
        section.addFormRow(row)
        
        self.form = form
        
        self.navigationItem.backBarButtonItem?.setValue(UIColor.whiteColor(), forKey: "tintColor")
    
    }
    
    func didTouchNextButton() {
        // do validation
        
        // go to next screen or not depending on validation result
    }
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        
        if (formRow.tag == "Phone") {
            if formRow.value == nil { return};
            let isValidForm = isValidPhone(formRow.value as! String)
            
            if (!isValidForm) {
                print("Error: is not valid phone number")
            }
        }
    }
    
    func validateForm(buttonItem: UIBarButtonItem) {
        let array = formValidationErrors()
        for errorItem in array {
            let error = errorItem as! NSError
            let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
            if validationStatus.rowDescriptor!.tag == "FirstName" {
                if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPathOfFormRow(rowDescriptor), let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    cell.backgroundColor = .orangeColor()
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.backgroundColor = .whiteColor()
                    })
                }
            }
            else if validationStatus.rowDescriptor!.tag == "LastName" ||
                validationStatus.rowDescriptor!.tag == "Phone" ||
                validationStatus.rowDescriptor!.tag == "Email" {
                    if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPathOfFormRow(rowDescriptor), let cell = tableView.cellForRowAtIndexPath(indexPath) {
                        self.animateCell(cell)
                    }
            }
        }
    }
    
    func animateCell(cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.additive = true
        cell.layer.addAnimation(animation, forKey: "shake")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.5)
   //     self.navigationController?.view.tintColor = UIColor.whiteColor()
        self.inputViewController?.view.backgroundColor = UIColor.blackColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBarHidden = false
        
        navigationItem.rightBarButtonItem?.enabled = true
       
        
  //      view.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
