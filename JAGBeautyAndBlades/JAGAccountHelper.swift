//
//  JAGAccountHelper.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 3/8/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import Foundation
import Locksmith

struct JAGAccount: ReadableSecureStorable, CreateableSecureStorable, DeleteableSecureStorable, GenericPasswordSecureStorable
{
    let username: String
    let password: String
    let firstName: String
    let lastName: String
    let userType: UserType
    let email:String
    
    let service = "JAG"
    
    var account: String { return email }
    
    var data: [String: AnyObject] {
        return ["password": password]
    }
    
    func createKeychainAccount() {
        try! self.createInSecureStore()
    }
    
    func readKeychainAccount() {
        let result = self.readFromSecureStore()
    }
    
}

//func createKeychainAccount(account:JAGAccount) {
    
