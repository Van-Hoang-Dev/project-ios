//
//  HomeController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit
import UserNotifications

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var drinkCollection: UICollectionView!
    
    
    @IBOutlet weak var amoutWaterLabel: UILabel!
    
    @IBOutlet weak var processWater: UIProgressView!
    
    var drinks = [Drink]()
    
    let notificationCenter = UNUserNotificationCenter.current()
    //Chuoi thoi gian
    let morningString = UserDefaultsKey.getWakeUpTime() ?? "6:30"
    let sleepString = UserDefaultsKey.getSleepTime() ?? "22:30"
    let durationTime = UserDefaultsKey.getDurationTime()
    let drinkTime = UserDefaultsKey.getDrinkTime() ?? "6:30"
    let dao = Database()
    let today =  Date()
    let reminderString = [
        "🚰 Don't forget to drink water to stay healthy!",
        "💧 A glass of water will make you feel refreshed!",
        "🥤 Have a glass of water to boost your energy!",
        "🚿 Drink water and feel the freshness!",
        "🧊 Keep your body hydrated!",
        "💦 It's time to drink some water, don't skip it!",
        "🍹 A refreshing glass of water is waiting for you!",
        "🌊 Water is life, drink a little more!",
        "🏞️ Stay fresh with a glass of water!",
        "🧃 Your body needs water, keep it hydrated!"
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinkCollection.delegate = self
        drinkCollection.dataSource = self
        // Kiểm tra quyền thông báo và tự động đặt thông báo nếu đã được cấp quyền
        checkAndScheduleNotifications()
        
        
    }
    
    func checkAndScheduleNotifications() {
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                //để đảm bảo rằng nó được thực hiện trên luồng chính
                DispatchQueue.main.sync {
                    print("Thong bao doc cho phep!")
                    // Đặt thông báo
                    let notificationEnabled = UserDefaultsKey.getNotification()
                    if notificationEnabled {
                        // Chuyen chuoi thanh date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        // kiểm tra một điều kiện và yêu cầu một hành động được thực hiện nếu điều kiện không đúng, ngăn việc thực thi phần còn lại của mã trong phạm vi hiện tại.
                        guard let morningTime = dateFormatter.date(from: self.morningString),
                              let sleepTime = dateFormatter.date(from: self.sleepString) else{
                            print("ERR: Không thể chuyển chuỗi thành ngày")
                            return
                        }
                        
                        //Ngay co dinh
                        let currentDate = Date()
                        //Ket hop thoi gian voi ngay
                        let calendar = Calendar.current
                        let morningDate = calendar.date(bySettingHour: calendar.component(.hour, from: morningTime),minute: calendar.component(.minute, from: morningTime),second: 0, of: currentDate) ?? Date()
                        
                        let sleepDate = calendar.date(bySettingHour: calendar.component(.hour, from: sleepTime),minute: calendar.component(.minute, from: sleepTime),second: 0, of: currentDate) ?? Date()
                        
                        print("Morning Date: \(dateFormatter.string(from: morningDate))")
                        print("Sleep Date: \(dateFormatter.string(from: sleepDate))")
                        self.scheduleMorningNotification(date: morningDate)
                        self.scheduleWaterNotification(from: morningDate, to: sleepDate, duration: self.durationTime)
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
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningComp, repeats: false)
        let morningRequest = UNNotificationRequest(identifier: "morning_notification", content: morningContent, trigger: morningTrigger)
        // Thêm thông báo chào buổi sáng
        notificationCenter.add(morningRequest) { error in
            if let error = error {
                print("Error scheduling morning notification: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleWaterNotification (from startDate: Date, to endDate:Date, duration durationValue:Int) {
        print("Thoi gian lap lai: \(durationValue)")
        var waterDate = startDate
        while waterDate < endDate {
    
            let waterContent = UNMutableNotificationContent()
            waterContent.title = "Stay Hydrated!"
            waterContent.body = reminderString.randomElement()!
            print(waterContent.body)
            
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
        let drink = drinks[indexPath.item]
        if let cell = drinkCollection.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? DrinkCollectionCell {
            cell.image.image = UIImage(named: drink.cup.image)
            // Hiển thị lượng nước và đơn vị
            var formattedString = ""
            if UserDefaultsKey.getUnit() == 0 {
                formattedString = String(format: "%.0f", drink.cup.amount) + " ml"
            }
            else{
                formattedString = String(format: "%.2f", drink.cup.amount) + " oz"
            }
            cell.amout.text = formattedString
            cell.time.text = drink.time
            //print("Ngay: \(drink.time)")
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handelLongPress(_:)))
            cell.addGestureRecognizer(longPressGesture)
            return cell
        }
        fatalError("Khong the tao cell!")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width / 4, height: 128)
    }
    
    // Su ly nhan giu de xoa coc nuoc
    @objc func handelLongPress (_ gesture:UILongPressGestureRecognizer) {
        if gesture.state == .began {
            if let cell = gesture.view as? DrinkCollectionCell, let indexPath = drinkCollection.indexPath(for: cell) {
                let time = drinks[indexPath.item].time
                let drinkId = drinks[indexPath.item].id
                let alert = UIAlertController(title: "Delete", message: "You want to delete the water you drank at \(time)?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    if self.dao.deleteDrink(drinkId: drinkId) {
                        self.updateData()
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //Ham hien thi alert
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    //Ham chuyen date thanh chuoi
    func dateToString(date:Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate =  dateFormatter.string(from: date)
        return strDate
        
    }
    
    // MARK: Ham cap nhat du lieu tu database cho home
    func updateData() {
        let strToday =  dateToString(date: today)
        if let drinks = dao.readDrinksForDay(forDate: strToday) {
            self.drinks = drinks
            drinkCollection.reloadData()
        }
        
        let currentTotal = dao.calculateTotalWaterAmount(forDate: strToday)
        let targetWater = UserDefaultsKey.getTotalWater()
        print("Water in database: \(String(currentTotal!))")
        amoutWaterLabel.text = "\(Int(currentTotal!))/\(Int(targetWater.rounded())) ml"
        processWater.progress = Float(currentTotal! / targetWater)
    }
}
