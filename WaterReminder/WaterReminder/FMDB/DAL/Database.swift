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

    
    
    
    
}//end class
