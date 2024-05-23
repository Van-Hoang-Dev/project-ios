//
//  ChooseController.swift
//  WaterReminder
//
//  Created by chau on 23/05/2024.
//

import UIKit

class ChooseController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var data:[InfoWater] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        data.append(InfoWater(images: "cup1",number: 200))
        data.append(InfoWater(images: "cup1",number: 400))
        print("in thanh cong \(data.count)")
        // Do any additional setup after loading the view.
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
}
extension ChooseController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: "cup1")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width-10)/2
        return CGSize(width: size, height: size)
    }
}
