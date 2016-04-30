//
//  HCFontsandColors.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/19/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift

let kHeaderFont = "PFMonumentaPro-Metallica"
let kJagFont = "PFMonumentaPro-Metallica"
let kBodyFont = "Raleway"

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.startIndex.advancedBy(1)
            let hexColor = hexString.substringFromIndex(start)
            
            if hexColor.characters.count == 8 {
                let scanner = NSScanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexLongLong(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

let kPrimaryColor:UIColor = UIColor(rgba: "#533A71")
let kSecondaryColor:UIColor = UIColor(rgba: "#E4DDCA") // Old color #50C5B7
let kGoldColor:UIColor = UIColor(rgba: "#E4DDCA")
let kPurpleColor:UIColor = UIColor(rgba: "#4C0B84")


class HCFontsandColors:NSObject {
    

    
}