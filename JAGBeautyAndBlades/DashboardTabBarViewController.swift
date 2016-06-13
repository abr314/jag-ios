//
//  DashboardTabBarViewController.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 4/20/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import SwiftyJSON

class DashboardTabBarViewController: UITabBarController {
    
    var appointments:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.registerApplicationWithGCM(UIApplication.sharedApplication())

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
        
        let recognizer = UITapGestureRecognizer(target: self, action: "enableDebugTools")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func enableDebugTools() {
        
        navigationItem.title = getAppVersionString()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
}
