//
//  Date.swift
//  Animation_Demo
//
//  Created by SOTSYS036 on 05/01/18.
//  Copyright © 2018 SOTSYS036. All rights reserved.
//

import Foundation

class BDate {

    var month: String
    var day: String
    var year:String
    
    init(month: String, day: String, year:String) {
        self.month = month
        self.day = day
        self.year = year
    }
    
    class func getMonths() -> [String]{
        return ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
    }
    class func getYears(startYear: Int, endYear: Int) -> [String] {
        return CalendarHelper.fetchYears(startYear: startYear, endYear: endYear)
    }
    
}

public enum SelectionType {
    case square
    case roundedsquare
    case circle
}


