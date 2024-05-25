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
    
    
    var genders = [
        "Male", "Female"
    ]
    let integerArray = Array(20...200)
    var decimalArray = [".0", ".1", ".2", ".3", ".4", ".5", ".6", ".7", ".8", ".9"]
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectdRow = 0
    var selectedRowNum = 0
    var selectedRowNumDecimal = 0
    var numberOfComponents = 1
    var checkTypePicker = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func notificationSwitchAc(_ sender: UISwitch) {
        if sender.isOn {
            print("Bat thong bao bao")
        }
        else {
            print("Tat thong bao")
        }
    }
    
    //Sua gioi tinh
    @IBAction func genderPopUpPicker(_ sender: UIButton) {
        checkTypePicker = 1
        // Khởi tạo 1 viewComtroller mới
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let genderPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        genderPicker.dataSource = self
        genderPicker.delegate = self
        
        genderPicker.selectRow(selectdRow, inComponent: 0, animated: false)
        
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
            self.selectdRow = genderPicker.selectedRow(inComponent: 0)
            let selected = Array(self.genders)[self.selectdRow]
            let gender = selected
            print("Giới Tính: \(gender)")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func weightPopUpPicker(_ sender: UIButton) {
        numberOfComponents = 2
        checkTypePicker = 2
        //Khoi tao 1 viewController
        let vc = ViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let weightPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        weightPicker.dataSource = self
        weightPicker.delegate = self
        
        weightPicker.selectRow(selectedRowNum, inComponent: 0, animated: false)
        weightPicker.selectRow(selectedRowNumDecimal, inComponent: 1, animated: false)
        
        vc.view.addSubview(weightPicker)
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
            
            print("Weight: \(self.selectedRowNum)\(self.selectedRowNumDecimal)")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func targetDrinkPopUpPicker(_ sender: UIButton) {
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.sizeToFit()
        
        if checkTypePicker == 1 {
            label.text = genders[row]
            print("Gender picker \(genders[row])")
        }
        else if checkTypePicker == 2{
            if component == 0 {
                label.text = String(integerArray[row])
            } else {
                label.text = decimalArray[row]
            }
        }
        
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if checkTypePicker == 1 {
            return genders.count
        }
        else if checkTypePicker == 2 {
            if component == 0 {
                return integerArray.count
            } else {
                return decimalArray.count
            }
        }
        else {
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
