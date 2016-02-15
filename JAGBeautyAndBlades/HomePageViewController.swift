//
//  HomePage.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/19/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import SwiftyButton
import UIColor_Hex_Swift

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var customerButton: UIButton!
    
    @IBOutlet weak var professionalButton: UIButton!
    
    @IBOutlet weak var createAccountCallLabel: UILabel!
    
    var userInfo:String = " "
    override func viewDidLoad() {
       super.viewDidLoad()
    
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.navigationController?.navigationBar.translucent = false
        
        if let font = UIFont(name: kHeaderFont, size: 23) {
            
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSFontAttributeName: font,
                    NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        }
    override func viewWillAppear(animated: Bool) {
        setUpView()        
    }
    
    func setUpView() {
        
        let font:UIFont = UIFont(name: kBodyFont, size: 16)!
        
        createAccountCallLabel.backgroundColor = UIColor.clearColor()
        createAccountCallLabel.font = UIFont(name: kHeaderFont, size: 20)
        createAccountCallLabel.textColor = UIColor.whiteColor()
        
        customerButton.backgroundColor = UIColor.clearColor()
        customerButton.titleLabel?.font = font
        customerButton.titleLabel?.tintColor = UIColor.whiteColor()
        
        professionalButton.backgroundColor = UIColor.clearColor()
        professionalButton.titleLabel?.font = font
        professionalButton.titleLabel?.tintColor = UIColor.whiteColor()
       
        customerButton.addTarget(self, action: "customerButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        professionalButton.addTarget(self, action: "professionalButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
   //     self.view.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.5)
    }
    
    func customerButtonPressed() {
        self.performSegueWithIdentifier("CustomerSignup", sender: nil)
    }
    
    func professionalButtonPressed() {
        self.performSegueWithIdentifier("ProfessionalSignup", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let svc = segue.destinationViewController as? BasicSignupViewController {
        
        // UX: change to maintain input on back push
        svc.formMode = FormMode.CreateMode
            
        if segue.identifier == "ProfessionalSignUp" {
           // if let svc = segue.destinationViewController as? BasicSignupViewController {
                svc.userType = UserType.Provider
           // }
        }
        
        if segue.identifier == "CustomerSignUp" {
          //  if let svc = segue.destinationViewController as? BasicSignupViewController {
                svc.userType = UserType.Customer
            }
        //    }
        }
       
    }
}