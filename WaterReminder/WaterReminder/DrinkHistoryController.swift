//
//  DrinkHistoryController.swift
//  WaterReminder
//
//  Created by khang on 26/05/2024.
//

import UIKit

class DrinkHistoryController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var daysOfWeekCollection: UICollectionView!
    
    @IBOutlet weak var drinksCollection: UICollectionView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    
    var totalSquares = [Date]()
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellView()
        setWeekView()
        daysOfWeekCollection.delegate = self
        daysOfWeekCollection.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseCell = "DayCollectionCell"
        
        if let cell = daysOfWeekCollection.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? DayCollectionCell {
            
            let date = totalSquares[indexPath.item]
            
            cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))

            if selectedDate == date {
                cell.backgroundColor = UIColor.systemBlue
                cell.dayOfMonth.textColor = UIColor.white
            }else {
                cell.backgroundColor = UIColor.white
                cell.dayOfMonth.textColor = UIColor.black
            }
            return cell
        }
        fatalError("ko the tao cell")
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = totalSquares[indexPath.item]
        daysOfWeekCollection.reloadData()
    }
    
    //order function
    func setCellView(){
        let width = (daysOfWeekCollection.frame.size.width) / 7
        let height = (daysOfWeekCollection.frame.size.height)
        
        let flowLayout = daysOfWeekCollection.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    func setWeekView(){
        // xoa du lieu cua mang
        totalSquares.removeAll()
        
        var current = CalendarHelper().sundayForDate(date:   selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
        while current < nextSunday {
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
        monthLabel.text = CalendarHelper().monthString(date: selectedDate) + " " + CalendarHelper().yearString(date: selectedDate)
        daysOfWeekCollection.reloadData()
        
    }
    
    
    @IBAction func btnPreviousWeek(_ sender: UIButton) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
        setWeekView()
    }
    
    
    @IBAction func btnNextWeek(_ sender: UIButton) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
        setWeekView()
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
