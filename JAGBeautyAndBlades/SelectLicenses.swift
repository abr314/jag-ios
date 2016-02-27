//
//  SelectLicenses.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/2/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm

class SelectLicenses: XLFormViewController {

    var numOfItemsChecked = 0
    var professional:HCProvider = HCProvider()
    var licenseArrayCache = Array<String>()
    
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
    
        self.inputViewController?.view.backgroundColor = UIColor.blackColor()
     //   self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
       
        self.tableView.sectionIndexBackgroundColor = UIColor.blackColor()
        self.tableView.backgroundColor = UIColor.blackColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "pressedCancel")
        
        self.navigationItem.leftBarButtonItem?.enabled = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "pressedDone")
    }
    
    
    func pressedCancel() {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
   
    
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        
        if let title = formRow.title {
        
            if(newValue as? Bool == true){
            // add to array cache
        
                if !licenseArrayCache.contains(title) {
                    licenseArrayCache.append(title)
                    numOfItemsChecked++
                }
            }
        
            if(newValue as? Bool == false) {
            // remove from array
            
                if licenseArrayCache.contains(title) {
                    licenseArrayCache = licenseArrayCache.filter { $0 != title }
                    numOfItemsChecked--
                }
            }
        }
    }
    
    func pressedDone() {
        
      //  var oneHasBeenPressed = false
       
     //   formValues().
        if (licenseArrayCache.isEmpty) {
            // alert: this can't be empty
        } else if (!licenseArrayCache.isEmpty) {
            
            // verify that at least one is checked
            
            
            for type in licenseArrayCache {
                let string = RLMStringWrapper().wrapperValueForString(type)
                professional.licenseTypes.append(string)
            }
          //  professional.licenseTypes.appendContentsOf(licenseArrayCache)
            self.performSegueWithIdentifier("SignUp", sender:nil)
        }
        
       
    }
    override func viewWillAppear(animated: Bool) {
        professional.licenseTypes.removeAll()
    }
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Licenses")
        
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Please Select The Licenses You Hold")
 
        form.addFormSection(section)
        
     //   var i = 0
        
        let licenses:[String] = ServiceTypes().arrayOfLicenses()
        
        for license in licenses {
            
        
            row = XLFormRowDescriptor(tag: license, rowType: XLFormRowDescriptorTypeBooleanCheck, title: license)
            
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
            
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
     
            section.addFormRow(row)
        }
     
        self.form = form
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SignUp" {
            if let svc = segue.destinationViewController as? BasicSignupViewController {
                          svc.isProviderType = true
                          svc.provider = professional
            }
        }
        
        if segue.identifier == "SelectServices" {
            if let svc = segue.destinationViewController as? SelectServicesFormViewController {
     //           svc.isProviderType = true
                svc.professional = professional
            }
        }
    }
}
