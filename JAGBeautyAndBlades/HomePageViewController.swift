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
    override func viewDidLoad() {
       super.viewDidLoad()
        
        }
    override func viewWillAppear(animated: Bool) {
        setUpView()
        
        self.navigationController?.navigationBarHidden = true
    }
    
    func setUpView() {
        
        let font:UIFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)!
        
        createAccountCallLabel.backgroundColor = UIColor.clearColor()
        createAccountCallLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        createAccountCallLabel.textColor = UIColor.whiteColor()
        customerButton.backgroundColor = UIColor.clearColor()
     
        customerButton.titleLabel?.font = font
        customerButton.titleLabel?.tintColor = UIColor.whiteColor()
        
        professionalButton.backgroundColor = UIColor.clearColor()
        professionalButton.titleLabel?.font = font
        professionalButton.titleLabel?.tintColor = UIColor.whiteColor()
        customerButton.addTarget(self, action: "customerButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        professionalButton.addTarget(self, action: "professionalButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.5)
    }
    
    func customerButtonPressed() {
        self.performSegueWithIdentifier("CustomerSignup", sender: nil)
    }
    
    func professionalButtonPressed() {
        self.performSegueWithIdentifier("ProfessionalSignup", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CustomerSignup" {
            let basicQuestionsViewController: BasicSignupViewController = segue.destinationViewController as! BasicSignupViewController
           // basicQuestionsViewController.isProvider = false
        }
        if segue.identifier == "ProfessionalSignup" {
            let basicQuestionsViewController: BasicSignupViewController = segue.destinationViewController as! BasicSignupViewController
         //   basicQuestionsViewController.isProvider = true
        }
    }
}