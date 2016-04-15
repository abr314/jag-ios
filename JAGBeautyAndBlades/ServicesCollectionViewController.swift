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
     var appointmentsJSON:JSON = JSON.null
     var customerToken = ""
     var bookingID = 0
     var appointmentCategory = 0
     var appointmentID = 0
     var categoryID = 0
     var appointmentsDownloaded = false
     var hasBeenTapped = false
    
    override func viewWillAppear(animated: Bool) {
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
                
                self.appointmentsJSON = JSON(json)
                print("APPOINTMENTS:\(self.appointmentsJSON)")
                self.appointmentsDownloaded = true
                
                if let appointmentsVC = self.tabBarController?.viewControllers {
                    for vc in appointmentsVC {
                        if vc.title == "Appointments" {
                            if let appointmentVC = vc as? AppointmentsFormViewController {
                                appointmentVC.appointments = self.appointmentsJSON
                            }
                        }
                    }
                    
                }
            case .Failure(_): break
                
            }
        }
    }
    override func viewDidLoad() {
        
         super.viewDidLoad()
        // download the service types dictionary
        hasBeenTapped = false
        
        self.title = "JAG"
        self.edgesForExtendedLayout = UIRectEdge.None
        navigationController?.title = "JAG"
        navigationItem.title = "JAG"
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor()]
  //      UINavigationBar.appearance().bartin
        
        Alamofire.request(.GET, kServiceCategoriesURL).responseJSON {
            response in switch response.result {
            case .Success(let json):
            //    let response = json as? JSON
                self.servicesJSON = JSON(json)
            case .Failure(_): break
                
                }
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
        self.view.backgroundColor = UIColor.whiteColor()
        
        cellImages = [kBarberImageString,
                      kCosmoImageString,
                      kMassageImageString,
                      kNailImageString,
                      kSpaImageString,
                      kTrainerImageString]
        
        cellLabels = ["Barber",
                      "Cosmetic",
                      "Massage",
                      "Nails",
                      "Spa",
                      "Training"]
        
        webCellNames = ["hair",
                        "cosmetic",
                        "massage",
                        "nails",
                        "spa",
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
                svc.service = selectedCellTitle
                svc.services = servicesJSON
                svc.newName = selectedCellName
                svc.categoryImageName = selectedCellImageName
                svc.customerToken = customerToken
                svc.appointmentID = appointmentID
                svc.bookingID = bookingID
 
                svc.categoryID = categoryID
 
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
