//
//  ServicesCollectionViewController.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 3/13/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
private let reuseIdentifier = "Cell"

class ServicesCollectionViewController: UICollectionViewController {
     var cellImages = [String]()
     var cellLabels = [String]()
     var webCellNames = [String]()
     var selectedCellTitle = ""
     var selectedCellName = ""
     var selectedCellImageName = ""
     var servicesJSON:JSON = JSON.null
  //   var appointmentsJSON:JSON = JSON.null
     var customerToken = ""
     var bookingID = 0
     var appointmentCategory = 0
     var appointmentID = 0
     var categoryID = 0
     var appointmentsDownloaded = false
     var hasBeenTapped = false
    
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       // super.viewWillAppear(true)
       // self.navigationController?.viewWillAppear(true)
        
        if let object = UserInformation.sharedInstance.customerProfile {
            if object.isProfessional == true {
                
                
                
                
              performSegueWithIdentifier("proAppointments", sender: nil)
                // transition to appointment form VC
            }
        }
        var token = ""
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey(kJAGToken)
        {
            
            token = name
            customerToken = name
        }
        
        let headers = ["Authorization":  "Token  \(token)"]
        Alamofire.request(.GET, kAppointmentsURL, headers: headers).responseJSON {
            response in switch response.result {
                
            case .Success(let json):
                
                UserInformation.sharedInstance.appointments = JSON(json)
                print("APPOINTMENTS via SCV:\(UserInformation.sharedInstance.appointments)")
                self.appointmentsDownloaded = true
                /*
                if let appointmentsVC = self.tabBarController?.viewControllers {
                    for vc in appointmentsVC {
                        if vc.title == "Appointments" {
                            if let appointmentVC = vc as? AppointmentsFormViewController {
                                appointmentVC.appointments = UserInformation.sharedInstance.appointments
                       //         UserInformation.sharedInstance.appointments = self.appointmentsJSON
                            }
                        }
                    }
                    
                }
            */
            case .Failure(let error): //break
                let alertController = returnAlertControllerForErrorCode(error.code)
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
                
            }
        }
    }
    
  //  svc.initializeForm()
    override func viewDidLoad() {
        
         super.viewDidLoad()
        // download the service types dictionary
        hasBeenTapped = false
        
        self.title = "Services"
        /*
            If  user type is provider, transition to the activities VC and disable services
        */
  //      self.delegate = self
        
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(kPrimaryColor, size: CGSizeMake(((self.tabBarController?.tabBar.frame.width)!/2) - 0, (self.tabBarController?.tabBar.frame.height)! - 0))
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        //self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : kPrimaryColor]
  //      UINavigationBar.appearance().bartin
        
        Alamofire.request(.GET, kServiceCategoriesURL).responseJSON {
            response in switch response.result {
            case .Success(let json):
            //    let response = json as? JSON
                self.servicesJSON = JSON(json)
                print(json)
            case .Failure(let error): //break
                let alertController = returnAlertControllerForErrorCode(error.code)
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
                }
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
        //self.view.backgroundColor = UIColor.whiteColor()
        
        cellImages = [kBarberImageString,
                      kNailImageString,
                      kMassageImageString,
                      kSpaImageString,
                      kCosmoImageString,
                      kTrainerImageString]
        
        cellLabels = ["Barber",
                      "Nails",
                      "Massage",
                      "Spa",
                      "Cosmetic",
                      "Training"]
        
        webCellNames = ["hair",
                        "nails",
                        "massage",
                        "spa",
                        "cosmetic",
                        "trainers"]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        // convert selection to lower case
        // search through the services JSON object for the selected service
        // pass the proper dictionary to the details VC
        if segue.identifier == "procedures" {
            if let svc = segue.destinationViewController as? ServiceDetailFormViewController {
                svc.navigationItem.title = selectedCellName
                svc.service = selectedCellTitle
                svc.services = servicesJSON
                svc.newName = selectedCellName
                svc.categoryImageName = selectedCellImageName
                svc.customerToken = customerToken
                svc.appointmentID = appointmentID
                svc.bookingID = bookingID
 
                svc.categoryID = categoryID
                
                let backItem = UIBarButtonItem()
                backItem.title = ""
                svc.navigationItem.backBarButtonItem = backItem
                
                hasBeenTapped = false
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cellImages.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> ServicesCollectionViewCell {
 
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ServicesCollectionViewCell
        // Configure the cell
        let image = UIImage(named: cellImages[indexPath.row])
        
        
     
        cell.cellImage?.image = image
        
      //  cell.serviceLabel.text = text
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectedCellTitle = cellLabels[indexPath.row]
        selectedCellName = webCellNames[indexPath.row]
        selectedCellImageName = cellImages[indexPath.row]
        categoryID = servicesJSON[indexPath.row]["id"].intValue
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.objectForKey("role") as? String == "pro" {
            
        
        
      //  if let cus = UserInformation.sharedInstance.customerProfile {
        
            
        //    if cus.isProfessional == true {
                
                
                let alertController = UIAlertController(title: "", message: "Booking is currently for customers only. Please sign-up on the website with a customer account and book your appointment there.", preferredStyle: .Alert)
            
           // let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ...
           // }
         //   alertController.addAction(cancelAction)
            
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
                }
                alertController.addAction(OKAction)
            
                self.presentViewController(alertController, animated: true) {
                // ...
                }
                return
    //        }
        }
        
        if hasBeenTapped == true {
            return
        }
        if hasBeenTapped == false {
            hasBeenTapped = true
            performSegueWithIdentifier("procedures", sender: nil)
        }
    }
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
    }

    
    
}
