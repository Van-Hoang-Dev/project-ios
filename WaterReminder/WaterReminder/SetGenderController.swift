//
//  SetGenderController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit

class SetGenderController: UIViewController {
    
    
    
    var user:User?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(user!.toString())
        
        // Thiết lập hàm gọi lại cho cả hai nút
        
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func btnMaleAc(_ sender: UIButton) {
        UserDefaultsKey.setValue(0, .USER_GENDER)
        user?.gender = 0
    }
    
    @IBAction func btnFemaleAc(_ sender: UIButton) {
        UserDefaultsKey.setValue(1, .USER_GENDER)
        user?.gender = 1
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SetUnitController {
            vc.user = user!
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
