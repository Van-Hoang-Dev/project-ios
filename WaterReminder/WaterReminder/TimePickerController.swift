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
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Time Picker: \(user!.toString())")
        // Do any additional setup after loading the view.
    }
    @IBAction func setWakeUp(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: sender.date)
        let minute = calendar.component(.minute, from: sender.date)
        user?.wakeUpTime = "\(hour):\(minute)"
        print("\(hour):\(minute)")
        
    }//end setwakeup
    
    @IBAction func setSleep(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: sender.date)
        let minute = calendar.component(.minute, from: sender.date)
        user?.sleepTime = "\(hour):\(minute)"
        print("\(hour):\(minute)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TotalWaterController {
            vc.user = user
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
