//
//  ServiceTypes.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/17/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import Foundation



class ServiceTypes {
    private var array:NSArray!
   
    var creationSuccessful = false
    
    init()
    {
        creationSuccessful = createServiceTypeObjectSuccessful()
        
        if (!creationSuccessful) {
            // error
        }
    }

    private func createServiceTypeObjectSuccessful()-> Bool {
        // test and check for errors
        if let path = NSBundle.mainBundle().pathForResource(kServiceTypesPlistTitle, ofType:kPlist) {
        array = NSArray(contentsOfFile:path)
        return true
        }
        return false
    }
    
    // array of names
    func serviceTypesArray() -> NSArray {
        if (creationSuccessful) {
        return array.filter { $0[kName] != nil }.map { $0[kName]! }
        }
        return NSArray()
    }
    
    // procedures for name
    
    func proceduresForServiceName(name:String) -> NSArray {
       
        var newArray = NSMutableArray()
        
        for dict in array {
            if dict[kName] == name {
                newArray.addObject(dict[kProcedures])
            }
        }
        
        return newArray
    }
    
    func licensesForServiceName(name:String) -> NSArray {
        
        var newArray = NSMutableArray()
        
        for dict in array {
            if dict[kName] == name {
                newArray.addObject(dict[kLicenseOptions])
            }
        }
        
        return newArray
    }
    
    func serviceNamesForLicense(name:String) -> Array<String>  {
      
        var newArray = Array<String>()
        
        for dict in array {
            let licensesArray:Array<String> = dict.objectForKey(kLicenseOptions) as! Array<String>
            for licenseString:String in licensesArray {
                if (licenseString == name){
                    let newName = dict.objectForKey(kName)
                   newArray.append(newName as! String)
                }
            }
        }
        return newArray
    }
    
    func arrayOfLicenses() -> Array<String> {
        
        var licensesArray = [String]()
        
        for dict in array {
            licensesArray.appendContentsOf(dict.objectForKey(kLicenseOptions) as! [String])
        }
        
        let unique = Array(Set(licensesArray))
        
        return unique
    }
}