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
    
    var valueLabel: UILabel!
    
    var genders = [
        "Male", "Female"
    ]
    let integerArray = Array(20...200)
    var decimalArray = [".0", ".1", ".2", ".3", ".4", ".5", ".6", ".7", ".8", ".9"]
    let durationTimeOptions = [5, 10, 15, 30, 60, 120]
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    var selectedRowNum = 0
    var selectedRowNumDecimal = 0
    var numberOfComponents = 1
    var checkTypePicker = ""
    let WEIGHT_PICKER = "weightPicker"
    let GENDER_PICKER = "genderPicker"
    let DURATION_TIME_PICKER = "durationTimePicker"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load trạng thái của công tắc thông báo
        let notificationEnabled = UserDefaults.standard.bool(forKey: "notificationEnabled")
        notificationSwitch.isOn = notificationEnabled
    }
    
    
    @IBAction func notificationSwitchAc(_ sender: UISwitch) {
        // Lưu trạng thái công tắc thông báo
        UserDefaults.standard.set(sender.isOn, forKey: "notificationEnabled")
        
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
            self.selectedRow = genderPicker.selectedRow(inComponent: 0)
            let selected = Array(self.genders)[self.selectedRow]
            let gender = selected
            self.btnPickerGender.setTitle(gender, for: .normal)
            print("Giới Tính: \(gender)")
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
            self.btnPickerWeight.setTitle(weight + " Kg", for: .normal)
            print("Weight: \(weight) kg")
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
        slider.minimumValue = 1000
        slider.maximumValue = 3000
        slider.value = 1500
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
        valueLabel.text = "\(slider.value)"
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
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func targetDrinkChangeValue(_ sender: UISlider){
        let value = Int(sender.value)
        self.valueLabel.text = "\(value)"
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
        
        // Đặt kích thước cho view controller là kích thước của picker view
        //        vc.preferredContentSize = pickerView.frame.size
        
        // Các ràng buộc để căn giữa pickerView trong view controller
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
            let timeValue = String(selected)
            self.btnPickerDuation.setTitle(timeValue, for: .normal)
            print("Duation: \(timeValue)")
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
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
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
