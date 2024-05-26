//
//  HomeController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var DrinkCollection: UICollectionView!
    
    var drinks = [Drink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drinks.append(Drink(image: "cup1", amount: 200, date: "7:00"))
        drinks.append(Drink(image: "cup1", amount: 300, date: "8:00"))
        drinks.append(Drink(image: "cup1", amount: 100, date: "9:00"))
        
        DrinkCollection.delegate = self
        DrinkCollection.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseCell = "DrinkCell"
        let drink = drinks[indexPath.row]
        if let cell = DrinkCollection.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? DrinkCollectionCell {
            cell.image.image = UIImage(named: drink.image)
            let formattedString = String(format: "%.0f", drink.amount) + " ml"
            cell.amout.text = formattedString
            cell.time.text = drink.date
            return cell
        }
        fatalError("Khong the tao cell!")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width / 4, height: 128)
    }


}
