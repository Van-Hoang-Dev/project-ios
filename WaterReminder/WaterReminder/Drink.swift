//
//  Drink.swift
//  WaterReminder
//
//  Created by Nguyen Van Hoang on 22/05/2024.
//

import Foundation

class Drink {
    // MARK: Fields
    var image:String
    var amount:Double
    var date:String
    
    init(image: String, amount: Double, date: String) {
        self.image = image
        self.amount = amount
        self.date = date
    }
}
