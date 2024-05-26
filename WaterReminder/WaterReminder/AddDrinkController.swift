//
//  AddDrinkController.swift
//  WaterReminder
//
//  Created by khang on 23/05/2024.
//

import UIKit

class AddDrinkController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var cupCollection: UICollectionView!
    
    var cups = [Cup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        cups.append(Cup(image: "cup1", amount: 200))
//        cups.append(Cup(image: "cup1", amount: 300))
//        cups.append(Cup(image: "cup1", amount: 250))
//        
//        cups.append(Cup(image: "cup1", amount: 200))
//        cups.append(Cup(image: "cup1", amount: 300))
//        cups.append(Cup(image: "cup1", amount: 250))
        
        cupCollection.delegate = self
        cupCollection.dataSource = self
        
        // Reload data để hiển thị danh sách cốc đã lưu
        cupCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseCell = "CupCollectionCell"
        let cup = cups[indexPath.row]
        if let cell = cupCollection.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? CupCollectionCell {
            cell.imageCup.image = UIImage(named: cup.image)
            let formattedString = String(format: "%.0f", cup.amount) + " ml"
            cell.labelAmount.text = formattedString
            return cell
        }
        fatalError("Khong the tao cell!")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width / 4, height: 128)
    }
    


}
