//
//  ProfessionalDetailSignUpViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/25/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm

/*
class NSArrayValueTrasformer : NSValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let arrayValue = value as? Array<AnyObject> {
            return String(format: "%d Item%@", arrayValue.count, arrayValue.count > 1 ? "s" : "")
        }
        else if let stringValue = value as? String {
            return String(format: "%@ - ) - Transformed", stringValue)
        }
        return nil
    }
}
*/

class ProfessionalDetailSignUpViewController: XLFormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var provider:HCProvider?
    var imagePicker = UIImagePickerController()
    var photo:UIImage?
    var licenseToPass:HCLicense?
    var realm:Realm?
    
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
        
        form = XLFormDescriptor(title: "Details")
        
        form.assignFirstResponderOnShow = true
        section = XLFormSectionDescriptor.formSectionWithTitle("Please your enter your professional information")
        form.addFormSection(section)
        
  /*      // Choose Services
       // section = XLFormSectionDescriptor.formSectionWithTitle("Multiple Selectors")
      //  form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: "ChooseServices", rowType:XLFormRowDescriptorTypeMultipleSelector, title:"Choose the services you offer")
        row.selectorOptions = ["Barber", "Cosmetology", "Manicurist", "Esthetician", "Eye Lash Extensions", "Manicurist/Ethetician", "Spray Tans", "Spa", "Massage", "Fitness", "Yoga", "Personal Trainers"]
    //    row.valueTransformer = NSArrayValueTrasformer.self
        
    //    row.value = "Yoga"
    */
      //  section.addFormRow(row)
        
    //    form.addFormSection(section)
        
        // Availability
        
        row = XLFormRowDescriptor(tag: "Availability", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Availability")
       // row.action.formSegueIdentifier = "Availiablity";
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        
        row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
        row.action.formSegueIdentifier = "Availability";
        section.addFormRow(row)
        
        // Locations
        
        row = XLFormRowDescriptor(tag: "Locations", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Locations")
        // row.action.formSegueIdentifier = "Availiablity";
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        
        row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
        row.action.formSegueIdentifier = "ViewLocations";
        section.addFormRow(row)
        
        /*
        // Professional Licenses
        
        // make licenses deleteable
        section = XLFormSectionDescriptor.formSectionWithTitle("Licenses")
        form.addFormSection(section)
        if (provider.licenses.count > 0) {
            var i:Int
            for (i = 0; i <= provider.licenses.count-1; i++) {
                let currentLicense:HCLicense = provider.licenses[i]
                row = XLFormRowDescriptor(tag: currentLicense.name, rowType: XLFormRowDescriptorTypeSelectorPush, title: currentLicense.name)
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
                row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
                
                row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")
                
                section.addFormRow(row)
            }
        }
        
        row = XLFormRowDescriptor(tag: "AddLicense", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Add License")
        row.action.formSegueIdentifier = "AddLicense";
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")

        row.cellConfig.setObject(UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!, forKey: "textLabel.font")

        section.addFormRow(row)
        */
        //Add Picture
        
        if (photo != nil) {
            row = XLFormRowDescriptor(tag: "Photo", rowType: XLFormRowDescriptorTypeImage, title: "Picture")
            row.value = photo
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
            
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
  
        } else {
        row = XLFormRowDescriptor(tag: "AddPicture", rowType: XLFormRowDescriptorTypeButton, title: "Add Picture")
  
        row.action.formSelector = "touchedAddPicture"
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "self.tintColor")
        row.cellConfig.setObject(UIColor.blackColor(), forKey: "backgroundColor")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
  
        row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
        }
        section.addFormRow(row)
    
        self.form = form
    }
    
    func editLicense() {
        
    }
    func touchedAddPicture() {
        let alertController = UIAlertController(title: nil, message: "Add a Picture", preferredStyle: .ActionSheet)
        
        let addFromPhotos = UIAlertAction(title: "Pick From Photos", style: .Default) { (action) in
            // ...
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
                //  println("Button capture")
                
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
                self.imagePicker.allowsEditing = false
                
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
        }
        let takeNewPhoto = UIAlertAction(title: "Take Photo", style: .Default) { (action) in
            // ...
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            // ...
        }
        
        alertController.addAction(addFromPhotos)
        alertController.addAction(takeNewPhoto)
        alertController.addAction(cancel)
        
        self.presentViewController(alertController, animated: true) {
            
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        self.photo = image
        initializeForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.view.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.5)
        //     self.navigationController?.view.tintColor = UIColor.whiteColor()
        self.inputViewController?.view.backgroundColor = UIColor.blackColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPressed")
        self.view.backgroundColor = UIColor.blackColor()
        self.tableView.backgroundColor = UIColor.blackColor()
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        // Do any additional setup after loading the view.
    }
    
    
    func doneButtonPressed() {
        
        // verify that the required fields have been added, if not raise an alert view
        self.performSegueWithIdentifier("VerifyInformation", sender: nil)
    }
    override func viewWillAppear(animated: Bool) {
        initializeForm()
    //    navigationController?.navigationBarHidden = false
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
        
        if segue.identifier == "AddLicense" {
            let ViewController: AddLicenseViewController = segue.destinationViewController as! AddLicenseViewController
            if let provider = provider {
                ViewController.provider = provider
            }
        }
        
        if segue.identifier == "Availability" {
            let ViewController: AvailabilityTableViewController = segue.destinationViewController as! AvailabilityTableViewController
            ViewController.provider = provider
            ViewController.realm = realm
        }
        
        if segue.identifier == "VerifyInformation" {
            let VC: VerifyInformationFormViewController = segue.destinationViewController as! VerifyInformationFormViewController
            if let provider = provider {
                VC.provider = provider
            }
            VC.realm = realm
        }
    }
    

}
