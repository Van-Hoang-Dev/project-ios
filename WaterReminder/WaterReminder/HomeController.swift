//
//  HomeController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit
import UserNotifications

class HomeController: UIViewController {
    
    let notificationCenter = UNUserNotificationCenter.current()
    //Chuoi thoi gian
    let morningString = "19:35"
    let sleepString = "20:30"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Kiểm tra quyền thông báo và tự động đặt thông báo nếu đã được cấp quyền
        checkAndScheduleNotifications()
        
    }
    
    func checkAndScheduleNotifications() {
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                //để đảm bảo rằng nó được thực hiện trên luồng chính
                DispatchQueue.main.sync {
                    // Đặt thông báo
                    let notificationEnabled = UserDefaults.standard.bool(forKey: "notificationEnabled")
                    if notificationEnabled {
                        // Chuyen chuoi thanh date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        // kiểm tra một điều kiện và yêu cầu một hành động được thực hiện nếu điều kiện không đúng, ngăn việc thực thi phần còn lại của mã trong phạm vi hiện tại.
                        guard let morningTime = dateFormatter.date(from: self.morningString),
                              let sleepTime = dateFormatter.date(from: self.sleepString) else{
                            print("ERR: Khong the chuyen chuoi thanh ngay")
                            return
                        }
                        
                        //Ngay co dinh
                        let currentDate = Date()
                        //Ket hop thoi gian voi ngay
                        let calendar = Calendar.current
                        let morningDate = calendar.date(bySettingHour: calendar.component(.hour, from: morningTime),
                                                        minute: calendar.component(.minute, from: morningTime),
                                                        second: 0, of:     currentDate) ?? Date()
                        
                        let sleepDate = calendar.date(bySettingHour: calendar.component(.hour, from: sleepTime),
                                                      minute: calendar.component(.minute, from: sleepTime),
                                                      second: 0, of: currentDate) ?? Date()
                        print("Morning Date: \(dateFormatter.string(from: morningDate))")
                        print("Sleep Date: \(dateFormatter.string(from: sleepDate))")
                        self.scheduleMorningNotification(date: morningDate)
                        self.scheduleWaterNotification(from: morningDate, to: sleepDate, duration: 2)
                    }
                    else{
                        
                    }
                }
            }
        }
    }
    
    func scheduleMorningNotification(date: Date) {
        // Tạo thông báo chào buổi sáng
        let morningContent = UNMutableNotificationContent()
        morningContent.title = "Good morning!"
        morningContent.body = "Rise and shine!"
        let morningComp = Calendar.current.dateComponents([.hour, .minute], from: date)
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningComp, repeats:
                                                            false)
        let morningRequest = UNNotificationRequest(identifier: "morning_notification", content:
                                                    morningContent, trigger: morningTrigger)
        // Thêm thông báo chào buổi sáng
        notificationCenter.add(morningRequest) { error in
            if let error = error {
                print("Error scheduling morning notification: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleWaterNotification (from startDate: Date, to endDate:Date, duration durationValue:Int) {
        var waterDate = startDate
        let waterContent = UNMutableNotificationContent()
        waterContent.title = "Stay Hydrated!"
        waterContent.body = "It's time to drink some water."
        while waterDate < endDate {
            waterDate = Calendar.current.date(byAdding: .minute, value: durationValue, to: waterDate)!
            let waterComp = Calendar.current.dateComponents([.hour, .minute], from: waterDate)
            
            var gio = Calendar.current.component(.hour, from: waterDate)
            var phut = Calendar.current.component(.minute, from: waterDate)
            print("Giờ: \(gio):\(phut)")
            
            
            let waterTrigger = UNCalendarNotificationTrigger(dateMatching: waterComp, repeats: true)
            let waterRequest = UNNotificationRequest(identifier: "water_notofocation_\(waterDate)", content: waterContent, trigger: waterTrigger)
            //Them thong bao nhac nho uong nuoc
            notificationCenter.add(waterRequest) { error in
                if let error = error {
                    print("Error scheduling water notification: \(error.localizedDescription)")
                }
                
            }
        }
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
