//
//  ViewController.swift
//  Example
//
//  Created by SOTSYS027 on 02/05/18.
//  Copyright © 2018 SOTSYS027. All rights reserved.
//

import UIKit
import ADDatePicker

class ViewController: UIViewController {

    @IBOutlet weak var DatePicker: ADDatePicker!
    
    @IBOutlet weak var btnGetDate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customDatePicker1()
    }
    func customDatePicker1(){
        DatePicker.yearRange(inBetween: 1990, end: 2022)
        DatePicker.selectionType = .circle
        DatePicker.bgColor = #colorLiteral(red: 0.3444891578, green: 0.5954311329, blue: 0.6666666865, alpha: 1)
        DatePicker.deselectTextColor = UIColor.init(white: 1.0, alpha: 0.7)
        DatePicker.deselectedBgColor = .clear
        DatePicker.selectedBgColor = .white
        DatePicker.selectedTextColor = .black
        DatePicker.intialDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
    }
    
    @IBAction func getDate(_ sender: UIButton) {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        btnGetDate.setTitle(dateformatter.string(from:DatePicker.getSelectedDate()), for: .normal)
        
    }
}

