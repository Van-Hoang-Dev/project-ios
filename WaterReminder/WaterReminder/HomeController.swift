//
//  HomeController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit
import UserNotifications

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
     @IBOutlet weak var DrinkCollection: UICollectionView!
    
    
    @IBOutlet weak var amoutWaterLabel: UILabel!
    
    @IBOutlet weak var processWater: UIProgressView!
    
    var drinks = [Drink]()

    let notificationCenter = UNUserNotificationCenter.current()
    //Chuoi thoi gian
    let morningString = "19:35"
    let sleepString = "20:30"
    let dao = Database()
    
    override func viewWillAppear(_ animated: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today =  dateFormatter.string(from: Date())
        if let drinks = dao.readDrinksForDay(forDate: today) {
            self.drinks = drinks
            DrinkCollection.reloadData()
        }
        
        let currentTotale = dao.calculateTotalWaterAmount()
        let targetWater = UserDefaultsKey.getTotalWater()
        amoutWaterLabel.text = "\(Int(currentTotale!))/\(Int(targetWater.rounded())) ml"
        processWater.progress = Float(currentTotale! / targetWater)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        drinks.append(Drink(image: "cup1", amount: 200, date: "7:00"))
//        drinks.append(Drink(image: "cup1", amount: 300, date: "8:00"))
//        drinks.append(Drink(image: "cup1", amount: 100, date: "9:00"))
        
        
        DrinkCollection.delegate = self
        DrinkCollection.dataSource = self
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
            
            let gio = Calendar.current.component(.hour, from: waterDate)
            let phut = Calendar.current.component(.minute, from: waterDate)
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseCell = "DrinkCollectionCell"
        let drink = drinks[indexPath.row]
        if let cell = DrinkCollection.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? DrinkCollectionCell {
            cell.image.image = UIImage(named: drink.cup.image)
            let formattedString = String(format: "%.0f", drink.cup.amount) + " ml"
            cell.amout.text = formattedString
            cell.time.text = drink.time
            print("Ngay: \(drink.time)")
            return cell
        }
        fatalError("Khong the tao cell!")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width / 4, height: 128)
    }
}
