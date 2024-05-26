//
//  Cup.swift
//  WaterReminder
//
//  Created by Nguyen Van Hoang on 22/05/2024.
//

import Foundation

class Cup {
    //MARK: FIELDS
    var id:Int
    var image:String
    var amount:Double
    
    init(id: Int = -1 ,image: String, amount: Double) {
        self.id = id
        self.image = image
        self.amount = amount
    }
}
