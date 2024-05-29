//
//  TotalWaterController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit
import UserNotifications

class TotalWaterController: UIViewController {
    
    
    @IBOutlet weak var lblTotalWater: UILabel!
    var totalWater:Double = 0.0
    var strUnit = ""
    //kiem tra don vi su dung
    let KG_TO_LB = 0.4535923745
    let ML_TO_FLOZ = 28.41
    override func viewDidLoad() {
        super.viewDidLoad()
        let unit = UserDefaultsKey.getUnit()
        let weight = UserDefaultsKey.getWeight()
        if(unit == 0){
            totalWater = ((weight / KG_TO_LB) / 2) * ML_TO_FLOZ
            strUnit = "ml"
        }else{
            totalWater = weight / 2
            strUnit = "fl oz"
        }
        lblTotalWater.text = "\(Int(totalWater.rounded())) \(strUnit)"
        UserDefaultsKey.setValue(60, .USER_DURATION_TIME)
        //Yeu cao cap quyen thong bao cho ung dung
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                UserDefaults.standard.set(true,forKey: "notificationEnabled")
                print("Quyen gui thong bao da duoc cap")
            } else if let error = error {
                print("Lỗi khi yêu cầu quyền gửi thông báo: \(error.localizedDescription)")
            } else {
                print("Quyền gửi thông báo không được cấp.")
            }
        }
        
    }
    
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        //luu luong nuoc
        UserDefaultsKey.setValue(totalWater, .USER_TOTAL_WATER)
        // Danh dau lan dau tien vao app
        UserDefaultsKey.setValue(true, .USER_ISUSEDFIRSTTIME)
        
        //dan home vao lai nagivation controller
        // Chuyển sang HomeViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let reused = "HomeController"
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: reused) as! HomeController
        let navController = UINavigationController(rootViewController: homeVC)
        
        // Thay đổi root view controller của UIWindow
        if let windowScene = view.window?.windowScene {
            let sceneDelegate = windowScene.delegate as? SceneDelegate
            sceneDelegate?.window?.rootViewController = navController
            UIView.transition(with: sceneDelegate!.window!, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
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
