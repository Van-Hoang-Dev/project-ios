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
    var image:String
    var amount:Double
    var time:String
    var date:String
    
    init(id: Int, image: String, amount: Double, time: String, date: String) {
        self.id = id
        self.image = image
        self.amount = amount
        self.time = time
        self.date = date
    }
}
