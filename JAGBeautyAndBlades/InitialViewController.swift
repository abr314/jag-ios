//
//  InitialViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/21/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import SwiftyTimer
class InitialViewController: UIViewController {

    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        NSTimer.after(2.seconds) {
            self.addBlurToBackgroundImage()

            self.performSegueWithIdentifier("SignUp", sender: self)
        }
        
        self.backgroundImage.hidden = false
        self.navigationController?.navigationBarHidden = true
        
        
        // Do any additional setup after loading the view.
    }

    func addBlurToBackgroundImage() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.view.addSubview(blurEffectView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //       blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
     //   self.view.addSubview(blurEffectView)
        self.backgroundImage.hidden = false
        
        
   //     presentViewController(nc, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
