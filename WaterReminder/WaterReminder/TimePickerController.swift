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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func setWakeUp(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: sender.date)
        let minute = calendar.component(.minute, from: sender.date)
        print("\(hour):\(minute)")
        
    }//end setwakeup
    
    @IBAction func setSleep(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: sender.date)
        let minute = calendar.component(.minute, from: sender.date)
        print("\(hour):\(minute)")
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
