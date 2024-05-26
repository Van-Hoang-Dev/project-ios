//
//  CalendarHelper.swift
//  WaterReminder
//
//  Created by khang on 26/05/2024.
//

import Foundation
import UIKit

class CalendarHelper{
    
    let calendar = Calendar.current
    
    // Lay ten thang hien tai
    func monthString(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    // Lay nam hien tai
    func yearString(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    // Lay so luong ngay trong thang
    func daysInMonth(date:Date)->Int{
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    // Lay ngay trong thang
    func dayOfMonth(date:Date)->Int{
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    // Lay ngay dau tien trong thang
    func firstOfMonth(date:Date)->Int{
        let components = calendar.dateComponents([.year, .month], from: date)
        return components.day!
    }
    // Lay ngay trong tuan
    func dayOfWeek(date:Date)->Int{
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    // Them ngay trong tuan
    func addDays(date:Date, days:Int)->Date{
        return calendar.date(byAdding: .day, value: days, to: date)!
    }
    // Tim ngay chu nhat
    func sundayForDate(date:Date)->Date{
        var current = date
        let oneWeekAgo = addDays(date: current, days: -7)
        while (current > oneWeekAgo) {
            let currentWeedDay = calendar.dateComponents([.weekday], from: current).weekday
            if(currentWeedDay == 1){
                return current
            }
            current = addDays(date: current, days: -1)
        }
        return current
    }
    
}
