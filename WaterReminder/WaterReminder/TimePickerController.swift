//
//  TimePickerController.swift
//  WaterReminder
//
//  Created by MAC on 21/5/24.
//

import UIKit

class TimePickerController: UIViewController {

    @IBOutlet weak var wakeUpTime: UIDatePicker!
    @IBOutlet weak var sleepTime: UIDatePicker!
    
    var strWakeupTime:String = "";
    var strSleepTime:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //get wake-up default time
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: wakeUpTime.date)
        var minute = calendar.component(.minute, from: wakeUpTime.date)
        strWakeupTime = "\(hour):\(minute)"
        //get sleep default time
        hour = calendar.component(.hour, from: sleepTime.date)
        minute = calendar.component(.minute, from: sleepTime.date)
        strSleepTime = "\(hour):\(minute)"
        
    }
    @IBAction func setWakeUp(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: sender.date)
        let minute = calendar.component(.minute, from: sender.date)
        strWakeupTime = "\(hour):\(minute)"
        print("\(hour):\(minute)")
        
    }//end setwakeup
    
    @IBAction func setSleep(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: sender.date)
        let minute = calendar.component(.minute, from: sender.date)
        strSleepTime = "\(hour):\(minute)"
        print("\(hour):\(minute)")
    }
    
    @IBAction func timeNextBtn(_ sender: UIButton) {
        UserDefaultsKey.setValue(strWakeupTime, .USER_WAKEUP_TIME)
        UserDefaultsKey.setValue(strSleepTime, .USER_SLEEP_TIME)
    }
    
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? TotalWaterController {
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
