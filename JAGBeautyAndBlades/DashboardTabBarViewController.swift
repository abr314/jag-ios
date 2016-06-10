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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let role = NSUserDefaults.standardUserDefaults().valueForKey("role") as? String
        if role == "pro" {
            
            self.selectedIndex = 1
            self.tabBar.hidden = true
            
            self.title = "Appointments"
            
        }
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(enableDebugTools))
        recognizer.numberOfTapsRequired = 5
        self.navigationController?.navigationBar.addGestureRecognizer(recognizer)
        
        
        let recog = UITapGestureRecognizer(target: self, action: #selector(shouldShowRatingController))
        recog.numberOfTapsRequired = 1
        //self.navigationController?.navigationBar.addGestureRecognizer(recog)
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

    // MARK: - Handling Rating Request
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
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    

    func enableDebugTools() {
        
        navigationItem.title = getAppVersionString()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
}
