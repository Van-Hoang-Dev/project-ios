//
//  TotalWaterController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit

class TotalWaterController: UIViewController {
    
    
    var user:User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Totle water \(user!  .toString())")
        
    }
    
    
    @IBAction func btnSave(_ sender: UIButton) {
        // Khoi tao doi tuong database
        let dao = Database()
        //Insert user vso database
        let _ = dao.insertUser(user: user!)
        
        // Danh dau lan dau tien vao app
        UserDefaults.standard.set(true, forKey: "isUsedFirstTime")
        
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
