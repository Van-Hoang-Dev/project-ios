//
//  SettingController.swift
//  WaterReminder
//
//  Created by Nguyen Van Hoang on 22/05/2024.
//

import UIKit

class SettingController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var btnPickerGender: UIButton!
    
    var genders = [
        "Male", "Female"
    ]
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectdRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func genderPopUpPicker(_ sender: UIButton) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(selectdRow, inComponent: 0, animated: false)
        vc.view.addSubview(pickerView)

        // Đặt kích thước ưa thích cho view controller là kích thước của picker view
        vc.preferredContentSize = pickerView.frame.size

        // Các ràng buộc để căn giữa pickerView trong view controller
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true

        let alert = UIAlertController(title: "Select gender", message: nil, preferredStyle: .actionSheet)

        // Đặt popover để hiển thị từ button hoặc view khác
        alert.popoverPresentationController?.sourceView = btnPickerGender
        alert.popoverPresentationController?.sourceRect = btnPickerGender.bounds

        // Đặt view controller tùy chỉnh làm nội dung của alert
        alert.setValue(vc, forKey: "contentViewController")

        // Thêm các action vào alert
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (action) in
            self.selectdRow = pickerView.selectedRow(inComponent: 0)
            let selected = Array(self.genders)[self.selectdRow]
            let gender = selected
            print("Giới Tính: \(gender)")
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)

    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        lable.text = Array(genders)[row]
        lable.sizeToFit()
        return lable
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        genders.count
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
