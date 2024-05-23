//
//  TotalWaterController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit

class TotalWaterController: UIViewController {
    
    var user:User?
    //khoi tao doi tuong database
    private let dao = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Totle water \(user!  .toString())")
        
        let _ = dao.insertUser(user: user!)
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
