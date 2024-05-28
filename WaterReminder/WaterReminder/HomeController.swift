//
//  HomeController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit
import UserNotifications

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var drinkCollection: UICollectionView!
    
    
    @IBOutlet weak var amoutWaterLabel: UILabel!
    
    @IBOutlet weak var processWater: UIProgressView!
    
    var drinks = [Drink]()
    
    let notificationCenter = UNUserNotificationCenter.current()
    //Chuoi thoi gian
    var morningString = UserDefaultsKey.getWakeUpTime() ?? "6:30"
    var sleepString = UserDefaultsKey.getSleepTime() ?? "22:30"
    var durationTime = UserDefaultsKey.getDurationTime()
    var drinkTime:String? = UserDefaultsKey.getDrinkTime()
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
        // Kiểm tra quyền thông báo và tự động đặt thông báo nếu đã được cấp quyền
        morningString = UserDefaultsKey.getWakeUpTime() ?? ""
        sleepString = UserDefaultsKey.getSleepTime() ?? ""
        let durationTime = UserDefaultsKey.getDurationTime()
        drinkTime = UserDefaultsKey.getDrinkTime()
        checkAndScheduleNotifications()
        print("Check it run again: \(drinkTime ?? "")")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinkCollection.delegate = self
        drinkCollection.dataSource = self
        notificationCenter.delegate = self
        
        
    }
    // Hàm này được gọi khi thông báo được nhận và ứng dụng đang mở
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // Xác định cách thông báo sẽ được hiển thị
            // Ở đây, chúng ta chọn hiển thị thông báo trên màn hình
            completionHandler([.banner, .sound, .badge])
        }
    
    
    //Hàm check quyền và tạo thông báo
    func checkAndScheduleNotifications() {
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                //để đảm bảo rằng nó được thực hiện trên luồng chính
                //DispatchQueue.main.async {
                    print("Thong bao doc cho phep!")
                    // Đặt thông báo
                    let notificationEnabled = UserDefaultsKey.getNotification()
                    if notificationEnabled {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
                        let morningDate = self.createDate(from: self.morningString)
                        let sleepDate = self.createDate(from: self.sleepString)
                        
                        print("Morning Date: \(dateFormatter.string(from: morningDate))")
                        print("Sleep Date: \(dateFormatter.string(from: sleepDate))")
                        if let drinkTime = self.drinkTime {
                            let drinkTimeDate = self.createDate(from: drinkTime)
                            print("Drink Date: \(dateFormatter.string(from: drinkTimeDate))")
                            self.scheduleWaterNotification(from: drinkTimeDate, to: sleepDate, duration: self.durationTime)
                        }
                        else {
                            self.scheduleMorningNotification(date: morningDate)
                            self.scheduleWaterNotification(from: morningDate, to: sleepDate, duration: self.durationTime)
                        }
                    }
                    else{
                        
                    }
                }
            }
       //}
    }
    
    //Ham chuyen chuoi sang calender
    func createDate(from timeString: String, currentDate: Date = Date()) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let time = dateFormatter.date(from: timeString) else {
            print("ERR: Không thể chuyển chuỗi thành ngày")
            return currentDate
        }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate) ?? currentDate
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
            cell.image.image = UIImage(named: drink.image)
            // Hiển thị lượng nước và đơn vị
            var formattedString = ""
            if UserDefaultsKey.getUnit() == 0 {
                formattedString = String(format: "%.0f", drink.amount) + " ml"
            }
            else{
                formattedString = String(format: "%.2f", drink.amount) + " oz"
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
        if(UserDefaultsKey.getUnit() == 0){
            amoutWaterLabel.text = "\(Int(currentTotal!))/\(Int(targetWater.rounded())) ml"
        }else {
            amoutWaterLabel.text = "\(Int(currentTotal!))/\(Int(targetWater.rounded())) fl oz"
        }
        
        processWater.progress = Float(currentTotal! / targetWater)
    }
}
