//
//  Database.swift
//  WaterReminder
//
//  Created by khang on 22/05/2024.
//

import Foundation
import UIKit
import os.log

class Database {
    //MARK: Cac thuoc tinh chung cua co so du lieu.
    private let DB_PATH:String?
    private let DB_NAME = "water.sqlite"
    private let database:FMDatabase?
    
    //MARK: Cac thuoc tinh lien quan den ban du lieu.
    // 1. Bang user.
    private let USER_TABLE_NAME = "user"
    private let USER_ID = "id"
    private let USER_NAME = "name"
    private let USER_GOAL = "goal"
    private let USER_GENDER = "gender"
    private let USER_UNIT = "unit"
    private let USER_WEIGHT = "weight"
    private let USER_WAKEUP_TIME = "wakeup_time"
    private let USER_SLEEP_TIME = "sleep_time"
    private let USER_TOTAL_WATER = "total_water"
    
    // 2. Bang cups.
    private let CUP_TABLE_NAME = "cups"
    private let CUP_ID = "id"
    private let CUP_IMAGE = "image"
    private let CUP_AMOUNT = "amount_water"
    
    // 3.Bang drink.
    private let DRINK_TABLE_NAME = "drinks"
    private let DRINK_ID = "id"
    private let DRINK_CUP = "cup_id"
    private let DRINK_TIME = "time"
    private let DRINK_DATE = "date"
    
    //MARK: constructor
    init() {
        // Lay tat ca duong dan den thu muc document trong 1 ung dung ios.
        let derectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        // Khoi tao duong dan DB_PATH.
        DB_PATH = derectories[0] + "/" + DB_NAME
        
        // Khoi tao doi tuong Database
        database = FMDatabase(path: DB_PATH)
        
        // Kiem tra su thanh cong cua Database
        if database != nil {
            os_log("Tao database thanh cong!")
            //thuc hien tao bang du lieu
            let sql_create_user = "CREATE TABLE \(USER_TABLE_NAME) ("
            + "\(USER_NAME) TEXT, "
            + "\(USER_GOAL) TEXT, "
            + "\(USER_GENDER) TEXT, "
            + "\(USER_UNIT) INT, "
            + "\(USER_WEIGHT) DOUBLE,"
            + "\(USER_WAKEUP_TIME) TEXT, "
            + "\(USER_SLEEP_TIME) TEXT, "
            + "\(USER_TOTAL_WATER) DOUBLE)"
            
            //            + "\(USER_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            let sql_create_cups = "CREATE TABLE \(CUP_TABLE_NAME) ("
            + "\(CUP_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(CUP_AMOUNT) DOUBLE, "
            + "\(CUP_IMAGE) TEXT)"
            
            let sql_create_drinks = "CREATE TABLE \(DRINK_TABLE_NAME) ("
            + "\(DRINK_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(DRINK_CUP) INTEGER, "
            + "\(DRINK_TIME) TEXT, "
            + "\(DRINK_DATE) TEXT)"
            
            //Kiem tra bang da duoc tao hay chua
            if open() {
                if !database!.tableExists(USER_TABLE_NAME) {
                    let _ = createTable(sql: sql_create_user)
                }
                if !database!.tableExists(CUP_TABLE_NAME) {
                    let _ = createTable(sql: sql_create_cups)
                }
                if !database!.tableExists(DRINK_TABLE_NAME) {
                    let _ = createTable(sql: sql_create_drinks)
                }
            }
            
        }//end if
        else {
            os_log("Khong the tao du lieu database.")
        }
    }//end init
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  MARK: Dinh nghia cac ham primitives cua CSDL
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    // 1: Mo CSDL
    private func open()-> Bool {
        var OK = false
        if let database = database {
            if database.open() {
                os_log("Mo CSDL thanh cong!")
                OK = true
            }
            else {
                os_log("Mo CSDL khong thanh cong!")
            }
        }
        return OK
    }
    
    // 2: Dong CSDL
    private func close() {
        if let database = database {
            database.close()
        }
    }
    
    // 3: Tao bang du lieu
    private func createTable(sql:String)->Bool {
        var OK = false
        if database!.executeStatements(sql) {
            os_log("Tao bang thanh cong!")
            OK = true
        }
        else {
            os_log("Tao bang khong thanh cong!")
        }
        return OK
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  MARK: Dinh nghia cac ham APIs cua CSDL
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Them nguoi dung vao co so du lieu
    func insertUser(user:User)->Bool{
        var OK = false
        if open(){
            // Kiem tra su ton tai cua bang du lieu
            if database!.tableExists(USER_TABLE_NAME){
                // Cau lenh SQL them vao CSDL
                let sql = "INSERT INTO \(USER_TABLE_NAME) (\(USER_NAME), \(USER_GOAL), \(USER_GENDER), \(USER_UNIT), \(USER_WEIGHT), \(USER_WAKEUP_TIME), \(USER_SLEEP_TIME), \(USER_TOTAL_WATER)) VALUES (?,?,?,?,?,?,?,?)"
                // Luu gia tri vao CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [user.name, user.goal, user.gender, user.unit, user.weight, user.wakeUpTime, user.sleepTime, user.totalWater]) {
                    os_log("them user thanh cong")
                    OK = true
                    // Dong CSDL
                    close()
                }
                else{
                    os_log("them user khong thanh cong")
                }
            }
        }
        return OK
    }
    
    //1.Thêm cup vào CSDL
    func insertCup(cup:Cup)->Bool{
        var OK = false
        if open(){
            if database!.tableExists(CUP_TABLE_NAME){
                let sql = "INSERT INTO \(CUP_TABLE_NAME) (\(CUP_IMAGE), \(CUP_AMOUNT)) VALUES (?,?)"
                // Lưu giá trị vào CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [cup.image, cup.amount]){
                    os_log("Đã thêm cup thành công.")
                    OK = true
                    close()
                }
                else{
                    os_log("Đã thêm cup thất bại!!!")
                }
            }
        }
        return OK
    }
    // 2. Đọc tất cả cups
    func readCup() -> [Cup]? {
        var cups = [Cup]()
        if open() {
            if database!.tableExists(CUP_TABLE_NAME) {
                let sql = "SELECT * FROM \(CUP_TABLE_NAME)"
                if let results = database!.executeQuery(sql, withArgumentsIn: []) {
                    while results.next() {
                        let id = Int(results.int(forColumn: CUP_ID))
                        let image = results.string(forColumn: CUP_IMAGE) ?? ""
                        let amount = results.double(forColumn: CUP_AMOUNT)
                        let cup = Cup(id: id, image: image, amount: amount)
                        cups.append(cup)
                    }
                    close()
                    return cups
                } else {
                    os_log("Lấy dữ liệu cups thất bại!!!")
                }
            }
            close()
        }
        return nil
    }
    
    // 3. Xóa cup theo id
    func deleteCup(cupId: Int) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(CUP_TABLE_NAME) {
                let sql = "DELETE FROM \(CUP_TABLE_NAME) WHERE \(CUP_ID) = ?"
                if database!.executeUpdate(sql, withArgumentsIn: [cupId]) {
                    os_log("Đã xoá cup thành công.")
                    OK = true
                    close()
                } else {
                    os_log("Đã xoá cup thất bại!!!")
                }
            }
        }
        return OK
    }
    
    // 4. Cập nhật cup theo id
    func updateCup(cupId: Int, newCup: Cup) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(CUP_TABLE_NAME) {
                let sql = "UPDATE \(CUP_TABLE_NAME) SET \(CUP_IMAGE) = ?, \(CUP_AMOUNT) = ? WHERE \(CUP_ID) = ?"
                if database!.executeUpdate(sql, withArgumentsIn: [newCup.image, newCup.amount, cupId]) {
                    os_log("Cập nhật cup thành công.")
                    OK = true
                    close()
                } else {
                    os_log("Cập nhật cup thất bại!!!")
                }
            }
            close()
        }
        return OK
    }
    
    //1.Thêm drink vào CSDL
    func insertDrink(cup_id:Int, time:String ,date:String)->Bool{
        var OK = false
        if open(){
            if database!.tableExists(DRINK_TABLE_NAME){
                let sql = "INSERT INTO \(DRINK_TABLE_NAME) (\(DRINK_CUP), \(DRINK_TIME) ,\(DRINK_DATE)) VALUES (?,?,?)"
                // Lưu giá trị vào CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [cup_id, time ,date]){
                    os_log("Đã thêm drink thành công.")
                    OK = true
                    close()
                }
                else{
                    os_log("Đã thêm drink thất bại!!!")
                }
            }
        }
        return OK
    }
    // 2. Đọc tất cả drinks
    //Truyen string date theo format "yyyy-MM-dd"
    func readDrinksForDay(forDate date:String) -> [Drink]? {
        var drinks = [Drink]()
        if open() {
            if database!.tableExists(DRINK_TABLE_NAME) {
                let sql = "SELECT \(DRINK_TABLE_NAME).\(DRINK_TIME), \(DRINK_TABLE_NAME).\(DRINK_DATE),"
                + " \(CUP_TABLE_NAME).\(CUP_IMAGE), \(CUP_TABLE_NAME).\(CUP_AMOUNT)"
                + " FROM \(DRINK_TABLE_NAME)"
                + " INNER JOIN \(CUP_TABLE_NAME) ON \(DRINK_TABLE_NAME).\(DRINK_CUP) = \(CUP_TABLE_NAME).\(CUP_ID)"
                + " WHERE DATE(\(DRINK_TABLE_NAME).\(DRINK_DATE)) = ?"
                if let results = database!.executeQuery(sql, withArgumentsIn: [date]) {
                    while results.next() {
                        let date = results.string(forColumn: DRINK_DATE) ?? ""
                        let time = results.string(forColumn: DRINK_TIME) ?? ""
                        let image = results.string(forColumn: CUP_IMAGE) ?? ""
                        let amount = results.double(forColumn: CUP_AMOUNT)
                        let cup = Cup(image: image, amount: amount)
                        let drink = Drink(cup: cup, time: time ,date: date)
                        drinks.append(drink)
                    }
                    close()
                    return drinks
                } else {
                    os_log("Lấy dữ liệu drinks thất bại!!!")
                }
            }
            close()
        }
        return nil
    }
    
    func calculateTotalWaterAmount() -> Double? {
        if open() {
            if database!.tableExists(DRINK_TABLE_NAME) {
                let today = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: today)
                
                let sql = "SELECT SUM(\(CUP_TABLE_NAME).\(CUP_AMOUNT)) AS total_amount"
                + " FROM \(DRINK_TABLE_NAME)"
                + " INNER JOIN \(CUP_TABLE_NAME) ON \(DRINK_TABLE_NAME).\(DRINK_CUP) = \(CUP_TABLE_NAME).\(CUP_ID)"
                + " WHERE DATE(\(DRINK_TABLE_NAME).\(DRINK_DATE)) = ?"
                
                if let results = database!.executeQuery(sql, withArgumentsIn: [dateString]), results.next() {
                    let totalAmount = results.double(forColumn: "total_amount")
                    close()
                    return totalAmount
                } else {
                    os_log("Lấy tổng lượng nước thất bại!!!")
                }
            }
            close()
        }
        return nil
    }
    
}//end class
