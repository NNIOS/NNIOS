import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class HomeMarketViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var lblMyItem: UILabel!
    @IBOutlet weak var LblPopCat: UILabel!
    @IBOutlet weak var lblAllListing: UILabel!
    @IBOutlet weak var LblWishList: UILabel!
    @IBOutlet weak var LblLatest: UILabel!
    @IBOutlet weak var collectionViewMyEvent: UICollectionView!
    @IBOutlet weak var LatestCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewcategory: UICollectionView!
    @IBOutlet weak var LatestCollectionViewListing: UICollectionView!
    @IBOutlet weak var LatestCollectionViewWishList: UICollectionView!
    
    @IBOutlet weak var collectionViewCategoryTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnMyItems: UIButton!
    @IBOutlet weak var btnWishList: UIButton!
    @IBOutlet weak var btnLatestViewAll: UIButton!
   
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var collectionViewSearch: UICollectionView!
    @IBOutlet weak var searchCollView: UIView!
    @IBOutlet weak var lblLatestTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblPopularTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var MarketFullView: UIView!

    
    var MarketCatData : MarketCatModel?
    var MarketWallData : MarketWallModel?
    var ProductListData : TodaProductListModel?
    var categories = [MarketWallModel]()
    var AllListMarketData : AlllistMarketModel?
    var idD = ""
    var thisWidth:CGFloat = 0
    private let bottomPanelView = BottomPanelView()
    var profileData : ProfileModel?
    var sourceViewController: String?
    var Newid: String? // Set this when navigating from MessageViewController
    var Oid: String?
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.lblMyItem.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.LblPopCat.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.lblAllListing.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.LblWishList.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.LblLatest.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        collectionViewMyEvent.tag = 1
        LatestCollectionView.tag = 2
        collectionViewcategory.tag = 3
        LatestCollectionViewListing.tag = 4
        LatestCollectionViewWishList.tag = 5
        callMarketwalltWebService()
        NetworkMonitor.shared.startMonitoring()
      //  collectionViewMyEvent.isHidden = true // CollectionView ko hide karein
      //  collectionViewMyEvent.da
      //  updateUI()
      //  self.setupBottomPanel()
    }
    
//    func updateUI() {
//        if collectionViewMyEvent.isHidden {
//            topConstraintLblLatest.constant = 10 // Adjust this value as per your UI
//        } else {
//            topConstraintLblLatest.constant = 150 // Original value when collectionView is visible
//        }
//
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionViewMyEvent.delegate = self
        collectionViewMyEvent.dataSource = self
        collectionViewMyEvent.reloadData()
        callMarketwalltWebService()
//        if let selectedIndex = selectedTabIndex {
//               bottomPanelView.updateTabAppearance(selectedIndex: selectedIndex)
//           }

        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(callMarketwalltWebService), userInfo: nil, repeats: true)
           
           if let selectedIndex = selectedTabIndex {
               bottomPanelView.updateTabAppearance(selectedIndex: selectedIndex)
           }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Invalidate the timer when the view disappears to avoid memory leaks
        timer?.invalidate()
        timer = nil
    }
    
    

    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            MarketFullView.backgroundColor = .black
            lblMyItem.textColor = .white
            LblLatest.textColor = .white
            LblPopCat.textColor = .white
            LblWishList.textColor = .white
            lblAllListing.textColor = .white
//            btnMyItems.setTitleColor(.white, for: .normal) // ✅ Correct way
//            btnLatestViewAll.setTitleColor(.white, for: .normal) // ✅ Correct way
//            btnWishList.setTitleColor(.white, for: .normal) // ✅ Correct way
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
          
            MarketFullView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            lblMyItem.textColor = UIColor.secondaryLabel
            LblLatest.textColor = UIColor.secondaryLabel
            LblPopCat.textColor = UIColor.secondaryLabel
            LblWishList.textColor = UIColor.secondaryLabel
            lblAllListing.textColor = UIColor.secondaryLabel
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    private func setupBottomPanel() {
        bottomPanelView.delegate = self
        bottomPanelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomPanelView)

        NSLayoutConstraint.activate([
            bottomPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5), // Moves it downward
            bottomPanelView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    
    @IBAction func btnSearch(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchAllListViewController") as? SearchAllListViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnAddMarket(_ : UIButton) {


        
        if MarketWallData?.verfiedMsg == "User Verification is completed!" {
           
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateMarketViewController") as? CreateMarketViewController else {return}

            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            // Create the alert controller
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            
            // Define font and color attributes
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            
            // Create attributed strings
            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
            let attributedMessage = NSAttributedString(
                string: "You have limited access till verification is complete. We thank you for your patience.",
                attributes: messageAttributes
            )
            
            // Set the title and message of the alert
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            // Add an action to the alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }

       }
    
    @IBAction func btnMyitemViewAll(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyitemsMarketViewController") as? MyitemsMarketViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnLatestViewAll(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "latestListMarketViewController") as? latestListMarketViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnAllLatestViewAll(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllListMarketViewController") as? AllListMarketViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnWishListViewAll(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WishListmarketViewController") as? WishListmarketViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnCategoryViewAll(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllCategoryilViewController") as? AllCategoryilViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewMyEvent {
            let count = MarketWallData?.yourItems?.count ?? 0
            let shouldHide = (count == 0)

            lblMyItem.isHidden = shouldHide
            btnMyItems.isHidden = shouldHide

            UIView.animate(withDuration: 0.3) { // Smooth UI update
                if shouldHide {
                    self.lblLatestTopConstraint.constant = -200 // Move to top
                } else {
                    self.lblLatestTopConstraint.constant = 15 // Original position
                }
                
                // Ensure layout updates immediately
                self.view.layoutIfNeeded()
            }
            
            return count
        }
        else if collectionView == LatestCollectionView {
          //  return MarketWallData?.todayList?.count ?? 0
            
            let count = MarketWallData?.todayList?.count ?? 0
            let shouldHide = (count == 0)

            LblLatest.isHidden = shouldHide
            btnLatestViewAll.isHidden = shouldHide
            
            UIView.animate(withDuration: 0.3) { // Smooth UI update
                if shouldHide {
                    self.lblPopularTopConstraint.constant = -200 // Move to top
                } else {
                    self.lblPopularTopConstraint.constant = 15 // Original position
                }
                
                // Ensure layout updates immediately
                self.view.layoutIfNeeded()
            }
            
            return count
        }
        else if collectionView == collectionViewcategory {
            return MarketWallData?.categories.count ?? 0
        }
        else if collectionView == LatestCollectionViewListing {
            return MarketWallData?.allProductsList?.count ?? 0
        } else {
          //  return MarketWallData?.wishlist?.count ?? 0
            
            let count = MarketWallData?.wishlist?.count ?? 0
            let shouldHide = (count == 0)

            LblWishList.isHidden = shouldHide
            btnWishList.isHidden = shouldHide
            return count
        }
    }



    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewMyEvent
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyItemCollectionViewCell", for: indexPath) as! MyItemCollectionViewCell
            cell.viewItems.layer.shadowColor = UIColor.gray.cgColor
            cell.viewItems.layer.shadowOpacity = 0.5
            cell.viewItems.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewItems.layer.shadowRadius = 5
            cell.viewItems.layer.masksToBounds = false
            cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
          //  cell.LargeImgView.image = imageArray[indexPath.row]
            
            cell.EventLbl.text = MarketWallData?.yourItems![indexPath.row].pTitle
        //    self.lblImgLimit.text = "Max Images: " + (self.EventDetauilData?.eventImgRemainLimit ?? "")
            cell.rsLbl.text = "Rs." + (MarketWallData?.yourItems![indexPath.row].salePrice ?? "")
            cell.DayLbl.text = MarketWallData?.yourItems![indexPath.row].createdTime
            
          //  cell.secttLbl.text = MarketWallData?.yourItems![indexPath.row].neighborhoodName
            let url = URL(string: (MarketWallData?.yourItems![indexPath.row].pImages ?? ""))
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "MarketDefault"))
            
            if MarketWallData?.yourItems![indexPath.row].pStatus == 2 {
                cell.SoldImgView.isHidden = false
               
               
            } else {
               
                cell.SoldImgView.isHidden = true
               
             
            }
            
            cell.DetailCallback = { [self] value in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
               // vc.idD = (MarketWallData?.yourItems?[indexPath.row].id)!
                vc.idD = String(MarketWallData?.yourItems?[indexPath.row].id ?? 0)
             
                self.navigationController?.pushViewController(vc, animated: true)
                
                
    
            }
            
            return cell
        }
        
        else if collectionView == LatestCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestListingCollectionViewCell", for: indexPath) as! LatestListingCollectionViewCell
            cell.viewItems.layer.shadowColor = UIColor.gray.cgColor
            cell.viewItems.layer.shadowOpacity = 0.5
            cell.viewItems.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewItems.layer.shadowRadius = 5
            cell.viewItems.layer.masksToBounds = false
            cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
            
            cell.EventLbl.text = MarketWallData?.todayList![indexPath.row].pTitle
            cell.rsLbl.text = "Rs." + (MarketWallData?.todayList![indexPath.row].salePrice ?? "")
            
          
            let url = URL(string: (MarketWallData?.todayList![indexPath.row].pImages ?? ""))
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "MarketDefault"))
            cell.DayLbl.text = MarketWallData?.todayList![indexPath.row].updatedTime
            
            if MarketWallData?.todayList![indexPath.row].pStatus == 2 {
                cell.SoldImgView.isHidden = false
               
               
            } else {
               
                cell.SoldImgView.isHidden = true
               
             
            }
            
            cell.DetailCallback = { [self] value in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
               // vc.idD = (MarketWallData?.yourItems?[indexPath.row].id)!
                vc.idD = String(MarketWallData?.todayList?[indexPath.row].id ?? 0)
             
                self.navigationController?.pushViewController(vc, animated: true)
                
                
    
            }
           
            
            return cell
        }
        
        else if collectionView == collectionViewcategory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            cell.viewItems.layer.shadowColor = UIColor.gray.cgColor
            cell.viewItems.layer.shadowOpacity = 0.5
            cell.viewItems.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewItems.layer.shadowRadius = 5
            cell.viewItems.layer.masksToBounds = false
            cell.EventLbl.font = UIFont(name: "Montserrat-SemiBold", size: 13)
            cell.EventLbl.text = MarketWallData?.categories[indexPath.row].catTitle
           
            let url = URL(string: (MarketWallData?.categories[indexPath.row].catImage ?? ""))
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "MarketDefault"))
           // cell.DayLbl.text = MarketWallData?.todayList![indexPath.row].updatedTime
            
            cell.DetailCallback = { [self] value in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailViewController")as! CategoryDetailViewController
               // vc.idD = (MarketWallData?.yourItems?[indexPath.row].id)!
                vc.idD = String(MarketWallData?.categories[indexPath.row].id ?? 0)
           //    vc.userName = String(MarketWallData?.categories[indexPath.row].catDescription)
                vc.userName = self.MarketWallData?.categories[indexPath.row].catTitle
                self.navigationController?.pushViewController(vc, animated: true)
                
                
    
            }
            
            return cell
        }
        else if collectionView == LatestCollectionViewListing {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllListingCollectionViewCell", for: indexPath) as! AllListingCollectionViewCell
            cell.viewItems.layer.shadowColor = UIColor.gray.cgColor
            cell.viewItems.layer.shadowOpacity = 0.5
            cell.viewItems.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewItems.layer.shadowRadius = 5
            cell.viewItems.layer.masksToBounds = false
            cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
            
            
            cell.EventLbl.text = MarketWallData?.allProductsList![indexPath.row].pTitle
            cell.rsLbl.text = "Rs." + (MarketWallData?.allProductsList![indexPath.row].salePrice ?? "")
            cell.DayLbl.text = MarketWallData?.allProductsList![indexPath.row].createdTime
            
            if MarketWallData?.allProductsList![indexPath.row].pStatus == 2 {
                cell.SoldImgView.isHidden = false
               
               
            } else {
               
                cell.SoldImgView.isHidden = true
               
             
            }
            
          //  cell.secttLbl.text = MarketWallData?.yourItems![indexPath.row].neighborhoodName
            let url = URL(string: (MarketWallData?.allProductsList![indexPath.row].pImages ?? ""))
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "MarketDefault"))
            
            cell.DetailCallback = { [self] value in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
               // vc.idD = (MarketWallData?.yourItems?[indexPath.row].id)!
                vc.idD = String(MarketWallData?.allProductsList?[indexPath.row].id ?? 0)
             
                self.navigationController?.pushViewController(vc, animated: true)
                
                
    
            }
            
            return cell
        }
        
        else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishListCollectionViewCell", for: indexPath) as! WishListCollectionViewCell
            cell.viewItems.layer.shadowColor = UIColor.gray.cgColor
            cell.viewItems.layer.shadowOpacity = 0.5
            cell.viewItems.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewItems.layer.shadowRadius = 5
            cell.viewItems.layer.masksToBounds = false
            cell.rsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.secttLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            cell.DayLbl.font = UIFont(name: "Montserrat-SemiBold", size: 9)
            
            cell.EventLbl.text = MarketWallData?.wishlist![indexPath.row].pTitle
            cell.rsLbl.text = "Rs." + (MarketWallData?.wishlist![indexPath.row].salePrice ?? "")
            cell.secttLbl.text = MarketWallData?.wishlist![indexPath.row].salePrice
            cell.DayLbl.text = MarketWallData?.wishlist![indexPath.row].createdTime
            let url = URL(string: (MarketWallData?.wishlist![indexPath.row].pImages ?? ""))
            
            
            if MarketWallData?.wishlist![indexPath.row].pStatus == 2 {
                cell.SoldImgView.isHidden = false
               
               
            } else {
               
                cell.SoldImgView.isHidden = true
               
             
            }
            
            cell.profileImgView.kf.indicatorType = .activity
            cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "MarketDefault"))
            
            if MarketWallData?.wishlist?.first?.wishlistStatus == 1 {
                cell.btnWishlist.isHidden = false
               
               
            } else if MarketWallData?.wishlist?.first?.wishlistStatus == 0 {
               
                cell.btnWishlist.isHidden = true
               
             
            }
            
            cell.DetailCallback = { [self] value in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketDetailViewController")as! MarketDetailViewController
               // vc.idD = (MarketWallData?.yourItems?[indexPath.row].id)!
                vc.idD = String(MarketWallData?.wishlist?[indexPath.row].id ?? 0)
             
                self.navigationController?.pushViewController(vc, animated: true)
                
                
    
            }
            
            return cell
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            switch collectionView.tag {
            case 1:
                // Set size for collectionView1 cells
                return CGSize(width: collectionView.frame.width / 2, height: 175)
            case 2:
                // Set size for collectionView2 cells
                return CGSize(width: collectionView.frame.width / 2, height: 175)
                
            case 3:
                // Set size for collectionView2 cells
                return CGSize(width: collectionView.frame.width / 4, height: 100)
            case 4:
                // Set size for collectionView2 cells
                return CGSize(width: collectionView.frame.width / 2, height: 175)
            case 5:
                // Set size for collectionView2 cells
                return CGSize(width: collectionView.frame.width / 2, height: 175)
           
            default:
                return CGSize(width: collectionView.frame.width / 2, height: 175)
            }
        }
    
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let idCr = UserDefaults.standard.string(forKey: "idOther")
       // var dictParams: [String: Any] = [:]

        // Determine parameters based on the source view controller
        let dictParams: [String: Any] = [
            "user_id": id
        ]

        // Call the web service
        WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { data in
            self.profileData = data
            
            // Save data to UserDefaults based on source
            if self.sourceViewController == "MessageViewController" {
                UserDefaults.standard.set(self.profileData?.id, forKey: "idOther")
            } else {
                UserDefaults.standard.set(self.profileData?.emerPhone, forKey: "emer_phone")
                UserDefaults.standard.set(self.profileData?.userpic, forKey: "profileImage")
            }

            completionClosure()
        }
    }
    
    func callMarketcatWebService(_ completionClosure: @escaping () -> ()) {
      
        let dictParams: Dictionary<String, Any> = ["":""]
                                                                    
      WebService.sharedInstance.callMarketcatWebService(withParams: dictParams) { data in
        self.MarketCatData = data
        completionClosure()
      }
    }
    
    

    func callAllMarketWallWebService(_ completionClosure: @escaping () -> ()) {
        // Get the user ID from UserDefaults
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""

        // Prepare the dictionary with user_id parameter
        let dictParams: [String: Any] = [
            "user_id": id
        ]

        // Call the web service with the parameters
        WebService.sharedInstance.callAllMarketWallWebService(withParams: dictParams) { data in
            // Store the data returned from the web service
            self.MarketWallData = data

            // Call the completion closure
            completionClosure()
        }
    }
    
    @objc func callMarketwalltWebService() {
                  let url = "https://dev.neighbrsnook.com/admin/api/mpk_home_wall?"

       // let dictParams: Dictionary<String, Any> = ["":""]
        
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "usercr")
          let dictParams: Dictionary<String, Any> = [
                                                    "user_id":id ?? "",
                                                    
                                                   
                                                                        ]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
          switch statusCode {
          case .SUCCESS ,.CREATED:
          do {
              let data = try JSONDecoder().decode(MarketWallModel.self, from: result!)
            self.MarketWallData = data
            self.collectionViewMyEvent.reloadData()
              self.LatestCollectionView.reloadData()
              self.collectionViewcategory.reloadData()
              self.LatestCollectionViewListing.reloadData()
              self.LatestCollectionViewWishList.reloadData()
          //    completionClosure(data)
              } catch {
              print(error.localizedDescription)
              }
          case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
              do {
                  let data = try JSONDecoder().decode(MarketWallModel.self, from: result!)
               //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
                  } catch {
                  print(error.localizedDescription)
                  }
          case .UNAUTHORIZED:
              print(error?.localizedDescription)
       //   self.showLogoutAlert()
          default:
          break
          }
      }
  }
    
    func callProductListWebService(_ completionClosure: @escaping () -> ()) {
        // Get the user ID from UserDefaults
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""

        // Prepare the dictionary with user_id parameter
        let dictParams: [String: Any] = [
            "user_id": id
        ]
                                                                    
      WebService.sharedInstance.callProductListWebService(withParams: dictParams) { data in
        self.ProductListData = data
        completionClosure()
      }

            // Call the completion closure
            completionClosure()
        }
    

    }
