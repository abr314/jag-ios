//
//  ServicesLabel.swift
//  JAGForMen
//
//  Created by Abraham Brovold on 3/13/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit

class ServicesLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setProperties()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setProperties()
    }
    func setProperties() {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.textColor = kPurpleColor
        self.backgroundColor = UIColor.whiteColor()
        
    }

}
