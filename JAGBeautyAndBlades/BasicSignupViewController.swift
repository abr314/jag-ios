//
//  BasicSignupViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/20/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//
//import Auk
import UIKit
import XLForm
import Alamofire
import Crashlytics
//import UIColor_Hex_Swift

class BasicSignupViewController: XLFormViewController {
    
    var validationIsOn = true
    
    var userType:UserType?
    var personType:String = ""
 
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let font = UIFont(name: kHeaderFont, size: 25) {
            
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSFontAttributeName: font,
                 NSForegroundColorAttributeName: UIColor.whiteColor()]
        }

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.tableView?.backgroundView = UIImageView(image: UIImage(named: "ManSplash.png"))
        self.navigationItem.setHidesBackButton(true, animated:false);
        self.tableView.scrollEnabled = false
        
        //UIApplication.sharedApplication().statusBarHidden = true

    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section > 0 {
            return 10
        }
        
        return 10
    }

    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "JAG for Men")
        
        form.assignFirstResponderOnShow = false
        section = XLFormSectionDescriptor.formSectionWithTitle("")//("Please Enter this Basic Information")
  
        form.addFormSection(section)
      
        // turn rows into arrays
        let firstNameArray = [kFirstName, XLFormRowDescriptorTypeName]
        let lastNameArray = [kLastName, XLFormRowDescriptorTypeName]
        let phoneNumberArray = [kPhone, XLFormRowDescriptorTypeText]
        let emailArray = [kEmail, XLFormRowDescriptorTypeEmail]
        let passwordArray = [ kPassword, XLFormRowDescriptorTypePassword]
        let nextArray = ["Register Now", XLFormRowDescriptorTypeButton]
    //    let isProfessionalArray = [kCustomerRoleString, XLFormRowDescriptorTypeSelectorPickerViewInline]
        let cancelArray = ["Cancel", XLFormRowDescriptorTypeButton]
  //      let referralCodeArray = ["Who were you referred by?", XLFormRowDescriptorTypeText]
        
    
        let arrayOfRows = [firstNameArray, lastNameArray, phoneNumberArray, emailArray, passwordArray, nextArray, cancelArray]
        // add array of rows to form with parameters
        
        for rowStrings in arrayOfRows {
     
            row = XLFormRowDescriptor(tag: rowStrings[0], rowType: rowStrings[1], title: rowStrings[0])
            
            row.cellConfig.setObject(UIColor.whiteColor().colorWithAlphaComponent(0.8), forKey: "backgroundColor")
            row.cellConfig.setObject(UIColor.blackColor(), forKey: "textLabel.textColor")
            row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textLabel.font")
            row.cellConfig.setObject(kPurpleColor, forKey: "self.tintColor")
            // add row customizations here
            
            if (row.tag == "Register Now") {
                row.action.formSelector = #selector(BasicSignupViewController.nextButtonPressed)
                row.cellConfig.setObject("", forKey: "self.selectionStyle")
                row.cellConfig.setObject(UIColor(red: 81/255.0, green: 6/255.0, blue: 133/255.0, alpha: 1.0), forKey: "backgroundColor")
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
                section = XLFormSectionDescriptor.formSectionWithTitle(" ")
                form.addFormSection(section)
            }
            if (row.tag != "Register Now" && row.tag != "I am a Service Provider" && row.tag != "Cancel" && row.tag != kCustomerRoleString && row.tag != kSignUpNote) {
                row.required = true

                row.cellConfig.setObject(UIFont(name: kBodyFont, size: 17)!, forKey: "textField.font")
                row.cellConfig.setObject(UIColor.blackColor(), forKey: "textField.textColor")
                
            }
            if (row.tag == kFirstName || row.tag == kLastName) {
                row.addValidator(XLFormRegexValidator(msg: "", andRegexString: "^\\w*$"))
            }
            
            if (row.tag == kPhone) {
                row.addValidator(XLFormRegexValidator(msg: "At least 10, max 10 characters", andRegexString: "^[2-9][0-9]{9}$"))
                row.cellConfig.setObject(self, forKey: "textField.delegate")
                row.cellConfig.setValue(323, forKey: "textField.tag")
            }
            
            if (row.tag == kEmail) {
                row.addValidator(XLFormRegexValidator(msg: "", andRegexString: "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"))
            }
            
            if (row.tag == kCustomerRoleString) {
                row.selectorOptions = [kCustomerTermString, kProviderTermString]
                row.value = kCustomerTermString
            }
            if (row.tag == "Cancel") {
                row.cellConfig.setObject(UIColor.whiteColor(), forKey: "backgroundColor")
                row.action.formBlock = { [weak self] (sender: XLFormRowDescriptor!) -> Void in
                self?.navigationController?.popViewControllerAnimated(false)
                }
                
                section = XLFormSectionDescriptor.formSectionWithTitle(" ")
                section.footerTitle = kSignUpNote
                
                form.addFormSection(section)
            }            

            
            section.addFormRow(row)
        }
        
        self.form = form
    
    }
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if section != 2 {
            return
        }
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.clearColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.textLabel?.textAlignment = NSTextAlignment.Center
    }
    
    func nextButtonPressed() {
        
        if validationIsOn {
            
            if (validateForm(self)) {
                synchronizeData()
             //   alamofireRequest = sendCustomerSignUpInfo(customer)
                registerWithServer()
            }
        }
    }
    
    func registerWithServer() {
        var url = kCustomerSignUpURL
        let parameters = ["email":customer.email,"password":customer.password,"first_name":customer.firstName,"last_name":customer.lastName, "phone":customer.phoneNumber, "referral_code":customer.referralCode]
        
        if isProviderType == true {
            url = kProSignUpURL
            UserInformation.sharedInstance.customerProfile?.isProfessional = true
        }
        
        Alamofire.request(.POST, url, parameters: parameters)
            
            .validate()
            
            .responseJSON { response in
                switch response.result {
                    
                    //response.result {
                case .Success(let json):
                    print(response)
                    
                    
                    //Log to Fabric
                    let formatter = NSDateFormatter()//.timeStyle = .ShortStyle
                    formatter.timeStyle = .ShortStyle
                    formatter.dateStyle = .ShortStyle
                    formatter.timeZone = NSTimeZone(abbreviation: "CST")
                    let dateString = formatter.stringFromDate(NSDate())
                    Answers.logSignUpWithMethod("Email",
                        success: true,
                        customAttributes: ["username":self.customer.email, "password" : self.customer.password, "appVersion" : getAppVersionString(), "timeStamp" : dateString])
                    /**
                        Grab the token
                        Add the token to the NSUserDefaults
                    */
                    
                    Alamofire.request(.POST, kAPITokenURL, parameters:["username":self.customer.email,"password":self.customer.password])
                    
                      
                        .responseJSON { response in
                 //           print(result)
                            switch response.result {
                               
                            case .Success(let JSON):
                                print(response)
                                
                                if let token = JSON.valueForKey("token") as? String {
                                   
                                    UserInformation.sharedInstance.token = token
                                    UserInformation.sharedInstance.userAlreadyExists = true
                                    UserInformation.sharedInstance.customerProfile?.isProfessional = false
                                    NSUserDefaults.standardUserDefaults().setObject("customer", forKey: "role")
                                    NSUserDefaults.standardUserDefaults().setObject(token, forKey: kJAGToken)
                                    
                                    // pop view to dashboard
                                    if self.isProviderType == true {
                                        
                                        
                                        
                                        
                                        self.performSegueWithIdentifier("providerAppointments", sender: nil)
                                    }
                                    
                                    if self.isProviderType == false {
                                        
                                        
                                        
                                        self.performSegueWithIdentifier("dashboardFromSignup", sender: nil)
                                    }
                                } else {
                                    let alertController = returnAlertControllerForErrorCode(-7003)
                                    self.presentViewController(alertController, animated: true) {
                                        // ...
                                    }
                                }
                                
                            case .Failure(let error):
                                
                                print(error)
                            }
                    }
                case .Failure(let error):
                    
                    
                    print(error)
                    print(error.code)
                    print(error.domain)
                    print(response)
                    
                    //Log to Fabric
                    let formatter = NSDateFormatter()//.timeStyle = .ShortStyle
                    formatter.timeStyle = .ShortStyle
                    formatter.dateStyle = .ShortStyle
                    formatter.timeZone = NSTimeZone(abbreviation: "CST")
                    let dateString = formatter.stringFromDate(NSDate())
                    Answers.logSignUpWithMethod("Email",
                        success: true,
                        customAttributes: ["username":self.customer.email, "password" : self.customer.password, "appVersion" : getAppVersionString(), "timeStamp" : dateString])
                    
                    let alertController = returnAlertControllerForErrorCode(error.code)
                    /*
                        Make Custom Alerts
                    */
                   
                //    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                    break
                    }
                }
                

    }
    func synchronizeData() {
        
        if let firstName = form.formRowWithTag(kFirstName)?.value as? String {
    
            customer.firstName = firstName
        }
        
        if let lastName = form.formRowWithTag(kLastName)?.value as? String {
    
            customer.lastName = lastName
        }
        
        if let phoneNumber = form.formRowWithTag(kPhone)?.value as? String {
    
            customer.phoneNumber = phoneNumber
        }
        
        if let email = form.formRowWithTag(kEmail)?.value as? String {
    
            customer.email = email
        }
        
        if let isPro = form.formRowWithTag(kCustomerRoleString)?.value as? String {
            if isPro == kProviderTermString{
                isProviderType = true
            }
            if isPro == kCustomerRoleString {
                isProviderType = false
            }
        }
        
        if let password = form.formRowWithTag(kPassword)?.value as? String {
            // provider?.email = email
            customer.password = password
        }
        
        if let referralCode = form.formRowWithTag("Who were you referred by?")?.value as? String {
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
    
    override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 323 {
            let textFieldLength = textField.text?.characters.count
            
            if range.location < textFieldLength {
                return true
            }
            if textFieldLength > 9 {
                return false
            }
            if string.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet()) != nil {
                return true
            } else {
                return false
            }

        }
        
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
}
