//
//  Time.swift
//  WaterReminder
//
//  Created by MAC on 21/5/24.
//

import Foundation
class Time {
    //MARK: fields
    private var hour:Int
    private var minute:Int
    //MARK: properties
    public func setHour(hour:Int){
        self.hour = hour
    }
    public func getHour() -> Int{
        return self.hour
    }
    public func setMinute(minute:Int){
        self.hour = minute
    }
    public func getMinute() -> Int{
        return self.minute
    }
    //MARK: constructor
    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
}
