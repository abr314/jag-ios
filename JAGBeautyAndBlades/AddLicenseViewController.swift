//
//  AddLicenseViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/26/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm
class AddLicenseViewController: XLFormViewController, XLFormRowDescriptorViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var provider:HCProvider = HCProvider()
    var license:HCLicense?
    var rowDescriptor: XLFormRowDescriptor?
    var imagePicker = UIImagePickerController()
  //  var photo = UIImage()
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
        section = XLFormSectionDescriptor.formSectionWithTitle("Please your enter your license information")
        form.addFormSection(section)
        
        if (license == nil) {
            license = HCLicense()
        }
        // Name
        row = XLFormRowDescriptor(tag: "Name", rowType: XLFormRowDescriptorTypeName, title: "Name")
        row.required = true
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(kGoldColor, forKey: "textField.textColor")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textField.font")
        row.addValidator(XLFormRegexValidator(msg: "", andRegexString: "^\\w*$"))
    
        row.value = license?.name
        section.addFormRow(row)
        
        //ID
        row = XLFormRowDescriptor(tag: "ID", rowType: XLFormRowDescriptorTypeName, title: "ID#")
        row.required = true
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(kGoldColor, forKey: "textField.textColor")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textField.font")
        row.addValidator(XLFormRegexValidator(msg: "", andRegexString: "^\\w*$"))
        row.value = license?.name
        section.addFormRow(row)
        
        // Button
        row = XLFormRowDescriptor(tag: "Button", rowType: XLFormRowDescriptorTypeButton, title: "Finish")
        row.cellConfig["textLabel.textColor"] = kGoldColor
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey:"self.tintColor")
        row.cellConfig.setObject("", forKey: "self.selectionStyle")
        row.action.formSelector = "finishButtonPressed"
        section.addFormRow(row)
        
        self.form = form
    }
    
    func finishButtonPressed() {
        //validate
        let result:Bool = validateFormSuccessful()
        if (result) {
           synchronize()
           // add to array of licenses
            if let license = license {
                provider.licenses.append(license)
            }
           // pop VC
           performSegueWithIdentifier("finished", sender: self)
        }
    }
    
    func synchronize() {
        if let name = form.formRowWithTag("Name")?.value as? String {
            license?.name = name
            
        }
        if let ID = form.formRowWithTag("ID")?.value as? String {
            license?.IDstring = ID
        }
    }
    func validateFormSuccessful() -> Bool {
        let array = formValidationErrors()
        for errorItem in array {
            let error = errorItem as! NSError
            let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
            
            if validationStatus.rowDescriptor!.tag == "Name" ||
                validationStatus.rowDescriptor!.tag == "ID" {
                    if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPathOfFormRow(rowDescriptor), let cell = tableView.cellForRowAtIndexPath(indexPath) {
                        self.animateCell(cell)
                    }
            }
        }
        
        if (array.count == 0) {
            return true
        } else {
            return false
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
    override func viewWillAppear(animated: Bool) {
       // self.view.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.5)
        //     self.navigationController?.view.tintColor = UIColor.whiteColor()
        self.inputViewController?.view.backgroundColor = UIColor.blackColor()
        
     //   self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "finished" {
            let ViewController: ProfessionalDetailSignUpViewController = segue.destinationViewController as! ProfessionalDetailSignUpViewController
            ViewController.provider = provider
        }
    }
    
    
}
