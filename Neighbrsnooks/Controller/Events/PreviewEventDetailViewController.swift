import UIKit

protocol PreviewEventDetailDelegate: AnyObject {
    func didUpdateSelectedImages(_ updatedImages: [UIImage])
}


class PreviewEventDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
   
    @IBOutlet weak var collectionView: UICollectionView!
    var thisWidth:CGFloat = 0
    var selectedImages: [UIImage] = []
    var images: [UIImage] = []
    weak var delegate: PreviewEventDetailDelegate?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            print("PreviewEventDetailViewController - Images Count: \(images.count)") // Debugging
            self.title = "Selected Images"
            collectionView.clipsToBounds = true
            view.clipsToBounds = true
            self.view.backgroundColor = .black
            collectionView.backgroundColor = .clear
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = .zero
            }
            loadSelectedImages()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData() // Ensure updated images are reflected
    }

    func saveSelectedImages() {
        let imageDataArray = selectedImages.compactMap { $0.pngData() }
        UserDefaults.standard.set(imageDataArray, forKey: "savedImages")
    }

    func loadSelectedImages() {
        if let imageDataArray = UserDefaults.standard.array(forKey: "savedImages") as? [Data] {
            selectedImages = imageDataArray.compactMap { UIImage(data: $0) }
        }
    }

    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    // UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeforePostEventCollectionViewCell", for: indexPath) as! BeforePostEventCollectionViewCell
        cell.profileImgView.image = selectedImages[indexPath.item]
        
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        
        cell.DeleteNewCallback = { [weak self] index in
            self?.didDeleteImage(at: index)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.collectionView.width) / 1
        return CGSize(width: thisWidth, height: 639)
    }
    
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        didDeleteImage(at: index)
    }

    func didDeleteImage(at index: Int) {
        guard index < selectedImages.count else { return }

        // Remove the image from the array
        selectedImages.remove(at: index)

        // Update UserDefaults
        saveSelectedImages()

        // Notify the delegate
        delegate?.didUpdateSelectedImages(selectedImages)

        // Reload the collection view
        collectionView.reloadData()
    }



}
