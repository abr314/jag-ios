//
//  BasicSignUpQuestionsViewController.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 1/19/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit
import Eureka

class BasicSignUpQuestionsViewController : FormViewController {
    
    var isProvider = false
    var customer:HCCustomer?
    var professional:HCProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   /*     ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
     */
       // UIView.appearance().backgroundColor = UIColor(rgba: "#141318")
    self.tableView?.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpTable()
    }
   
    func setUpTable() {
        let silverColor:UIColor = UIColor(rgba: "#1234EF")
        form
        
        +++ Section()
            
                <<< TextRow("First Name") {
                    $0.cell.backgroundColor = UIColor.blackColor()
                    $0.title = $0.tag
                //    $0.cell.textLabel?. = UIColor.whiteColor()
                    $0.cell.titleLabel?.textColor = UIColor.whiteColor()
                    $0.cell.tintColor = UIColor.whiteColor()
                    $0.cell.textField.textColor = UIColor.whiteColor()
                    $0.cell.textField.backgroundColor = UIColor.whiteColor()
                    $0.hightlightCell()
                   // $0.cell.titleLabel?.backgroundColor = UIColor.whiteColor()
                  //  $0.baseCell.textLabel?.textColor = UIColor.whiteColor()
                 //   $0.cellType =
                  //  $0.cell.titleLabel?.tintColor = silverColor
                    }.cellSetup{cell, row in
                    cell.textLabel!.textColor = UIColor.whiteColor()
                    }
                <<< TextRow("Last Name") { $0.title = $0.tag }
                <<< PhoneRow("Phone Number") { $0.title = $0.tag }
                <<< EmailRow("Email") { $0.title = $0.tag }
        
    }
    
    
}