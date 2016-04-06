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
  //   var shoppingCart = [HCAppointment]()
     var selectedCellTitle = ""
     var selectedCellName = ""
     var servicesJSON:JSON = JSON.null
     var appointmentsJSON:JSON = JSON.null
     var customerToken = ""
     var bookingID = 0
     var appointmentCategory = 0
     var appointmentID = 0
     var categoryID = 0
     var appointmentsDownloaded = false
 //   @IBOutlet weak var servicesCell: ServicesCollectionViewCell!
    
    override func viewWillAppear(animated: Bool) {
     
    }
    override func viewDidLoad() {
        
         super.viewDidLoad()
        // download the service types dictionary
        var token = ""
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey(kJAGToken)
        {
            token = name
            customerToken = name
        }
        
        let headers = ["Authorization":  "Token  \(token)"]
      
        Alamofire.request(.GET, kServiceCategoriesURL).responseJSON {
            response in switch response.result {
            case .Success(let json):
                let response = json as? JSON
                self.servicesJSON = JSON(json)
            case .Failure(let error): break
                }
        }
        
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
            case .Failure(let error): break
                
                }
        }
        
       
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
        self.view.backgroundColor = UIColor.whiteColor()
        // Register cell classes
  //      self.collectionView!.registerClass(ServicesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        cellImages = ["HairMan.png",
                      "CosmoMan.png",
                      "MassageMan.png",
                      "NailApp.png",
                      "SpaApp.png",
                      "TrainerApp.png"]
        
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
                svc.appointmentID = appointmentID
                svc.bookingID = bookingID
                svc.categoryID = categoryID
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
    //    let cell = ServicesCollectionViewCell()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ServicesCollectionViewCell
        // Configure the cell
        let image = UIImage(named: cellImages[indexPath.row])
        
      //  let text = cellLabels[indexPath.row]
        
    //    cell.serviceLabel.font = UIFont(name: kHeaderFont, size: 20)
        cell.cellImage?.image = image
        
      //  cell.serviceLabel.text = text
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedCellTitle = cellLabels[indexPath.row]
        selectedCellName = webCellNames[indexPath.row]
        categoryID = servicesJSON[indexPath.row]["id"].intValue
        let headers = ["Authorization":  "Token  \(customerToken)", "Content-Type":"application/json"]
      //  let parameters = ["":""]
        Alamofire.request(.POST, kCreateBookingURL, headers: headers, parameters:[:], encoding: .JSON).responseJSON
            { response in switch response.result {
                
            case .Success(let json):
             //   let newResponse = json //as? JSON
                let newJSON:JSON = JSON(json)
                let cusID = newJSON["id"].intValue
                
                
                
               Alamofire.request(.POST, kCreateAppointmentURL, headers: headers, parameters:["booking":cusID, "category":self.categoryID], encoding: .JSON).responseJSON
                { response in switch response.result {
                    case .Success(let json):
                     //   let newJSON = json
                        // Get and set appointment ID
                        let nJSON:JSON = JSON(json)
                        self.appointmentID = nJSON["id"].intValue
                        self.bookingID = nJSON["booking"].intValue
                        
                        
           //             let appID = newJSON["id"].intValue
                        print(nJSON["booking"].stringValue)
                        self.performSegueWithIdentifier("procedures", sender: nil)
                    case .Failure(let error): break
                    
                    }
                
                }
                
                

            case .Failure(let error): break
                
                }
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
