//
//  EnterNameController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit


class EnterNameController: UIViewController, UITextFieldDelegate {
    //MARK: Field
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var btnNext: UIButton!
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        
        username.delegate = self
        username.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        updateButtonState()
    }
    
    //MARK: Uy quyen cho TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        username.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let username = username.text {
            user.name = username
            print("user.name =\(user.name)")
            print("username =\(username)")
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField){
        updateButtonState()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SelectGoalController {
            vc.user = user
        }
    }
    
    
    func updateButtonState(){
        if let text = username.text, !text.isEmpty {
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
