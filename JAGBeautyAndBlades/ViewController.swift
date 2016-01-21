//
//  ViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/18/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
  //      let JSONObject:JSON = ["name":"my name"]
        Alamofire.request(.POST, "http://127.0.0.1:8000/signup", parameters: ["name":"my name"], encoding: .JSON)
        .response { (request, response, data, error) in
                if (response?.statusCode == 404) {
                    
                }
                print(request)
                print("response: \(response)")
                print(error)
            }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

