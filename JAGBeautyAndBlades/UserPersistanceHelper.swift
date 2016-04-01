//
//  UserPersistanceHelper.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 3/9/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//
/*
import Foundation
import RealmSwift
import Locksmith
import SwiftyJSON
func saveCustomer(customer:HCCustomer) {
    
    let token = retrieveAuthToken(customer.email, password: customer.password)
    customer.token = token
    
    let dictionary = ["email":"\(customer.email)", "password":"\(customer.password)", "token":"\(customer.token)", "first_name":"\(customer.firstName)", "last_name":"\(customer.lastName)", "phone":"\(customer.phoneNumber)"]
    // adds customer to realm and sign in info to keychain
    
    
    do {
        let realm = try Realm()
        try realm.write {
            realm.add(customer)
        }
        try Locksmith.saveData(dictionary, forUserAccount: "JAGAccount") //throws -> AnyObject
        
    } catch {
        
    }
}

func loadUserData() -> Any {
    // check realm database
    
    // check keychain
    //let json = JSON(Locksmith.loadDataForUserAccount("JAGAccount")
  
    if let object = Locksmith.loadDataForUserAccount("JAGAccount") as? [String:String], email:String = object["email"], password:String = object["password"] {
       
        let token = retrieveAuthToken(email, password:password)
        return token
        
    } else {
        // nothing we can do, account doesn't exist must login
    }
    
   
    return false
    
}
*/
