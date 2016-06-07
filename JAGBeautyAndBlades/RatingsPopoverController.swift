//
//  RatingsPopoverController.swift
//  JAGForMen
//
//  Created by Michael Rose on 6/6/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import Cosmos

class RatingsPopoverController: UIViewController {
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var issuesButton: UIButton!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var starRatingsView: CosmosView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var providerImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        
        border.backgroundColor = UIColor.grayColor().CGColor
        border.frame = CGRect(x: 0, y: userView.frame.size.height-2, width:  userView.frame.size.width, height: 2)
        
        userView.layer.addSublayer(border)
        //userView.layer.masksToBounds = true
    }
    
    
    @IBAction func userSubmittedRating() {
        let rating = starRatingsView.rating
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

