//
//  HCFormValidator.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/4/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import XLForm

public func validateForm(formVC: XLFormViewController) -> Bool {
   
    func animateCell(cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.additive = true
        cell.layer.addAnimation(animation, forKey: "shake")
    }
    
    func validateFormSuccessful() -> Bool {
        let array = formVC.formValidationErrors()
        for errorItem in array {
            let error = errorItem as! NSError
            let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
            
            if validationStatus.rowDescriptor!.tag == kEmail ||
                validationStatus.rowDescriptor!.tag == kPhone || validationStatus.rowDescriptor!.tag == kFirstName || validationStatus.rowDescriptor!.tag == kLastName || validationStatus.rowDescriptor!.tag == kPassword || validationStatus.rowDescriptor!.tag == kFirstLine || validationStatus.rowDescriptor!.tag == kZipCode || validationStatus.rowDescriptor!.tag == kStartTime || validationStatus.rowDescriptor!.tag == kEndTime {
                    if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = formVC.form.indexPathOfFormRow(rowDescriptor), let cell = formVC.tableView.cellForRowAtIndexPath(indexPath) {
                        animateCell(cell)
                    }
            }
        }
        
        if (array.count == 0) {
            return true
        } else {
            return false
        }
    }
    
    if validateFormSuccessful() {
        return true
        
    } else {
        
        return false
    }
}
