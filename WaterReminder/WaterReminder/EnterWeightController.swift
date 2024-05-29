//
//  EnterWeightController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit

class EnterWeightController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtWeight: UITextField!
    
    @IBOutlet weak var btnNext: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
         let title = "Enter your weight in "
        txtWeight.placeholder = UserDefaultsKey.getUnit() == 0 ? title + "kg" : title + "lb"
        
        txtWeight.delegate = self
        txtWeight.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //Cap nhat trang thai button
        updateButtonState()
    }
    
    //MARK: Uy quyen cho TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtWeight.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let weightString = txtWeight.text, let weight = Double(weightString) {
            if (UserDefaultsKey.getUnit() == 0) {
                if(weight >= 20 && weight <= 200){
                    UserDefaultsKey.setValue(weight, .USER_WEIGHT)
                }else {
                    let alert = UIAlertController(title: "Warning", message: "Cân nặng phải từ 20kg đến 200kg", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else {
                if(weight >= 44 && weight <= 440){
                    UserDefaultsKey.setValue(weight, .USER_WEIGHT)
                }else {
                    let alert = UIAlertController(title: "Warning", message: "Cân nặng phải từ 44bl đến 440bl", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
        else {
            print("Không thể chuyển đổi \(String(describing: txtWeight.text)) thành kiểu Double.")
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField){
        updateButtonState()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    //
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? TimePickerController {
//        }
//    }
    
    
    func updateButtonState(){
        if let text = txtWeight.text, !text.isEmpty {
            btnNext.isEnabled = true
        } else {
            btnNext.isEnabled = false
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
