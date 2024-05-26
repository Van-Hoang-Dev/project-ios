//
//  Drink.swift
//  WaterReminder
//
//  Created by Nguyen Van Hoang on 22/05/2024.
//

import Foundation

class Drink {
    // MARK: Fields
    var id:Int
    var cup:Cup
    var time:String
    var date:String
    
    init(id: Int = -1 , cup:Cup, time:String ,date: String) {
        self.id = id
        self.cup = cup
        self.time = time
        self.date = date
    }
}
