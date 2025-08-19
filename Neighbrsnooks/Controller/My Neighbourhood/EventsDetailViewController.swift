//import UIKit
//import SVProgressHUD
//import Alamofire
//import Photos
//import PhotosUI
//import Kingfisher
//import TOCropViewController  // last updated after lunch
//@available(iOS 16.0, *)
//class EventsDetailViewController: UIViewController , UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, ConfirmEventDelegate, ConfirmNoEventDelegate, ConfirmDeleteEvent, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCollectionViewControllerDelegate, TOCropViewControllerDelegate {
//    
//    func didTapDeleteButton(at index: Int) {
//        
//    }
//    func didDeleteImage(at index: Int) {
//        images.remove(at: index)
//    }
//    
//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    @IBOutlet weak var UserNameLbl: UILabel!
//    @IBOutlet weak var DateLbl: UILabel!
//    @IBOutlet weak var profileImgView : UIImageView!
//    @IBOutlet weak var UserImgView : UIImageView!
//    @IBOutlet weak var TitleLbl: UILabel!
//    @IBOutlet weak var VenueLbl: UILabel!
//    @IBOutlet weak var Add2Lbl: UILabel!
//    @IBOutlet weak var StartDateLbl: UILabel!
//    @IBOutlet weak var EndDateLbl: UILabel!
//    @IBOutlet weak var StartTimeLbl: UILabel!
//    @IBOutlet weak var EndTimeLbl: UILabel!
//    @IBOutlet weak var LikeLbl: UILabel!
//    @IBOutlet weak var EventDetailLbl: UILabel!
//    @IBOutlet weak var StcStartDateLbl: UILabel!
//    @IBOutlet weak var StcEndDateLbl: UILabel!
//    @IBOutlet weak var StcStartTimeLbl: UILabel!
//    @IBOutlet weak var StcEndTimeLbl: UILabel!
//    @IBOutlet weak var HradingTitleLbl: UILabel!
//    @IBOutlet weak var lblImgLimit: UILabel!
//    @IBOutlet weak var LblOwnerPhoto: UILabel!
//    @IBOutlet weak var LblAttendesPhoto: UILabel!
//    @IBOutlet weak var LblVenue: UILabel!
//    
//    @IBOutlet weak var appLbl: UILabel!
//    @IBOutlet weak var DeclLbl: UILabel!
//    @IBOutlet weak var btnUplImg: UIButton!
//    @IBOutlet weak var yesNewView: UIView!
//    @IBOutlet weak var ThumbsImgView : UIImageView!
//    @IBOutlet weak var UploadImgView: UIView!
//    @IBOutlet weak var AttendesCollectionView: UICollectionView!
//    @IBOutlet weak var collectionViewEvent: UICollectionView!
//    @IBOutlet weak var collectionViewEventHeightConst: NSLayoutConstraint!
//    @IBOutlet weak var AttendesCollectionViewHeightConst: NSLayoutConstraint!
//    
//    @IBOutlet weak var eventBGViewHeight: NSLayoutConstraint!
//    
//    @IBOutlet weak var btnyes: UIButton!
//    @IBOutlet weak var btnNo: UIButton!
//    @IBOutlet weak var btnAccpt: UIButton!
//    @IBOutlet weak var btnDec: UIButton!
//    @IBOutlet weak var btnEdit: UIButton!
//    @IBOutlet weak var btnDelete: UIButton!
//    @IBOutlet weak var btnPreview: UIButton!
//    
//    @IBOutlet weak var btnAccptIcon: UIButton!
//    @IBOutlet weak var btnDeclineIcon: UIButton!
//    
//    @IBOutlet weak var eventDescriptionHeight: NSLayoutConstraint!
//    @IBOutlet weak var UploadImgHeight: NSLayoutConstraint!
//    @IBOutlet weak var yesNewViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var uploadImgViewTopConstraint: NSLayoutConstraint! // This is the space between yesNewView &  @IBOutlet weak var uploadImgViewTopConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var LblOwnerPhotoTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imgCountlLbl: UILabel!
//    @IBOutlet weak var EventsBgView: UIView!
//    @IBOutlet weak var btnSeelectPhotos: UIButton!
//    
//    var isYesSelected: Bool {
//        get {
//            return UserDefaults.standard.bool(forKey: "isYesSelected")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "isYesSelected")
//        }
//    }
//    
//    var valueForScroll: Int = 0
//    var eventid = ""
//    var notiid = ""
//    var createdBy: String?
//    
//    
//    var EventDetauilData: EventDetailModel? {
//        didSet {
//            DispatchQueue.main.async {
//                self.collectionViewEvent.reloadData()
//                self.AttendesCollectionView.reloadData()
//            }
//        }
//    }
//    
//    var EventUploadPicData : UploadEventDetailModel?
//    var DelImgData : DeleteImgEventModel?
//    var EventYesData : EventYesJointModel?
//    //    var selection = 1
//    var selection: Int? = 0
//    //  var EventDetauilData : EventDetailModel?
//    var thisWidth:CGFloat = 0
//    var from = 1
//    var imagePicker:UIImagePickerController?
//    var imageArray = [UIImage]()
//    var attendeesArray = [UIImage]()
//    var CamimageArray = [UIImage]()
//    var images: [UIImage] = []
//    var selectedImge: UIImage? = nil
//    var currentImageToCrop: UIImage?
//    var MarketWDeleteData : DelMarketProductModel?
//    var id = UserDefaults.standard.string(forKey: "userid")
//    var idCr = UserDefaults.standard.string(forKey: "usercr")
//    var userImages: [ImageEvent] = []
//    var ownerImages: [ImageEvent] = []
//    var selectedImages: [UIImage] = []
//    func tapConfirm() {
//    }
//    var isEventOwner: Bool = false
//
//    var allImages: [UIImage] {
//        return selectedImages + images
//    }
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        //        updateColors()
//        DispatchQueue.main.async {
//            self.updateNewViewConstraints()
//            self.updateLblOwnerConstraints()
//        }
//        // Animate again to ensure correct layout
//        UIView.animate(withDuration: 0.1) {
//            self.view.layoutIfNeeded()
//        }
//        
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //            updateColors()
//        //        if valueForScroll == 0 {
//        //            scrollView.isScrollEnabled = false
//        //        } else {
//        //            scrollView.isScrollEnabled = true
//        //        }
//        SVProgressHUD.show()
//        UserDefaults.standard.set(eventid, forKey: "eventid")
//        DateLbl.textColor = UIColor.secondaryLabel
//        collectionViewEvent.delegate = self
//        collectionViewEvent.dataSource = self
//        AttendesCollectionView.delegate = self
//        AttendesCollectionView.dataSource = self
//        NetworkMonitor.shared.startMonitoring()
//        self.UserNameLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
//        self.HradingTitleLbl.font = UIFont(name: "Montserrat-Regular", size: 20)
//        self.DateLbl.font = UIFont(name: "Montserrat-Regular", size: 14)
//        self.TitleLbl.font = UIFont(name: "Montserrat-SemiBold", size: 16)
//        self.VenueLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
//        self.LblVenue.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        self.Add2Lbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        self.StartDateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
//        self.EndDateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
//        self.StartTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        
//        self.EndTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        self.LikeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        self.StartTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        self.EventDetailLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        
//        self.StcStartDateLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        self.StcEndDateLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        self.StcStartTimeLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        
//        self.StcEndTimeLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        self.lblImgLimit.font = UIFont(name: "Montserrat-Regular", size: 10)
//        self.LblAttendesPhoto.font = UIFont(name: "Montserrat-Regular", size: 14)
//        self.LblOwnerPhoto.font = UIFont(name: "Montserrat-Regular", size: 14)
//        self.HradingTitleLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
//        btnUplImg.isHidden = true
//        updateYesNoSelectionUI()
//        DispatchQueue.main.async {
//            
//            self.updateNewViewConstraints()
//            self.updateLblOwnerConstraints()
//        }
//        
//        
//        super.viewDidLayoutSubviews()
//        
//        if imgCountlLbl.gestureRecognizers?.isEmpty ?? true {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(previewLabelTapped))
//            imgCountlLbl.isUserInteractionEnabled = true
//            imgCountlLbl.addGestureRecognizer(tapGesture)
//            
//            
//        }
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        SVProgressHUD.show()
//        
//        let selection = UserDefaults.standard.string(forKey: "user_selected_option")
//           if selection == "yes" {
//               setUploadSectionVisibility(true)
//           } else {
//               setUploadSectionVisibility(false)
//           }
//        
//        callEventDetailWebService { [self] in
//            SVProgressHUD.dismiss()
//            
//            // Reload data
//            self.collectionViewEvent.reloadData()
//            self.AttendesCollectionView.reloadData()
//            
//            self.updateNewViewConstraints()
//            self.updateLblOwnerConstraints()
//            
//            // Set labels from API
//            
//            
//            self.UserNameLbl.text = self.EventDetauilData?.createby
//            self.DateLbl.text = self.EventDetauilData?.datetimeandneighbrhood
//            self.TitleLbl.text = self.EventDetauilData?.title
//            self.HradingTitleLbl.text = self.EventDetauilData?.title
//            self.VenueLbl.text = self.EventDetauilData?.addlineone
//            self.Add2Lbl.text = self.EventDetauilData?.addlinetwo
//            self.StartDateLbl.text = self.EventDetauilData?.eventStartDate
//            self.EndDateLbl.text = self.EventDetauilData?.eventEndDate
//            self.StartTimeLbl.text = self.EventDetauilData?.eventStarttime
//            self.EndTimeLbl.text = self.EventDetauilData?.eventEndtime
//            self.LikeLbl.text = self.EventDetauilData?.userlikes
//            self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
//            self.appLbl.text = self.EventDetauilData?.totalJoin
//            self.DeclLbl.text = self.EventDetauilData?.nojoin
//            self.lblImgLimit.text = "Max Images: \(self.EventDetauilData?.eventImgLimit ?? "0")"
//            
//            if let coverImageUrlString = self.EventDetauilData?.coverImage,
//               let coverImageUrl = URL(string: coverImageUrlString) {
//                DispatchQueue.global().async {
//                    if let imageData = try? Data(contentsOf: coverImageUrl) {
//                        let image = UIImage(data: imageData)
//                        DispatchQueue.main.async {
//                            self.profileImgView.image = image
//                        }
//                    }
//                }
//            }
//
//            if self.EventDetauilData?.totalLike == "0" {
//                self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup")
//            } else {
//                self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup.fill")
//            }
//            
//            
//            
//            if let urlU = URL(string: self.EventDetauilData?.userpic ?? "") {
//                self.UserImgView.kf.setImage(with: urlU, placeholder: UIImage(named: "EventImage"))
//            }
//            self.updatePhotoUploadButtonVisibility()
//
//        }
//    }
//    
//    @IBAction func BackButtionAction(_ : UIButton){
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//     
//    
//    func updateNewViewConstraints() {
//        if yesNewView.isHidden {
//            yesNewViewHeightConstraint.constant = 0
//            uploadImgViewTopConstraint.constant = 0 // No gap when hidden
//        } else {
//            yesNewViewHeightConstraint.constant = 60 // Set the original height of yesNewView
//            uploadImgViewTopConstraint.constant = 5  // Maintain a 20-point gap when visible
//        }
//    }
//    
//    func updateLblOwnerConstraints() {
//        if UploadImgView.isHidden {
//            uploadImgViewTopConstraint.constant = 0
//            LblOwnerPhotoTopConstraint.constant = 0 // No gap when hidden
//        } else {
//            uploadImgViewTopConstraint.constant = 5 // Set the original height of yesNewView
//            LblOwnerPhotoTopConstraint.constant = 5  // Maintain a 20-point gap when visible
//        }
//    }
//    
//    @IBAction func PostimgAction(_ sender: UIButton) {
//        print("✅ PostimgAction triggered")
//
//        // 🔴 Check image selection
//        if selectedImages.isEmpty {
//            showAlert(message: "Please select at least one image before uploading.")
//            return
//        }
//
//        // 🔁 Limit check
//        let limit = Int(EventDetauilData?.eventImgLimit ?? "0") ?? 0
//        if selectedImages.count > limit {
//            showAlert(message: "You have already reached maximum \(limit) media limit.")
//            return
//        }
//
//        sender.isEnabled = false
//
//        callEventUploadImgWebService {
//            print("✅ Image uploaded successfully")
//            self.imgCountlLbl.isHidden = true
//
//            // 🔁 Fetch updated event detail
//            self.callEventDetailWebService {
//                print("✅ Event details fetched again")
//
//                // 🔁 Refresh image data sources from updated EventDetauilData
//                self.ownerImages = self.EventDetauilData?.images?.filter { $0.type == "owner" } ?? []
//                self.userImages = self.EventDetauilData?.images?.filter { $0.type == "user" } ?? []
//
//                DispatchQueue.main.async {
//                    // 🔁 Reload collections
//                    self.collectionViewEvent.reloadData()
//                    self.AttendesCollectionView.reloadData()
//
//                    // 🔁 Show/hide based on updated data
//                    self.LblOwnerPhoto.isHidden = self.ownerImages.isEmpty
//                    self.LblAttendesPhoto.isHidden = self.userImages.isEmpty
//
//                    self.collectionViewEvent.isHidden = self.ownerImages.isEmpty
//                    self.AttendesCollectionView.isHidden = self.userImages.isEmpty
//
//                    self.collectionViewEventHeightConst.constant = self.ownerImages.isEmpty ? 0 : 128
//                    self.AttendesCollectionViewHeightConst.constant = self.userImages.isEmpty ? 0 : 128
//
//                    // 🔁 Remove uploaded image from selection
//                    self.selectedImages.removeAll()
//                    sender.isEnabled = true
//                }
//            }
//        }
//    }
//
//    
//    
//    func updateYesNoSelectionUI() {
//        if isYesSelected {
//            UploadImgView.isHidden = false
//            btnyes.backgroundColor = .systemGreen
//            btnNo.backgroundColor = .lightGray
//        } else {
//            UploadImgView.isHidden = true
//            btnyes.backgroundColor = .lightGray
//            btnNo.backgroundColor = .systemRed
//        }
//    }
//
//    func updateImageCollectionViewsVisibility() {
//        let ownerCount = EventDetauilData?.images?.filter { $0.type == "owner" }.count ?? 0
//        let userCount = EventDetauilData?.images?.filter { $0.type == "user" }.count ?? 0
//        collectionViewEventHeightConst.constant = (ownerCount > 0) ? 128 : 0
//        AttendesCollectionViewHeightConst.constant = (userCount > 0) ? 128 : 0
//    }
//    
//    //  self.EventDetauilData?.title
//    @IBAction func btnProfile(_ : UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
//        vc.Oid = EventDetauilData?.userid ?? ""
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @IBAction func imageTapped(_ sender: UIButton) {
//        guard let imageUrl = URL(string: self.EventDetauilData?.coverImage ?? "") else { return }
//        
//        // Instantiate ImageEnlargeViewController
//        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if different
//        if let enlargeVC = storyboard.instantiateViewController(withIdentifier: "EventImageEnlargeViewController") as? EventImageEnlargeViewController {
//            enlargeVC.imageUrl = imageUrl
//            self.navigationController?.pushViewController(enlargeVC, animated: true)
//        }
//    }
//    
//    // Change this code btnyes Irshad malik
//    
//    @IBAction func btnYes(_ sender: UIButton) {
//        saveUserSelection("yes")  // ✅ Save user's choice
//        self.lblImgLimit.isHidden = false
//        setUploadSectionVisibility(true)
//
//        btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
//        btnNo.backgroundColor = #colorLiteral(red: 0.4361207187, green: 0.4361207187, blue: 0.4361207187, alpha: 1)
//        btnyes.setTitleColor(.white, for: .normal)
//        btnNo.setTitleColor(.white, for: .normal)
//
//        SVProgressHUD.show()
//
//        callEventDetailWebService { [self] in
//            SVProgressHUD.dismiss()
//
//            self.selection = 1
//            self.UserNameLbl.text = self.EventDetauilData?.createby
//            self.DateLbl.text = self.EventDetauilData?.datetimeandneighbrhood
//            self.TitleLbl.text = self.EventDetauilData?.title
//            self.HradingTitleLbl.text = self.EventDetauilData?.title
//            self.VenueLbl.text = self.EventDetauilData?.addlineone
//            self.StartDateLbl.text = self.EventDetauilData?.eventStartDate
//            self.EndDateLbl.text = self.EventDetauilData?.eventEndDate
//            self.StartTimeLbl.text = self.EventDetauilData?.eventStarttime
//            self.EndTimeLbl.text = self.EventDetauilData?.eventEndtime
//            self.LikeLbl.text = self.EventDetauilData?.userlikes
//            self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
//            self.appLbl.text = self.EventDetauilData?.totalJoin
//            self.DeclLbl.text = self.EventDetauilData?.nojoin
//
//            let loginUserId = UserDefaults.standard.string(forKey: "userid") ?? ""
//            let eventCreatedById = self.EventDetauilData?.userid ?? ""
//
//            self.UploadImgView.isHidden = false
//
//            self.updateNewViewConstraints()
//            self.updateLblOwnerConstraints()
//
//            let selectedBtnValue = self.EventDetauilData?.userunjoinmemberlist?.compactMap({ Int($0.status ?? "") }).first
//            updateUploadViewBasedOnSelectionAndStatus(selectedBtnValue)
//            self.selection = selectedBtnValue
//
//            if let coverImage = self.EventDetauilData?.coverImage, let url = URL(string: coverImage) {
//                self.profileImgView.kf.indicatorType = .activity
//                self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "EventImage"))
//            }
//
//            if let userPic = self.EventDetauilData?.userpic, let urlU = URL(string: userPic) {
//                self.UserImgView.kf.indicatorType = .activity
//                self.UserImgView.kf.setImage(with: urlU, placeholder: UIImage(named: "EventImage"))
//            }
//
//            self.updatePhotoUploadButtonVisibility()
//        }
//
//        refreshAllEventData(from: "yes")
//    }
//
//    func saveUserSelection(_ value: String) {
//        UserDefaults.standard.setValue(value, forKey: "user_selected_option")
//    }
//
//
//
//    
//    
//    // MARK: - NO Button Clicked
//    @IBAction func btnNo(_ sender: UIButton) {
//        
//        saveUserSelection("no")  // ✅ Save user's choice
//        DispatchQueue.main.async {
//            self.updateNewViewConstraints()
//            self.updateLblOwnerConstraints()
//        }
//        isYesSelected = false
//        setUploadSectionVisibility(false)
//
//        btnyes.backgroundColor = #colorLiteral(red: 0.436, green: 0.436, blue: 0.436, alpha: 1)
//        btnNo.backgroundColor = #colorLiteral(red: 0.749, green: 0.211, blue: 0.047, alpha: 1)
//        btnyes.setTitleColor(.white, for: .normal)
//        btnNo.setTitleColor(.white, for: .normal)
//
//        SVProgressHUD.show()
//        callEventDetailWebService { [self] in
//            SVProgressHUD.dismiss()
//
//            self.selection = 0
//            self.UserNameLbl.text = self.EventDetauilData?.createby
//            self.DateLbl.text = self.EventDetauilData?.datetimeandneighbrhood
//            self.TitleLbl.text = self.EventDetauilData?.title
//            self.HradingTitleLbl.text = self.EventDetauilData?.title
//            self.VenueLbl.text = self.EventDetauilData?.addlineone
//            self.StartDateLbl.text = self.EventDetauilData?.eventStartDate
//            self.EndDateLbl.text = self.EventDetauilData?.eventEndDate
//            self.StartTimeLbl.text = self.EventDetauilData?.eventStarttime
//            self.EndTimeLbl.text = self.EventDetauilData?.eventEndtime
//            self.LikeLbl.text = self.EventDetauilData?.userlikes
//            self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
//            self.appLbl.text = self.EventDetauilData?.totalJoin
//            self.DeclLbl.text = self.EventDetauilData?.nojoin
//
//            self.UploadImgView.isHidden = true
//
//            let selectedBtnValue = self.EventDetauilData?.userunjoinmemberlist?.compactMap({ Int($0.status ?? "") }).first
//            updateUploadViewBasedOnSelectionAndStatus(selectedBtnValue)
//            self.selection = selectedBtnValue
//
//            if let coverImage = self.EventDetauilData?.coverImage, let url = URL(string: coverImage) {
//                self.profileImgView.kf.indicatorType = .activity
//                self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "EventImage"))
//            }
//
//            if let userPic = self.EventDetauilData?.userpic, let urlU = URL(string: userPic) {
//                self.UserImgView.kf.indicatorType = .activity
//                self.UserImgView.kf.setImage(with: urlU, placeholder: UIImage(named: "EventImage"))
//            }
//        }
//
//        refreshAllEventData(from: "no")
//    }
//
//    // MARK: - Hide/Show Upload Image Section
//     
//    func setUploadSectionVisibility(_ visible: Bool) {
//         self.UploadImgView.isHidden = !visible        // 👈 Yeh line UploadImgView show/hide karegi
//         self.collectionViewEvent.isHidden = !visible
//        self.AttendesCollectionView.isHidden = !visible
//        self.LblOwnerPhoto.isHidden = !visible
//        self.LblAttendesPhoto.isHidden = !visible
//
//        self.collectionViewEventHeightConst.constant = visible ? 128 : 0
//        self.AttendesCollectionViewHeightConst.constant = visible ? 128 : 0
//    }
//
//
//    
//    
//    
////    func setUploadSectionVisibility(_ isVisible: Bool) {
////        UploadImgView.isHidden = !isVisible
////        //        collectionViewEvent.isHidden = !isVisible
////        //        AttendesCollectionView.isHidden = !isVisible
////        lblImgLimit.isHidden = !isVisible
////    }
////    
//    
//    
//    private func updateUploadViewBasedOnSelectionAndStatus(_ statusValue: Int?) {
//        guard let status = statusValue else { return }
//        
//        if status == 1 && selection == 1 {
//            setUploadSectionVisibility(true)
//        } else if status == 0 && selection == 0{
//            setUploadSectionVisibility(false)
//        }
//    }
//    
//    
//    
//    
//    @IBAction func btnJoinList(_ : UIButton){
//        
//        
//        
//    }
//    
//    @IBAction func JoinPopUpBtnAction(_ sender: UIButton) {
//        if EventDetauilData?.totalJoin != "0" {
//            let vc = storyboard?.instantiateViewController(withIdentifier:"EventJoinListViewController")as! EventJoinListViewController
//            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            vc.delegate = self
//            vc.eventid = (EventDetauilData?.id)!
//            self.present(vc , animated: true)
//        }
//        
//    }
//    
//    @IBAction func EventJoinLikeListBtnAction(_ sender: UIButton) {
//        if self.EventDetauilData?.totalLike != "0" {
//            let vc = storyboard?.instantiateViewController(withIdentifier:"EventLikeListViewController")as! EventLikeListViewController
//            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            vc.delegate = self
//            vc.eventid = (EventDetauilData?.id)!
//            self.present(vc , animated: true)
//        } else {
//            print("No Likes .")
//        }
//    }
//    
//    
//    @IBAction func btnEdit(_ : UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateEventViewController")as! UpdateEventViewController
//        vc.eventid = (EventDetauilData?.id)!
//        vc.titleLabel = self.EventDetauilData?.title ?? ""
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @IBAction func NoJoinPopUpBtnAction(_ sender: UIButton) {
//        if ((self.EventDetauilData?.userunjoinmemberlist) != nil) != true {
//            let vc = storyboard?.instantiateViewController(withIdentifier:"EventNoJoinViewController")as! EventNoJoinViewController
//            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            vc.delegate = self
//            vc.eventid = (EventDetauilData?.id)!
//            self.present(vc , animated: true)
//        } else {
//            print("No user has not joined yet.")
//        }
//    }
//    
//    @IBAction func DeletePopUpNewBtnAction(_ sender: UIButton) {
//        
//        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
//        
//        // Customizing the message font and size
//        let messageText = "Are you sure you want to remove this event?"
//        let attributedMessage = NSAttributedString(string: messageText, attributes: [
//            .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
//            .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
//        ])
//        alertController.setValue(attributedMessage, forKey: "attributedMessage")
//        
//        // Define RGB Colors
//        let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)  // Green
//        let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)   // Red
//        
//        // Yes Action
//        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
//            self.callEventDeleteListWebService {
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
//        yesAction.setValue(yesColor, forKey: "titleTextColor") // Set Yes button color
//        
//        // No Action
//        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
//        noAction.setValue(noColor, forKey: "titleTextColor")
//        
//        alertController.addAction(yesAction)
//        alertController.addAction(noAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
//    
//    @IBAction func selectPhotos(_ sender: UIButton) {
//        let limit = Int(EventDetauilData?.eventImgRemainLimit ?? "") ?? 0
//        
//        if selectedImages.count >= limit {
//            showAlert(message: "You have already reached maximum limit.")
//            return
//        }
//        
//        
//        checkCameraPermission { [weak self] granted in
//            guard let self = self else { return }
//            if granted {
//                //                openCameraGallery()
//                selectImages() // your image picker method
//                btnUplImg.isHidden = false
//            }
//        }
//        
//    }
//    
//    
//    
//    
//    @IBAction func yesJoin(_ sender: UIButton) {
//        callEventYesjointWebService{}
//    }
//    
//    @IBAction func NoJoin(_ sender: UIButton) {
//        callEventNojointWebService{}
//    }
//    
//    @IBAction func like(_ sender: UIButton) {
//        
//        callEventLikeWebService{ [self] in
//            callEventDetailWebService{ [self] in
//                
//                SVProgressHUD.dismiss()
//                self.collectionViewEvent.reloadData()
//                self.AttendesCollectionView.reloadData()
//                
//                self.LikeLbl.text = self.EventDetauilData?.totalLike
//                
//                if self.EventDetauilData?.totalLike == "0" {
//                    self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup")
//                } else {
//                    self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup.fill")
//                }
//            }
//        }
//    }
//    
//    
//    
//    
//    
//    
//    func showAlert(title: String = "", message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        
//        // ✅ OK button add karein, jo alert ko turant dismiss karega
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            alert.dismiss(animated: true, completion: nil)
//        }))
//        present(alert, animated: true) {
//            
//        }
//    }
//    
//    @objc func selectImages() {
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
//            self.openCamera()
//        }))
//        
//        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
//            self.openGallery()
//        }))
//        
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        
//        present(actionSheet, animated: true, completion: nil)
//    }
//    
//    func openCamera() {
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .camera
//        present(picker, animated: true, completion: nil)
//    }
//    
//    func openGallery() {
//        var config = PHPickerConfiguration()
//        config.selectionLimit = Int(EventDetauilData?.eventImgLimit ?? "") ?? 0
//        config.filter = .images
//        
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = self
//        present(picker, animated: true, completion: nil)
//    }
//    
//    
//    
//    
//    
//    // MARK: - UIImagePickerControllerDelegate
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        picker.dismiss(animated: true) {
//            if let image = info[.originalImage] as? UIImage {
//                self.currentImageToCrop = image
//                self.openCropper(image: image)
//                
//            }
//        }
//    }
//    
//    // MARK: - PHPickerViewControllerDelegate
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
//                if let image = reading as? UIImage {
//                    DispatchQueue.main.async {
//                        self.currentImageToCrop = image
//                        self.openCropper(image: image)
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
//        print("✅ Image cropped successfully")
//        selectedImages.append(image)
//        
//        // ✅ Save to UserDefaults
//        saveSelectedImages()
//        
//        updateMediaCount()
//        cropViewController.dismiss(animated: true, completion: nil)
//    }
//    
//    // MARK: - Crop Delegate
//    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        print("✅ Cropped image received!")
//        selectedImages.append(image)
//        saveSelectedImages()  // ✅ Important!
//        updateMediaCount()
//        cropViewController.dismiss(animated: true, completion: nil)
//    }
//    
//    
//    
//    // MARK: - Open Cropper
//    func openCropper(image: UIImage) {
//        let cropVC = TOCropViewController(image: image)
//        cropVC.delegate = self
//        present(cropVC, animated: true, completion: nil)
//    }
//    
//    func updateMediaCount() {
//        DispatchQueue.main.async {
//            let totalMedia = self.selectedImages.count
//            self.imgCountlLbl.text = "\(totalMedia) previews"
//            self.imgCountlLbl.isHidden = totalMedia == 0
//            self.lblImgLimit.text = " Remaining limit \(self.EventDetauilData?.eventImgRemainLimit ?? "0")"
//        }
//    }
//    
//    
//    
//    // MARK: - Preview Screen
//    @objc func previewLabelTapped() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let previewVC = storyboard.instantiateViewController(withIdentifier: "PreviewEventDetailViewController") as? PreviewEventDetailViewController {
//            
//            print("Selected Images to send: \(selectedImages.count)")
//            
//            // ✅ Pass images
//            previewVC.selectedImages = self.selectedImages
//            
//            // ✅ Remove from UserDefaults if not needed anymore
//            UserDefaults.standard.removeObject(forKey: "savedImages")
//            print("🗑️ Cleared savedImages from UserDefaults on preview open")
//            
//            // ✅ Navigate to preview screen
//            self.navigationController?.pushViewController(previewVC, animated: true)
//        }
//    }
//    
//    
//    
//    
//    func saveSelectedImages() {
//        let imageDataArray = selectedImages.compactMap { $0.pngData() }
//        UserDefaults.standard.set(imageDataArray, forKey: "savedImages")
//    }
//    
//    
//    func refreshAllEventData(from buttonType: String = "yes") {
//        SVProgressHUD.show()
//        
//        callEventDetailWebService { [weak self] in
//            guard let self = self else { return }
//            
//            print("📡 Event Detail loaded")
//            
//            // Status ke hisab se YES/NO call karo
//            if buttonType == "yes" {
//                self.callEventYesjointWebService {
//                    print("✅ YES Join API called")
//                    self.finalizeUIRefresh()
//                }
//            } else if buttonType == "no" {
//                self.callEventNojointWebService {
//                    print("❌ NO Join API called")
//                    self.finalizeUIRefresh()
//                }
//            } else {
//                //                self.finalizeUIRefresh()
//            }
//        }
//    }
//    
//    func finalizeUIRefresh() {
//        DispatchQueue.main.async {
//            SVProgressHUD.dismiss()
//            
//            guard let data = self.EventDetauilData else {
//                print("❌ EventDetauilData missing")
//                return
//            }
//            
//            //            self.setUploadSectionVisibility(true)
//            
//            self.UserNameLbl.text = data.createby
//            self.DateLbl.text = data.datetimeandneighbrhood
//            self.TitleLbl.text = data.title
//            self.HradingTitleLbl.text = data.title
//            self.VenueLbl.text = (data.addlineone ?? "") + (data.addlinetwo ?? "")
//            self.StartDateLbl.text = data.eventStartDate
//            self.EndDateLbl.text = data.eventEndDate
//            self.StartTimeLbl.text = data.eventStarttime
//            self.EndTimeLbl.text = data.eventEndtime
//            self.LikeLbl.text = data.userlikes
//            self.EventDetailLbl.text = data.eventDetail
//            self.appLbl.text = data.totalJoin
//            self.DeclLbl.text = data.nojoin
//            
//            let selectedBtnValue = data.userunjoinmemberlist?.compactMap { Int($0.status ?? "") }.first
//            //            self.updateUploadViewBasedOnSelectionAndStatus(selectedBtnValue)
//            self.selection = selectedBtnValue
//            
//            if let coverImageUrl = URL(string: data.coverImage ?? "") {
//                self.profileImgView.kf.setImage(with: coverImageUrl, placeholder: UIImage(named: "EventImage"))
//            }
//            if let userPicUrl = URL(string: data.userpic ?? "") {
//                self.UserImgView.kf.setImage(with: userPicUrl, placeholder: UIImage(named: "EventImage"))
//            }
//            
//            self.collectionViewEvent.reloadData()
//            self.AttendesCollectionView.reloadData()
//        }
//    }
//    
//    
//    func updatePhotoUploadButtonVisibility() {
//        let loginUserId = UserDefaults.standard.string(forKey: "userid") ?? ""
//        let eventCreatedById = self.EventDetauilData?.userid ?? ""
//        
////        btnSeelectPhotos.isHidden = (loginUserId != eventCreatedById)
//    }
//    
//    
//
//    
//    
//    // Code irshad change
//    func callEventDetailWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let idEvent = UserDefaults.standard.string(forKey: "eventid")
//        
//        let dictParams: [String: Any] = [
//            "userid": id ?? "",
//            "eventid": idEvent ?? ""
//        ]
//        
//        print("📡 Sending params:", dictParams)
//        
//        WebService.sharedInstance.callEventDetailWebService(withParams: dictParams) { data in
//            self.EventDetauilData = data
//            
//            self.ownerImages = self.EventDetauilData?.images?.filter { $0.type == "owner" } ?? []
//            
//            if !self.ownerImages.isEmpty {
//                self.collectionViewEvent.isHidden = false
//                self.collectionViewEventHeightConst.constant = 128
//            } else {
//                self.collectionViewEvent.isHidden = true
//                self.collectionViewEventHeightConst.constant = 0
//            }
//            
//            DispatchQueue.main.async {
//                let loginUserId = UserDefaults.standard.string(forKey: "userid") ?? ""
//                let eventCreatedById = self.EventDetauilData?.userid ?? ""
//                
//                if loginUserId == eventCreatedById {
//                    // ✅ User is event creator
//                    self.UploadImgView.isHidden = false
//                    self.yesNewView.isHidden = true
//                    self.btnEdit.isHidden = false
//                    self.btnDelete.isHidden = false
//                    self.lblImgLimit.isHidden = false
//                    
//                    // 👇 Hide Accept/Decline buttons
//                    self.btnDeclineIcon.isHidden = false
//                    self.btnAccptIcon.isHidden = false
//                    self.btnDec.isHidden = false
//                    self.btnAccpt.isHidden = false
//                    self.appLbl.isHidden = false
//                    self.DeclLbl.isHidden = false
//                } else {
//                    // ✅ User is not the event creator
//                    self.UploadImgView.isHidden = true
//                    self.btnEdit.isHidden = true
//                    self.btnDelete.isHidden = true
//                    self.lblImgLimit.isHidden = true
//
//                    // 👇 Show Accept/Decline buttons
//                    self.btnAccptIcon.isHidden = true
//                    self.btnDeclineIcon.isHidden = true
//                    self.btnDec.isHidden = true
//                    self.btnAccpt.isHidden = true
//                    self.appLbl.isHidden = true
//                    self.DeclLbl.isHidden = true
//                }
//                
//                // Save event and creator ID in UserDefaults
//                UserDefaults.standard.set(self.EventDetauilData?.id, forKey: "eventid")
//                UserDefaults.standard.set(self.EventDetauilData?.userid, forKey: "usercr")
//                
//                completionClosure()
//            }
//            
//            print("✅ API Response received. Event Title: \(data.title ?? "nil")")
//            print("✅ API Response received. Data is  \(data)")
//        }
//    }
//
//    
//    
//    func callEventDeleteListWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let idEvent = UserDefaults.standard.string(forKey: "eventid")
//        let dictParams: Dictionary<String, Any> = [
//            "userid":id ?? "",
//            "e_id": idEvent ?? "",
//            
//        ]
//        WebService.sharedInstance.callEventDeleteListWebService(withParams: dictParams) { data in
//            //   self.GrouDeleteData = data
//            completionClosure()
//        }
//    }
//    
//    
//    
//    func callEventImgDelWebService(for indexPath: IndexPath, completionClosure: @escaping () -> ()) {
//        let idEvent = UserDefaults.standard.string(forKey: "eventid")
//        let id = UserDefaults.standard.string(forKey: "userid")
//        
//        // Filter images where type == "owner"
//        guard let ownerImages = self.EventDetauilData?.images?.filter({ $0.type == "owner" }),
//              indexPath.row < ownerImages.count else {
//            print("No owner images found or index out of bounds.")
//            return
//        }
//        
//        let selectedImage = ownerImages[indexPath.row]
//        
//        // Unwrap and clean the imgid
//        let rawImgId = selectedImage.imgid.flatMap { "\($0)" } ?? ""
//        let imgId: String
//        
//        if rawImgId.hasPrefix("integer(") {
//            imgId = String(rawImgId.dropFirst("integer(".count).dropLast(rawImgId.hasSuffix(")") ? 1 : 0))
//        } else if rawImgId.hasPrefix("string(\"") {
//            imgId = String(rawImgId.dropFirst("string(\"".count).dropLast(rawImgId.hasSuffix("\")") ? 2 : 0))
//        } else {
//            imgId = rawImgId
//        }
//        
//        let imgUrl = selectedImage.img ?? ""
//        
//        let dictParams: [String: Any] = [
//            "userid": id ?? "",
//            "event_id": idEvent ?? "",
//            "owner": id ?? "",
//            "imgid": imgId,
//            "imageurl": imgUrl
//        ]
//        
//        // Print to debug
//        print("dictParams:", dictParams)
//        
//        WebService.sharedInstance.callEventImgDelWebService(withParams: dictParams) { data in
//            self.DelImgData = data
//            
//            // Save values to UserDefaults
//            UserDefaults.standard.set(imgId, forKey: "imgId")
//            UserDefaults.standard.set(imgUrl, forKey: "imgUrl")
//            
//            completionClosure()
//        }
//    }
//    
//    
//    func callEventAttendesImgDelWebService(for indexPath: IndexPath, completionClosure: @escaping () -> ()) {
//        let idEvent = UserDefaults.standard.string(forKey: "eventid")
//        let currentUserId = UserDefaults.standard.string(forKey: "userid") // Your app's logged-in user
//        
//        // Filter images where type == "user"
//        guard let userImages = self.EventDetauilData?.images?.filter({ $0.type == "user" }),
//              indexPath.row < userImages.count else {
//            print("No user images found or index out of bounds.")
//            return
//        }
//        
//        let selectedImage = userImages[indexPath.row]
//        
//        // Extract userid from selectedImage (assuming it has a field for userid)
//        let userIdFromImage = selectedImage.userid ?? ""
//        
//        // Unwrap and clean the imgid
//        let rawImgId = selectedImage.imgid.flatMap { "\($0)" } ?? ""
//        let imgId: String
//        
//        if rawImgId.hasPrefix("integer(") {
//            imgId = String(rawImgId.dropFirst("integer(".count).dropLast(rawImgId.hasSuffix(")") ? 1 : 0))
//        } else if rawImgId.hasPrefix("string(\"") {
//            imgId = String(rawImgId.dropFirst("string(\"".count).dropLast(rawImgId.hasSuffix("\")") ? 2 : 0))
//        } else {
//            imgId = rawImgId
//        }
//        
//        let imgUrl = selectedImage.img ?? ""
//        
//        let dictParams: [String: Any] = [
//            "userid": userIdFromImage,  // Now using the userid of the image owner
//            "event_id": idEvent ?? "",
//            "owner": currentUserId ?? "", // Still using logged-in user ID
//            "imgid": imgId,
//            "imageurl": imgUrl
//        ]
//        
//        // Print to debug
//        print("dictParams:", dictParams)
//        
//        WebService.sharedInstance.callEventAttendesImgDelWebService(withParams: dictParams) { data in
//            self.DelImgData = data
//            
//            // Save values to UserDefaults
//            UserDefaults.standard.set(imgId, forKey: "imgId")
//            UserDefaults.standard.set(imgUrl, forKey: "imgUrl")
//            
//            completionClosure()
//        }
//    }
//    
//    
//    
//    func callEventYesjointWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
//        let idEvent = UserDefaults.standard.string(forKey: "eventid")
//        let UserName = UserDefaults.standard.string(forKey: "username")
//        let dictParams: Dictionary<String, Any> = [
//            "userid":id ?? "",
//            "eventid": idEvent ?? "",
//            "username":UserName ?? "",
//            "status":  "1",
//            "usercase":  "ATTEMPT",
//        ]
//        WebService.sharedInstance.callEventYesjointWebService(withParams: dictParams) { data in
//            self.EventYesData = data
//            self.callEventDetailWebService {
//                self.selection = 1
//            }
//            completionClosure()
//        }
//    }
//    
//    func callEventLikeWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
//        let idEvent = UserDefaults.standard.string(forKey: "eventid")
//        let UserName = UserDefaults.standard.string(forKey: "username")
//        let dictParams: Dictionary<String, Any> = [
//            "userid":id ?? "",
//            "eventid": idEvent ?? "",
//            "username":UserName ?? "",
//            "status":  "1",
//            "usercase":  "LIKES",
//            
//            
//        ]
//        WebService.sharedInstance.callEventLikeWebService(withParams: dictParams) { data in
//            self.EventYesData = data
//            //   UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
//            
//            
//            completionClosure()
//        }
//    }
//    
//    func callEventNojointWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
//        let idEvent = UserDefaults.standard.string(forKey: "eventid")
//        let UserName = UserDefaults.standard.string(forKey: "username")
//        let dictParams: Dictionary<String, Any> = [
//            "userid":id ?? "",
//            "eventid": idEvent ?? "",
//            "username":UserName ?? "",
//            "status":  "0",
//            "usercase":  "ATTEMPT",
//        ]
//        WebService.sharedInstance.callEventNojointWebService(withParams: dictParams) { data in
//            self.EventYesData = data
//            self.selection = 0
//            completionClosure()
//        }
//    }
//    
//    
//    func callEventUploadImgWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let idEvent = UserDefaults.standard.string(forKey: "eventid")
//        let dictParams: [String: Any] = [
//            "event_id": idEvent ?? "",
//            "userid": id ?? ""
//        ]
//        print("📤 Upload Parameters: \(dictParams)")
//        
//        btnUplImg.isHidden = true
//        
//        if self.from == 1 {
//            callsendImageAPI(param: dictParams, arrImage: selectedImages, imageKey: "image[]", URlName: kBASEURL + WebServiceName.kUploadImageEventt) {
//                
//                // ✅ Remove saved images ONLY after API upload completes
//                UserDefaults.standard.removeObject(forKey: "savedImages")
//                print("🗑️ Saved images removed from UserDefaults")
//                
//                completionClosure()
//            }
//        } else if self.from == 2 {
//            callsendImageAPI(param: dictParams, arrImage: images, imageKey: "image[]", URlName: kBASEURL + WebServiceName.kUploadImageEventt) {
//                
//                // ✅ Same logic here
//                UserDefaults.standard.removeObject(forKey: "savedImages")
//                print("🗑️ Saved images removed from UserDefaults")
//                
//                completionClosure()
//            }
//        }
//    }
//    
//
//    
//    
//    
//    func callsendImageAPI(param: [String: Any], arrImage: [UIImage], imageKey: String, URlName: String, withblock: @escaping () -> Void) {
//        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
//        
//        AF.upload(multipartFormData: { multipartFormData in
//            for (key, value) in param {
//                if let str = value as? String {
//                    multipartFormData.append(Data(str.utf8), withName: key)
//                }
//            }
//            
//            for (index, img) in arrImage.enumerated() {
//                if let imgData = img.jpegData(compressionQuality: 0.7) {
//                    multipartFormData.append(imgData, withName: imageKey, fileName: "image\(index).jpeg", mimeType: "image/jpeg")
//                } else {
//                    print("⚠️ Couldn't convert image at index \(index)")
//                }
//            }
//            
//        }, to: URlName, method: .post, headers: headers).response { response in
//            if let data = response.data, !data.isEmpty {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print("✅ API Upload Response JSON: \(json)")
//                    withblock()
//                } catch {
//                    print("❌ JSON parsing error: \(error.localizedDescription)")
//                }
//            } else {
//                print("❌ Empty or nil response received")
//                print("📡 Response object: \(response)")
//            }
//            
//            if let err = response.error {
//                print("❌ Upload failed: \(err.localizedDescription)")
//            }
//        }
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        var count = 0
//        
//        if collectionView == collectionViewEvent {
//            count = EventDetauilData?.images?.filter { $0.type == "owner" }.count ?? 0
//            LblOwnerPhoto.isHidden = (count == 0)  // Hide if count is 0
//            
//        } else if collectionView == AttendesCollectionView {
//            count = EventDetauilData?.images?.filter { $0.type == "user" }.count ?? 0
//            LblAttendesPhoto.isHidden = (count == 0)  // Hide if count is 0
//        } else {
//            count = images.count
//        }
//        
//        return count
//    }
//    
//    
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == collectionViewEvent
//        {
//            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailCollectionViewCell", for: indexPath) as! EventDetailCollectionViewCell
//            
//            
//            
//            
//            if let ownerImages = EventDetauilData?.images?.filter({ $0.type == "owner" }),
//               indexPath.row < ownerImages.count {
//                let imageData = ownerImages[indexPath.row]
//                let url = URL(string: imageData.img ?? "")
//                
//                if let imageUrl = url {
//                    ImageLoader.loadImage(
//                        into: cell.profileImgView,
//                        from: "\(imageUrl)",
//                        placeholder: UIImage(named: "EventImage")
//                    )
//                } else {
//                    cell.profileImgView.image = UIImage(named: "EventImage") // Fallback image
//                }
//                
//                
//                // Show btnDelImg only if there are owner images
//                cell.btnDel.isHidden = ownerImages.isEmpty
//                
//                cell.indexPath = indexPath
//                cell.FullImgCallback = { [self] value in
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventEnlargementViewController") as! EventEnlargementViewController
//                    vc.url = url
//                    vc.otherImages = ownerImages.compactMap { $0.img }
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                
//                cell.configure(with: imageData)
//            } else {
//                // Hide btnDelImg if no owner images are found
//                cell.btnDel.isHidden = true
//            }
//            
//            
//            
//            if let imageData = EventDetauilData?.images?[indexPath.row] {
//                cell.configure(with: imageData)
//                
//                
//            }
//            
//            if let id = UserDefaults.standard.string(forKey: "userid"),
//               let idCr = UserDefaults.standard.string(forKey: "usercr") {
//                print("id: \(id), idCr: \(idCr)") // Debugging output
//                
//                if id == idCr {
//                    cell.btnDel.isHidden = false
//                    // btnEdit.isHidden = false
//                    
//                } else {
//                    cell.btnDel.isHidden = true
//                    
//                    
//                }
//            } else {
//                print("UserDefaults values are nil") // Handle nil case
//                
//                
//            }
//            
//            cell.DelCallback = { [self] value in
//                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
//                
//                // Customize the message attributes
//                let messageText = "Are you sure you want to delete?"
//                let attributes: [NSAttributedString.Key: Any] = [
//                    .font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16),
//                    .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
//                ]
//                
//                let attributedMessage = NSAttributedString(string: messageText, attributes: attributes)
//                alertController.setValue(attributedMessage, forKey: "attributedMessage")
//                let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
//                    if let indexPath = cell.indexPath {
//                        self.callEventImgDelWebService(for: indexPath) {
//                            self.callEventDetailWebService {
//                                //                                self.updateMediaCount()
//                                if !self.selectedImages.isEmpty {
//                                    self.selectedImages.remove(at: 0)
//                                }
//                                self.imgCountlLbl.isHidden = true
//                                self.collectionViewEvent.reloadData()
//                                self.AttendesCollectionView.reloadData()
//                            }
//                        }
//                    }
//                }
//                
//                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
//                alertController.addAction(yesAction)
//                alertController.addAction(noAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//            return cell
//        }
//        
//        
//        if collectionView == AttendesCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttendesCollectionViewCell", for: indexPath) as! AttendesCollectionViewCell
//            collectionView.showsVerticalScrollIndicator = false
//            // Ensure EventDetauilData has images and filter user type images
//            if let userImages = EventDetauilData?.images?.filter({ $0.type == "user" }),
//               indexPath.row < userImages.count {
//                
//                let imageData = userImages[indexPath.row]
// 
//                if let imageUrl = imageData.img {
//                    ImageLoader.loadImage(
//                        into: cell.profileImgView,
//                        from: imageUrl,
//                        placeholder: UIImage(named: "EventImage")
//                    )
//                } else {
//                    cell.profileImgView.image = UIImage(named: "EventImage") // Default image
//                }
//                
//                
//                // Hide delete button if no user images
//                cell.btnDel.isHidden = userImages.isEmpty
//                
//                // Assign the correct indexPath to the cell
//                cell.indexPath = indexPath
//                
//                // Setup callback for full image view
//                cell.FullImgCallback = { [weak self] value in
//                    guard let self = self else { return }
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventEnlargementViewController") as! EventEnlargementViewController
//                    vc.url = URL(string: imageData.img ?? "")
//                    vc.otherImages = userImages.compactMap { $0.img }
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                cell.configure(with: imageData)
//                if  let idCr = UserDefaults.standard.string(forKey: "userid") {
//                    let imgUserId = EventDetauilData?.images?[indexPath.row].userid
//                    if idCr == imgUserId {
//                        cell.btnDel.isHidden = false
//                    } else {
//                        cell.btnDel.isHidden = true
//                    }
//                }
//            } else {
//                cell.profileImgView.image = UIImage(named: "EventImage") // Default image
//            }
//            
//            cell.DelAttendeCallback = { [self] value in
//                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
//                
//                // Customize the message attributes
//                let messageText = "Are you sure you want to delete?"
//                let attributes: [NSAttributedString.Key: Any] = [
//                    .font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16),
//                    .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
//                ]
//                
//                let attributedMessage = NSAttributedString(string: messageText, attributes: attributes)
//                alertController.setValue(attributedMessage, forKey: "attributedMessage")
//                
//                let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
//                    if let indexPath = cell.indexPath {
//                        self.callEventAttendesImgDelWebService(for: indexPath) {
//                            self.callEventDetailWebService {
//                                //                                            self.updateMediaCount()
//                                if !self.selectedImages.isEmpty {
//                                    self.selectedImages.remove(at: 0)
//                                }
//                                self.imgCountlLbl.isHidden = true
//                                //                                            self.collectionViewEvent.reloadData()
//                                self.AttendesCollectionView.reloadData()
//                            }
//                        }
//                    }
//                }
//                
//                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
//                
//                alertController.addAction(yesAction)
//                alertController.addAction(noAction)
//                
//                self.present(alertController, animated: true, completion: nil)
//            }
//            
//            
//            return cell
//        }
//        
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CamPostCollectionViewCell", for: indexPath) as! CamPostCollectionViewCell
//            cell.LargeImgView.image = images[indexPath.row]
//            
//            cell.FullImgCallback = { [self] value in
//                
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforeCamPostViewController")as! BeforeCamPostViewController
//                //
//                // vc.UserName = self.UserName.self
//                vc.images = self.images.self
//                vc.selectedIndex = indexPath.row
//                vc.delegate = self
//                
//                self.navigationController?.pushViewController(vc, animated: true)
//                
//                
//            }
//            
//            return cell
//        }
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemsPerRow: CGFloat = 4
//        let spacing: CGFloat = 2
//        let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        
//        let totalSpacing = sectionInsets.left + sectionInsets.right + (spacing * (itemsPerRow - 1))
//        let availableWidth = collectionView.bounds.width - totalSpacing
//        let itemWidth = floor(availableWidth / itemsPerRow)
//        
//        return CGSize(width: itemWidth, height: itemWidth)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//}
//import UIKit
//import SVProgressHUD
//import Alamofire
//import Photos
//import PhotosUI
//import Kingfisher
//import TOCropViewController  // Yaha se shuru kia din mai
//@available(iOS 16.0, *)
//class EventsDetailViewController: UIViewController , UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, ConfirmEventDelegate, ConfirmNoEventDelegate, ConfirmDeleteEvent, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCollectionViewControllerDelegate, TOCropViewControllerDelegate {
//    
//    func didTapDeleteButton(at index: Int) {
//        
//    }
//    func didDeleteImage(at index: Int) {
//        images.remove(at: index)
//    }
//    
//    //    @IBOutlet weak var btnTotalLIke: UIButton!
//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    @IBOutlet weak var UserNameLbl: UILabel!
//    @IBOutlet weak var DateLbl: UILabel!
//    @IBOutlet weak var profileImgView : UIImageView!
//    @IBOutlet weak var UserImgView : UIImageView!
//    @IBOutlet weak var TitleLbl: UILabel!
//    @IBOutlet weak var VenueLbl: UILabel!
//    @IBOutlet weak var Add2Lbl: UILabel!
//    @IBOutlet weak var StartDateLbl: UILabel!
//    @IBOutlet weak var EndDateLbl: UILabel!
//    @IBOutlet weak var StartTimeLbl: UILabel!
//    @IBOutlet weak var EndTimeLbl: UILabel!
//    @IBOutlet weak var LikeLbl: UILabel!
//    @IBOutlet weak var EventDetailLbl: UILabel!
//    @IBOutlet weak var StcStartDateLbl: UILabel!
//    @IBOutlet weak var StcEndDateLbl: UILabel!
//    @IBOutlet weak var StcStartTimeLbl: UILabel!
//    @IBOutlet weak var StcEndTimeLbl: UILabel!
//    @IBOutlet weak var HradingTitleLbl: UILabel!
//    @IBOutlet weak var lblImgLimit: UILabel!
//    @IBOutlet weak var LblOwnerPhoto: UILabel!
//    @IBOutlet weak var LblAttendesPhoto: UILabel!
//    @IBOutlet weak var LblVenue: UILabel!
//    
//    @IBOutlet weak var appLbl: UILabel!
//    @IBOutlet weak var DeclLbl: UILabel!
//    @IBOutlet weak var btnUplImg: UIButton!
//    @IBOutlet weak var yesNewView: UIView!
//    @IBOutlet weak var ThumbsImgView : UIImageView!
//    @IBOutlet weak var UploadImgView: UIView!
//    @IBOutlet weak var AttendesCollectionView: UICollectionView!
//    @IBOutlet weak var collectionViewEvent: UICollectionView!
//    @IBOutlet weak var collectionViewEventHeightConst: NSLayoutConstraint!
//    @IBOutlet weak var AttendesCollectionViewHeightConst: NSLayoutConstraint!
//    
//    @IBOutlet weak var eventBGViewHeight: NSLayoutConstraint!
//    
//    @IBOutlet weak var btnyes: UIButton!
//    @IBOutlet weak var btnNo: UIButton!
//    @IBOutlet weak var btnAccpt: UIButton!
//    @IBOutlet weak var btnDec: UIButton!
//    @IBOutlet weak var btnEdit: UIButton!
//    @IBOutlet weak var btnDelete: UIButton!
//    @IBOutlet weak var btnPreview: UIButton!
//    
//    @IBOutlet weak var btnAccptIcon: UIButton!
//    @IBOutlet weak var btnDeclineIcon: UIButton!
//    
//    @IBOutlet weak var eventDescriptionHeight: NSLayoutConstraint!
//    @IBOutlet weak var UploadImgHeight: NSLayoutConstraint!
//    @IBOutlet weak var yesNewViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var uploadImgViewTopConstraint: NSLayoutConstraint! // This is the space between yesNewView &  @IBOutlet weak var uploadImgViewTopConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var LblOwnerPhotoTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imgCountlLbl: UILabel!
//    @IBOutlet weak var EventsBgView: UIView!
//    @IBOutlet weak var btnSeelectPhotos: UIButton!
//    
//    
//    var valueForScroll: Int = 0
//    var eventid = ""
//    var notiid = ""
//    var createdBy: String?
//    
//    
//    var EventDetauilData: EventDetailModel? {
//        didSet {
//            DispatchQueue.main.async {
//                self.collectionViewEvent.reloadData()
//                self.AttendesCollectionView.reloadData()
//            }
//        }
//    }
//    
//    var EventUploadPicData : UploadEventDetailModel?
//    var DelImgData : DeleteImgEventModel?
//    var EventYesData : EventYesJointModel?
//    var selection: Int? = 0
//    var thisWidth:CGFloat = 0
//    var from = 1
//    var imagePicker:UIImagePickerController?
//    var imageArray = [UIImage]()
//    var attendeesArray = [UIImage]()
//    var CamimageArray = [UIImage]()
//    var images: [UIImage] = []
//    var selectedImge: UIImage? = nil
//    var currentImageToCrop: UIImage?
//    var MarketWDeleteData : DelMarketProductModel?
//    var id = UserDefaults.standard.string(forKey: "userid")
//    var idCr = UserDefaults.standard.string(forKey: "usercr")
//    var userImages: [ImageEvent] = []
//    var ownerImages: [ImageEvent] = []
//    var selectedImages: [UIImage] = []
//    func tapConfirm() {
//        
//    }
//    
//    var allImages: [UIImage] {
//        return selectedImages + images
//    }
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        updateColors()
//        DispatchQueue.main.async {
//            self.finalizeUIRefresh()
//        }
//        UIView.animate(withDuration: 0.1) {
//            self.view.layoutIfNeeded()
//        }
//        
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //            updateColors()
//        SVProgressHUD.show()
//        UserDefaults.standard.set(eventid, forKey: "eventid")
//        DateLbl.textColor = UIColor.secondaryLabel
//        collectionViewEvent.delegate = self
//        collectionViewEvent.dataSource = self
//        AttendesCollectionView.delegate = self
//        AttendesCollectionView.dataSource = self
//        NetworkMonitor.shared.startMonitoring()
//        self.UserNameLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
//        self.HradingTitleLbl.font = UIFont(name: "Montserrat-Regular", size: 20)
//        self.DateLbl.font = UIFont(name: "Montserrat-Regular", size: 14)
//        self.TitleLbl.font = UIFont(name: "Montserrat-SemiBold", size: 16)
//        self.VenueLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
//        self.LblVenue.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        self.Add2Lbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        self.StartDateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
//        self.EndDateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
//        self.StartTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        self.EndTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        self.LikeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        self.StartTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        self.EventDetailLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
//        self.StcStartDateLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        self.StcEndDateLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        self.StcStartTimeLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        self.StcEndTimeLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
//        self.lblImgLimit.font = UIFont(name: "Montserrat-Regular", size: 10)
//        self.LblAttendesPhoto.font = UIFont(name: "Montserrat-Regular", size: 14)
//        self.LblOwnerPhoto.font = UIFont(name: "Montserrat-Regular", size: 14)
//        self.HradingTitleLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
//        btnUplImg.isHidden = true
//        super.viewDidLayoutSubviews()
//        if let userAttends = self.EventDetauilData?.userunjoinmemberlist as? String {
//            switch userAttends {
//            case "1":
//                btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
//                if selection != 1 {
//                    UploadImgView.isHidden = false
//                    lblImgLimit.isHidden = false
//                }
//            case "0":
//                btnNo.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
//                if selection != 1 {
//                    UploadImgView.isHidden = true
//                    lblImgLimit.isHidden = true
//                }
//                //            case "2":
//                //                DispatchQueue.main.async {
//                //                    self.UploadImgView.isHidden = true
//                //                    self.lblImgLimit.isHidden = true
//                //                }
//            default:
//                break
//            }
//        }
//        
//        if let selectedBtnValue = self.EventDetauilData?.userunjoinmemberlist?.compactMap({ Int($0.status ?? "") }).first {
//            switch selectedBtnValue {
//            case 1:
//                self.UploadImgView.isHidden = false
//                
//                self.lblImgLimit.isHidden = false
//            case 0:
//                if selection != 1 {
//                    UploadImgView.isHidden = true
//                    self.lblImgLimit.isHidden = true
//                }
//            default:
//                break
//            }
//        }
//        
//        if let userAttends = self.EventDetauilData?.userunjoinmemberlist as? String {
//            switch userAttends {
//            case "1":
//                btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
//                if selection != 1 {
//                    UploadImgView.isHidden = false
//                    lblImgLimit.isHidden = false
//                }
//            case "0":
//                btnNo.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
//                if selection != 1 {
//                    UploadImgView.isHidden = true
//                    lblImgLimit.isHidden = true
//                }
//                //            case "2":
//                //                DispatchQueue.main.async {
//                //                    self.UploadImgView.isHidden = true
//                //                    self.lblImgLimit.isHidden = true
//                //                }
//            default:
//                break
//            }
//        }
//        
//        
//        if let selectedBtnValue = self.EventDetauilData?.userunjoinmemberlist?
//            .compactMap({ Int($0.status ?? "") }).first {
//            
//            switch selectedBtnValue {
//            case 1:
//                self.UploadImgView.isHidden = false
//                
//                self.lblImgLimit.isHidden = false
//            case 0:
//                if selection != 1 {
//                    UploadImgView.isHidden = true
//                    
//                    self.lblImgLimit.isHidden = true
//                }
//                
//            default:
//                break
//            }
//        }
//        
//        if let id = UserDefaults.standard.string(forKey: "userid"),
//           let idCr = UserDefaults.standard.string(forKey: "usercr") {
//            print("id: \(id), idCr: \(idCr)") // Debugging output
//            
//            if id == idCr {
//                yesNewView.isHidden = true
//                // btnEdit.isHidden = false
//                appLbl.isHidden = false
//                DeclLbl.isHidden = false
//                btnAccptIcon.isHidden = false
//                btnDeclineIcon.isHidden = false
//                btnAccpt.isHidden = false
//                btnDec.isHidden = false
//                UploadImgView.isHidden = false
//                lblImgLimit.isHidden = false
//                btnDelete.isHidden = false
//                btnEdit.isHidden = false
//            } else {
//                if EventDetauilData?.userunjoinmemberlist?.compactMap({ $0.status }).contains("1") == true {
//                    UploadImgView.isHidden = false
//                    lblImgLimit.isHidden = false
//                } else {
//                    UploadImgView.isHidden = true
//                    lblImgLimit.isHidden = true
//                }
//                yesNewView.isHidden = false
//                //  btnEdit.isHidden = true
//                appLbl.isHidden = true
//                DeclLbl.isHidden = true
//                btnAccpt.isHidden = true
//                btnAccptIcon.isHidden = true
//                btnDeclineIcon.isHidden = true
//                btnDec.isHidden = true
//                btnDelete.isHidden = true
//                btnEdit.isHidden = true
//            }
//        } else {
//            print("UserDefaults values are nil")
//        }
//        
//        
//        if imgCountlLbl.gestureRecognizers?.isEmpty ?? true {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(previewLabelTapped))
//            imgCountlLbl.isUserInteractionEnabled = true
//            imgCountlLbl.addGestureRecognizer(tapGesture)
//        }
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        // Restore selection from UserDefaults
//        //        selection = UserDefaults.standard.integer(forKey: "selection")
//        
//        SVProgressHUD.show()
//        callEventDetailWebService { [self] in
//            SVProgressHUD.dismiss()
//            
//            // Reload data
//            self.collectionViewEvent.reloadData()
//            self.AttendesCollectionView.reloadData()
//            finalizeUIRefresh()
//            
//            // Set labels from API
//            self.UserNameLbl.text = self.EventDetauilData?.createby
//            self.DateLbl.text = self.EventDetauilData?.datetimeandneighbrhood
//            self.TitleLbl.text = self.EventDetauilData?.title
//            self.HradingTitleLbl.text = self.EventDetauilData?.title
//            self.VenueLbl.text = self.EventDetauilData?.addlineone
//            self.Add2Lbl.text = self.EventDetauilData?.addlinetwo
//            self.StartDateLbl.text = self.EventDetauilData?.eventStartDate
//            self.EndDateLbl.text = self.EventDetauilData?.eventEndDate
//            self.StartTimeLbl.text = self.EventDetauilData?.eventStarttime
//            self.EndTimeLbl.text = self.EventDetauilData?.eventEndtime
//            //            self.LikeLbl.text = self.EventDetauilData?.userlikes
//            self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
//            self.appLbl.text = self.EventDetauilData?.totalJoin
//            self.DeclLbl.text = self.EventDetauilData?.nojoin
//            self.lblImgLimit.text = "Max Images: \(self.EventDetauilData?.eventImgLimit ?? "0")"
//            
//            
//            DispatchQueue.main.async {
//                // Set Upload Section Visibility
//                if let userList = self.EventDetauilData?.userjoinmemberlist, !userList.isEmpty {
//                    
//                    let statusList = userList.filter { $0.status == "1" || $0.status == "0" }
//                    
//                    if let userId = UserDefaults.standard.string(forKey: "userid"),
//                       let currentUser = userList.first(where: { $0.userid == userId }), currentUser.status == "1" {
//                        //                         self.setUploadSectionVisibility(true)
//                        self.btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
//                        self.btnyes.setTitleColor(.white, for: .normal)
//                        
//                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                        self.btnNo.setTitleColor(.white, for: .normal)
//                        
//                    } else if self.selection == 0 {
//                        //                         self.setUploadSectionVisibility(false)
//                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.2117647059, blue: 0.04705882353, alpha: 1)
//                        self.btnNo.setTitleColor(.white, for: .normal)
//                        
//                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                        self.btnyes.setTitleColor(.white, for: .normal)
//                    } else {
//                        // Optional: reset to default style
//                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                        self.btnyes.setTitleColor(.white, for: .normal)
//                        
//                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                        self.btnNo.setTitleColor(.white, for: .normal)
//                    }
//                }
//            }
//            
//            
//            
//            
//            
//            if let id = UserDefaults.standard.string(forKey: "userid"),
//               let idCr = UserDefaults.standard.string(forKey: "usercr") {
//                
//                if let userList = self.EventDetauilData?.userunjoinmemberlist {
//                    if userList.isEmpty == true {
//                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                    }
//                }
//                
//                
//                
//                
//                
//                if let userList = self.EventDetauilData?.userjoinmemberlist {
//                    if userList.isEmpty == true {
//                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                    }
//                }
//                
//                if id == idCr {
//                    // Owner: Show Upload View
//                    self.UploadImgView.isHidden = false
//                } else {
//                    // Not the owner
//                    if let userList = self.EventDetauilData?.userunjoinmemberlist as? [UserUnjoinMemberList], !userList.isEmpty {
//                        
//                        let statusList = userList.filter { $0.status == "1" || $0.status == "0" }
//                        
//                        if statusList.isEmpty {
//                            print("No users with status 1 or 2 found.")
//                            //                            self.btnNo.backgroundColor = #colorLiteral(red: 0.436, green: 0.436, blue: 0.436, alpha: 1)
//                            //                            self.btnyes.backgroundColor = #colorLiteral(red: 0.436, green: 0.436, blue: 0.436, alpha: 1)
//                            self.UploadImgView.isHidden = true
//                        } else {
//                            print("Filtered users with status 1 or 2:")
//                            for user in statusList {
//                                print("Status coming for user: \(user.status ?? "0")")
//                                //                                if user.status == "\(0)" {
//                                //                                    self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                                //                                    self.btnNo.backgroundColor = #colorLiteral(red: 0.749, green: 0.211, blue: 0.047, alpha: 1)
//                                //                                } else if user.status == "\(1)" {
//                                //                                    self.btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.501, blue: 0, alpha: 1)
//                                //                                    self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                                //                                }
//                            }
//                        }
//                    } else {
//                        print("userunjoinmemberlist is nil or empty.")
//                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                        self.UploadImgView.isHidden = true
//                    }
//                    
//                    if let userList = self.EventDetauilData?.userunjoinmemberlist as? [Userjoinmemberlist], !userList.isEmpty {
//                        
//                        let statusList = userList.filter { $0.status == "1" || $0.status == "0" }
//                        
//                        if statusList.isEmpty {
//                            print("No users with status 1 or 2 found.")
//                            //                            self.btnNo.backgroundColor = #colorLiteral(red: 0.436, green: 0.436, blue: 0.436, alpha: 1)
//                            //                            self.btnyes.backgroundColor = #colorLiteral(red: 0.436, green: 0.436, blue: 0.436, alpha: 1)
//                            self.UploadImgView.isHidden = true
//                        } else {
//                            print("Filtered users with status 1 or 2:")
//                            for user in statusList {
//                                print("Status coming for user: \(user.status ?? "0")")
//                                if user.status == "\(0)" {
//                                    self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                                    self.btnNo.backgroundColor = #colorLiteral(red: 0.749, green: 0.211, blue: 0.047, alpha: 1)
//                                } else if user.status == "\(1)" {
//                                    self.btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.501, blue: 0, alpha: 1)
//                                    self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                                }
//                            }
//                        }
//                    } else {
//                        print("userunjoinmemberlist is nil or empty.")
//                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                        self.UploadImgView.isHidden = true
//                    }
//                    
//                }
//            }
//            
//            
//            
//            
//            // Thumbs image based on likes
//            if self.EventDetauilData?.totalLike == "0" {
//                self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup")
//            } else {
//                self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup.fill")
//            }
//            
//            // Set profile & user images
//            if let url = URL(string: self.EventDetauilData?.coverImage ?? "") {
//                self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "EventImage"))
//            }
//            if let urlU = URL(string: self.EventDetauilData?.userpic ?? "") {
//                self.UserImgView.kf.setImage(with: urlU, placeholder: UIImage(named: "EventImage"))
//            }
//            
//            // Event creator check
//            if let id = UserDefaults.standard.string(forKey: "userid"),
//               let idCr = UserDefaults.standard.string(forKey: "usercr") {
//                
//                if id == idCr {
//                    // This user is the creator
//                    yesNewView.isHidden = true
//                    btnEdit.isHidden = false
//                    btnDelete.isHidden = false
//                    DeclLbl.isHidden = false
//                    btnAccpt.isHidden = false
//                    btnDec.isHidden = false
//                    btnAccptIcon.isHidden = false
//                    btnDeclineIcon.isHidden = false
//                } else {
//                    // Regular user
//                    yesNewView.isHidden = false
//                    btnEdit.isHidden = true
//                    btnDelete.isHidden = true
//                    appLbl.isHidden = true
//                    DeclLbl.isHidden = true
//                    btnAccpt.isHidden = true
//                    btnAccptIcon.isHidden = true
//                    btnDeclineIcon.isHidden = true
//                    btnDec.isHidden = true
//                }
//            }
//            
//            // If event is not running, hide upload view
//            if let isEventRunning = self.EventDetauilData?.iseventrunning, Int(isEventRunning) == 0 {
//                yesNewView.isHidden = true
//            }
//            
//            // ✅ FINAL: Set upload section visibility based on saved selection
//            //            DispatchQueue.main.async {
//            //                if self.selection == 1 {
//            //                    self.setUploadSectionVisibility(true)
//            //                } else if self.selection == 0 {
//            //                    self.setUploadSectionVisibility(false)
//            //                }
//            //            }
//        }
//    }
//    
//    @IBAction func BackButtionAction(_ : UIButton){
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//    
//    private func updateColors() {
//        if traitCollection.userInterfaceStyle == .dark {
//            // Dark mode colors
//            UserNameLbl.textColor = .white
//            DateLbl.textColor = .white
//            TitleLbl.textColor = .white
//            VenueLbl.textColor = .white
//            Add2Lbl.textColor = .white
//            DateLbl.textColor = .white
//            StartDateLbl.textColor = .white
//            EventsBgView.backgroundColor = .black
//            imgCountlLbl.textColor = .white
//            EndDateLbl.textColor = .white
//            StartTimeLbl.textColor = .white
//            EndTimeLbl.textColor = .white
//            LikeLbl.textColor = .white
//            EventDetailLbl.textColor = .white
//            StcStartDateLbl.textColor = .white
//            StcEndTimeLbl.textColor = .white
//            StcStartTimeLbl.textColor = .white
//            
//            StcEndDateLbl.textColor = .white
//            lblImgLimit.textColor = .white
//            LblOwnerPhoto.textColor = .white
//            LblAttendesPhoto.textColor = .white
//            appLbl.textColor = .white
//            DeclLbl.textColor = .white
//            yesNewView.backgroundColor = .white
//            UploadImgView.backgroundColor = .black
//            yesNewView.backgroundColor = .black
//            LblVenue.textColor = .white
//            collectionViewEvent.backgroundColor = .black
//            AttendesCollectionView.backgroundColor = .black
//            UploadImgView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
//            UploadImgView.layer.borderWidth = 1.0
//        } else {
//            // Light mode mein storyboard ke original colors preserve karna
//            //            UserNameLbl.textColor = UIColor.secondaryLabel
//            DateLbl.textColor = UIColor.secondaryLabel
//            TitleLbl.textColor = UIColor.secondaryLabel
//            VenueLbl.textColor = UIColor.secondaryLabel
//            Add2Lbl.textColor = UIColor.secondaryLabel
//            DateLbl.textColor = UIColor.secondaryLabel
//            StartDateLbl.textColor = UIColor.secondaryLabel
//            StcEndDateLbl.textColor = UIColor.secondaryLabel
//            StcStartTimeLbl.textColor = UIColor.secondaryLabel
//            imgCountlLbl.textColor = UIColor.secondaryLabel
//            // Light mode mein PollsView ka background red karna
//            EventsBgView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
//            collectionViewEvent.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
//            AttendesCollectionView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
//            EndDateLbl.textColor = UIColor.secondaryLabel
//            StartTimeLbl.textColor = UIColor.secondaryLabel
//            EndTimeLbl.textColor = UIColor.secondaryLabel
//            LikeLbl.textColor = UIColor.secondaryLabel
//            EventDetailLbl.textColor = UIColor.secondaryLabel
//            StcStartDateLbl.textColor = UIColor.secondaryLabel
//            StcEndTimeLbl.textColor = UIColor.secondaryLabel
//            
//            lblImgLimit.textColor = UIColor.secondaryLabel
//            LblOwnerPhoto.textColor = UIColor.secondaryLabel
//            LblAttendesPhoto.textColor = UIColor.secondaryLabel
//            appLbl.textColor = UIColor.secondaryLabel
//            DeclLbl.textColor = UIColor.secondaryLabel
//            LblVenue.textColor = UIColor.secondaryLabel
//            // yesNewView.backgroundColor = UIColor.secondaryLabel
//            UploadImgView.backgroundColor = .white
//            yesNewView.backgroundColor = .white
//            //  UploadImgView.isUserInteractionEnabled = tr // Disable in light mode
//            UploadImgView.layer.borderWidth = 0
//        }
//    }
//    
//    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            updateColors() // Re-apply colors on theme change
//        }
//    }
//    
//    @IBAction func PostimgAction(_ sender: UIButton) {
//        print("✅ PostimgAction triggered")
//        
//        // 🛑 Image empty check
//        if selectedImages.isEmpty {
//            showAlert(message: "Please select at least one image before uploading.")
//            return
//        }
//        
//        let limitString = EventDetauilData?.eventImgLimit ?? "0"
//        let limit = Int(limitString) ?? 0
//        print("🟡 Selected images: \(selectedImages.count), Limit: \(limit)")
//        
//        if selectedImages.count > limit {
//            showAlert(message: "You have already reached maximum \(limit) media limit.")
//            return
//        }
//        
//        sender.isEnabled = false // disable while uploading
//        
//        
//        callEventUploadImgWebService {
//            print("✅ Image uploaded successfully")
//            self.imgCountlLbl.isHidden = true  // abdul
//            
//            self.callEventDetailWebService {
//                print("✅ Event details fetched")
//                DispatchQueue.main.async {
//                    //                    self.updateMediaCount()
//                    self.collectionViewEvent.reloadData()
//                    self.AttendesCollectionView.reloadData()
//                    self.updateImageCollectionViewsVisibility()
//                    self.view.layoutIfNeeded()
//                    let ownerImages = self.EventDetauilData?.images?.filter { $0.type == "owner" } ?? []
//                    let userImages = self.EventDetauilData?.images?.filter { $0.type == "user" } ?? []
//                    if let userList = self.EventDetauilData?.userjoinmemberlist, !userList.isEmpty {
//                        if let userId = UserDefaults.standard.string(forKey: "userid"),
//                           let currentUser = userList.first(where: { $0.userid == userId }) {
//                            if currentUser.status == "1" {
//                                if self.id != self.idCr {
//                                    if userImages.isEmpty != true {
//                                        self.AttendesCollectionView.isHidden = false
//                                        self.AttendesCollectionViewHeightConst.constant = 128
//                                    }
//                                }
//                            }
//                            if self.id == self.idCr {
//                                if ownerImages.isEmpty != true {
//                                    self.collectionViewEvent.isHidden = false
//                                    self.collectionViewEventHeightConst.constant = 128
//                                } else if ownerImages.isEmpty == true {
//                                    self.collectionViewEvent.isHidden = true
//                                    self.collectionViewEventHeightConst.constant = 0
//                                }
//                                if userImages.isEmpty != true {
//                                    self.AttendesCollectionView.isHidden = false
//                                    self.AttendesCollectionViewHeightConst.constant = 128
//                                } else if userImages.isEmpty == true {
//                                    self.AttendesCollectionView.isHidden = true
//                                    self.AttendesCollectionViewHeightConst.constant = 0
//                                }
//                            }
//                        }
//                    }
//                    
//                    
//                    self.LblOwnerPhoto.isHidden = ownerImages.isEmpty
//                    self.LblAttendesPhoto.isHidden = userImages.isEmpty
//                    self.AttendesCollectionView.isHidden = userImages.isEmpty  // ✅ Final fix here
//                    print("👁️ Owner: \(ownerImages.count), User: \(userImages.count)")
//                    sender.isEnabled = true
//                    if !self.selectedImages.isEmpty {
//                        self.selectedImages.remove(at: 0)
//                    }
//                }
//                
//                self.collectionViewEvent.reloadData()
//                self.AttendesCollectionView.reloadData()
//            }
//        }
//        
//        //        callEventUploadImgWebService {}
//    }
//    
//    
//    
//    func updateImageCollectionViewsVisibility() {
//        let ownerCount = EventDetauilData?.images?.filter { $0.type == "owner" }.count ?? 0
//        let userCount = EventDetauilData?.images?.filter { $0.type == "user" }.count ?? 0
//        collectionViewEventHeightConst.constant = (ownerCount > 0) ? 128 : 0
//        AttendesCollectionViewHeightConst.constant = (userCount > 0) ? 128 : 0
//    }
//    //  self.EventDetauilData?.title
//        @IBAction func btnProfile(_ : UIButton) {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
//            vc.Oid = EventDetauilData?.userid ?? ""
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        
//        @IBAction func imageTapped(_ sender: UIButton) {
//            guard let imageUrl = URL(string: self.EventDetauilData?.coverImage ?? "") else { return }
//            
//            // Instantiate ImageEnlargeViewController
//            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if different
//            if let enlargeVC = storyboard.instantiateViewController(withIdentifier: "EventImageEnlargeViewController") as? EventImageEnlargeViewController {
//                enlargeVC.imageUrl = imageUrl
//                self.navigationController?.pushViewController(enlargeVC, animated: true)
//            }
//        }
//        
//        // Change this code btnyes Irshad malik
//        @IBAction func btnYes(_ sender: UIButton) {
//            btnNo.isUserInteractionEnabled = true
//          
//            setUploadSectionVisibility(true)
//            sender.isUserInteractionEnabled = false
//            btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
//            btnNo.backgroundColor = #colorLiteral(red: 0.4361207187, green: 0.4361207187, blue: 0.4361207187, alpha: 1)
//            btnyes.setTitleColor(.white, for: .normal)
//            btnNo.setTitleColor(.white, for: .normal)
//           
//            
//            SVProgressHUD.show()
//            callEventDetailWebService { [self] in
//                SVProgressHUD.dismiss()
//                self.finalizeUIRefresh()
//                self .selection = 1
//                UserDefaults.standard.set(1, forKey: "selection")
//                
//                self.UserNameLbl.text = self.EventDetauilData?.createby
//                self.DateLbl.text = self.EventDetauilData?.datetimeandneighbrhood
//                self.TitleLbl.text = self.EventDetauilData?.title
//                self.HradingTitleLbl.text = self.EventDetauilData?.title
//                self.VenueLbl.text = self.EventDetauilData?.addlineone
//                self.StartDateLbl.text = self.EventDetauilData?.eventStartDate
//                self.EndDateLbl.text = self.EventDetauilData?.eventEndDate
//                self.StartTimeLbl.text = self.EventDetauilData?.eventStarttime
//                self.EndTimeLbl.text = self.EventDetauilData?.eventEndtime
//                self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
//                self.appLbl.text = self.EventDetauilData?.totalJoin
//                self.DeclLbl.text = self.EventDetauilData?.nojoin
//                self.handleUserJoinStatus(value: self.selection ?? 0)
//                if let coverImage = self.EventDetauilData?.coverImage, let url = URL(string: coverImage) {
//                    self.profileImgView.kf.indicatorType = .activity
//                    self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "EventImage"))
//                }
//                
//                if let userPic = self.EventDetauilData?.userpic, let urlU = URL(string: userPic) {
//                    self.UserImgView.kf.indicatorType = .activity
//                    self.UserImgView.kf.setImage(with: urlU, placeholder: UIImage(named: "EventImage"))
//                }
//            }
//            refreshAllEventData(from: "yes")
//            
//        }
//        
//        
//        @IBAction func btnNo(_ sender: UIButton) {
//
//            btnyes.isUserInteractionEnabled = true
//
//      
//            
//            btnyes.backgroundColor = #colorLiteral(red: 0.4361207187, green: 0.4361207187, blue: 0.4361207187, alpha: 1)
//            btnNo.backgroundColor =  #colorLiteral(red: 0.7490196078, green: 0.2117647059, blue: 0.04705882353, alpha: 1)
//            btnyes.setTitleColor(.white, for: .normal)
//            btnNo.setTitleColor(.white, for: .normal)
//            
//            LblOwnerPhoto.isHidden = true
//            LblAttendesPhoto.isHidden = true
//            setUploadSectionVisibility(false) // No dabane par hide karo
//            
//            callEventDetailWebService { [self] in
//                SVProgressHUD.dismiss()
//                self.finalizeUIRefresh()
//                self .selection = 0
//                UserDefaults.standard.set(0, forKey: "selection")
//                if self.selection == 0 {
//                    setUploadSectionVisibility(false)
//                    self.LblOwnerPhoto.isHidden = true
//                    self.LblAttendesPhoto.isHidden = true
//                    self.AttendesCollectionView.isHidden  = true
//                    self.AttendesCollectionViewHeightConst.constant = 0
//                    self.collectionViewEvent.isHidden  = true
//                    self.collectionViewEventHeightConst.constant = 0
//                }
//                self.UserNameLbl.text = self.EventDetauilData?.createby
//                self.DateLbl.text = self.EventDetauilData?.datetimeandneighbrhood
//                self.TitleLbl.text = self.EventDetauilData?.title
//                self.HradingTitleLbl.text = self.EventDetauilData?.title
//                self.VenueLbl.text = self.EventDetauilData?.addlineone
//                self.StartDateLbl.text = self.EventDetauilData?.eventStartDate
//                self.EndDateLbl.text = self.EventDetauilData?.eventEndDate
//                self.StartTimeLbl.text = self.EventDetauilData?.eventStarttime
//                self.EndTimeLbl.text = self.EventDetauilData?.eventEndtime
//    //            self.LikeLbl.text = self.EventDetauilData?.userlikes
//                self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
//                self.appLbl.text = self.EventDetauilData?.totalJoin
//                self.DeclLbl.text = self.EventDetauilData?.nojoin
//                
//                let selectedBtnValue = self.EventDetauilData?.userunjoinmemberlist?.compactMap({ Int($0.status ?? "0") }).first
//                updateUploadViewBasedOnSelectionAndStatus(selectedBtnValue)
//                self.selection = selectedBtnValue
//                
//                if let coverImage = self.EventDetauilData?.coverImage, let url = URL(string: coverImage) {
//                    self.profileImgView.kf.indicatorType = .activity
//                    self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "EventImage"))
//                }
//                
//                if let userPic = self.EventDetauilData?.userpic, let urlU = URL(string: userPic) {
//                    self.UserImgView.kf.indicatorType = .activity
//                    self.UserImgView.kf.setImage(with: urlU, placeholder: UIImage(named: "EventImage"))
//                }
//            }
//            refreshAllEventData(from: "no")
//            
//        }
//        
//        func setUploadSectionVisibility(_ isVisible: Bool) {
//            UploadImgView.isHidden = !isVisible
//    //        collectionViewEvent.isHidden = !isVisible
//    //        AttendesCollectionView.isHidden = !isVisible
//            lblImgLimit.isHidden = !isVisible
//        }
//        
//        
//        
//        private func updateUploadViewBasedOnSelectionAndStatus(_ statusValue: Int?) {
//            guard let status = statusValue else { return }
//            
//            if status == 1 && selection == 1 {
//                setUploadSectionVisibility(true)
//            } else if status == 0 && selection == 0{
//                setUploadSectionVisibility(false)
//            }
//        }
//        
//        
//        
//        
//        @IBAction func btnJoinList(_ : UIButton){
//        }
//        
//        @IBAction func JoinPopUpBtnAction(_ sender: UIButton) {
//            if EventDetauilData?.totalJoin != "0" {
//    //            let vc = storyboard?.instantiateViewController(withIdentifier:"EventJoinListViewController")as! EventJoinListViewController
//    //            vc.modalPresentationStyle = .overFullScreen
//    //            vc.modalTransitionStyle = .crossDissolve
//    //            vc.delegate = self
//    //            vc.eventid = (EventDetauilData?.id)!
//    //            self.present(vc , animated: true)
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttendeesVC") as! AttendeesVC
//                vc.getData = EventDetauilData
//                vc.isComingFrom = "Attendees"
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .overFullScreen
//                nav.modalTransitionStyle = .crossDissolve
//                self.present(nav, animated: true)
//            }
//        }
//        
//        @IBAction func EventJoinLikeListBtnAction(_ sender: UIButton) {
//            if self.EventDetauilData?.totalLike != "0" {
//                let vc = storyboard?.instantiateViewController(withIdentifier:"EventLikeListViewController")as! EventLikeListViewController
//                vc.modalPresentationStyle = .overFullScreen
//                vc.modalTransitionStyle = .crossDissolve
//                vc.delegate = self
//                vc.eventid = (EventDetauilData?.id)!
//                self.present(vc , animated: true)
//                
//            } else {
//                print("No Likes .")
//            }
//        }
//        
//        
//        @IBAction func btnEdit(_ : UIButton) {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateEventViewController")as! UpdateEventViewController
//            vc.eventid = (EventDetauilData?.id)!
//            vc.titleLabel = self.EventDetauilData?.title ?? ""
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        
//        @IBAction func NoJoinPopUpBtnAction(_ sender: UIButton) {
//            if self.EventDetauilData?.userunjoinmemberlist?.isEmpty != true {
//    //            let vc = storyboard?.instantiateViewController(withIdentifier:"EventNoJoinViewController")as! EventNoJoinViewController
//    //            vc.modalPresentationStyle = .overFullScreen
//    //            vc.modalTransitionStyle = .crossDissolve
//    //            vc.delegate = self
//    //            vc.eventid = (EventDetauilData?.id)!
//    //            self.present(vc , animated: true)
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttendeesVC") as! AttendeesVC
//                vc.getData = EventDetauilData
//                vc.isComingFrom = "NonAttendees"
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .overFullScreen
//                nav.modalTransitionStyle = .crossDissolve
//                self.present(nav, animated: true)
//            } else {
//                print("No user has not joined yet.")
//            }
//        }
//        
//        @IBAction func DeletePopUpNewBtnAction(_ sender: UIButton) {
//            
//            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
//            
//            // Customizing the message font and size
//            let messageText = "Are you sure you want to remove this event?"
//            let attributedMessage = NSAttributedString(string: messageText, attributes: [
//                .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
//                .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
//            ])
//            alertController.setValue(attributedMessage, forKey: "attributedMessage")
//            
//            // Define RGB Colors
//            let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)  // Green
//            let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)   // Red
//            
//            // Yes Action
//            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
//                self.callEventDeleteListWebService {
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
//            yesAction.setValue(yesColor, forKey: "titleTextColor") // Set Yes button color
//            
//            // No Action
//            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
//            noAction.setValue(noColor, forKey: "titleTextColor")
//            
//            alertController.addAction(yesAction)
//            alertController.addAction(noAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//        
//        @IBAction func selectPhotos(_ sender: UIButton) {
//            let limit = Int(EventDetauilData?.eventImgRemainLimit ?? "") ?? 0
//            if selectedImages.count >= limit {
//                showAlert(message: "You have already reached maximum limit.")
//                return
//            }
//            checkCameraPermission { [weak self] granted in
//                guard let self = self else { return }
//                if granted {
//                    selectImages()
//                    btnUplImg.isHidden = false
//                }
//            }
//        }
//        
//        
//        
//        
//        @IBAction func yesJoin(_ sender: UIButton) {
//            callEventYesjointWebService{}
//        }
//        
//        @IBAction func NoJoin(_ sender: UIButton) {
//            callEventNojointWebService{}
//        }
//        
//        @IBAction func like(_ sender: UIButton) {
//            
//            callEventLikeWebService{ [self] in
//                callEventDetailWebService{ [self] in
//                    
//                    SVProgressHUD.dismiss()
//                    self.collectionViewEvent.reloadData()
//                    self.AttendesCollectionView.reloadData()
//                    
//                    self.LikeLbl.text = self.EventDetauilData?.totalLike
//                    
//                    if self.EventDetauilData?.totalLike == "0" {
//                        self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup")
//                    } else {
//                        self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup.fill")
//                    }
//                }
//            }
//        }
//        
//        
//        
//        
//        
//        
//        func showAlert(title: String = "", message: String) {
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            
//            // ✅ OK button add karein, jo alert ko turant dismiss karega
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            present(alert, animated: true) {
//                // ✅ 2 second ke baad alert automatically dismiss hoga
//                //            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                //                alert.dismiss(animated: true, completion: nil)
//                //            }
//            }
//        }
//        
//        @objc func selectImages() {
//            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            
//            actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
//                self.openCamera()
//            }))
//            
//            actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
//                self.openGallery()
//            }))
//            
//            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            
//            present(actionSheet, animated: true, completion: nil)
//        }
//        
//        func openCamera() {
//            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            picker.sourceType = .camera
//            present(picker, animated: true, completion: nil)
//        }
//        
//        func openGallery() {
//            var config = PHPickerConfiguration()
//            config.selectionLimit = Int(EventDetauilData?.eventImgLimit ?? "") ?? 0
//            config.filter = .images
//            
//            let picker = PHPickerViewController(configuration: config)
//            picker.delegate = self
//            present(picker, animated: true, completion: nil)
//        }
//        
//        
//        
//        
//        
//        // MARK: - UIImagePickerControllerDelegate
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            picker.dismiss(animated: true) {
//                if let image = info[.originalImage] as? UIImage {
//                    self.currentImageToCrop = image
//                    self.openCropper(image: image)
//    //                self.updateMediaCount()
//                }
//            }
//        }
//        
//        // MARK: - PHPickerViewControllerDelegate
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            picker.dismiss(animated: true)
//            
//            for result in results {
//                result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
//                    if let image = reading as? UIImage {
//                        DispatchQueue.main.async {
//                            self.currentImageToCrop = image
//                            self.openCropper(image: image)
//                        }
//                    }
//                }
//            }
//        }
//        
//        
//        func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
//            print("✅ Image cropped successfully")
//            selectedImages.append(image)
//            
//            // ✅ Save to UserDefaults
//            saveSelectedImages()
//            
//            updateMediaCount()
//            cropViewController.dismiss(animated: true, completion: nil)
//        }
//        
//        // MARK: - Crop Delegate
//        func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//            print("✅ Cropped image received!")
//            selectedImages.append(image)
//            saveSelectedImages()  // ✅ Important!
//            updateMediaCount()
//            cropViewController.dismiss(animated: true, completion: nil)
//        }
//        
//        
//        
//        // MARK: - Open Cropper
//        func openCropper(image: UIImage) {
//            let cropVC = TOCropViewController(image: image)
//            cropVC.delegate = self
//            present(cropVC, animated: true, completion: nil)
//        }
//        
//        func updateMediaCount() {
//            DispatchQueue.main.async {
//                let totalMedia = self.selectedImages.count
//                self.imgCountlLbl.text = "\(totalMedia) previews"
//                self.imgCountlLbl.isHidden = totalMedia == 0
//                self.lblImgLimit.text = " Remaining limit \(self.EventDetauilData?.eventImgRemainLimit ?? "0")"
//            }
//        }
//        
//        
//        
//        // MARK: - Preview Screen
//        @objc func previewLabelTapped() {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let previewVC = storyboard.instantiateViewController(withIdentifier: "PreviewEventDetailViewController") as? PreviewEventDetailViewController {
//                
//                print("Selected Images to send: \(selectedImages.count)")
//                
//                // ✅ Pass images
//                previewVC.selectedImages = self.selectedImages
//                
//                // ✅ Remove from UserDefaults if not needed anymore
//                UserDefaults.standard.removeObject(forKey: "savedImages")
//                print("🗑️ Cleared savedImages from UserDefaults on preview open")
//                
//                // ✅ Navigate to preview screen
//                self.navigationController?.pushViewController(previewVC, animated: true)
//            }
//        }
//        
//        
//        
//        
//        func saveSelectedImages() {
//            let imageDataArray = selectedImages.compactMap { $0.pngData() }
//            UserDefaults.standard.set(imageDataArray, forKey: "savedImages")
//        }
//        
//        
//        func refreshAllEventData(from buttonType: String = "yes") {
//            SVProgressHUD.show()
//            
//            callEventDetailWebService { [weak self] in
//                guard let self = self else { return }
//                
//                print("📡 Event Detail loaded")
//                
//                // Status ke hisab se YES/NO call karo
//                if buttonType == "yes" {
//                    self.callEventYesjointWebService {
//                        print("✅ YES Join API called")
//                        self.finalizeUIRefresh()
//                    }
//                } else if buttonType == "no" {
//                    self.callEventNojointWebService {
//                        print("❌ NO Join API called")
//                        self.finalizeUIRefresh()
//                    }
//                } else {
//                    self.finalizeUIRefresh()
//                }
//            }
//        }
//        
//        func finalizeUIRefresh() {
//            DispatchQueue.main.async {
//                SVProgressHUD.dismiss()
//    //
//                self.UploadImgView.isHidden = true
//                guard let data = self.EventDetauilData else {
//                    print("❌ EventDetauilData missing")
//                    return
//                }
//
//                
//                self.UserNameLbl.text = data.createby
//                self.DateLbl.text = data.datetimeandneighbrhood
//                self.TitleLbl.text = data.title
//                self.HradingTitleLbl.text = data.title
//                self.VenueLbl.text = (data.addlineone ?? "") + (data.addlinetwo ?? "")
//                self.StartDateLbl.text = data.eventStartDate
//                self.EndDateLbl.text = data.eventEndDate
//                self.StartTimeLbl.text = data.eventStarttime
//                self.EndTimeLbl.text = data.eventEndtime
//    //            self.LikeLbl.text = data.userlikes
//                if data.eventEndtime?.isEmpty == true {
//                    self.LikeLbl.text = "0"
//                } else {
//                    self.LikeLbl.text = data.userlikes
//                }
//                self.EventDetailLbl.text = data.eventDetail
//                self.appLbl.text = data.totalJoin
//                self.DeclLbl.text = data.nojoin
//    //            self.btnTotalLIke.setTitle("\(self.EventDetauilData?.totalLike ?? "")", for: .normal)
//    //            self.btnTotalLIke.setTitleColor(#colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1), for: .normal)
//                let selectedBtnValue = data.userunjoinmemberlist?.compactMap { Int($0.status ?? "") }.first
//                self.updateUploadViewBasedOnSelectionAndStatus(selectedBtnValue)
//                self.selection = selectedBtnValue
//                
//                if let coverImageUrl = URL(string: data.coverImage ?? "") {
//                    self.profileImgView.kf.setImage(with: coverImageUrl, placeholder: UIImage(named: "EventImage"))
//                }
//                if let userPicUrl = URL(string: data.userpic ?? "") {
//                    self.UserImgView.kf.setImage(with: userPicUrl, placeholder: UIImage(named: "EventImage"))
//                }
//                
//                
//                
//                if let id = UserDefaults.standard.string(forKey: "userid"),
//                   let idCr = UserDefaults.standard.string(forKey: "usercr") {
//                    let ownerImages = self.EventDetauilData?.images?.filter { $0.type == "owner" } ?? []
//                    let userImages = self.EventDetauilData?.images?.filter { $0.type == "user" } ?? []
//                    print("ID creator is : \(idCr)")
//                    print("ID  is : \(id)")
//                    self.UploadImgView.isHidden = true
//                    if id == idCr {
//                        self.LblOwnerPhoto.isHidden = true
//                        self.LblAttendesPhoto.isHidden = true
//                        self.yesNewView.isHidden = true
//                        self.yesNewViewHeightConstraint.constant = 0
//                        self.UploadImgView.isHidden = false
//                    } else if id != idCr  {
//                        self.yesNewView.isHidden = false // Yaha tak abhi sahi hai raat ka
//                        self.yesNewViewHeightConstraint.constant = 50
//                        self.lblImgLimit.isHidden = true
//    //                    if ((self.EventDetauilData?.userjoinmemberlist?.compactMap({ Int($0.status ?? "1") }).first) != nil) {
//    //                        self.UploadImgView.isHidden = false
//    //                    } else {
//    //                        self.UploadImgView.isHidden = true
//    //                    }
//                        if let status = self.EventDetauilData?.userjoinmemberlist?.compactMap({ Int($0.status ?? "1") }).first {
//                            self.UploadImgView.isHidden = false
//                            self.LblOwnerPhoto.isHidden = false
//                        } else {
//                            self.UploadImgView.isHidden = true
//                            self.LblOwnerPhoto.isHidden = true
//                        }
//
//                    }
//                    
//                    if id == idCr {
//                        if ownerImages.isEmpty == true {
//                            self.LblOwnerPhoto.isHidden = true
//                            self.collectionViewEvent.isHidden = true
//                            self.collectionViewEventHeightConst.constant = 0
//                        }
//                        if ownerImages.isEmpty != true {
//                            self.LblOwnerPhoto.isHidden = false
//                            self.collectionViewEvent.isHidden = false
//                            self.collectionViewEventHeightConst.constant = 128
//                        }
//                        if userImages.isEmpty != true {
//                            self.LblAttendesPhoto.isHidden = false
//                            self.AttendesCollectionView.isHidden = false
//                            self.AttendesCollectionViewHeightConst.constant = 128
//                        }  else  if userImages.isEmpty == true  {
//                            self.LblOwnerPhoto.isHidden = true
//                        }
//                    }
//                    if id != idCr {
//                        if userImages.isEmpty != true {
//                            self.LblOwnerPhoto.isHidden = false
//                        } else  if userImages.isEmpty == true {
//                            self.LblOwnerPhoto.isHidden = true
//                            self.LblAttendesPhoto.isHidden = true
//                            self.UploadImgView.isHidden = true
//                        }
//
//                        
//                       
//                    }
//                }
//                
//                let ownerImages = self.EventDetauilData?.images?.filter { $0.type == "owner" } ?? []
//                let userImages = self.EventDetauilData?.images?.filter { $0.type == "user" } ?? []
//                if let userList = self.EventDetauilData?.userjoinmemberlist, !userList.isEmpty {
//                    
//                    if let userId = UserDefaults.standard.string(forKey: "userid"),
//                       let currentUser = userList.first(where: { $0.userid == userId }) {
//                        print("Status is : \(currentUser.status ?? "")")
//                       if  currentUser.status == "0" {
//                            if self.id != self.idCr {
//                                self.UploadImgView.isHidden = true
//                                self.LblOwnerPhoto.isHidden = true
//                                self.LblAttendesPhoto.isHidden = true
//                                self.collectionViewEvent.isHidden = true
//                                self.collectionViewEventHeightConst.constant = 0
//                                self.AttendesCollectionView.isHidden = true
//                                self.AttendesCollectionViewHeightConst.constant = 0
//                            }
//                        }
//                        if currentUser.status == "1" {
//                            if self.id != self.idCr {
//                                self.UploadImgView.isHidden = false
//                                if userImages.isEmpty != true {
//                                    self.AttendesCollectionView.isHidden = false
//                                    self.AttendesCollectionViewHeightConst.constant = 128
//                                    self.LblOwnerPhoto.isHidden = false
//                                    self.LblAttendesPhoto.isHidden = false
//                                } else if userImages.isEmpty == true {
//                                    self.AttendesCollectionView.isHidden = false
//                                    self.AttendesCollectionView.isHidden = true
//                                    self.AttendesCollectionViewHeightConst.constant = 0
//                                    self.LblAttendesPhoto.isHidden = true
//                                }
//                                if ownerImages.isEmpty != true {
//                                    self.UploadImgView.isHidden = false
//                                    self.collectionViewEvent.isHidden = false
//                                    self.collectionViewEventHeightConst.constant = 128
//                                    self.LblOwnerPhoto.isHidden = false
//                                } else if ownerImages.isEmpty == true {
//                                    self.UploadImgView.isHidden = false
//                                    self.collectionViewEvent.isHidden = true
//                                    self.collectionViewEventHeightConst.constant = 0
//                                    
//                                }
//                            }
//                        } else if currentUser.status == "0" {
//                            if self.id != self.idCr {
//                                self.UploadImgView.isHidden = true
//                                self.LblOwnerPhoto.isHidden = true
//                                self.LblAttendesPhoto.isHidden = true
//                                self.collectionViewEvent.isHidden = true
//                                self.collectionViewEventHeightConst.constant = 0
//                                self.AttendesCollectionView.isHidden = true
//                                self.AttendesCollectionViewHeightConst.constant = 0
//                            }
//                        }
//                    }
//                } // Build ek baad
//                
//                    if self.EventDetauilData?.iseventrunning == "0" { // for past Events ;last time
//                        self.yesNewView.isHidden = true
//                        self.UploadImgView.isHidden = true
//                        self.yesNewViewHeightConstraint.constant = 0
//                    }
//                self.collectionViewEvent.reloadData()
//                self.AttendesCollectionView.reloadData()
//                
//               
//            }
//        }
//    // Code irshad change
//        func callEventDetailWebService(_ completionClosure: @escaping () -> ()) {
//            let id = UserDefaults.standard.string(forKey: "userid")
//            let idEvent = UserDefaults.standard.string(forKey: "eventid")
//            
//            let dictParams: [String: Any] = [
//                "userid": id ?? "",
//                "eventid": idEvent ?? ""
//            ]
//            
//            print("📡 Sending params:", dictParams)
//            
//            WebService.sharedInstance.callEventDetailWebService(withParams: dictParams) { data in
//                self.EventDetauilData = data
//                
//                self.ownerImages = self.EventDetauilData?.images ?? []
//                self.userImages = self.EventDetauilData?.images ?? []
//                
//                self.ownerImages = self.EventDetauilData?.images?.filter { $0.type == "owner" } ?? []
//                if self.ownerImages.isEmpty != true {
//                    self.collectionViewEvent.isHidden = false
//                    self.collectionViewEventHeightConst.constant = 128
//                } else {
//                    self.collectionViewEvent.isHidden = true
//                    self.collectionViewEventHeightConst.constant = 0
//                }
//                
//                
//                print("✅ API Response received. Event Title: \(data.title ?? "nil")")
//                print("✅ API Response received. Data is  \(data)")
//                UserDefaults.standard.set(self.EventDetauilData?.id, forKey: "eventid")
//                UserDefaults.standard.set(self.EventDetauilData?.userid, forKey: "usercr")
//                DispatchQueue.main.async {
//                    completionClosure()
//                }
//            }
//        }
//        
//        
//        
//        func callEventDeleteListWebService(_ completionClosure: @escaping () -> ()) {
//            let id = UserDefaults.standard.string(forKey: "userid")
//            let idEvent = UserDefaults.standard.string(forKey: "eventid")
//            let dictParams: Dictionary<String, Any> = [
//                "userid":id ?? "",
//                "e_id": idEvent ?? "",
//                
//            ]
//            WebService.sharedInstance.callEventDeleteListWebService(withParams: dictParams) { data in
//                //   self.GrouDeleteData = data
//                completionClosure()
//            }
//        }
//        
//        
//        
//        func callEventImgDelWebService(for indexPath: IndexPath, completionClosure: @escaping () -> ()) {
//            let idEvent = UserDefaults.standard.string(forKey: "eventid")
//            let id = UserDefaults.standard.string(forKey: "userid")
//            
//            // Filter images where type == "owner"
//            guard let ownerImages = self.EventDetauilData?.images?.filter({ $0.type == "owner" }),
//                  indexPath.row < ownerImages.count else {
//                print("No owner images found or index out of bounds.")
//                return
//            }
//            
//            let selectedImage = ownerImages[indexPath.row]
//            
//            // Unwrap and clean the imgid
//            let rawImgId = selectedImage.imgid.flatMap { "\($0)" } ?? ""
//            let imgId: String
//            
//            if rawImgId.hasPrefix("integer(") {
//                imgId = String(rawImgId.dropFirst("integer(".count).dropLast(rawImgId.hasSuffix(")") ? 1 : 0))
//            } else if rawImgId.hasPrefix("string(\"") {
//                imgId = String(rawImgId.dropFirst("string(\"".count).dropLast(rawImgId.hasSuffix("\")") ? 2 : 0))
//            } else {
//                imgId = rawImgId
//            }
//            
//            let imgUrl = selectedImage.img ?? ""
//            
//            let dictParams: [String: Any] = [
//                "userid": id ?? "",
//                "event_id": idEvent ?? "",
//                "owner": id ?? "",
//                "imgid": imgId,
//                "imageurl": imgUrl
//            ]
//            
//            // Print to debug
//            print("dictParams:", dictParams)
//            
//            WebService.sharedInstance.callEventImgDelWebService(withParams: dictParams) { data in
//                self.DelImgData = data
//                
//                // Save values to UserDefaults
//                UserDefaults.standard.set(imgId, forKey: "imgId")
//                UserDefaults.standard.set(imgUrl, forKey: "imgUrl")
//                
//                completionClosure()
//            }
//        }
//        
//        func callEventAttendesImgDelWebService(for indexPath: IndexPath, completionClosure: @escaping () -> ()) {
//            let idEvent = UserDefaults.standard.string(forKey: "eventid")
//            let currentUserId = UserDefaults.standard.string(forKey: "userid") // Your app's logged-in user
//            
//            // Filter images where type == "user"
//            guard let userImages = self.EventDetauilData?.images?.filter({ $0.type == "user" }),
//                  indexPath.row < userImages.count else {
//                print("No user images found or index out of bounds.")
//                return
//            }
//            
//            let selectedImage = userImages[indexPath.row]
//            
//            // Extract userid from selectedImage (assuming it has a field for userid)
//            let userIdFromImage = selectedImage.userid ?? ""
//            
//            // Unwrap and clean the imgid
//            let rawImgId = selectedImage.imgid.flatMap { "\($0)" } ?? ""
//            let imgId: String
//            
//            if rawImgId.hasPrefix("integer(") {
//                imgId = String(rawImgId.dropFirst("integer(".count).dropLast(rawImgId.hasSuffix(")") ? 1 : 0))
//            } else if rawImgId.hasPrefix("string(\"") {
//                imgId = String(rawImgId.dropFirst("string(\"".count).dropLast(rawImgId.hasSuffix("\")") ? 2 : 0))
//            } else {
//                imgId = rawImgId
//            }
//            
//            let imgUrl = selectedImage.img ?? ""
//            
//            let dictParams: [String: Any] = [
//                "userid": userIdFromImage,  // Now using the userid of the image owner
//                "event_id": idEvent ?? "",
//                "owner": currentUserId ?? "", // Still using logged-in user ID
//                "imgid": imgId,
//                "imageurl": imgUrl
//            ]
//            
//            // Print to debug
//            print("dictParams:", dictParams)
//            
//            WebService.sharedInstance.callEventAttendesImgDelWebService(withParams: dictParams) { data in
//                self.DelImgData = data
//                
//                // Save values to UserDefaults
//                UserDefaults.standard.set(imgId, forKey: "imgId")
//                UserDefaults.standard.set(imgUrl, forKey: "imgUrl")
//                
//                completionClosure()
//            }
//        }
//        
//        
//        
//        func callEventYesjointWebService(_ completionClosure: @escaping () -> ()) {
//            let id = UserDefaults.standard.string(forKey: "userid")
//            let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
//            let idEvent = UserDefaults.standard.string(forKey: "eventid")
//            let UserName = UserDefaults.standard.string(forKey: "username")
//            let dictParams: Dictionary<String, Any> = [
//                "userid":id ?? "",
//                "eventid": idEvent ?? "",
//                "username":UserName ?? "",
//                "status":  "1",
//                "usercase":  "ATTEMPT",
//                ]
//            WebService.sharedInstance.callEventYesjointWebService(withParams: dictParams) { data in
//                self.EventYesData = data
//                self.callEventDetailWebService {
//                }
//                completionClosure()
//            }
//        }
//        
//        func callEventLikeWebService(_ completionClosure: @escaping () -> ()) {
//            let id = UserDefaults.standard.string(forKey: "userid")
//            let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
//            let idEvent = UserDefaults.standard.string(forKey: "eventid")
//            let UserName = UserDefaults.standard.string(forKey: "username")
//            let dictParams: Dictionary<String, Any> = [
//                "userid":id ?? "",
//                "eventid": idEvent ?? "",
//                "username":UserName ?? "",
//                "status":  "1",
//                "usercase":  "LIKES",
//                
//                
//            ]
//            WebService.sharedInstance.callEventLikeWebService(withParams: dictParams) { data in
//                self.EventYesData = data
//                //   UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
//                
//                
//                completionClosure()
//            }
//        }
//        
//        func callEventNojointWebService(_ completionClosure: @escaping () -> ()) {
//            let id = UserDefaults.standard.string(forKey: "userid")
//            let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
//            let idEvent = UserDefaults.standard.string(forKey: "eventid")
//            let UserName = UserDefaults.standard.string(forKey: "username")
//            let dictParams: Dictionary<String, Any> = [
//                "userid":id ?? "",
//                "eventid": idEvent ?? "",
//                "username":UserName ?? "",
//                "status":  "0",
//                "usercase":  "ATTEMPT",
//                ]
//            WebService.sharedInstance.callEventNojointWebService(withParams: dictParams) { data in
//                self.EventYesData = data
//                completionClosure()
//            }
//        }
//        
//        
//        func callEventUploadImgWebService(_ completionClosure: @escaping () -> ()) {
//            let id = UserDefaults.standard.string(forKey: "userid")
//            let idEvent = UserDefaults.standard.string(forKey: "eventid")
//            let dictParams: [String: Any] = [
//                "event_id": idEvent ?? "",
//                "userid": id ?? ""
//            ]
//            print("📤 Upload Parameters: \(dictParams)")
//            
//            btnUplImg.isHidden = true
//            
//            if self.from == 1 {
//                callsendImageAPI(param: dictParams, arrImage: selectedImages, imageKey: "image[]", URlName: kBASEURL + WebServiceName.kUploadImageEventt) {
//                    
//                    // ✅ Remove saved images ONLY after API upload completes
//                    UserDefaults.standard.removeObject(forKey: "savedImages")
//                    print("🗑️ Saved images removed from UserDefaults")
//                    
//                    completionClosure()
//                }
//            } else if self.from == 2 {
//                callsendImageAPI(param: dictParams, arrImage: images, imageKey: "image[]", URlName: kBASEURL + WebServiceName.kUploadImageEventt) {
//                    
//                    // ✅ Same logic here
//                    UserDefaults.standard.removeObject(forKey: "savedImages")
//                    print("🗑️ Saved images removed from UserDefaults")
//                    
//                    completionClosure()
//                }
//            }
//        }
//        
//        
//        
//        
//        
//        
//        
//    //    private func handleUserAttends(value: Int) {
//    //        switch value {
//    //        case 1:
//    //            btnyes.backgroundColor = .systemGreen
//    //            if selection != 1 {
//    //                UploadImgView.isHidden = false
//    //                collectionViewEvent.isHidden = false
//    //                AttendesCollectionView.isHidden = false
//    //                lblImgLimit.isHidden = false
//    //            }
//    //        case 0:
//    //            btnNo.backgroundColor = .systemRed
//    //            if selection != 1 {
//    //                UploadImgView.isHidden = true
//    //                collectionViewEvent.isHidden = true
//    //                AttendesCollectionView.isHidden = true
//    //                lblImgLimit.isHidden = true
//    //            }
//    //        case 2:
//    //            UploadImgView.isHidden = true
//    //            collectionViewEvent.isHidden = true
//    //            AttendesCollectionView.isHidden = true
//    //            lblImgLimit.isHidden = true
//    //        default:
//    //            break
//    //        }
//    //    }
//        
//        private func handleUserJoinStatus(value: Int) {
//            switch selection {
//            case 1:
//                UploadImgView.isHidden = false
//                collectionViewEvent.isHidden = false
//                AttendesCollectionView.isHidden = false
//                lblImgLimit.isHidden = false
//            case 0:
//    //            if selection != 1 {
//                    UploadImgView.isHidden = true
//                    collectionViewEvent.isHidden = true
//                    AttendesCollectionView.isHidden = true
//                    lblImgLimit.isHidden = true
//    //            }
//            default:
//                break
//            }
//        }
//        
//        
//        
//        
//        func callsendImageAPI(param: [String: Any], arrImage: [UIImage], imageKey: String, URlName: String, withblock: @escaping () -> Void) {
//            let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
//            
//            AF.upload(multipartFormData: { multipartFormData in
//                for (key, value) in param {
//                    if let str = value as? String {
//                        multipartFormData.append(Data(str.utf8), withName: key)
//                    }
//                }
//                
//                for (index, img) in arrImage.enumerated() {
//                    if let imgData = img.jpegData(compressionQuality: 0.7) {
//                        multipartFormData.append(imgData, withName: imageKey, fileName: "image\(index).jpeg", mimeType: "image/jpeg")
//                    } else {
//                        print("⚠️ Couldn't convert image at index \(index)")
//                    }
//                }
//                
//            }, to: URlName, method: .post, headers: headers).response { response in
//                if let data = response.data, !data.isEmpty {
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        print("✅ API Upload Response JSON: \(json)")
//                        withblock()
//                    } catch {
//                        print("❌ JSON parsing error: \(error.localizedDescription)")
//                    }
//                } else {
//                    print("❌ Empty or nil response received")
//                    print("📡 Response object: \(response)")
//                }
//                
//                if let err = response.error {
//                    print("❌ Upload failed: \(err.localizedDescription)")
//                }
//            }
//        }
//        
//        
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            var count = 0
//            
//            if collectionView == collectionViewEvent {
//    //            count = EventDetauilData?.images?.filter { $0.type == "owner" }.count ?? 0
//    //            LblOwnerPhoto.isHidden = (count == 0)  // Hide if count is 0
//                
//                if let images = EventDetauilData?.images {
//                    count = images.filter { $0.type == "owner" }.count
//                }
//    //            LblOwnerPhoto.isHidden = (count == 0)
//    //            LblOwnerPhoto.isHidden = (count == 0)
//                
//            } else if collectionView == AttendesCollectionView {
//                if let images = EventDetauilData?.images {
//                    count = images.filter { $0.type == "user" }.count
//                }
//    //            LblAttendesPhoto.isHidden = (count == 0)
//            } else {
//                count = images.count
//            }
//            
//            return count
//        }
//        
//        
//        
//        
//        
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            if collectionView == collectionViewEvent
//            {
//                
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailCollectionViewCell", for: indexPath) as! EventDetailCollectionViewCell
//                
//
//                
//                
//                if let ownerImages = EventDetauilData?.images?.filter({ $0.type == "owner" }),
//                   indexPath.row < ownerImages.count {
//                    let imageData = ownerImages[indexPath.row]
//                    let url = URL(string: imageData.img ?? "")
//
//                    if let imageUrl = url {
//                        ImageLoader.loadImage(
//                            into: cell.profileImgView,
//                            from: "\(imageUrl)",
//                            placeholder: UIImage(named: "EventImage")
//                        )
//                    } else {
//                        cell.profileImgView.image = UIImage(named: "EventImage") // Fallback image
//                    }
//
//                    
//                    // Show btnDelImg only if there are owner images
//                    cell.btnDel.isHidden = ownerImages.isEmpty
//                    
//                    cell.indexPath = indexPath
//                    cell.FullImgCallback = { [self] value in
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventEnlargementViewController") as! EventEnlargementViewController
//                        vc.url = url
//                        vc.otherImages = ownerImages.compactMap { $0.img }
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                    
//                    cell.configure(with: imageData)
//                } else {
//                    // Hide btnDelImg if no owner images are found
//                    cell.btnDel.isHidden = true
//                }
//                
//                
//                
//                if let imageData = EventDetauilData?.images?[indexPath.row] {
//                    cell.configure(with: imageData)
//                    
//                    
//                }
//                
//                if let id = UserDefaults.standard.string(forKey: "userid"),
//                   let idCr = UserDefaults.standard.string(forKey: "usercr") {
//                    print("id: \(id), idCr: \(idCr)") // Debugging output
//                    
//                    if id == idCr {
//                        cell.btnDel.isHidden = false
//                        // btnEdit.isHidden = false
//                        
//                        
//                        
//                    } else {
//                        cell.btnDel.isHidden = true
//                        
//                        
//                    }
//                } else {
//                    print("UserDefaults values are nil") // Handle nil case
//                    
//                    
//                }
//                
//                cell.DelCallback = { [self] value in
//                    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
//                    
//                    // Customize the message attributes
//                    let messageText = "Are you sure you want to delete?"
//                    let attributes: [NSAttributedString.Key: Any] = [
//                        .font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16),
//                        .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
//                    ]
//                    
//                    let attributedMessage = NSAttributedString(string: messageText, attributes: attributes)
//                    alertController.setValue(attributedMessage, forKey: "attributedMessage")
//                    let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
//                        if let indexPath = cell.indexPath {
//                            self.callEventImgDelWebService(for: indexPath) {
//                                self.callEventDetailWebService {
//    //                                self.updateMediaCount()
//                                    if !self.selectedImages.isEmpty {
//                                        self.selectedImages.remove(at: 0)
//                                    }
//                                    self.imgCountlLbl.isHidden = true
//                                    self.collectionViewEvent.reloadData()
//                                    self.AttendesCollectionView.reloadData()
//                                }
//                            }
//                        }
//                    }
//                    
//                    let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
//                    alertController.addAction(yesAction)
//                    alertController.addAction(noAction)
//                    self.present(alertController, animated: true, completion: nil)
//                }
//                return cell
//            }
//            
//            
//            if collectionView == AttendesCollectionView {
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttendesCollectionViewCell", for: indexPath) as! AttendesCollectionViewCell
//                collectionView.showsVerticalScrollIndicator = false
//                if let userImages = EventDetauilData?.images?.filter({ $0.type == "user" }), !userImages.isEmpty ,
//                   indexPath.row < userImages.count {
//                    cell.btnDel.isHidden = false
//                    let imageData = userImages[indexPath.row]
//                    if let imageUrl = imageData.img {
//                        ImageLoader.loadImage(
//                            into: cell.profileImgView,
//                            from: imageUrl,
//                            placeholder: UIImage(named: "EventImage")
//                        )
//                    } else {
//                        cell.profileImgView.image = UIImage(named: "EventImage")
//                    }
//                    cell.indexPath = indexPath
//                    
//                    
//                    
//                    
//                    cell.FullImgCallback = { [weak self] value in
//                        guard let self = self else { return }
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventEnlargementViewController") as! EventEnlargementViewController
//                        vc.url = URL(string: imageData.img ?? "")
//                        vc.otherImages = userImages.compactMap { $0.img }
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                    cell.configure(with: imageData)
//                    if  let idCr = UserDefaults.standard.string(forKey: "userid") {
//                        let imgUserId = EventDetauilData?.images?[indexPath.row].userid
//                        if idCr == imgUserId {
//                            cell.btnDel.isHidden = false
//                        } else {
//                            cell.btnDel.isHidden = true
//                        }
//                    }
//                } else {
//                    cell.profileImgView.image = UIImage(named: "EventImage") // Default image
//                }
//                
//                
//                
//                cell.DelAttendeCallback = { [self] value in
//                    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
//                    
//                    // Customize the message attributes
//                    let messageText = "Are you sure you want to delete?"
//                    let attributes: [NSAttributedString.Key: Any] = [
//                        .font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16),
//                        .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
//                    ]
//                    
//                    let attributedMessage = NSAttributedString(string: messageText, attributes: attributes)
//                    alertController.setValue(attributedMessage, forKey: "attributedMessage")
//                    
//                    let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
//                        if let indexPath = cell.indexPath {
//                            self.callEventAttendesImgDelWebService(for: indexPath) {
//                                self.callEventDetailWebService {
//                                    //                                            self.updateMediaCount()
//                                    if !self.selectedImages.isEmpty {
//                                        self.selectedImages.remove(at: 0)
//                                    }
//                                    self.imgCountlLbl.isHidden = true
//                                    //                                            self.collectionViewEvent.reloadData()
//                                    self.AttendesCollectionView.reloadData()
//                                }
//                            }
//                        }
//                    }
//                    
//                    let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
//                    
//                    alertController.addAction(yesAction)
//                    alertController.addAction(noAction)
//                    
//                    self.present(alertController, animated: true, completion: nil)
//                }
//                
//                
//                return cell
//            }
//            
//            else {
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CamPostCollectionViewCell", for: indexPath) as! CamPostCollectionViewCell
//                cell.LargeImgView.image = images[indexPath.row]
//                
//                cell.FullImgCallback = { [self] value in
//                    
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforeCamPostViewController")as! BeforeCamPostViewController
//                    vc.images = self.images.self
//                    vc.selectedIndex = indexPath.row
//                    vc.delegate = self
//                    
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    
//                    
//                }
//                
//                return cell
//            }
//        }
//        
//        
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            let itemsPerRow: CGFloat = 4
//            let spacing: CGFloat = 2
//            let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//            let totalSpacing = sectionInsets.left + sectionInsets.right + (spacing * (itemsPerRow - 1))
//            let availableWidth = collectionView.bounds.width - totalSpacing
//            let itemWidth = floor(availableWidth / itemsPerRow)
//
//            return CGSize(width: itemWidth, height: itemWidth)
//        }
//
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//            return 2
//        }
//
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            return 2
//        }
//
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//    }



import UIKit
import SVProgressHUD
import Alamofire
import Photos
import PhotosUI
import Kingfisher
import TOCropViewController  // Yaha se shuru kia din mai
@available(iOS 16.0, *)
class EventsDetailViewController: UIViewController , UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, ConfirmEventDelegate, ConfirmNoEventDelegate, ConfirmDeleteEvent, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCollectionViewControllerDelegate, TOCropViewControllerDelegate, MediaCountUpdateDelegate {
    
    func didTapDeleteButton(at index: Int) {
        
    }
    func didDeleteImage(at index: Int) {
        images.remove(at: index)
    }
    
//    @IBOutlet weak var btnTotalLIke: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
        
    @IBOutlet weak var UserNameLbl: UILabel!
    @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var UserImgView : UIImageView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var VenueLbl: UILabel!
    @IBOutlet weak var Add2Lbl: UILabel!
    @IBOutlet weak var StartDateLbl: UILabel!
    @IBOutlet weak var EndDateLbl: UILabel!
    @IBOutlet weak var StartTimeLbl: UILabel!
    @IBOutlet weak var EndTimeLbl: UILabel!
    @IBOutlet weak var LikeLbl: UILabel!
    @IBOutlet weak var EventDetailLbl: UILabel!
    @IBOutlet weak var StcStartDateLbl: UILabel!
    @IBOutlet weak var StcEndDateLbl: UILabel!
    @IBOutlet weak var StcStartTimeLbl: UILabel!
    @IBOutlet weak var StcEndTimeLbl: UILabel!
    @IBOutlet weak var HradingTitleLbl: UILabel!
    @IBOutlet weak var lblImgLimit: UILabel!
    @IBOutlet weak var LblOwnerPhoto: UILabel!
    @IBOutlet weak var LblAttendesPhoto: UILabel!
    @IBOutlet weak var LblVenue: UILabel!
    
    @IBOutlet weak var appLbl: UILabel!
    @IBOutlet weak var DeclLbl: UILabel!
    @IBOutlet weak var btnUplImg: UIButton!
    @IBOutlet weak var yesNewView: UIView!
    @IBOutlet weak var ThumbsImgView : UIImageView!
    @IBOutlet weak var UploadImgView: UIView!
    @IBOutlet weak var AttendesCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewEvent: UICollectionView!
    @IBOutlet weak var collectionViewEventHeightConst: NSLayoutConstraint!
    @IBOutlet weak var AttendesCollectionViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var eventBGViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnyes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnAccpt: UIButton!
    @IBOutlet weak var btnDec: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnPreview: UIButton!
    
    @IBOutlet weak var btnAccptIcon: UIButton!
    @IBOutlet weak var btnDeclineIcon: UIButton!
    
    @IBOutlet weak var eventDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var UploadImgHeight: NSLayoutConstraint!
    @IBOutlet weak var yesNewViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadImgViewTopConstraint: NSLayoutConstraint! // This is the space between yesNewView &  @IBOutlet weak var uploadImgViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var LblOwnerPhotoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgCountlLbl: UILabel!
    @IBOutlet weak var EventsBgView: UIView!
    @IBOutlet weak var btnSeelectPhotos: UIButton!
    
    
    var valueForScroll: Int = 0
    var eventid = ""
    var notiid = ""
    var createdBy: String?
   
    var imagesToCropQueue: [UIImage] = []
    var isCropping: Bool = false

    
    
    var EventDetauilData: EventDetailModel? {
        didSet {
            DispatchQueue.main.async {
                self.collectionViewEvent.reloadData()
                self.AttendesCollectionView.reloadData()
            }
        }
    }
    
    var EventUploadPicData : UploadEventDetailModel?
    var DelImgData : DeleteImgEventModel?
    var EventYesData : EventYesJointModel?
    var selection: Int? = 0
    var thisWidth:CGFloat = 0
    var from = 1
    var imagePicker:UIImagePickerController?
    var imageArray = [UIImage]()
    var attendeesArray = [UIImage]()
    var CamimageArray = [UIImage]()
    var images: [UIImage] = []
    var selectedImge: UIImage? = nil
    var currentImageToCrop: UIImage?
    var MarketWDeleteData : DelMarketProductModel?
    var id = UserDefaults.standard.string(forKey: "userid")
    var idCr = UserDefaults.standard.string(forKey: "usercr")
    var userImages: [ImageEvent] = []
    var ownerImages: [ImageEvent] = []
    var selectedImages: [UIImage] = []
    func tapConfirm() {
        
    }
    
    var allImages: [UIImage] {
        return selectedImages + images
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateColors()
        DispatchQueue.main.async {
            self.finalizeUIRefresh()
        }
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //            updateColors()
        SVProgressHUD.show()
        UserDefaults.standard.set(eventid, forKey: "eventid")
        DateLbl.textColor = UIColor.secondaryLabel
        collectionViewEvent.delegate = self
        collectionViewEvent.dataSource = self
        AttendesCollectionView.delegate = self
        AttendesCollectionView.dataSource = self
        NetworkMonitor.shared.startMonitoring()
        self.UserNameLbl.font = UIFont(name: "Montserrat-SemiBold", size: 16) // yaha tak back aa skte hain
        self.HradingTitleLbl.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.DateLbl.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.TitleLbl.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        self.VenueLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.LblVenue.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        self.Add2Lbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.StartDateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.EndDateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.StartTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.EndTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.LikeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.StartTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.EventDetailLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.StcStartDateLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        self.StcEndDateLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        self.StcStartTimeLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        self.StcEndTimeLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        self.lblImgLimit.font = UIFont(name: "Montserrat-Regular", size: 10)
        self.LblAttendesPhoto.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.LblOwnerPhoto.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.HradingTitleLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        btnUplImg.isHidden = true
        self.UploadImgView.isHidden = true
        super.viewDidLayoutSubviews()
        if let userAttends = self.EventDetauilData?.userunjoinmemberlist as? String {
            switch userAttends {
            case "1":
                btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                if selection != 1 {
                    UploadImgView.isHidden = false
                    lblImgLimit.isHidden = false
                }
            case "0":
                btnNo.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
                if selection != 1 {
                    UploadImgView.isHidden = true
                    lblImgLimit.isHidden = true
                }
//            case "2":
//                DispatchQueue.main.async {
//                    self.UploadImgView.isHidden = true
//                    self.lblImgLimit.isHidden = true
//                }
            default:
                break
            }
        }

        if let selectedBtnValue = self.EventDetauilData?.userunjoinmemberlist?.compactMap({ Int($0.status ?? "") }).first {
            switch selectedBtnValue {
            case 1:
                self.UploadImgView.isHidden = false
                
                self.lblImgLimit.isHidden = false
            case 0:
                if selection != 1 {
                    UploadImgView.isHidden = true
                    self.lblImgLimit.isHidden = true
                }
            default:
                break
            }
        }
        
        if let userAttends = self.EventDetauilData?.userunjoinmemberlist as? String {
            switch userAttends {
            case "1":
                btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                if selection != 1 {
                    UploadImgView.isHidden = false
                    lblImgLimit.isHidden = false
                }
            case "0":
                btnNo.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
                if selection != 1 {
                    UploadImgView.isHidden = true
                    lblImgLimit.isHidden = true
                }
//            case "2":
//                DispatchQueue.main.async {
//                    self.UploadImgView.isHidden = true
//                    self.lblImgLimit.isHidden = true
//                }
            default:
                break
            }
        }

        
        if let selectedBtnValue = self.EventDetauilData?.userunjoinmemberlist?
            .compactMap({ Int($0.status ?? "") }).first {
            
            switch selectedBtnValue {
            case 1:
                self.UploadImgView.isHidden = false
                
                self.lblImgLimit.isHidden = false
            case 0:
                if selection != 1 {
                    UploadImgView.isHidden = true
                    
                    self.lblImgLimit.isHidden = true
                }
                
            default:
                break
            }
        }
        
        if let id = UserDefaults.standard.string(forKey: "userid"),
           let idCr = UserDefaults.standard.string(forKey: "usercr") {
            print("id: \(id), idCr: \(idCr)") // Debugging output
            
            if id == idCr {
                yesNewView.isHidden = true
                // btnEdit.isHidden = false
                appLbl.isHidden = false
                DeclLbl.isHidden = false
                btnAccptIcon.isHidden = false
                btnDeclineIcon.isHidden = false
                btnAccpt.isHidden = false
                btnDec.isHidden = false
                UploadImgView.isHidden = false
                lblImgLimit.isHidden = false
                btnDelete.isHidden = false
                btnEdit.isHidden = false
            } else {
                if EventDetauilData?.userunjoinmemberlist?.compactMap({ $0.status }).contains("1") == true {
                    UploadImgView.isHidden = false
                    lblImgLimit.isHidden = false
                } else {
                    UploadImgView.isHidden = true
                    lblImgLimit.isHidden = true
                }
                yesNewView.isHidden = false
                //  btnEdit.isHidden = true
                appLbl.isHidden = true
                DeclLbl.isHidden = true
                btnAccpt.isHidden = true
                btnAccptIcon.isHidden = true
                btnDeclineIcon.isHidden = true
                btnDec.isHidden = true
                btnDelete.isHidden = true
                btnEdit.isHidden = true
            }
        } else {
            print("UserDefaults values are nil")
        }
        
        
        if imgCountlLbl.gestureRecognizers?.isEmpty ?? true {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(previewLabelTapped))
            imgCountlLbl.isUserInteractionEnabled = true
            imgCountlLbl.addGestureRecognizer(tapGesture)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Restore selection from UserDefaults
//        selection = UserDefaults.standard.integer(forKey: "selection")
        
        SVProgressHUD.show()
        callEventDetailWebService { [self] in
            SVProgressHUD.dismiss()
            
            // Reload data
            self.collectionViewEvent.reloadData()
            self.AttendesCollectionView.reloadData()
            finalizeUIRefresh()
            
            // Set labels from API
            self.UserNameLbl.text = self.EventDetauilData?.createby
            self.DateLbl.text = self.EventDetauilData?.datetimeandneighbrhood
            self.TitleLbl.text = self.EventDetauilData?.title
            self.HradingTitleLbl.text = self.EventDetauilData?.title
            self.VenueLbl.text = self.EventDetauilData?.addlineone
            self.Add2Lbl.text = self.EventDetauilData?.addlinetwo
            self.StartDateLbl.text = self.EventDetauilData?.eventStartDate
            self.EndDateLbl.text = self.EventDetauilData?.eventEndDate
            self.StartTimeLbl.text = self.EventDetauilData?.eventStarttime
            self.EndTimeLbl.text = self.EventDetauilData?.eventEndtime
//            self.LikeLbl.text = self.EventDetauilData?.userlikes
            self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
            self.appLbl.text = self.EventDetauilData?.totalJoin  ?? "0"
            self.DeclLbl.text = self.EventDetauilData?.nojoin
            self.lblImgLimit.text = "Max Images: \(self.EventDetauilData?.eventImgLimit ?? "0")"
      
            
            DispatchQueue.main.async {
                // Set Upload Section Visibility
                if let userList = self.EventDetauilData?.userjoinmemberlist, !userList.isEmpty {
                    
                    let statusList = userList.filter { $0.status == "1" || $0.status == "0" }
                    
                    if let userId = UserDefaults.standard.string(forKey: "userid"),
                       let currentUser = userList.first(where: { $0.userid == userId }), currentUser.status == "1" {
//                         self.setUploadSectionVisibility(true)
                        self.btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                        self.btnyes.setTitleColor(.white, for: .normal)
                        
                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                        self.btnNo.setTitleColor(.white, for: .normal)
                        
                    } else if self.selection == 0 {
//                         self.setUploadSectionVisibility(false)
                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.2117647059, blue: 0.04705882353, alpha: 1)
                        self.btnNo.setTitleColor(.white, for: .normal)
                        
                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                        self.btnyes.setTitleColor(.white, for: .normal)
                    } else {
                        // Optional: reset to default style
                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                        self.btnyes.setTitleColor(.white, for: .normal)
                        
                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                        self.btnNo.setTitleColor(.white, for: .normal)
                    }
                }
            }



            
            
            if let id = UserDefaults.standard.string(forKey: "userid"),
               let idCr = UserDefaults.standard.string(forKey: "usercr") {
                
                if let userList = self.EventDetauilData?.userunjoinmemberlist {
                    if userList.isEmpty == true {
                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                    }
                }
                
               
                
                
                
                if let userList = self.EventDetauilData?.userjoinmemberlist {
                    if userList.isEmpty == true {
                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                    }
                }

                if id == idCr {
                    // Owner: Show Upload View
                    self.UploadImgView.isHidden = false
                } else {
                    // Not the owner
                    if let userList = self.EventDetauilData?.userunjoinmemberlist as? [UserUnjoinMemberList], !userList.isEmpty {
                        
                        let statusList = userList.filter { $0.status == "1" || $0.status == "0" }

                        if statusList.isEmpty {
                            print("No users with status 1 or 2 found.")
//                            self.btnNo.backgroundColor = #colorLiteral(red: 0.436, green: 0.436, blue: 0.436, alpha: 1)
//                            self.btnyes.backgroundColor = #colorLiteral(red: 0.436, green: 0.436, blue: 0.436, alpha: 1)
                            self.UploadImgView.isHidden = true
                        } else {
                            print("Filtered users with status 1 or 2:")
                            for user in statusList {
                                print("Status coming for user: \(user.status ?? "0")")
//                                if user.status == "\(0)" {
//                                    self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                                    self.btnNo.backgroundColor = #colorLiteral(red: 0.749, green: 0.211, blue: 0.047, alpha: 1)
//                                } else if user.status == "\(1)" {
//                                    self.btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.501, blue: 0, alpha: 1)
//                                    self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//                                }
                            }
                        }
                    } else {
                        print("userunjoinmemberlist is nil or empty.")
                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                        self.UploadImgView.isHidden = true
                    }
                    
                    if let userList = self.EventDetauilData?.userunjoinmemberlist as? [Userjoinmemberlist], !userList.isEmpty {
                        
                        let statusList = userList.filter { $0.status == "1" || $0.status == "0" }

                        if statusList.isEmpty {
                            print("No users with status 1 or 2 found.")
//                            self.btnNo.backgroundColor = #colorLiteral(red: 0.436, green: 0.436, blue: 0.436, alpha: 1)
//                            self.btnyes.backgroundColor = #colorLiteral(red: 0.436, green: 0.436, blue: 0.436, alpha: 1)
                            self.UploadImgView.isHidden = true
                        } else {
                            print("Filtered users with status 1 or 2:")
                            for user in statusList {
                                print("Status coming for user: \(user.status ?? "0")")
                                if user.status == "\(0)" {
                                    self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                                    self.btnNo.backgroundColor = #colorLiteral(red: 0.749, green: 0.211, blue: 0.047, alpha: 1)
                                } else if user.status == "\(1)" {
                                    self.btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.501, blue: 0, alpha: 1)
                                    self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                                }
                            }
                        }
                    } else {
                        print("userunjoinmemberlist is nil or empty.")
                        self.btnNo.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                        self.btnyes.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
                        self.UploadImgView.isHidden = true
                    }

                }
            }

            
            
            
            // Thumbs image based on likes
            if self.EventDetauilData?.totalLike == "0" {
                self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup")
            } else {
                self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup.fill")
            }
            
            // Set profile & user images
            if let url = URL(string: self.EventDetauilData?.coverImage ?? "") {
                self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "EventImage"))
            }
            if let urlU = URL(string: self.EventDetauilData?.userpic ?? "") {
                self.UserImgView.kf.setImage(with: urlU, placeholder: UIImage(named: "EventImage"))
            }
            
            // Event creator check
            if let id = UserDefaults.standard.string(forKey: "userid"),
               let idCr = UserDefaults.standard.string(forKey: "usercr") {
                
                if id == idCr {
                    // This user is the creator
                    yesNewView.isHidden = true
                    btnEdit.isHidden = false
                    btnDelete.isHidden = false
                    DeclLbl.isHidden = false
                    btnAccpt.isHidden = false
                    btnDec.isHidden = false
                    btnAccptIcon.isHidden = false
                    btnDeclineIcon.isHidden = false
                } else {
                    // Regular user
                    yesNewView.isHidden = false
                    btnEdit.isHidden = true
                    btnDelete.isHidden = true
                    appLbl.isHidden = true
                    DeclLbl.isHidden = true
                    btnAccpt.isHidden = true
                    btnAccptIcon.isHidden = true
                    btnDeclineIcon.isHidden = true
                    btnDec.isHidden = true
                }
            }
            
            // If event is not running, hide upload view
            if let isEventRunning = self.EventDetauilData?.iseventrunning, Int(isEventRunning) == 0 {
                yesNewView.isHidden = true
            }
        }
    }
    @IBAction func BackButtionAction(_ : UIButton){
            self.navigationController?.popViewController(animated: true)
        }
        
        
        
        private func updateColors() {
            if traitCollection.userInterfaceStyle == .dark {
                // Dark mode colors
                UserNameLbl.textColor = .white
                DateLbl.textColor = .white
                TitleLbl.textColor = .white
                VenueLbl.textColor = .white
                Add2Lbl.textColor = .white
                DateLbl.textColor = .white
                StartDateLbl.textColor = .white
                EventsBgView.backgroundColor = .black
                imgCountlLbl.textColor = .white
                EndDateLbl.textColor = .white
                StartTimeLbl.textColor = .white
                EndTimeLbl.textColor = .white
                LikeLbl.textColor = .white
                EventDetailLbl.textColor = .white
                StcStartDateLbl.textColor = .white
                StcEndTimeLbl.textColor = .white
                StcStartTimeLbl.textColor = .white
                
                StcEndDateLbl.textColor = .white
                lblImgLimit.textColor = .white
                LblOwnerPhoto.textColor = .white
                LblAttendesPhoto.textColor = .white
                appLbl.textColor = .white
                DeclLbl.textColor = .white
                yesNewView.backgroundColor = .white
                UploadImgView.backgroundColor = .black
                yesNewView.backgroundColor = .black
                LblVenue.textColor = .white
                collectionViewEvent.backgroundColor = .black
                AttendesCollectionView.backgroundColor = .black
                UploadImgView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
                UploadImgView.layer.borderWidth = 1.0
            } else {
                // Light mode mein storyboard ke original colors preserve karna
                //            UserNameLbl.textColor = UIColor.secondaryLabel
                DateLbl.textColor = UIColor.secondaryLabel
                TitleLbl.textColor = UIColor.secondaryLabel
                VenueLbl.textColor = UIColor.secondaryLabel
                Add2Lbl.textColor = UIColor.secondaryLabel
                DateLbl.textColor = UIColor.secondaryLabel
                StartDateLbl.textColor = UIColor.secondaryLabel
                StcEndDateLbl.textColor = UIColor.secondaryLabel
                StcStartTimeLbl.textColor = UIColor.secondaryLabel
                imgCountlLbl.textColor = UIColor.secondaryLabel
                // Light mode mein PollsView ka background red karna
                EventsBgView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
                collectionViewEvent.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
                AttendesCollectionView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
                EndDateLbl.textColor = UIColor.secondaryLabel
                StartTimeLbl.textColor = UIColor.secondaryLabel
                EndTimeLbl.textColor = UIColor.secondaryLabel
                LikeLbl.textColor = UIColor.secondaryLabel
                EventDetailLbl.textColor = UIColor.secondaryLabel
                StcStartDateLbl.textColor = UIColor.secondaryLabel
                StcEndTimeLbl.textColor = UIColor.secondaryLabel
                
                lblImgLimit.textColor = UIColor.secondaryLabel
                LblOwnerPhoto.textColor = UIColor.secondaryLabel
                LblAttendesPhoto.textColor = UIColor.secondaryLabel
                appLbl.textColor = UIColor.secondaryLabel
                DeclLbl.textColor = UIColor.secondaryLabel
                LblVenue.textColor = UIColor.secondaryLabel
                // yesNewView.backgroundColor = UIColor.secondaryLabel
                UploadImgView.backgroundColor = .white
                yesNewView.backgroundColor = .white
                //  UploadImgView.isUserInteractionEnabled = tr // Disable in light mode
                UploadImgView.layer.borderWidth = 0
            }
        }
        
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateColors() // Re-apply colors on theme change
            }
        }
        
        @IBAction func PostimgAction(_ sender: UIButton) {
            print("✅ PostimgAction triggered")
            
            // 🛑 Image empty check
            if selectedImages.isEmpty {
                showAlert(message: "Please select at least one image before uploading.")
                return
            }
            
            let limitString = EventDetauilData?.eventImgLimit ?? "0"
            let limit = Int(limitString) ?? 0
            print("🟡 Selected images: \(selectedImages.count), Limit: \(limit)")
            
            if selectedImages.count > limit {
                showAlert(message: "You have already reached maximum \(limit) media limit.")
                return
            }
            
            sender.isEnabled = false // disable while uploading
         
            
            callEventUploadImgWebService {
                print("✅ Image uploaded successfully")
                self.imgCountlLbl.isHidden = true  // abdul
                
                self.callEventDetailWebService {
                    self.finalizeUIRefresh()
                    print("✅ Event details fetched")
                    DispatchQueue.main.async {
    //                    self.updateMediaCount()
                        self.collectionViewEvent.reloadData()
                        self.AttendesCollectionView.reloadData()
                        self.updateImageCollectionViewsVisibility()
                        self.view.layoutIfNeeded()
                        let ownerImages = self.EventDetauilData?.images?.filter { $0.type == "owner" } ?? []
                        let userImages = self.EventDetauilData?.images?.filter { $0.type == "user" } ?? []
                        if let userList = self.EventDetauilData?.userjoinmemberlist, !userList.isEmpty {
                            if let userId = UserDefaults.standard.string(forKey: "userid"),
                               let currentUser = userList.first(where: { $0.userid == userId }) {
                                if currentUser.status == "1" {
                                    if self.id != self.idCr {
                                        if userImages.isEmpty != true {
                                            self.AttendesCollectionView.isHidden = false
                                            self.AttendesCollectionViewHeightConst.constant = 128
                                        }
                                    }
                                }
                                if self.id == self.idCr {
                                    if ownerImages.isEmpty != true {
                                        self.collectionViewEvent.isHidden = false
                                        self.collectionViewEventHeightConst.constant = 128
                                    } else if ownerImages.isEmpty == true {
                                        self.collectionViewEvent.isHidden = true
                                        self.collectionViewEventHeightConst.constant = 0
                                    }
                                    if userImages.isEmpty != true {
                                        self.AttendesCollectionView.isHidden = false
                                        self.AttendesCollectionViewHeightConst.constant = 128
                                    } else if userImages.isEmpty == true {
                                        self.AttendesCollectionView.isHidden = true
                                        self.AttendesCollectionViewHeightConst.constant = 0
                                    }
                                }
                            }
                        }
                       
                        
                        self.LblOwnerPhoto.isHidden = ownerImages.isEmpty
                        self.LblAttendesPhoto.isHidden = userImages.isEmpty
                        self.AttendesCollectionView.isHidden = userImages.isEmpty  // ✅ Final fix here
                        print("👁️ Owner: \(ownerImages.count), User: \(userImages.count)")
                        sender.isEnabled = true
                        if !self.selectedImages.isEmpty {
                            self.selectedImages.remove(at: 0)
                        }
                    }
                    
                    self.collectionViewEvent.reloadData()
                    self.AttendesCollectionView.reloadData()
                }
            }
            
    //        callEventUploadImgWebService {}
        }
        
        
        
        func updateImageCollectionViewsVisibility() {
            let ownerCount = EventDetauilData?.images?.filter { $0.type == "owner" }.count ?? 0
            let userCount = EventDetauilData?.images?.filter { $0.type == "user" }.count ?? 0
            collectionViewEventHeightConst.constant = (ownerCount > 0) ? 128 : 0
            AttendesCollectionViewHeightConst.constant = (userCount > 0) ? 128 : 0
        }
        
        //  self.EventDetauilData?.title
        @IBAction func btnProfile(_ : UIButton) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            vc.Oid = EventDetauilData?.userid ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        @IBAction func imageTapped(_ sender: UIButton) {
            guard let imageUrl = URL(string: self.EventDetauilData?.coverImage ?? "") else { return }
            
            // Instantiate ImageEnlargeViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if different
            if let enlargeVC = storyboard.instantiateViewController(withIdentifier: "EventImageEnlargeViewController") as? EventImageEnlargeViewController {
                enlargeVC.imageUrl = imageUrl
                self.navigationController?.pushViewController(enlargeVC, animated: true)
            }
        }
        
        // Change this code btnyes Irshad malik
        @IBAction func btnYes(_ sender: UIButton) {
            btnNo.isUserInteractionEnabled = true
          
            setUploadSectionVisibility(true)
            sender.isUserInteractionEnabled = false
            btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
            btnNo.backgroundColor = #colorLiteral(red: 0.4361207187, green: 0.4361207187, blue: 0.4361207187, alpha: 1)
            btnyes.setTitleColor(.white, for: .normal)
            btnNo.setTitleColor(.white, for: .normal)
           
    //        self.finalizeUIRefresh()
            SVProgressHUD.show()
            callEventDetailWebService { [self] in
                SVProgressHUD.dismiss()
    //            self.finalizeUIRefresh()
                self .selection = 1
                if selection == 1 {
                    if let id = UserDefaults.standard.string(forKey: "userid"),
                       let idCr = UserDefaults.standard.string(forKey: "usercr") {
                        
                        let ownerImages = self.EventDetauilData?.images?.filter { $0.type == "owner" } ?? []
                        self.id = id
                        self.idCr = idCr
                        
                        if self.id != self.idCr {
                            if ownerImages.isEmpty {
                                self.LblOwnerPhoto.isHidden = true
                            }
                            
                        }
                    }
                }
                
                UserDefaults.standard.set(1, forKey: "selection")
                
                self.UserNameLbl.text = self.EventDetauilData?.createby
                self.DateLbl.text = self.EventDetauilData?.datetimeandneighbrhood
                self.TitleLbl.text = self.EventDetauilData?.title
                self.HradingTitleLbl.text = self.EventDetauilData?.title
                self.VenueLbl.text = self.EventDetauilData?.addlineone
                self.StartDateLbl.text = self.EventDetauilData?.eventStartDate
                self.EndDateLbl.text = self.EventDetauilData?.eventEndDate
                self.StartTimeLbl.text = self.EventDetauilData?.eventStarttime
                self.EndTimeLbl.text = self.EventDetauilData?.eventEndtime
                self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
                self.appLbl.text = self.EventDetauilData?.totalJoin ?? "0"
                self.DeclLbl.text = self.EventDetauilData?.nojoin
                self.handleUserJoinStatus(value: self.selection ?? 0)
                if let coverImage = self.EventDetauilData?.coverImage, let url = URL(string: coverImage) {
                    self.profileImgView.kf.indicatorType = .activity
                    self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "EventImage"))
                }
                
                if let userPic = self.EventDetauilData?.userpic, let urlU = URL(string: userPic) {
                    self.UserImgView.kf.indicatorType = .activity
                    self.UserImgView.kf.setImage(with: urlU, placeholder: UIImage(named: "EventImage"))
                }
            }
            refreshAllEventData(from: "yes")
            
        }
        
        
        @IBAction func btnNo(_ sender: UIButton) {

            btnyes.isUserInteractionEnabled = true

      
            
            btnyes.backgroundColor = #colorLiteral(red: 0.4361207187, green: 0.4361207187, blue: 0.4361207187, alpha: 1)
            btnNo.backgroundColor =  #colorLiteral(red: 0.7490196078, green: 0.2117647059, blue: 0.04705882353, alpha: 1)
            btnyes.setTitleColor(.white, for: .normal)
            btnNo.setTitleColor(.white, for: .normal)
            self.finalizeUIRefresh()
            LblOwnerPhoto.isHidden = true
            LblAttendesPhoto.isHidden = true
            setUploadSectionVisibility(false) // No dabane par hide karo
            
            callEventDetailWebService { [self] in
                SVProgressHUD.dismiss()
    //            self.finalizeUIRefresh()
                self .selection = 0
                UserDefaults.standard.set(0, forKey: "selection")
                if self.selection == 0 {
                    setUploadSectionVisibility(false)
                    self.LblOwnerPhoto.isHidden = true
                    self.LblAttendesPhoto.isHidden = true
                    self.AttendesCollectionView.isHidden  = true
                    self.AttendesCollectionViewHeightConst.constant = 0
                    self.collectionViewEvent.isHidden  = true
                    self.collectionViewEventHeightConst.constant = 0
                }
                self.UserNameLbl.text = self.EventDetauilData?.createby
                self.DateLbl.text = self.EventDetauilData?.datetimeandneighbrhood
                self.TitleLbl.text = self.EventDetauilData?.title
                self.HradingTitleLbl.text = self.EventDetauilData?.title
                self.VenueLbl.text = self.EventDetauilData?.addlineone
                self.StartDateLbl.text = self.EventDetauilData?.eventStartDate
                self.EndDateLbl.text = self.EventDetauilData?.eventEndDate
                self.StartTimeLbl.text = self.EventDetauilData?.eventStarttime
                self.EndTimeLbl.text = self.EventDetauilData?.eventEndtime
    //            self.LikeLbl.text = self.EventDetauilData?.userlikes
                self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
                self.appLbl.text = self.EventDetauilData?.totalJoin ?? "0"
                self.DeclLbl.text = self.EventDetauilData?.nojoin
                
                let selectedBtnValue = self.EventDetauilData?.userunjoinmemberlist?.compactMap({ Int($0.status ?? "0") }).first
                updateUploadViewBasedOnSelectionAndStatus(selectedBtnValue)
                self.selection = selectedBtnValue
                
                if let coverImage = self.EventDetauilData?.coverImage, let url = URL(string: coverImage) {
                    self.profileImgView.kf.indicatorType = .activity
                    self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "EventImage"))
                }
                
                if let userPic = self.EventDetauilData?.userpic, let urlU = URL(string: userPic) {
                    self.UserImgView.kf.indicatorType = .activity
                    self.UserImgView.kf.setImage(with: urlU, placeholder: UIImage(named: "EventImage"))
                }
            }
            refreshAllEventData(from: "no")
            
        }
    func setUploadSectionVisibility(_ isVisible: Bool) {
            UploadImgView.isHidden = !isVisible
    //        collectionViewEvent.isHidden = !isVisible
    //        AttendesCollectionView.isHidden = !isVisible
            lblImgLimit.isHidden = !isVisible
        }
        
        
        
        private func updateUploadViewBasedOnSelectionAndStatus(_ statusValue: Int?) {
            guard let status = statusValue else { return }
            
            if status == 1 && selection == 1 {
                setUploadSectionVisibility(true)
            } else if status == 0 && selection == 0{
                setUploadSectionVisibility(false)
            }
        }
        
        
        
        
        @IBAction func btnJoinList(_ : UIButton){
        }
        
        @IBAction func JoinPopUpBtnAction(_ sender: UIButton) {
            if EventDetauilData?.totalJoin != "0" {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttendeesVC") as! AttendeesVC
                vc.getData = EventDetauilData
                vc.isComingFrom = "Attendees"
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                self.present(nav, animated: true)
            }
        }
        
        @IBAction func EventJoinLikeListBtnAction(_ sender: UIButton) {
            if self.EventDetauilData?.totalLike != "0" {
                let vc = storyboard?.instantiateViewController(withIdentifier:"EventLikeListViewController")as! EventLikeListViewController
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.delegate = self
                vc.eventid = (EventDetauilData?.id)!
                self.present(vc , animated: true)
                
            } else {
                print("No Likes .")
            }
        }
        
        
        @IBAction func btnEdit(_ : UIButton) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateEventViewController")as! UpdateEventViewController
            vc.eventid = (EventDetauilData?.id)!
            vc.titleLabel = self.EventDetauilData?.title ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        @IBAction func NoJoinPopUpBtnAction(_ sender: UIButton) {
            if self.EventDetauilData?.userunjoinmemberlist?.isEmpty != true {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttendeesVC") as! AttendeesVC
                vc.getData = EventDetauilData
                vc.isComingFrom = "NonAttendees"
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                self.present(nav, animated: true)
            } else {
                print("No user has not joined yet.")
            }
        }
        
        @IBAction func DeletePopUpNewBtnAction(_ sender: UIButton) {
            
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            // Customizing the message font and size
            let messageText = "Are you sure you want to remove this event?"
            let attributedMessage = NSAttributedString(string: messageText, attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
                .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            ])
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            
            // Define RGB Colors
            let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)  // Green
            let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)   // Red
            
            // Yes Action
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.callEventDeleteListWebService {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            yesAction.setValue(yesColor, forKey: "titleTextColor") // Set Yes button color
            
            // No Action
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            noAction.setValue(noColor, forKey: "titleTextColor")
            
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        @IBAction func selectPhotos(_ sender: UIButton) {
            let limit = Int(EventDetauilData?.eventImgRemainLimit ?? "") ?? 0
            if selectedImages.count >= limit {
                showAlert(message: "You have already reached maximum limit.")
                return
            }
            checkCameraPermission { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    selectImages()
                    btnUplImg.isHidden = false
                }
            }
        }
        
        
        
        
        @IBAction func yesJoin(_ sender: UIButton) {
            callEventYesjointWebService{}
        }
        
        @IBAction func NoJoin(_ sender: UIButton) {
            callEventNojointWebService{}
        }
        
        @IBAction func like(_ sender: UIButton) {
            
            callEventLikeWebService{ [self] in
                callEventDetailWebService{ [self] in
                    
                    SVProgressHUD.dismiss()
                    self.collectionViewEvent.reloadData()
                    self.AttendesCollectionView.reloadData()
                    
                    self.LikeLbl.text = self.EventDetauilData?.totalLike
                    
                    if self.EventDetauilData?.totalLike == "0" {
                        self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup")
                    } else {
                        self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup.fill")
                    }
                }
            }
        }
        
        
        
        
        
        
        func showAlert(title: String = "", message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // ✅ OK button add karein, jo alert ko turant dismiss karega
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true)
        }
        
        @objc func selectImages() {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
                self.openGallery()
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(actionSheet, animated: true, completion: nil)
        }
        
        func openCamera() {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        }
        
        func openGallery() {
            var config = PHPickerConfiguration()
            let totalLimit = Int(EventDetauilData?.eventImgRemainLimit ?? "") ?? 0
            let remainingLimit = totalLimit - selectedImages.count
            config.selectionLimit = remainingLimit > 0 ? remainingLimit : 0
            config.filter = .images
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
        
        
        // MARK: - UIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true) {
                if let image = info[.originalImage] as? UIImage {
                    self.currentImageToCrop = image
                    self.openCropper(image: image)
                }
            }
        }
        
        // MARK: - PHPickerViewControllerDelegate
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            imagesToCropQueue.removeAll()  // clear any existing queue

            let dispatchGroup = DispatchGroup()

            for result in results {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                    if let image = reading as? UIImage {
                        self.imagesToCropQueue.append(image)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.cropNextImageInQueue()
            }
        }
        
        func cropNextImageInQueue() {
            guard !imagesToCropQueue.isEmpty, !isCropping else { return }
            isCropping = true

            let image = imagesToCropQueue.removeFirst()
            currentImageToCrop = image
            openCropper(image: image)
        }
        
        // MARK: - Crop Delegate
        func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
            print("✅ Image cropped successfully")
            saveSelectedImages()
            selectedImages.append(image)
            updateMediaCount()
            cropViewController.dismiss(animated: true) {
                self.isCropping = false
                self.cropNextImageInQueue()
            }
        }
        
        
        // MARK: - Open Cropper
        func openCropper(image: UIImage) {
            let cropVC = TOCropViewController(image: image)
            cropVC.delegate = self
            present(cropVC, animated: true, completion: nil)
        }
        
        func updateMediaCount() {
            DispatchQueue.main.async {
                let totalMedia = self.selectedImages.count
                self.imgCountlLbl.text = "\(totalMedia) previews"
                self.imgCountlLbl.isHidden = totalMedia == 0
                self.lblImgLimit.text = " Remaining limit \(self.EventDetauilData?.eventImgRemainLimit ?? "0")"
            }
        }
        
        // MARK: - Preview Screen
        @objc func previewLabelTapped() {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let previewVC = storyboard.instantiateViewController(withIdentifier: "BeforePostEnlargeViewController") as? BeforePostEnlargeViewController {
                    
                    print("Selected Images to send: \(selectedImages.count)")
                    previewVC.imageArray = self.selectedImages
                    UserDefaults.standard.removeObject(forKey: "savedImages")
                    previewVC.countDelegate = self
                    print("🗑️ Cleared savedImages from UserDefaults on preview open")
                    self.navigationController?.pushViewController(previewVC, animated: true)
                }
            }
        
        func didUpdateMedia(imageArray: [UIImage], videoArray: [URL]) {
                self.selectedImages = imageArray
                DispatchQueue.main.async {
                    self.updateMediaCount()
                }
            }
        
        
        
        
        func saveSelectedImages() {
            let imageDataArray = selectedImages.compactMap { $0.pngData() }
            UserDefaults.standard.set(imageDataArray, forKey: "savedImages")
        }
        
        
        func refreshAllEventData(from buttonType: String = "yes") {
            SVProgressHUD.show()
            
            callEventDetailWebService { [weak self] in
                guard let self = self else { return }
                
                print("📡 Event Detail loaded")
                
                // Status ke hisab se YES/NO call karo
                if buttonType == "yes" {
                    self.callEventYesjointWebService {
                        print("✅ YES Join API called")
                        self.finalizeUIRefresh()
                    }
                } else if buttonType == "no" {
                    self.callEventNojointWebService {
                        print("❌ NO Join API called")
                        self.finalizeUIRefresh()
                    }
                } else {
                    self.finalizeUIRefresh()
                }
            }
        }
        
        func finalizeUIRefresh() {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.UploadImgView.isHidden = true
                
                guard let data = self.EventDetauilData else {
                    print("❌ EventDetauilData missing")
                    return
                }
                
                // Set basic labels
                self.UserNameLbl.text = data.createby
                self.DateLbl.text = data.datetimeandneighbrhood
                self.TitleLbl.text = data.title
                self.HradingTitleLbl.text = data.title
                self.VenueLbl.text = (data.addlineone ?? "") + (data.addlinetwo ?? "")
                self.StartDateLbl.text = data.eventStartDate
                self.EndDateLbl.text = data.eventEndDate
                self.StartTimeLbl.text = data.eventStarttime
                self.EndTimeLbl.text = data.eventEndtime
                self.LikeLbl.text = data.eventEndtime?.isEmpty == true ? "0" : data.userlikes
                self.EventDetailLbl.text = data.eventDetail
                self.appLbl.text = data.totalJoin ?? "0"
                self.DeclLbl.text = data.nojoin
                
                // Button state
                let selectedBtnValue = data.userunjoinmemberlist?.compactMap { Int($0.status ?? "") }.first
                self.updateUploadViewBasedOnSelectionAndStatus(selectedBtnValue)
                self.selection = selectedBtnValue
                
                // Images
                if let coverImageUrl = URL(string: data.coverImage ?? "") {
                    self.profileImgView.kf.setImage(with: coverImageUrl, placeholder: UIImage(named: "EventImage"))
                }
                if let userPicUrl = URL(string: data.userpic ?? "") {
                    self.UserImgView.kf.setImage(with: userPicUrl, placeholder: UIImage(named: "EventImage"))
                }
                
                // User-specific UI logic
                if let id = UserDefaults.standard.string(forKey: "userid"),
                   let idCr = UserDefaults.standard.string(forKey: "usercr") {
                    
                    let ownerImages = data.images?.filter { $0.type == "owner" } ?? []
                    let userImages = data.images?.filter { $0.type == "user" } ?? []
                    self.id = id
                    self.idCr = idCr
                    
                    print("ID creator is : \(idCr)")
                    print("ID is : \(id)")
                    
                    if id == idCr {
                        self.yesNewView.isHidden = true
                        self.yesNewViewHeightConstraint.constant = 0
                        self.UploadImgView.isHidden = false
                        self.LblAttendesPhoto.isHidden = true
                        // Owner Images
                        
                        if ownerImages.isEmpty {
                            self.LblOwnerPhoto.isHidden = true
                            self.collectionViewEvent.isHidden = true
                            self.collectionViewEventHeightConst.constant = 0
                        } else {
                            self.LblOwnerPhoto.isHidden = false
                            self.collectionViewEvent.isHidden = false
                            self.collectionViewEventHeightConst.constant = 128
                        }

                        // User Images
                        if !userImages.isEmpty {
                            self.LblAttendesPhoto.isHidden = false
                            self.AttendesCollectionView.isHidden = false
                            self.AttendesCollectionViewHeightConst.constant = 128
                        }

                    } else {
                        self.yesNewView.isHidden = false
                        self.yesNewViewHeightConstraint.constant = 50
                        self.lblImgLimit.isHidden = true

                        // Attendee-side user image logic
                        if !userImages.isEmpty {
                            self.LblOwnerPhoto.isHidden = false
                        } else {
                            self.LblOwnerPhoto.isHidden = true
                            self.LblAttendesPhoto.isHidden = true
                            self.UploadImgView.isHidden = true
                        }
                    }

                    // User Join Status Based Image Logic
                    if let userList = data.userjoinmemberlist,
                       let currentUser = userList.first(where: { $0.userid == id }) {
                        
                        let status = currentUser.status ?? ""
                        print("Status is : \(status)")
                        
                        if status == "0" && id != idCr {
                            self.UploadImgView.isHidden = true
                            self.LblOwnerPhoto.isHidden = true
                            self.LblAttendesPhoto.isHidden = true
                            self.collectionViewEvent.isHidden = true
                            self.collectionViewEventHeightConst.constant = 0
                            self.AttendesCollectionView.isHidden = true
                            self.AttendesCollectionViewHeightConst.constant = 0
                        }
                        
                        if status == "1" && id != idCr {
                            self.UploadImgView.isHidden = false
                            
                            if ownerImages.isEmpty {
                                self.collectionViewEventHeightConst.constant = 0
                            } else {
                                self.collectionViewEvent.isHidden = false
                                self.collectionViewEventHeightConst.constant = 128
                                self.LblOwnerPhoto.isHidden = false
                            }
                            
                            if userImages.isEmpty {
                                self.AttendesCollectionView.isHidden = true
                                self.AttendesCollectionViewHeightConst.constant = 0
                                self.LblAttendesPhoto.isHidden = true
                            } else {
                                self.AttendesCollectionView.isHidden = false
                                self.AttendesCollectionViewHeightConst.constant = 128
                                self.LblOwnerPhoto.isHidden = false
                                self.LblAttendesPhoto.isHidden = false
                            }
                        }
                    }
                }
                
                // Event Status Conditions
                if data.iseventrunning == "0" {
                    self.yesNewView.isHidden = true
                    self.UploadImgView.isHidden = true
                    self.yesNewViewHeightConstraint.constant = 0
                }
                
                if data.futureeventstatus == "1" {
                    if self.id != self.idCr {
                        self.yesNewView.isHidden = false
                        self.UploadImgView.isHidden = true
                        self.yesNewViewHeightConstraint.constant = 50
                    } else {
                        self.yesNewView.isHidden = true
                        self.UploadImgView.isHidden = false
                        self.yesNewViewHeightConstraint.constant = 0
                    }
                }

                // Reload Collections
                self.collectionViewEvent.reloadData()
                self.AttendesCollectionView.reloadData()
            }
        }

        
        
        // Code irshad change
        func callEventDetailWebService(_ completionClosure: @escaping () -> ()) {
            let id = UserDefaults.standard.string(forKey: "userid")
            let idEvent = UserDefaults.standard.string(forKey: "eventid")
            
            let dictParams: [String: Any] = [
                "userid": id ?? "",
                "eventid": idEvent ?? ""
            ]
            
            print("📡 Sending params:", dictParams)
            
            WebService.sharedInstance.callEventDetailWebService(withParams: dictParams) { data in
                self.EventDetauilData = data
                
                self.ownerImages = self.EventDetauilData?.images ?? []
                self.userImages = self.EventDetauilData?.images ?? []
                
                self.ownerImages = self.EventDetauilData?.images?.filter { $0.type == "owner" } ?? []
                if self.ownerImages.isEmpty != true {
                    self.collectionViewEvent.isHidden = false
                    self.collectionViewEventHeightConst.constant = 128
                } else {
                    self.collectionViewEvent.isHidden = false
                    self.collectionViewEventHeightConst.constant = 0
                }
                
                
                print("✅ API Response received. Event Title: \(data.title ?? "nil")")
                print("✅ API Response received. Data is  \(data)")
                UserDefaults.standard.set(self.EventDetauilData?.id, forKey: "eventid")
                UserDefaults.standard.set(self.EventDetauilData?.userid, forKey: "usercr")
                DispatchQueue.main.async {
                    completionClosure()
                }
            }
        }
        
        
        
        func callEventDeleteListWebService(_ completionClosure: @escaping () -> ()) {
            let id = UserDefaults.standard.string(forKey: "userid")
            let idEvent = UserDefaults.standard.string(forKey: "eventid")
            let dictParams: Dictionary<String, Any> = [
                "userid":id ?? "",
                "e_id": idEvent ?? "",
                
            ]
            WebService.sharedInstance.callEventDeleteListWebService(withParams: dictParams) { data in
                //   self.GrouDeleteData = data
                completionClosure()
            }
        }
        
        
        
        func callEventImgDelWebService(for indexPath: IndexPath, completionClosure: @escaping () -> ()) {
            let idEvent = UserDefaults.standard.string(forKey: "eventid")
            let id = UserDefaults.standard.string(forKey: "userid")
            
            // Filter images where type == "owner"
            guard let ownerImages = self.EventDetauilData?.images?.filter({ $0.type == "owner" }),
                  indexPath.row < ownerImages.count else {
                print("No owner images found or index out of bounds.")
                return
            }
            
            let selectedImage = ownerImages[indexPath.row]
            
            // Unwrap and clean the imgid
            let rawImgId = selectedImage.imgid.flatMap { "\($0)" } ?? ""
            let imgId: String
            
            if rawImgId.hasPrefix("integer(") {
                imgId = String(rawImgId.dropFirst("integer(".count).dropLast(rawImgId.hasSuffix(")") ? 1 : 0))
            } else if rawImgId.hasPrefix("string(\"") {
                imgId = String(rawImgId.dropFirst("string(\"".count).dropLast(rawImgId.hasSuffix("\")") ? 2 : 0))
            } else {
                imgId = rawImgId
            }
            
            let imgUrl = selectedImage.img ?? ""
            
            let dictParams: [String: Any] = [
                "userid": id ?? "",
                "event_id": idEvent ?? "",
                "owner": id ?? "",
                "imgid": imgId,
                "imageurl": imgUrl
            ]
            
            // Print to debug
            print("dictParams:", dictParams)
            
            WebService.sharedInstance.callEventImgDelWebService(withParams: dictParams) { data in
                self.DelImgData = data
                
                // Save values to UserDefaults
                UserDefaults.standard.set(imgId, forKey: "imgId")
                UserDefaults.standard.set(imgUrl, forKey: "imgUrl")
                
                completionClosure()
            }
        }
        
        func callEventAttendesImgDelWebService(for indexPath: IndexPath, completionClosure: @escaping () -> ()) {
            let idEvent = UserDefaults.standard.string(forKey: "eventid")
            let currentUserId = UserDefaults.standard.string(forKey: "userid") // Your app's logged-in user
            
            // Filter images where type == "user"
            guard let userImages = self.EventDetauilData?.images?.filter({ $0.type == "user" }),
                  indexPath.row < userImages.count else {
                print("No user images found or index out of bounds.")
                return
            }
            
            let selectedImage = userImages[indexPath.row]
            
            // Extract userid from selectedImage (assuming it has a field for userid)
            let userIdFromImage = selectedImage.userid ?? ""
            
            // Unwrap and clean the imgid
            let rawImgId = selectedImage.imgid.flatMap { "\($0)" } ?? ""
            let imgId: String
            
            if rawImgId.hasPrefix("integer(") {
                imgId = String(rawImgId.dropFirst("integer(".count).dropLast(rawImgId.hasSuffix(")") ? 1 : 0))
            } else if rawImgId.hasPrefix("string(\"") {
                imgId = String(rawImgId.dropFirst("string(\"".count).dropLast(rawImgId.hasSuffix("\")") ? 2 : 0))
            } else {
                imgId = rawImgId
            }
            
            let imgUrl = selectedImage.img ?? ""
            
            let dictParams: [String: Any] = [
                "userid": userIdFromImage,  // Now using the userid of the image owner
                "event_id": idEvent ?? "",
                "owner": currentUserId ?? "", // Still using logged-in user ID
                "imgid": imgId,
                "imageurl": imgUrl
            ]
            
            // Print to debug
            print("dictParams:", dictParams)
            
            WebService.sharedInstance.callEventAttendesImgDelWebService(withParams: dictParams) { data in
                self.DelImgData = data
                
                // Save values to UserDefaults
                UserDefaults.standard.set(imgId, forKey: "imgId")
                UserDefaults.standard.set(imgUrl, forKey: "imgUrl")
                
                completionClosure()
            }
        }
        
        
        
        func callEventYesjointWebService(_ completionClosure: @escaping () -> ()) {
            let id = UserDefaults.standard.string(forKey: "userid")
            let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
            let idEvent = UserDefaults.standard.string(forKey: "eventid")
            let UserName = UserDefaults.standard.string(forKey: "username")
            let dictParams: Dictionary<String, Any> = [
                "userid":id ?? "",
                "eventid": idEvent ?? "",
                "username":UserName ?? "",
                "status":  "1",
                "usercase":  "ATTEMPT",
                ]
            WebService.sharedInstance.callEventYesjointWebService(withParams: dictParams) { data in
                self.EventYesData = data
                self.callEventDetailWebService {
                }
                completionClosure()
            }
        }
        
        func callEventLikeWebService(_ completionClosure: @escaping () -> ()) {
            let id = UserDefaults.standard.string(forKey: "userid")
            let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
            let idEvent = UserDefaults.standard.string(forKey: "eventid")
            let UserName = UserDefaults.standard.string(forKey: "username")
            let dictParams: Dictionary<String, Any> = [
                "userid":id ?? "",
                "eventid": idEvent ?? "",
                "username":UserName ?? "",
                "status":  "1",
                "usercase":  "LIKES",
                
                
            ]
            WebService.sharedInstance.callEventLikeWebService(withParams: dictParams) { data in
                self.EventYesData = data
                //   UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
                
                
                completionClosure()
            }
        }
        
        func callEventNojointWebService(_ completionClosure: @escaping () -> ()) {
            let id = UserDefaults.standard.string(forKey: "userid")
            let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
            let idEvent = UserDefaults.standard.string(forKey: "eventid")
            let UserName = UserDefaults.standard.string(forKey: "username")
            let dictParams: Dictionary<String, Any> = [
                "userid":id ?? "",
                "eventid": idEvent ?? "",
                "username":UserName ?? "",
                "status":  "0",
                "usercase":  "ATTEMPT",
                ]
            WebService.sharedInstance.callEventNojointWebService(withParams: dictParams) { data in
                self.EventYesData = data
                completionClosure()
            }
        }
        
        
        func callEventUploadImgWebService(_ completionClosure: @escaping () -> ()) {
            let id = UserDefaults.standard.string(forKey: "userid")
            let idEvent = UserDefaults.standard.string(forKey: "eventid")
            let dictParams: [String: Any] = [
                "event_id": idEvent ?? "",
                "userid": id ?? ""
            ]
            print("📤 Upload Parameters: \(dictParams)")
            
            btnUplImg.isHidden = true
            
            if self.from == 1 {
                callsendImageAPI(param: dictParams, arrImage: selectedImages, imageKey: "image[]", URlName: kBASEURL + WebServiceName.kUploadImageEventt) {
                    
                    // ✅ Remove saved images ONLY after API upload completes
                    UserDefaults.standard.removeObject(forKey: "savedImages")
                    print("🗑️ Saved images removed from UserDefaults")
                    
                    completionClosure()
                }
            } else if self.from == 2 {
                callsendImageAPI(param: dictParams, arrImage: images, imageKey: "image[]", URlName: kBASEURL + WebServiceName.kUploadImageEventt) {
                    
                    // ✅ Same logic here
                    UserDefaults.standard.removeObject(forKey: "savedImages")
                    print("🗑️ Saved images removed from UserDefaults")
                    
                    completionClosure()
                }
            }
        }
        private func handleUserJoinStatus(value: Int) {
            switch selection {
            case 1:
                UploadImgView.isHidden = false
                collectionViewEvent.isHidden = false
                AttendesCollectionView.isHidden = false
                lblImgLimit.isHidden = false
            case 0:
                if selection != 1 {
                    UploadImgView.isHidden = true
                    collectionViewEvent.isHidden = true
                    AttendesCollectionView.isHidden = true
                    lblImgLimit.isHidden = true
                }
            default:
                break
            }
        }
        
        
        
        
        func callsendImageAPI(param: [String: Any], arrImage: [UIImage], imageKey: String, URlName: String, withblock: @escaping () -> Void) {
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
            
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in param {
                    if let str = value as? String {
                        multipartFormData.append(Data(str.utf8), withName: key)
                    }
                }
                
                for (index, img) in arrImage.enumerated() {
                    if let imgData = img.jpegData(compressionQuality: 0.7) {
                        multipartFormData.append(imgData, withName: imageKey, fileName: "image\(index).jpeg", mimeType: "image/jpeg")
                    } else {
                        print("⚠️ Couldn't convert image at index \(index)")
                    }
                }
                
            }, to: URlName, method: .post, headers: headers).response { response in
                if let data = response.data, !data.isEmpty {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("✅ API Upload Response JSON: \(json)")
                        withblock()
                    } catch {
                        print("❌ JSON parsing error: \(error.localizedDescription)")
                    }
                } else {
                    print("❌ Empty or nil response received")
                    print("📡 Response object: \(response)")
                }
                
                if let err = response.error {
                    print("❌ Upload failed: \(err.localizedDescription)")
                }
            }
        }
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            var count = 0
            
            if collectionView == collectionViewEvent {
    //            count = EventDetauilData?.images?.filter { $0.type == "owner" }.count ?? 0
    //            LblOwnerPhoto.isHidden = (count == 0)  // Hide if count is 0
                
                if let images = EventDetauilData?.images {
                    count = images.filter { $0.type == "owner" }.count
                }
    //            LblOwnerPhoto.isHidden = (count == 0)
    //            LblOwnerPhoto.isHidden = (count == 0)
                
            } else if collectionView == AttendesCollectionView {
                if let images = EventDetauilData?.images {
                    count = images.filter { $0.type == "user" }.count
                }
    //            LblAttendesPhoto.isHidden = (count == 0)
            } else {
                count = images.count
            }
            
            return count
        }
        
        
        
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                if collectionView == collectionViewEvent
                {
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailCollectionViewCell", for: indexPath) as! EventDetailCollectionViewCell
                    

                    
                    
                    if let ownerImages = EventDetauilData?.images?.filter({ $0.type == "owner" }),
                       indexPath.row < ownerImages.count {
                        
                        let imageData = ownerImages[indexPath.row]
                        let imageUrl = URL(string: imageData.img ?? "")
                        
                        ImageLoader.loadImage(
                            into: cell.profileImgView,
                            from: imageData.img ?? "",
                            placeholder: UIImage(named: "EventImage")
                        )
                        
                        cell.btnDel.isHidden = ownerImages.isEmpty
                        
                        cell.indexPath = indexPath
                        cell.FullImgCallback = { [self] value in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventEnlargementViewController") as! EventEnlargementViewController
                            vc.url = imageUrl
                            vc.otherImages = ownerImages.compactMap { $0.img }
                            self.navigationController?.pushViewController(vc, animated: true)
                        }

                        cell.DelCallback = { [self] value in
                            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                            let messageText = "Are you sure you want to delete?"
                            let attributes: [NSAttributedString.Key: Any] = [
                                .font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16),
                                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                            ]
                            alertController.setValue(NSAttributedString(string: messageText, attributes: attributes), forKey: "attributedMessage")

                            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                                if let indexPath = cell.indexPath {
                                    self.callEventImgDelWebService(for: indexPath) {
                                        
                                        self.callEventDetailWebService {
                                            self.imgCountlLbl.isHidden = true
                                            self.ownerImages = self.EventDetauilData?.images?.filter { $0.type == "owner" } ?? []
                                            self.LblOwnerPhoto.isHidden = self.ownerImages.isEmpty
                                            self.collectionViewEvent.reloadData()
                                        }
                                    }
                                }
                            }

                            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                            alertController.addAction(yesAction)
                            alertController.addAction(noAction)
                            self.present(alertController, animated: true, completion: nil)
                        }

                        // Final cell setup
                        cell.configure(with: imageData)

                        // Determine delete button visibility based on userID
                        if let userId = UserDefaults.standard.string(forKey: "userid"),
                           let creatorId = UserDefaults.standard.string(forKey: "usercr") {
                            cell.btnDel.isHidden = userId != creatorId
                        } else {
                            cell.btnDel.isHidden = true
                        }

                    } else {
                        cell.btnDel.isHidden = true
                    }

                    return cell
                }
                
                
                if collectionView == AttendesCollectionView {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttendesCollectionViewCell", for: indexPath) as! AttendesCollectionViewCell
                    collectionView.showsVerticalScrollIndicator = false
                    if let userImages = EventDetauilData?.images?.filter({ $0.type == "user" }), !userImages.isEmpty,
                       indexPath.row < userImages.count {
                        
                        cell.btnDel.isHidden = false
                        let imageData = userImages[indexPath.row]
                        
                        if let imageUrl = imageData.img {
                            ImageLoader.loadImage(
                                into: cell.profileImgView,
                                from: imageUrl,
                                placeholder: UIImage(named: "EventImage")
                            )
                        } else {
                            cell.profileImgView.image = UIImage(named: "EventImage")
                        }
                        
                        cell.indexPath = indexPath
                        
                        cell.FullImgCallback = { [weak self] value in
                            guard let self = self else { return }
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventEnlargementViewController") as! EventEnlargementViewController
                            vc.url = URL(string: imageData.img ?? "")
                            vc.otherImages = userImages.compactMap { $0.img }
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                        cell.configure(with: imageData)
                        
                        if let idCr = UserDefaults.standard.string(forKey: "userid") {
                            let imgUserId = EventDetauilData?.images?[indexPath.row].userid
                            if idCr == imgUserId {
                                cell.btnDel.isHidden = false
                            } else {
                                cell.btnDel.isHidden = true
                            }
                        }
                        
                    } else {
                        cell.profileImgView.image = UIImage(named: "EventImage") // Default image
                    }

                    cell.DelAttendeCallback = { [self] value in
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        
                        let messageText = "Are you sure you want to delete?"
                        let attributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16),
                            .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                        ]
                        
                        let attributedMessage = NSAttributedString(string: messageText, attributes: attributes)
                        alertController.setValue(attributedMessage, forKey: "attributedMessage")
                        
                        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                            if let indexPath = cell.indexPath {
                                self.callEventAttendesImgDelWebService(for: indexPath) {
                                    self.callEventDetailWebService {
                                        if !self.selectedImages.isEmpty {
                                            self.selectedImages.remove(at: 0)
                                        }

                                        // ✅ Refresh userImages after deletion
                                        let updatedUserImages = self.EventDetauilData?.images?.filter { $0.type == "user" } ?? []
                                        self.userImages = updatedUserImages
                                        self.LblAttendesPhoto.isHidden = updatedUserImages.isEmpty

                                        self.imgCountlLbl.isHidden = true
                                        self.AttendesCollectionView.reloadData()
                                    }
                                }
                            }
                        }
                        
                        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                        
                        alertController.addAction(yesAction)
                        alertController.addAction(noAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }

                    
                    
                    return cell
                }
                
                else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CamPostCollectionViewCell", for: indexPath) as! CamPostCollectionViewCell
                    cell.LargeImgView.image = images[indexPath.row]
                    
                    cell.FullImgCallback = { [self] value in
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforeCamPostViewController")as! BeforeCamPostViewController
                        vc.images = self.images.self
                        vc.selectedIndex = indexPath.row
                        vc.delegate = self
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                    
                    return cell
                }
            }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let itemsPerRow: CGFloat = 4
            let spacing: CGFloat = 2
            let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

            let totalSpacing = sectionInsets.left + sectionInsets.right + (spacing * (itemsPerRow - 1))
            let availableWidth = collectionView.bounds.width - totalSpacing
            let itemWidth = floor(availableWidth / itemsPerRow)

            return CGSize(width: itemWidth, height: itemWidth)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
