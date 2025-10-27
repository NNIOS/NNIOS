//
//  AllCategoryilViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 18/09/24.
//

import UIKit

@available(iOS 16.0, *)
class AllCategoryilViewController: BaseViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var collectionViewMyEvent: UICollectionView!
    
    let popularViewModel = CategoryListViewModel()
    var objPopularCategoryData: PopularCategoryResponse?
    var objDecryptPopularCartegory: DecryptPopularCategoryResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCategories()
    }
    
    @IBAction func BackButtionAction(_ : UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Setup & API
extension AllCategoryilViewController {
    func setupUI() {
        collectionViewMyEvent.delegate = self
        collectionViewMyEvent.dataSource = self
        collectionViewMyEvent.tag = 1
        lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
    }
    
    private func fetchCategories() {
        guard Reach().isInternet() else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
            return
        }
        callpopularCategoryApi()
    }
    
    func callpopularCategoryApi() {
        popularViewModel.fetchCategoryListData { [weak self] response in
            guard let self, let encryptedString = response?.data else { return }
            objPopularCategoryData?.data = encryptedString
            decryptPopularCategoryApi(encryptedString: encryptedString)
        }
    }
    
    func decryptPopularCategoryApi(encryptedString: String) {
        popularViewModel.decryptCategoryListData(encryptedString: encryptedString) { [weak self] response in
            guard let self, let decryptedData = response else {
                print("❌ Failed to decrypt poll list data")
                return
            }
            DispatchQueue.main.async {
                self.objDecryptPopularCartegory = decryptedData
                self.collectionViewMyEvent.reloadData()
            }
        }
    }
}

// MARK: - CollectionView
extension AllCategoryilViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        objDecryptPopularCartegory?.data.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyItemCollectionViewCell", for: indexPath) as! MyItemCollectionViewCell
        if let item = objDecryptPopularCartegory?.data.categories[indexPath.row] {
            cell.EventLbl.text = item.name
            cell.EventLbl.font = UIFont(name: "Montserrat-SemiBold", size: 12)
            cell.viewItems.layer.applyShadow(color: .gray,  alpha: 0.5,x: 0, y: 0, blur: 10, spread: 0, cornerRadius: 2)
            ImageLoader.shared.setImage(on: cell.profileImgView, urlString: item.image, placeholder: "MarketDefault")
            cell.DetailCallback = { [weak self] _ in
                guard let self else { return }
                let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryDetailViewController") as! CategoryDetailViewController
                vc.jCatId = item.id
                vc.jCatTitle = item.name
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionViewMyEvent.frame.width / 4 - 8, height: 105)
    }
}
