//
//  ViewPendingAppointmentViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/8/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm

class ViewPendingAppointmentViewController: XLFormViewController {

    var userType:UserType?
    var provider:HCProvider?
    var customer:HCCustomer?
    
    var formMode:FormMode?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
        form = XLFormDescriptor(title: "Pending Appointment")
        
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Details")
        
        form.addFormSection(section)
        
        // other participant name
        
        // location address
        
        // city and state
        
        // date and time
        
        // new section:
            // rows of services
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
