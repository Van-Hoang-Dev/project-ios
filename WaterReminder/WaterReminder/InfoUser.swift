//
//  InfoUser.swift
//  WaterReminder
//
//  Created by MAC on 21/5/24.
//

import UIKit
class InfoUser{
    //MARK: properties
    var name:String?
    var gender:Int?
    var weight:Double?
    var wakeUpTime:Time?
    var sleepTime:Time?
    var totalWater:Double?
    
    //MARK: constructor
    init(name: String? = nil, gender: Int? = nil, weight: Double? = nil, wakeUpTime: Time? = nil, sleepTime: Time? = nil, totalWater: Double? = nil) {
        self.name = name
        self.gender = gender
        self.weight = weight
        self.wakeUpTime = wakeUpTime
        self.sleepTime = sleepTime
        self.totalWater = totalWater
    }
    
    
}//end class
