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
    var dao = Database()
    
    override func viewWillAppear(_ animated: Bool) {
        // Reload data để hiển thị danh sách cốc đã lưu
        updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cupCollection.delegate = self
        cupCollection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseCell = "CupCollectionCell"
        let cup = cups[indexPath.row]
        if let cell = cupCollection.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? CupCollectionCell {
            cell.imageCup.image = UIImage(named: cup.image)
            // Hiển thị lượng nước và đơn vị
            var formattedString = ""
            if UserDefaultsKey.getUnit() == 0 {
                formattedString = String(format: "%.0f", cup.amount) + " ml"
            }
            else{
                formattedString = String(format: "%.2f", cup.amount) + " oz"
            }
            cell.labelAmount.text = formattedString
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handelLongPress(_:)))
            cell.addGestureRecognizer(longPressGesture)
            return cell
        }
        fatalError("Khong the tao cell!")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width / 4, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Thuc hien insert coc nuoc vao database
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "HH:mm"
        let now = dateFormatter.string(from: Date())
        UserDefaultsKey.setValue(now, .USER_DRINK_TIME)
//        print("User drink time: \(UserDefaultsKey.getDrinkTime()!)")
//        print("Nay hom nay: \(now)")
        if dao.insertDrink(cup: cups[indexPath.row], time: now ,date: todayDate) {
            //Chuyen ve man hinh truoc do
            navigationController?.popViewController(animated: true)
        }
    }
    
    // Su ly nhan giu de xoa coc nuoc
    @objc func handelLongPress (_ gesture:UILongPressGestureRecognizer) {
        if gesture.state == .began {
            if let cell = gesture.view as? CupCollectionCell, let indexPath = cupCollection.indexPath(for: cell) {
                let amount = "\(cups[indexPath.item].amount)" + (UserDefaultsKey.getUnit() == 0 ? "ml" : "oz")
                let cupId = cups[indexPath.item].id
                let cup = cups[indexPath.item]
                let alert = UIAlertController(title: "Edit", message: "Are you sure you want to delete the \(amount) cup of water?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
                    if self.dao.deleteCup(cupId: cupId) {
                        self.updateData()
                    }
                }))
                alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
                    // Khởi tạo AddCupController từ storyboard
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let addCupVC = storyboard.instantiateViewController(withIdentifier: "AddCupControllerID") as? AddCupController {
                        addCupVC.cup = cup
                        self.navigationController?.pushViewController(addCupVC, animated: true)
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    //Ham lay du lieu tu database
    func updateData() {
        cups = dao.readCup() ?? []
        cupCollection.reloadData()
        for cup in cups {
            print("Cup ID: \(cup.id), Amount: \(cup.amount), Image: \(cup.image)")
        }
    }
    
}
