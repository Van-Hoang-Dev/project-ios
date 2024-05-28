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
    // 1.Bang cups.
    private let CUP_TABLE_NAME = "cups"
    private let CUP_ID = "id"
    private let CUP_IMAGE = "image"
    private let CUP_AMOUNT = "amount_water"
    
    // 2.Bang drink.
    private let DRINK_TABLE_NAME = "drinks"
    private let DRINK_ID = "id"
    private let DRINK_IMAGE = "image"
    private let DRINK_AMOUNT = "amount"
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
            let sql_create_cups = "CREATE TABLE \(CUP_TABLE_NAME) ("
            + "\(CUP_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(CUP_AMOUNT) DOUBLE, "
            + "\(CUP_IMAGE) TEXT)"
            
            let sql_create_drinks = "CREATE TABLE \(DRINK_TABLE_NAME) ("
            + "\(DRINK_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(DRINK_IMAGE) STRING, "
            + "\(DRINK_AMOUNT) DOUBLE, "
            + "\(DRINK_TIME) TEXT, "
            + "\(DRINK_DATE) TEXT)"
            
            //Kiem tra bang da duoc tao hay chua
            if open() {
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
                
                // Xóa các drink liên quan đến cupId
                // Xóa các cup
                let sql = "DELETE FROM \(CUP_TABLE_NAME) WHERE \(CUP_ID) = ?"
                if database!.executeUpdate(sql, withArgumentsIn: [cupId]) {
                    os_log("Đã xoá cup thành công.")
                    OK = true
                } else {
                    os_log("Đã xoá cup thất bại!!!")
                }
                
            }
            close()
        }
        return OK
    }
    
    // 4. Cập nhật lương nươc khi thay đổi theo đơn vị
    func updateAmountOfCup(cupId: Int, newAmount:Double) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(CUP_TABLE_NAME) {
                
                let sql = "UPDATE \(CUP_TABLE_NAME) SET \(CUP_AMOUNT) = ? WHERE \(CUP_ID) = ?"
                if database!.executeUpdate(sql, withArgumentsIn: [newAmount, cupId]) {
                    os_log("Cập nhật dữ liệu theo đơn vị thành công.")
                    OK = true
                    close()
                } else {
                    os_log("Cập nhật dữ liệu theo đơn vị thất bại!!!")
                }
            }
            close()
        }
        return OK
    }
    func updateCup(cup:Cup)->Bool{
        var OK = false
        if open() {
            if database!.tableExists(CUP_TABLE_NAME) {
                
                let sql = "UPDATE \(CUP_TABLE_NAME) SET \(CUP_AMOUNT) = ? ,\(CUP_IMAGE) = ? WHERE \(CUP_ID) = ?"
                if database!.executeUpdate(sql, withArgumentsIn: [cup.amount, cup.image, cup.id]) {
                    os_log("Cập nhật dữ liệu thành công.")
                    OK = true
                    close()
                } else {
                    os_log("Cập nhật dữ liệu thất bại!!!")
                }
            }
            close()
        }
        return OK
    }
    //1.Thêm drink vào CSDL
    func insertDrink(cup:Cup, time:String ,date:String)->Bool{
        var OK = false
        if open(){
            if database!.tableExists(DRINK_TABLE_NAME){
                let sql = "INSERT INTO \(DRINK_TABLE_NAME) (\(DRINK_IMAGE), \(DRINK_AMOUNT), \(DRINK_TIME) ,\(DRINK_DATE)) VALUES (?,?,?,?)"
                // Lưu giá trị vào CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [cup.image, cup.amount, time ,date]){
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
    // 2. Đọc tất cả drinks theo ngay
    //Truyen string date theo format "yyyy-MM-dd"
    func readDrinksForDay(forDate date:String) -> [Drink]? {
        var drinks = [Drink]()
        if open() {
            if database!.tableExists(DRINK_TABLE_NAME) {
                let sql = "SELECT * FROM \(DRINK_TABLE_NAME) WHERE DATE(\(DRINK_TABLE_NAME).\(DRINK_DATE)) = ?"
                if let results = database!.executeQuery(sql, withArgumentsIn: [date]) {
                    while results.next() {
                        let id = results.int(forColumn: DRINK_ID)
                        let date = results.string(forColumn: DRINK_DATE) ?? ""
                        let time = results.string(forColumn: DRINK_TIME) ?? ""
                        let image = results.string(forColumn: DRINK_IMAGE) ?? ""
                        let amount = results.double(forColumn: DRINK_AMOUNT)
                        let drink = Drink(id: Int(id), image: image, amount: amount, time: time, date: date)
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
    
    //Ham xoa nuoc da uong
    func deleteDrink(drinkId:Int)->Bool {
        var OK = false
        if open() {
            if database!.tableExists(DRINK_TABLE_NAME) {
                let sql = "DELETE FROM \(DRINK_TABLE_NAME) WHERE \(DRINK_ID) = ?"
                if database!.executeUpdate(sql, withArgumentsIn: [drinkId]) {
                    os_log("Đã xoá drink thành công.")
                    OK = true
                } else {
                    os_log("Đã xoá drink thất bại!!!")
                }
            }
            close()
        }
        return OK
    }
    
    //Lay tonh luong nuoc duoc them vao CSDL
    func calculateTotalWaterAmount(forDate date:String) -> Double? {
        if open() {
            if database!.tableExists(DRINK_TABLE_NAME) {
                
                let sql = "SELECT SUM(\(DRINK_TABLE_NAME).\(DRINK_AMOUNT)) AS total_amount"
                + " FROM \(DRINK_TABLE_NAME)"
                + " WHERE DATE(\(DRINK_TABLE_NAME).\(DRINK_DATE)) = ?"
                
                if let results = database!.executeQuery(sql, withArgumentsIn: [date]), results.next() {
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
    //lay tat ca luong nuoc
    func readDrinks()->[Drink]? {
        var drinks = [Drink]()
        if open() {
            if database!.tableExists(DRINK_TABLE_NAME) {
                let sql = "SELECT * FROM \(DRINK_TABLE_NAME)"
                if let results = database!.executeQuery(sql, withArgumentsIn: []) {
                    while results.next() {
                        let id = results.int(forColumn: DRINK_ID)
                        let date = results.string(forColumn: DRINK_DATE) ?? ""
                        let time = results.string(forColumn: DRINK_TIME) ?? ""
                        let image = results.string(forColumn: DRINK_IMAGE) ?? ""
                        let amount = results.double(forColumn: DRINK_AMOUNT)
                        let drink = Drink(id: Int(id), image: image, amount: amount, time: time, date: date)
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
    //cap nhat drinks
    func updateAmountOfDrinks(drinkId: Int, newAmount:Double) -> Bool {
        var OK = false
        if open() {
            if database!.tableExists(DRINK_TABLE_NAME) {
                
                let sql = "UPDATE \(DRINK_TABLE_NAME) SET \(DRINK_AMOUNT) = ? WHERE \(DRINK_ID) = ?"
                if database!.executeUpdate(sql, withArgumentsIn: [newAmount, drinkId]) {
                    os_log("Cập nhật dữ liệu theo đơn vị thành công.")
                    OK = true
                    close()
                } else {
                    os_log("Cập nhật dữ liệu theo đơn vị thất bại!!!")
                }
            }
            close()
        }
        return OK
    }
    
}//end class
