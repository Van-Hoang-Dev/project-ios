//
//  SelectGoalController.swift
//  WaterReminder
//
//  Created by Nguyen Van Hoang on 22/05/2024.
//

import UIKit

class SelectGoalController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var selectGoalTable: UITableView!
    
    var goals = [String]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reUse = "SelectGoalCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reUse) as? SelectGoalCell {
            cell.goalName.text = goals[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        fatalError("Khong the return cell!")
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Tao du lieu cho goals
        goals.append("Weight loss")
        goals.append("Weight loss")
        selectGoalTable.delegate = self
        selectGoalTable.dataSource = self
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
