//
//  RatingsPopoverController.swift
//  JAGForMen
//
//  Created by Michael Rose on 6/6/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire

class RatingsPopoverController: UIViewController {
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var issuesButton: UIButton!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var starRatingsView: CosmosView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var providerImageView: UIImageView!
    
    var appointmentID = ""
    var userToRateImageURL: NSURL?
    var userToRateName: String?
    var isProRatingCustomer: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //popoverPresentationController?.delegate = self
        
        providerImageView.contentMode = .ScaleAspectFill
        
        providerNameLabel.text = userToRateName
        userTypeLabel.text = isProRatingCustomer == true ? "Customer" : "Pro"
        if let data = NSData(contentsOfURL: userToRateImageURL!) {
            providerImageView.image = UIImage(data: data)
            
            providerImageView.layer.borderWidth = 3
            providerImageView.layer.masksToBounds = false
            providerImageView.layer.borderColor = kPrimaryColor.CGColor
            providerImageView.layer.cornerRadius = providerImageView.frame.height/2
            providerImageView.clipsToBounds = true
        }
        
        self.view.layer.borderWidth = 2
        self.view.layer.cornerRadius = 10
        self.view.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //initializeForm()
    }
    
    override func viewWillAppear(animated: Bool) {
            }
    
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let borderHeight = CGFloat(2)
        
        border.backgroundColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: userView.frame.size.height-borderHeight, width:  userView.frame.size.width, height: borderHeight)
        
        userView.layer.addSublayer(border)
        //userView.layer.masksToBounds = true
    }
    
    
    @IBAction func userSubmittedRating() {
        if starRatingsView.rating < 1 {
            let alert = UIAlertController(title: "No Rating", message: "Please rate your experience first", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Gotya!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        submitRating()
        
    }
    
    
    func submitRating() {
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.color = UIColor.blackColor()
        //  transform = CGAffineTransform(CGAffineTransformMakeScale(1.5f, 1.5f);
        //  activityIndicator.transform = transform
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true
        //    activityView.activityIndicatorViewStyle = UIActivityIndicatorView.
        self.view.addSubview(activityView)
        activityView.startAnimating()
        
        
        let token = UserInformation.sharedInstance.token
        let headers = ["Authorization":  "Token  \(token)"]
        var endpointURL:URLStringConvertible
        var params = [String: AnyObject]?()
        
        if isProRatingCustomer == true {
            params = ["appointment_provider_rates_customer":Int(starRatingsView.rating)]
            endpointURL = kAppointmentEndURL + appointmentID + "/"
        } else {
            params = ["rating":Int(starRatingsView.rating), "appointment_id" : appointmentID]
            endpointURL = kRatingsURL
        }
        
        Alamofire.request(.POST, endpointURL, parameters:params, headers:headers)
            .responseJSON { response in
                
                switch response.result {
                
                case .Success(let json):
                    print(json)
                    //self.navigationController?.popToRootViewControllerAnimated(true)
                    self.dismissViewControllerAnimated(true, completion:nil)
                    if self.isProRatingCustomer == true {
                        self.popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover!(self.popoverPresentationController!)
                    }
                
                case .Failure(let error):
                    print(response.result)
                    print(error)
                    print(error.code)
                    print(error.localizedFailureReason)
                    let alertController = returnAlertControllerForErrorCode(error.code)
                    self.presentViewController(alertController, animated: true) {}
                    
                }
                
                activityView.stopAnimating()
        }

        
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        if isProRatingCustomer == true {
            return false
        }
        return false
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

