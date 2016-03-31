//
//  JAGPreviewViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/27/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit

class JAGPreviewViewController: UIViewController, UIScrollViewDelegate {

    var descriptionLabels = [String]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        showInitialImage()
        updateCurrentImageDescription()
        scrollView.tintColor = UIColor.purpleColor()
        for localImage in HCPreviewConstants.localImages {
            if let image = UIImage(named: localImage.fileName) {
                scrollView.auk.show(image: image, accessibilityLabel: localImage.description)
                descriptionLabels.append(localImage.description)
            }
        }
        
        self.title = "JAG For Men"
        
        
       
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        var signUpButton = UIBarButtonItem(title: "Sign Up", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(JAGPreviewViewController.signUpClicked))
        
        //    signUpButton.tintColor = kPurpleColor
        // navigationItem.
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("AccountHasBeenCreated") as? Bool != true) {
            self.navigationItem.setRightBarButtonItem(signUpButton, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signUpClicked() {
        if (NSUserDefaults.standardUserDefaults().objectForKey("AccountHasBeenCreated") as? Bool == true) {
            let alert = UIAlertController(title: "You've already created an account", message: "Please go www.jagformen.com for booking and more information", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        self.performSegueWithIdentifier("SignUp", sender: nil)
    }
    private func showInitialImage() {
        if let image = UIImage(named: HCPreviewConstants.initialImage.fileName) {
            scrollView.auk.show(image: image,
                accessibilityLabel: HCPreviewConstants.initialImage.description)
            
            descriptionLabels.append(HCPreviewConstants.initialImage.description)
        }
    }
    
    private func updateCurrentImageDescription() {
        if let description = currentImageDescription {
            descriptionLabel.text = description
            descriptionLabel.font = UIFont(name: kBodyFont, size: 19)
        } else {
            descriptionLabel.text = nil
        }
    }
    
    private var currentImageDescription: String? {
        if scrollView.auk.currentPageIndex >= descriptionLabels.count {
            return nil
        }
        
        return descriptionLabels[scrollView.auk.currentPageIndex]
    }
    
    @IBAction func onAutoscrollTapped(sender: AnyObject) {
        scrollView.auk.startAutoScroll(delaySeconds: 2)
    }
    
    @IBAction func onScrollViewTapped(sender: AnyObject) {
     //   descriptionLabel.text = "Tapped image #\(scrollView.auk.currentPageIndex)"
      /*
        for localImage in HCPreviewConstants.localImages {
            if let image = UIImage(named: localImage.fileName) {
                scrollView.auk.show(image: image, accessibilityLabel: localImage.description)
                descriptionLabels.append(localImage.description)
            }
        }
        */
        updateCurrentImageDescription()
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateCurrentImageDescription()
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
