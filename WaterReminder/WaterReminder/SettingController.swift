//
//  SettingController.swift
//  WaterReminder
//
//  Created by Nguyen Van Hoang on 22/05/2024.
//

import UIKit

class SettingController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var btnPickerGender: UIButton!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var btnPickerWeight: UIButton!
    
    @IBOutlet weak var btnPickerTargetDrink: UIButton!
    
    @IBOutlet weak var btnPickerDuation: UIButton!
    
    @IBOutlet weak var btnPickerUnit: UIButton!
    
    @IBOutlet weak var wakeUpTime: UIDatePicker!
    
    @IBOutlet weak var sleepTime: UIDatePicker!
    
    var valueLabel: UILabel!
    
    let dao = Database()
    var genders = [
        "Male", "Female"
    ]
    var units = ["kg and ml","lb and oz"];
    let integerArray = Array(20...200)
    var decimalArray = [".0", ".1", ".2", ".3", ".4", ".5", ".6", ".7", ".8", ".9"]
    let durationTimeOptions = [1, 5, 10, 15, 30, 60, 120]
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedRow = UserDefaultsKey.getGender()
    var selectedtUnit = UserDefaultsKey.getUnit()
    var selectedRowNum = Int(UserDefaultsKey.getWeight())
    var selectedRowNumDecimal = 0
    var numberOfComponents = 1
    var checkTypePicker = ""
    let WEIGHT_PICKER = "weightPicker"
    let GENDER_PICKER = "genderPicker"
    let DURATION_TIME_PICKER = "durationTimePicker"
    let Unit_PICKER = "unitPicker"
    let KG_TO_LB = 0.4535923745
    let ML_TO_FLOZ = 28.41
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load trạng thái của công tắc thông báo
        let notificationEnabled = UserDefaultsKey.getNotification()
        notificationSwitch.isOn = notificationEnabled
        
        btnPickerDuation.setTitle(String(UserDefaultsKey.getDurationTime()) + " m", for: .normal)
        
        var formattedString = ""
        if UserDefaultsKey.getUnit() == 0 {
            btnPickerUnit.setTitle(units[0], for: .normal)
            formattedString = String(format: "%.1f", UserDefaultsKey.getWeight())
            btnPickerWeight.setTitle(formattedString + " kg", for: .normal)
            btnPickerTargetDrink.setTitle(String(Int(UserDefaultsKey.getTotalWater().rounded())) + " ml", for: .normal)
        }
        else{
            btnPickerUnit.setTitle(units[1], for: .normal)
            formattedString = String(format: "%.2f", UserDefaultsKey.getWeight())
            btnPickerWeight.setTitle(formattedString + " lb", for: .normal)
            btnPickerTargetDrink.setTitle(String(Int(UserDefaultsKey.getTotalWater().rounded())) + " oz", for: .normal)
        }
        
        if UserDefaultsKey.getGender() == 0 {
            btnPickerGender.setTitle(genders[0], for: .normal)
        }
        else{
            btnPickerGender.setTitle(genders[1], for: .normal)
        }
        
        // Chuỗi thời gian đầu vào
        if let strWakeUpTime = UserDefaultsKey.getWakeUpTime(),
           let strSleepTime = UserDefaultsKey.getSleepTime() {
            // Định dạng DateFormatter để chuyển đổi chuỗi thành Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "H:mm"
            // Chuyển đổi chuỗi thành đối tượng Date
            if let wakeupDate = dateFormatter.date(from: strWakeUpTime),
                let sleepDate = dateFormatter.date(from: strSleepTime) {
                wakeUpTime.setDate(wakeupDate, animated: true)
                sleepTime.setDate(sleepDate, animated: true)
            }
        }
        
    }
    
    
    @IBAction func notificationSwitchAc(_ sender: UISwitch) {
        // Lưu trạng thái công tắc thông báo
        UserDefaultsKey.setValue(sender.isOn, .USER_NOTIFICATION_ENABLED)
        
        if sender.isOn {
            print("Bat thong bao bao")
        }
        else {
            print("Tat thong bao")
        }
    }
    
    // MARK: Gender pop up picker
    @IBAction func genderPopUpPicker(_ sender: UIButton) {
        numberOfComponents = 1
        checkTypePicker = GENDER_PICKER
        // Khởi tạo 1 viewComtroller mới
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let genderPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        genderPicker.dataSource = self
        genderPicker.delegate = self
        
        genderPicker.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(genderPicker)
        
        // Đặt kích thước cho view controller là kích thước của picker view
        //        vc.preferredContentSize = pickerView.frame.size
        
        // Các ràng buộc để căn giữa pickerView trong view controller
        genderPicker.translatesAutoresizingMaskIntoConstraints = false
        genderPicker.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        genderPicker.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        //Khoi tao 1 alert
        let alert = UIAlertController(title: "Select gender", message: nil, preferredStyle: .actionSheet)
        
        // Đặt popover để hiển thị từ button
        alert.popoverPresentationController?.sourceView = btnPickerGender
        alert.popoverPresentationController?.sourceRect = btnPickerGender.bounds
        
        // Đặt view controller tùy chỉnh làm nội dung của alert
        alert.setValue(vc, forKey: "contentViewController")
        
        // Thêm các action vào alert
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (action) in
            let conformAlert = UIAlertController(title: "Change Gender", message: "Do you want to change?", preferredStyle: .alert)
            conformAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.selectedRow = genderPicker.selectedRow(inComponent: 0)
                let selected = Array(self.genders)[self.selectedRow]
                let gender = selected
                UserDefaultsKey.setValue(self.selectedRow, .USER_GENDER)
                self.btnPickerGender.setTitle(gender, for: .normal)
            }))
            
            conformAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(conformAlert, animated: true)
        
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: Weight pop up picker
    @IBAction func weightPopUpPicker(_ sender: UIButton) {
        numberOfComponents = 2
        checkTypePicker = WEIGHT_PICKER
        //Khoi tao 1 viewController
        let vc = ViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let weightPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        weightPicker.dataSource = self
        weightPicker.delegate = self
        
        weightPicker.selectRow(selectedRowNum, inComponent: 0, animated: false)
        weightPicker.selectRow(selectedRowNumDecimal, inComponent: 1, animated: false)
        
        vc.view.addSubview(weightPicker)
        weightPicker.translatesAutoresizingMaskIntoConstraints = false
        weightPicker.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        weightPicker.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        //Khoi tao alert
        let alert = UIAlertController(title: "Select weight", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = btnPickerWeight
        alert.popoverPresentationController?.sourceRect = btnPickerWeight.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        
        // Thêm các action vào alert
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (action) in
            self.selectedRowNum = weightPicker.selectedRow(inComponent: 0)
            self.selectedRowNumDecimal = weightPicker.selectedRow(inComponent: 1)
            
            let weight = String(self.integerArray[self.selectedRowNum]) + self.decimalArray[self.selectedRowNumDecimal]
            if UserDefaultsKey.getUnit() == 0 {
                self.btnPickerWeight.setTitle(weight + " kg", for: .normal)
            }
            else{
                self.btnPickerWeight.setTitle(weight + " lb", for: .normal)
            }
            UserDefaultsKey.setValue(Double(weight), .USER_WEIGHT)
            print(UserDefaultsKey.getWeight())
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: target drink picker
    @IBAction func targetDrinkPopUpPicker(_ sender: UIButton) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let slider = UISlider(frame: CGRect(x: 0, y: 0 , width: screenWidth, height: screenHeight))
        if UserDefaultsKey.getUnit() == 0 {
            slider.minimumValue = 1000
            slider.maximumValue = 3000
        }
        else{
            slider.minimumValue = Float(1000 / ML_TO_FLOZ)
            slider.maximumValue = Float(3000 / ML_TO_FLOZ)
        }
        
        
        slider.value = Float(UserDefaultsKey.getTotalWater())
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(self.targetDrinkChangeValue(_:)), for: .valueChanged)
        
        vc.view.addSubview(slider)

        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16), // Adjust leading space as needed
            slider.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16), // Adjust trailing space as needed
            slider.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])
        
        // Initialize label to show slider value
        valueLabel = UILabel()
        vc.view.addSubview(valueLabel)
        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        var formattedString = ""
        if UserDefaultsKey.getUnit() == 0 {
            formattedString = String(format: "%.0f", slider.value) + " ml"
        }
        else{
            formattedString = String(format: "%.2f", slider.value) + " oz"
        }
        valueLabel.text = formattedString
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add constraints for the label
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -80)
        ])
        
        //Khoi tao alert
        let alert = UIAlertController(title: "Select Target", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = btnPickerWeight
        alert.popoverPresentationController?.sourceRect = btnPickerWeight.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        
        // Thêm các action vào alert
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (action) in
            self.btnPickerTargetDrink.setTitle(self.valueLabel.text!, for: .normal)
            UserDefaultsKey.setValue(slider.value, .USER_TOTAL_WATER)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func targetDrinkChangeValue(_ sender: UISlider){
        let value = sender.value
        var formattedString = ""
        if UserDefaultsKey.getUnit() == 0 {
            formattedString = String(format: "%.0f", value) + " ml"
        }
        else{
            formattedString = String(format: "%.2f",  value) + " oz"
        }
        self.valueLabel.text = formattedString
        print("Target drink: \(value)")
    }
    
    // MARK: Duation time reapeat notification
    
    @IBAction func durationTimePopUpPicker(_ sender: UIButton) {
        numberOfComponents = 1
        checkTypePicker = DURATION_TIME_PICKER
        // Khởi tạo 1 viewComtroller mới
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let durationTimePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        durationTimePicker.dataSource = self
        durationTimePicker.delegate = self
        
        durationTimePicker.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(durationTimePicker)

        durationTimePicker.translatesAutoresizingMaskIntoConstraints = false
        durationTimePicker.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        durationTimePicker.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        //Khoi tao 1 alert
        let alert = UIAlertController(title: "Select gender", message: nil, preferredStyle: .actionSheet)
        
        // Đặt popover để hiển thị từ button
        alert.popoverPresentationController?.sourceView = btnPickerGender
        alert.popoverPresentationController?.sourceRect = btnPickerGender.bounds
        
        // Đặt view controller tùy chỉnh làm nội dung của alert
        alert.setValue(vc, forKey: "contentViewController")
        
        // Thêm các action vào alert
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (action) in
            self.selectedRow = durationTimePicker.selectedRow(inComponent: 0)
            let selected = self.durationTimeOptions[self.selectedRow]
            let timeValue = String(selected) + "m"
            UserDefaultsKey.setValue(selected, .USER_DURATION_TIME)
            self.btnPickerDuation.setTitle(timeValue, for: .normal)
            print("Duation: \(timeValue)")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Unit picker
    
    @IBAction func unitPopUpPicker(_ sender: UIButton) {
        numberOfComponents = 1
        checkTypePicker = Unit_PICKER
        // Khởi tạo 1 viewComtroller mới
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let unitPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        unitPicker.dataSource = self
        unitPicker.delegate = self
        
        unitPicker.selectRow(selectedtUnit, inComponent: 0, animated: false)
        
        vc.view.addSubview(unitPicker)
        
        // Các ràng buộc để căn giữa pickerView trong view controller
        unitPicker.translatesAutoresizingMaskIntoConstraints = false
        unitPicker.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        unitPicker.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        //Khoi tao 1 alert
        let alert = UIAlertController(title: "Select unit", message: nil, preferredStyle: .actionSheet)
        
        // Đặt popover để hiển thị từ button
        alert.popoverPresentationController?.sourceView = btnPickerGender
        alert.popoverPresentationController?.sourceRect = btnPickerGender.bounds
        
        // Đặt view controller tùy chỉnh làm nội dung của alert
        alert.setValue(vc, forKey: "contentViewController")
        
        // Thêm các action vào alert
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (action) in
            let conformAlert = UIAlertController(title: "Change Unit", message: "Do you want to change the unit?", preferredStyle: .alert)
            conformAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.selectedtUnit = unitPicker.selectedRow(inComponent: 0)
                //Kiem tra don vi nguoi dung lay
                if self.selectedtUnit == 1 && UserDefaultsKey.getUnit() == 0 {
                    //Chuyen tu kg sang lb
                    self.changeKg_MLToLB_OZ()
                }
                if self.selectedtUnit == 0 && UserDefaultsKey.getUnit() == 1 {
                    //Chuyen tu lb sang kg
                    self.changeLB_OZToKG_ML()
                    
                }
                let selected = self.units[self.selectedtUnit]
                UserDefaultsKey.setValue(self.selectedtUnit, .USER_UNIT)
                self.btnPickerUnit.setTitle(selected, for: .normal)
            }))
            
            conformAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(conformAlert, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.sizeToFit()
        
        if checkTypePicker == GENDER_PICKER {
            label.text = genders[row]
        }
        else if checkTypePicker == WEIGHT_PICKER{
            if component == 0 {
                label.text = String(integerArray[row])
            } else {
                label.text = decimalArray[row]
            }
        }
        else if checkTypePicker == DURATION_TIME_PICKER {
            label.text = String(durationTimeOptions[row]) + " minute"
        }
        else if checkTypePicker == Unit_PICKER {
            label.text = units[row]
        }
        
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if checkTypePicker == GENDER_PICKER {
            return genders.count
        }
        else if checkTypePicker == WEIGHT_PICKER {
            if component == 0 {
                return integerArray.count
            } else {
                return decimalArray.count
            }
        }
        else if checkTypePicker == DURATION_TIME_PICKER{
            return durationTimeOptions.count
        }
        else if checkTypePicker == Unit_PICKER{
            return units.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    //MARK: Time Picker
    
    @IBAction func setWakeUp(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: sender.date)
        let minute = calendar.component(.minute, from: sender.date)
        let strWakeupTime = "\(hour):\(minute)"
        UserDefaultsKey.setValue(strWakeupTime, .USER_WAKEUP_TIME)
        
    }//end setwakeup
    
    @IBAction func setSleep(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: sender.date)
        let minute = calendar.component(.minute, from: sender.date)
        let strSleepTime = "\(hour):\(minute)"
        UserDefaultsKey.setValue(strSleepTime, .USER_SLEEP_TIME)
    }
    
    //MARK: Chuyen doi don vi
    
    //Ham chuyen luong nuoc va can nang tu kg, ml sang lb, oz
    func changeKg_MLToLB_OZ () {
        //Chuyen tu kg sang lb
        print("Can nang: \(UserDefaultsKey.getWeight())")
        let weight = UserDefaultsKey.getWeight() / self.KG_TO_LB
        let totalDrink = UserDefaultsKey.getTotalWater() / ML_TO_FLOZ
        btnPickerWeight.setTitle(String(Int(weight.rounded())) + " lb", for: .normal)
        btnPickerTargetDrink.setTitle(String(Int(totalDrink.rounded())) + " oz", for: .normal)
        //Thay doi trong local
        UserDefaultsKey.setValue(weight, .USER_WEIGHT)
        UserDefaultsKey.setValue(totalDrink, .USER_TOTAL_WATER)
        
        //Thay doi trong database
        let cups = dao.readCup() ?? []
        for cup in cups {
            cup.amount = cup.amount / ML_TO_FLOZ
            let _ = dao.updateAmountOfCup(cupId: cup.id, newAmount: cup.amount)
        }
        let drinks = dao.readDrinks() ?? []
        for drink in drinks {
            drink.amount = drink.amount / ML_TO_FLOZ
            let _ = dao.updateAmountOfDrinks(drinkId: drink.id, newAmount: drink.amount)
        }
        
    }
    
    //Ham chuyen luong nuoc va can nang lb, oz sang kg, ml
    func changeLB_OZToKG_ML () {
        //Chuyen tu kg sang lb
        print("Can nang: \(UserDefaultsKey.getWeight())")
        let weight = UserDefaultsKey.getWeight() * self.KG_TO_LB
        let totalDrink = UserDefaultsKey.getTotalWater() * ML_TO_FLOZ
        btnPickerWeight.setTitle(String(Int(weight.rounded())) + " kg", for: .normal)
        btnPickerTargetDrink.setTitle(String(Int(totalDrink.rounded())) + " ml", for: .normal)
        //Thay doi trong local
        UserDefaultsKey.setValue(weight, .USER_WEIGHT)
        UserDefaultsKey.setValue(totalDrink, .USER_TOTAL_WATER)
        
        //Thay doi trong database
        let cups = dao.readCup() ?? []
        for cup in cups {
            cup.amount = cup.amount * ML_TO_FLOZ
            let _ = dao.updateAmountOfCup(cupId: cup.id, newAmount: cup.amount)
        }
        let drinks = dao.readDrinks() ?? []
        for drink in drinks {
            drink.amount = drink.amount * ML_TO_FLOZ
            let _ = dao.updateAmountOfDrinks(drinkId: drink.id, newAmount: drink.amount)
        }
        
    }
    
    
}
