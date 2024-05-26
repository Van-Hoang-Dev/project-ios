//
//  TotalWaterController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit

class TotalWaterController: UIViewController {
    
    
    @IBOutlet weak var lblTotalWater: UILabel!
    var user:User?
    var totalWater:Double = 0.0
    var strUnit = ""
    //kiem tra don vi nguoi dung su dung
    let KG_TO_LB = 0.4535923745
    let ML_TO_FLOZ = 28.41
    override func viewDidLoad() {
        super.viewDidLoad()
        let unit = UserDefaultsKey.getUnit()
        let weight = UserDefaultsKey.getWeight()
        if(unit == 1){
            totalWater = ((weight / KG_TO_LB) / 2) * ML_TO_FLOZ
            strUnit = "ml"
        }else{
            totalWater = weight / 2
            strUnit = "fl oz"
        }
        lblTotalWater.text = "\(Int(totalWater.rounded())) \(strUnit)"
        print("Totle water \(user!  .toString())")
        
    }
    
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        //luu luong nuoc
        UserDefaultsKey.setValue(totalWater, .USER_TOTAL_WATER)
        // Danh dau lan dau tien vao app
        UserDefaultsKey.setValue(true, .USER_ISUSEDFIRSTTIME)
        
        
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
