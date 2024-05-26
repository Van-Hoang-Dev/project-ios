//
//  TotalWaterController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit
import UserNotifications

class TotalWaterController: UIViewController {
    
    
    var user:User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Yeu cao cap quyen thong bao cho ung dung
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                UserDefaults.standard.set(true,forKey: "notificationEnabled")
                print("Quyen gui thong bao da duoc cap")
            } else if let error = error {
                print("Lỗi khi yêu cầu quyền gửi thông báo: \(error.localizedDescription)")
            } else {
                print("Quyền gửi thông báo không được cấp.")
            }
        }
        print("Totle water \(user!  .toString())")
        
    }
    
    
    @IBAction func btnSave(_ sender: UIButton) {
        // Khoi tao doi tuong database
        let dao = Database()
        //Insert user vso database
        let _ = dao.insertUser(user: user!)
        
        // Danh dau lan dau tien vao ap
        UserDefaults.standard.set(true, forKey: "isUsedFirstTime")
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
