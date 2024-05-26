//
//  SetUnitController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit

class SetUnitController: UIViewController {
    
    var user:User?

    override func viewDidLoad() {
        super.viewDidLoad()

        print(user!.toString())
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnMetType(_ sender: UIButton) {
        // 1 = ml ,m
        UserDefaultsKey.setValue(1, .USER_UNIT)
        user?.unit = 1
    }
    
    
    @IBAction func btnEnglishType(_ sender: UIButton) {
        // 2 = oz, ft
        UserDefaultsKey.setValue(2, .USER_UNIT)
        user?.unit = 2
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EnterWeightController {
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
