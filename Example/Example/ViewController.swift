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
    
    @IBOutlet weak var datePicker: ADDatePicker!
    
    @IBOutlet weak var btnGetDate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customDatePicker1()
        
    }
    func customDatePicker1(){
        datePicker.yearRange(inBetween: 1990, end: 2022)
        datePicker.selectionType = .circle
        datePicker.bgColor = #colorLiteral(red: 0.3444891578, green: 0.5954311329, blue: 0.6666666865, alpha: 1)
        datePicker.deselectTextColor = UIColor.init(white: 1.0, alpha: 0.7)
        datePicker.deselectedBgColor = .clear
        datePicker.selectedBgColor = .white
        datePicker.selectedTextColor = .black
        datePicker.intialDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        // datePicker.delegate = self
    }
    
    @IBAction func getDate(_ sender: UIButton) {
        let date = datePicker.getSelectedDate()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        btnGetDate.setTitle(dateformatter.string(from: date) , for: .normal)
    }
}
//
extension ViewController: ADDatePickerDelegate {
    func ADDatePicker(didChange date: Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        btnGetDate.setTitle(dateformatter.string(from: date) , for: .normal)
    }
}

