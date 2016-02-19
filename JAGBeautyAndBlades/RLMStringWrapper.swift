//
//  RLMStringWrapper.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/17/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import RealmSwift

class RLMStringWrapper: Object {
    dynamic var string = ""
    
    func wrapperValueForString(newString:String) -> RLMStringWrapper {
        
        string = "\(newString)"
        
        return self
    }
    
    
}
