//
//  UserDefaultsKeys.swift
//  WaterReminder
//
//  Created by khang on 25/05/2024.
//

import Foundation

class UserDefaultsKey {
    enum User : String {
        //khai bao cac Enum
        case USER_NAME = "name"
        case USER_GOAL = "goal"
        case USER_GENDER = "gender"
        case USER_UNIT = "unit"
        case USER_WEIGHT = "weight"
        case USER_WAKEUP_TIME = "wakeup_time"
        case USER_SLEEP_TIME = "sleep_time"
        case USER_TOTAL_WATER = "total_water"
        case USER_DURATION_TIME = "duration_time"
        case USER_NOTIFICATION_ENABLED = "notification_enabled"
        case USER_ISUSEDFIRSTTIME = "isUsedFirstTime"
    }
    //ham gan gia tri vao userDefaults
    public static let setValue: (_ value:Any?,_ key:User)->Void = {value, key in
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    //lay gia tri tu UserDefaults
    public static func getName()->String?{
        return UserDefaults.standard.string(forKey: User.USER_NAME.rawValue)
    }
    public static func getGoal()->String?{
        return UserDefaults.standard.string(forKey: User.USER_GOAL.rawValue)
    }
    //get gender: male = 0; female = 1
    public static func getGender()->Int{
        return UserDefaults.standard.integer(forKey: User.USER_GENDER.rawValue)
    }
    //get unit: 1 = ml,m; 2= oz,fl oz
    public static func getUnit()->Int{
        return UserDefaults.standard.integer(forKey: User.USER_UNIT.rawValue)
    }
    public static func getWeight()->Double{
        return UserDefaults.standard.double(forKey: User.USER_WEIGHT.rawValue)
    }
    public static func getWakeUpTime()->String?{
        return UserDefaults.standard.string(forKey: User.USER_WAKEUP_TIME.rawValue)
    }
    public static func getSleepTime()->String?{
        return UserDefaults.standard.string(forKey: User.USER_SLEEP_TIME.rawValue)
    }
    public static func getTotalWater()->Double{
        return UserDefaults.standard.double(forKey: User.USER_TOTAL_WATER.rawValue)
    }
    public static func getDurationTime()->Int{
        return UserDefaults.standard.integer(forKey: User.USER_DURATION_TIME.rawValue)
    }
    public static func getNotification()->Bool{
        return UserDefaults.standard.bool(forKey: User.USER_NOTIFICATION_ENABLED.rawValue)
    }
    public static func isUsedFirstTime()->Bool{
        return UserDefaults.standard.bool(forKey: User.USER_ISUSEDFIRSTTIME.rawValue)
    }
}
