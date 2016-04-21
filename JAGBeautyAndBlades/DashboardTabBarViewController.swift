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

        // Do any additional setup after loading the view.
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        
        
        
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

}
