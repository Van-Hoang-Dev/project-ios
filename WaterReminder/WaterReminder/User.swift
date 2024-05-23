//
//  User.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import Foundation
import UIKit

class User {
    
    //MARK: Fields
    var name:String
    var goal:String
    var gender:Int
    var unit:Int
    var weight:Double
    var wakeUpTime:String
    var sleepTime:String
    var totalWater:Double
    
    //MARK: Constructor
    init(){
        name = ""
        goal = ""
        gender = 0
        unit = 0
        weight = 1.0
        wakeUpTime = "00:00"
        sleepTime = "00:00"
        totalWater = 1.0
    }
    
    //MARK: method
    func toString()->String{
        return "name: \(self.name), "
        + "goal: \(self.goal), "
        + "gender: \(self.gender), "
        + "unit: \(self.unit), "
        + "weight: \(self.weight), "
        + "wakeup: \(self.wakeUpTime), "
        + "sleep: \(self.sleepTime), "
        + "total: \(self.totalWater)"
    }
    
}
