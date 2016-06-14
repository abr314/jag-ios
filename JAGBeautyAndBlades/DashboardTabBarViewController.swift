//
//  DashboardTabBarViewController.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 4/20/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import SwiftyJSON

class DashboardTabBarViewController: UITabBarController , UIPopoverPresentationControllerDelegate {
    
    var appointments:JSON?
    var role:String?
    var AppointmentToRate = JSON.null
    var currentlySegueing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.registerApplicationWithGCM(UIApplication.sharedApplication())

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.checkForMidFlowAppointmentStates(_:)), name: kCheckForAppointmentNeedingCustomerRatingNotification, object: nil)
        
        //if let navBarFont = UIFont(name: kJagFont, size: 30) {
        self.title = "Services"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: kPrimaryColor,
            NSFontAttributeName: UIFont(name: kJagFontFilled, size: 28)!
        ]
        //self.navigationItem.leftBarButtonItem?.background

        
        print(UserInformation.sharedInstance.customerProfile?.email)
        print(UserInformation.sharedInstance.customerProfile?.isProfessional)
        // Do any additional setup after loading the view.
        
        role = NSUserDefaults.standardUserDefaults().valueForKey("role") as? String
        if role == "pro" {
            
            self.selectedIndex = 1
            self.tabBar.hidden = true
            
            self.title = "Appointments"
            
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(enableDebugTools))
        recognizer.numberOfTapsRequired = 5
        self.navigationController?.navigationBar.addGestureRecognizer(recognizer)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        
        self.title = item.title
        
        if item.title == "Appointments" {
            if let vcs = viewControllers {
                for view in vcs {
                    if view.title == "Appointments" {
                        if let vcc = view as? AppointmentsFormViewController {
                            vcc.initializeForm()
                        }
                    }
                }
            }
        }
    }

    // MARK: - Customer Appointment Rating
    func checkForMidFlowAppointmentStates(notification: NSNotification) {
        
        let appointments = UserInformation.sharedInstance.appointments
        
        for appointment in appointments {
            
            let jsonObj = appointment.1
            let status = jsonObj["status"].stringValue
            
            if status == "unrated" && role == "customer" {
                seekRatingForAppointment(jsonObj)
                break
            } else if status == "in_progress" && role != "customer" && !(navigationController?.visibleViewController is AppointmentDetailFormViewController){
                performSegueWithIdentifier("appointmentStillInProgress", sender: nil)
            }
        }
    

    }

    func seekRatingForAppointment(appointmentToRate:JSON) {
        
        AppointmentToRate = appointmentToRate
        
        shouldShowRatingController()
    }
    
    func shouldShowRatingController() {
        self.performSegueWithIdentifier("ratings", sender: nil)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ratings" {
            let popoverViewController = segue.destinationViewController //as! UIViewController
            
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            
            
            popoverViewController.popoverPresentationController?.sourceRect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1)
            popoverViewController.popoverPresentationController?.sourceView = self.view
            
            
            if let vc = segue.destinationViewController as? RatingsPopoverController {
                vc.isProRatingCustomer = false
                vc.appointmentID = AppointmentToRate["id"].stringValue
                let lastName = AppointmentToRate["service_provider"]["last_name"].stringValue
                vc.userToRateName = AppointmentToRate["service_provider"]["first_name"].stringValue + " " + String(lastName[lastName.startIndex]) + "."
                vc.userToRateImageURL = AppointmentToRate["service_provider"]["profile_picture"].URL
            }
        } else if segue.identifier == "appointmentStillInProgress" {
            let appointmentDetailVC = segue.destinationViewController as? AppointmentDetailFormViewController
            appointmentDetailVC?.refreshDetailView()
        }
        

    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    

    func enableDebugTools() {
        
        navigationItem.title = getAppVersionString()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
}
