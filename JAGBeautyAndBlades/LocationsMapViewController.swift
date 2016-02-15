//
//  AddLocationsViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/3/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationsMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: nil, action: "addButtonPressed")
  
        navigationItem.rightBarButtonItem = barButton
  
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func addButtonPressed() {
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
    }

}
