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
    let dao = Database()
    
    var totalDrinks = [Drink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellView()
        setWeekView()
        daysOfWeekCollection.delegate = self
        daysOfWeekCollection.dataSource = self
        
        drinksCollection.delegate = self
        drinksCollection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == daysOfWeekCollection{
            return totalSquares.count
        }else{
            return totalDrinks.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == daysOfWeekCollection {
            let reuseCell = "DayCollectionCell"
            
            if let cell = daysOfWeekCollection.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? DayCollectionCell {
                
                let date = totalSquares[indexPath.item]
                
                cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
                //Luong nuoc cua 1 ngay
                let strDate = formatDate(date: date)
                let totalWaterOfDayDB = dao.calculateTotalWaterAmount(forDate: strDate) ?? 0
                let totalOfDay = Float(totalWaterOfDayDB / UserDefaultsKey.getTotalWater())
                cell.processTargeWater.progress = totalOfDay
                
                if selectedDate == date {
                    //Dat background cho cell
                    cell.backgroundColor = UIColor.systemBlue
                    cell.dayOfMonth.textColor = UIColor.white
                    
                    // Dat au cho process
                    // Màu của phần tiến trình
                    cell.processTargeWater.progressTintColor = UIColor.white
                    // Màu của phần chưa đạt được
                    cell.processTargeWater.trackTintColor = UIColor.systemGray3
                    
                    //Day du lieu theo ngay duoc chon
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let current = dateFormatter.string(from: selectedDate)
                    totalDrinks = Database().readDrinksForDay(forDate: current) ?? []
                    drinksCollection.reloadData()
                }else {
                    cell.backgroundColor = UIColor.white
                    cell.dayOfMonth.textColor = UIColor.black
                    // Màu của phần tiến trình
                    cell.processTargeWater.progressTintColor = UIColor.systemBlue
                    // Màu của phần chưa đạt được
                    cell.processTargeWater.trackTintColor = UIColor.systemGray5
                }
                return cell
            }
            fatalError("ko the tao cell")
        }else if collectionView == drinksCollection{
            let reuseCell = "DrinkCollectionCell"
            
            if let cell = drinksCollection.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? DrinkCollectionCell {
                
                let drink = totalDrinks[indexPath.item]
                
                cell.image.image = UIImage(named: drink.image)
                // Hiển thị lượng nước và đơn vị
                var formattedString = ""
                if UserDefaultsKey.getUnit() == 0 {
                    formattedString = String(format: "%.0f", drink.amount) + " ml"
                }
                else{
                    formattedString = String(format: "%.2f", drink.amount) + " oz"
                }
                cell.amout.text = formattedString
                cell.time.text = drink.time
                
                // Add long press gesture recognizer
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                cell.addGestureRecognizer(longPressGesture)
                
                
                return cell
            }
            else{
                fatalError("ko the tao cell")
            }
        }
        fatalError("ko the tao cell")
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == daysOfWeekCollection{
            selectedDate = totalSquares[indexPath.item]
            daysOfWeekCollection.reloadData()
            let date = formatDate(date: selectedDate)
            totalDrinks = Database().readDrinksForDay(forDate: date) ?? []
            drinksCollection.reloadData()
        }
    }
    
    //Format date
    func formatDate(date:Date)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            if let cell = gesture.view as? DrinkCollectionCell, let indexPath = drinksCollection.indexPath(for: cell) {
                let drink = totalDrinks[indexPath.item]
                let alertController = UIAlertController(title: "Drink Info", message: "You held down on a drink with amount \(drink.amount) at \(drink.time).", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    /*
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     if collectionView == drinksCollection {
     return CGSize(width: collectionView.frame.size.width / 4, height: 128)
     }else {
     return CGSize(width: collectionView.frame.size.width / 7, height: collectionView.frame.size.height)
     }
     }
     */
    
    //order function
    func setCellView(){
        let dayWidth = (daysOfWeekCollection.frame.size.width) / 7
        let dayHeight = (daysOfWeekCollection.frame.size.height)
        
        let flowDayLayout = daysOfWeekCollection.collectionViewLayout as! UICollectionViewFlowLayout
        flowDayLayout.itemSize = CGSize(width: dayWidth, height: dayHeight)
        
        let drinkWidth = (drinksCollection.frame.size.width)/4
        
        let drinkHeight:CGFloat = (drinksCollection.frame.size.width)/2.5
        
        let flowDrinkLayout = drinksCollection.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowDrinkLayout.itemSize = CGSize(width: drinkWidth, height: drinkHeight)
        
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
    
}
