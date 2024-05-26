import UIKit

class AddCupController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var inputField: UITextField!
    
    var images = ["cup1", "image1", "unit"]
    var selectedImage: String?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollection.delegate = self
        imageCollection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseCell = "ImageCollectionCell"
        let image = images[indexPath.row]
        if let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? ImageCollectionCell {
            cell.image.image = UIImage(named: image)
            cell.layer.borderWidth = (indexPath == selectedIndexPath) ? 2 : 0
            cell.layer.borderColor = (indexPath == selectedIndexPath) ? UIColor.blue.cgColor : nil
            return cell
        }
        fatalError("Khong the tao cell!")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = images[indexPath.row]
        let previousIndexPath = selectedIndexPath
        selectedIndexPath = indexPath
        
        var indexPaths: [IndexPath] = [indexPath]
        if let previous = previousIndexPath {
            indexPaths.append(previous)
        }
        
        collectionView.reloadItems(at: indexPaths)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 4, height: 128)
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        guard let amountText = inputField.text, let amount = Double(amountText), let image = selectedImage else {
            let alert = UIAlertController(title: "Lỗi", message: "Vui lòng nhập đầy đủ thông tin.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let cup = Cup(id: 0, image: image, amount: amount)
                let db = Database()
                
                if db.insertCup(cup: cup) {
                    let alert = UIAlertController(title: "Thành công", message: "Đã lưu dữ liệu thành công.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "showDrinkData", sender: self)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Lỗi", message: "Không thể lưu dữ liệu.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "showDrinkData" {
                    if let destinationVC = segue.destination as? AddDrinkController {
                        destinationVC.cups = Database().readCup() ?? []
                    }
                }
            }

}
