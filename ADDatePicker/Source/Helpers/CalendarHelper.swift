//
//  CalendarHelper.swift
//  Animation_Demo
//
//  Created by SOTSYS036 on 05/01/18.
//  Copyright © 2018 SOTSYS036. All rights reserved.
//

import UIKit


class CalendarHelper{
    
    static func fetchYears(startYear: Int, endYear: Int) -> [String] {
        let cal = Calendar.current
        var years:[String] = []
        let StartDateComponents = DateComponents(year: startYear , month: 1, day: 1)
        
        guard let startDate = cal.date(from: StartDateComponents) else {
            return []
        }
        if endYear > startYear {
            let range = endYear - startYear
            for i in 0 ... range {
                guard let yearsBetween = cal.date(byAdding: .year, value: i, to: startDate) else { return [] }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy"
                let year = dateFormatter.string(from: yearsBetween)
                years.append(year)
            }
            return years
        }else {
            fatalError("startYear cannot be greater than EndYear")
        }
        
    }
    
    static func fetchDays(_ years: [ModelDate], _ months: [ModelDate]) -> Int {
        var numDays = 0
        var currentMonth = "6"
        for (index, month) in months.enumerated() {
            if month.isSelected == true {
                currentMonth = "\(index + 1)"
                break
            }
        }
        if let yearInt = Int(years.currentYear.type), let monthInt = Int(currentMonth){
            let dateComponents = DateComponents(year: yearInt, month: monthInt)
            let calendar = Calendar.current
            let date = calendar.date(from: dateComponents)!
            
            let range = calendar.range(of: .day, in: .month, for: date)!
            numDays = range.count
        }
        return numDays
    }
    
    
    static func getThatDate(_ days: [ModelDate], _ months: [ModelDate], _ years: [ModelDate]) -> Date{
        var currentDay: String = ""
        var currentMonth: String = ""
        var currentYear: String = ""
        for day in days{
            if day.isSelected == true {
                currentDay = day.type
                break
            }
        }
        for month in months {
            if month.isSelected == true {
                currentMonth = month.type
                break
            }
        }
        for year in years {
            if year.isSelected == true {
                currentYear = year.type
                break
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if currentDay == "" {
            currentDay = (days.last?.type)!
        }
        let date = dateFormatter.date(from: "\(currentMonth)/\(currentDay)/\(currentYear)")
        
        return date!
    }
}

extension Array where Element: ModelDate {
    
    var currentMonth: ModelDate {
        if let selectedMonth = self.filter({ (modelObject) -> Bool in
            return modelObject.isSelected
        }).first {
            return selectedMonth
        }
        return ModelDate(type: "6", isSelected: false)
    }
    
    var currentYear: ModelDate {
        if let selectedYear = self.filter({ (modelObj) -> Bool in
            return modelObj.isSelected
        }).first {
            return selectedYear
        }
        return ModelDate(type: "2006", isSelected: false)
    }
    
    func selectDay(selectedDay: ModelDate){
        for day in self  {
            if day == selectedDay {
                day.isSelected = selectedDay.isSelected
            }
        }
    }
}


