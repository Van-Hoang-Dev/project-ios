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
    
    var totalDrinks = [Drink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellView()
        setWeekView()
        daysOfWeekCollection.delegate = self
        daysOfWeekCollection.dataSource = self
        
        
        let drink1 = Drink(image: "cup1", amount: 200, date: "10:00")
        totalDrinks.append(drink1)
        totalDrinks.append(drink1)
        totalDrinks.append(drink1)
        totalDrinks.append(drink1)
        
        drinksCollection.delegate = self
        drinksCollection.dataSource = self
        
        // Do any additional setup after loading the view.
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
        }else if collectionView == drinksCollection{
            let reuseCell = "DrinkCollectionCell"
            
            if let cell = drinksCollection.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? DrinkCollectionCell {
                
                let drink = totalDrinks[indexPath.item]
                
                cell.image.image = UIImage(named: drink.image)
                cell.amout.text = String(drink.amount)
                cell.time.text = drink.date
                
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
        
        let drinkHeight:CGFloat = 128
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
