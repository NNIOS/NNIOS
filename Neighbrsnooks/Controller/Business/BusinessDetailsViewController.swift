//
//  BusinessDetailsViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/08/24.
//

import UIKit
import SVProgressHUD
import AVFoundation
@available(iOS 16.0, *)
class BusinessDetailsViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, UITextViewDelegate,ConfirmBusinessDelegate, ConfirmNewDelegate, UIGestureRecognizerDelegate, ConfirmRatingDelegate {
    
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewEvent: UICollectionView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var TacosLbl: UILabel!
    @IBOutlet weak var DocTypeLbl: UILabel!
    @IBOutlet weak var lblOpen: UILabel!
    @IBOutlet weak var lblWeek: UILabel!
    @IBOutlet weak var AddressLbl: UILabel!
    @IBOutlet weak var WebLbl: UILabel!
    @IBOutlet weak var GmailLbl: UILabel!
    @IBOutlet weak var lblMob: UILabel!
    @IBOutlet weak var UserLbl: UILabel!
    @IBOutlet weak var CategoryLbl: UILabel!
    @IBOutlet weak var BussinessLbl: UILabel!
    @IBOutlet weak var RatingLbl: UILabel!
    @IBOutlet weak var ReviewLbl: UILabel!
    @IBOutlet weak var ReviewText: UILabel!
    @IBOutlet weak var LblBusinessOwner: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var tvmessage: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var lblClosedOn: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentViewLine: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bussinessView: UIView!
    
    
    @IBOutlet weak var webDataHideShow: UIImageView!
    @IBOutlet weak var gmailHideShow: UIImageView!
    @IBOutlet weak var phoneHideShow: UIImageView!
    
    @IBOutlet weak var webContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var gmailContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneContainerHeight: NSLayoutConstraint!

    @IBOutlet weak var docTypeEye: UIImageView!
    @IBOutlet weak var btnViewDoc: UIButton!
    
    @IBOutlet weak var messageReviewViewHeight: NSLayoutConstraint!
    
    var bussData = [ImageBussi]()
    var thisWidth:CGFloat = 0
    var BussinessDetailData : BusinessDetailModel?
    var ReviewCommentData : ReviewCommentModel?
    var business_id : String?
    var otherid : String?
    var BusinessDeleteData : DeleteBusinessModel?
    var id : String?
    var images: [ImageBussi] = []
    private var defaultTextColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        updateColors()
        NetworkMonitor.shared.startMonitoring()
        self.profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        self.profileImgView.clipsToBounds = true
        collectionViewEvent.delegate = self
        collectionViewEvent.dataSource = self
        placeholderLabel.numberOfLines = 0  // Infinite lines allow karna
        placeholderLabel.lineBreakMode = .byWordWrapping  // Proper text wrapping
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0 // Space between items should be 0
        collectionViewEvent.collectionViewLayout = layout
        collectionViewEvent.isPagingEnabled = false // We'll handle custom snapping
        collectionViewEvent.decelerationRate = .fast // Fast scrolling stop
        collectionViewEvent.showsHorizontalScrollIndicator = false
        // Add long press gesture recognizer to collectionViewEvent
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false // IMPORTANT
        collectionViewEvent.addGestureRecognizer(tapGesture)
        callBussinesDetailPostWebService {}
        placeholderLabel.text = "Write your review..."
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvmessage.text.isEmpty
        tvmessage.delegate = self
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: collectionViewEvent)
        if let indexPath = collectionViewEvent.indexPathForItem(at: point) {
            print("🟢 Tap detected at index: \(indexPath.row)")
        } else {
            print("🔴 Tap not recognized in collection view")
        }
    }
    
    func tapConfirm() {
        print("⭐ Rating submitted, refreshing data")
        self.callBussinesDetailPostWebService {
            self.updateBusinessDetailUI()
            
            // Optionally scroll to top if needed
            DispatchQueue.main.async {
                self.scrollView.setContentOffset(.zero, animated: true)
            }
        }
    }

    deinit {
        // Stop monitoring when the view controller is deallocated
        NetworkMonitor.shared.stopMonitoring()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        SVProgressHUD.show()
        commentView.isHidden = true
        commentViewLine.isHidden = true
        
        defaultTextColor = BussinessLbl.textColor
        //        updateColors()
        
        callBussinesDetailPostWebService{
            SVProgressHUD.dismiss()
            self.collectionViewEvent.reloadData()
            DispatchQueue.main.async {
                let allItems = self.BussinessDetailData?.image ?? []
                let hasValidData = allItems.contains { item in
                    let isImageValid = !(item.img?.isEmpty ?? true)
                    let isVideoValid = !(item.video?.isEmpty ?? true)
                    return isImageValid || isVideoValid
                }
                self.collectionViewHeightConstraint.constant = hasValidData ? 500 : 0
                self.collectionViewEvent.layoutIfNeeded()
                // 🔹 Web
                let webText = self.BussinessDetailData?.web ?? ""
                let isWebEmpty = webText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                self.WebLbl.text = webText
                self.WebLbl.isHidden = isWebEmpty
                self.webDataHideShow.isHidden = isWebEmpty
                self.webContainerHeight.constant = isWebEmpty ? 0 : 40
                // 🔹 Gmail
                let emailText = self.BussinessDetailData?.email ?? ""
                let isEmailEmpty = emailText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                self.GmailLbl.text = emailText
                self.GmailLbl.isHidden = isEmailEmpty
                self.gmailHideShow.isHidden = isEmailEmpty
                self.gmailContainerHeight.constant = isEmailEmpty ? 0 : 40
                // 🔹 Mobile
                let phoneText = self.BussinessDetailData?.mobile ?? ""
                let isPhoneEmpty = phoneText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                self.lblMob.text = phoneText
                self.lblMob.isHidden = isPhoneEmpty
                self.phoneHideShow.isHidden = isPhoneEmpty
                self.phoneContainerHeight.constant = isPhoneEmpty ? 0 : 40
                // Layout update
                self.view.layoutIfNeeded()
                
            }
            self.TacosLbl.text = self.BussinessDetailData?.description
            self.DocTypeLbl.text = self.BussinessDetailData?.doctype
            self.lblOpen.text = self.BussinessDetailData?.opentime
            self.AddressLbl.text = self.BussinessDetailData?.bisaddress
            self.WebLbl.text = self.BussinessDetailData?.web
            self.GmailLbl.text = self.BussinessDetailData?.email
            self.lblMob.text = self.BussinessDetailData?.mobile
            self.UserLbl.text = self.BussinessDetailData?.username
            self.UserLbl.textColor = #colorLiteral(red: 0.2657058537, green: 0.5550700426, blue: 0.1762118042, alpha: 1)
            self.lblWeek.text = self.BussinessDetailData?.weeklyOff
            self.CategoryLbl.text = self.BussinessDetailData?.category
            self.BussinessLbl.text = self.BussinessDetailData?.businessName
            self.lblHeading.text = self.BussinessDetailData?.businessName
            if let rating = self.BussinessDetailData?.rating, rating != "0.0", !rating.isEmpty {
                self.RatingLbl.text = rating
            } else {
                self.RatingLbl.text = "--"
            }
            
            if let review = self.BussinessDetailData?.review, review != "0", review.lowercased() != "o", !review.isEmpty {
                self.ReviewLbl.text = review
            } else {
                self.ReviewLbl.text = "No"
            }
            let url = URL(string: (self.BussinessDetailData?.userpic ?? ""))
            self.profileImgView.kf.indicatorType = .activity
            self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: ""))
            self.TacosLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.DocTypeLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
            self.lblOpen.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.AddressLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.WebLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.GmailLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.lblMob.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.UserLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.lblWeek.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.CategoryLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            // self.LblUploadDoc.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.BussinessLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
            self.RatingLbl.font = UIFont(name: "Montserrat-SemiBold", size: 14)
            self.ReviewLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            self.ReviewText.font = UIFont(name: "Montserrat-Regular", size: 12)
            self.LblBusinessOwner.font = UIFont(name: "Montserrat-Regular", size: 12)
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        updateColors()
    }
    
    
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            
            bussinessView.backgroundColor = .black
            BussinessLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            CategoryLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            TacosLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            DocTypeLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            lblOpen.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            lblWeek.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            lblMob.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            AddressLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            GmailLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            lblWeek.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            lblWeek.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            WebLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            lblClosedOn.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
        } else {
            BussinessLbl.textColor = defaultTextColor
            CategoryLbl.textColor = UIColor.secondaryLabel
            TacosLbl.textColor = UIColor.secondaryLabel
            DocTypeLbl.textColor = UIColor.secondaryLabel
            lblOpen.textColor = UIColor.secondaryLabel
            lblWeek.textColor = UIColor.secondaryLabel
            lblMob.textColor = UIColor.secondaryLabel
            AddressLbl.textColor = UIColor.secondaryLabel
            GmailLbl.textColor = UIColor.secondaryLabel
            lblWeek.textColor = UIColor.secondaryLabel
            WebLbl.textColor = UIColor.secondaryLabel
            lblClosedOn.textColor = UIColor.secondaryLabel
            bussinessView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            // tableviewBussiness.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            //            updateColors()
        }
    }
    
    // MARK: - height for textview height auto fill
    
    func textViewDidChange(_ textView: UITextView) {
        // Content ka size nikalna
        let fixedWidth = textView.frame.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        // ✅ Minimum height = 60, Maximum height = 200
        let newHeight = min(max(newSize.height, 60), 200)
        messageReviewViewHeight.constant = newHeight
        
        // ✅ Placeholder hide/show
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        // Layout update
        view.layoutIfNeeded()
    }


    
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @IBAction func btnBusinessreview(_ : UIButton) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let dictParams: [String: Any] = [
            "userid": id,
            "business_id": business_id ?? ""
        ]
        
        ActivityIndicatorManager.shared.start(in: self.view)

        WebService.sharedInstance.callBussinesReviewDetailPostWebService(withParams: dictParams) { data in
            DispatchQueue.main.async {
                ActivityIndicatorManager.shared.stop()
                
                // ✅ Check if reviews exist
                guard let reviews = data.listdata, !reviews.isEmpty else {
                    self.showAutoDismissAlert(message: "No reviews yet.")
                    return
                }
                
                // ✅ Reviews exist, open the popup
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessReviwDetailViewController") as? BusinessReviwDetailViewController else { return }
                
                vc.business_id = self.business_id
                vc.height = 200
                vc.topCornerRadius = 10.0
                vc.presentDuration = 0.5
                vc.dismissDuration = 0.5
                vc.view.backgroundColor = .white
                vc.callback = { [weak self] in
                    guard let self = self else { return }
                    print("🟢 Review deleted, reloading business details...")
                    self.callBussinesDetailPostWebService {
                        self.updateBusinessDetailUI()
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    
    @IBAction func btnreview(_ : UIButton){
//        scrollToBottom()
        commentView.isHidden = false
        commentViewLine.isHidden = false
        tvmessage.becomeFirstResponder()
        
    }
    
    //    @IBAction func openLinkButtonTapped(_ sender: UIButton) {
    //           if let url = URL(string: "https://www.example.com") {
    //               UIApplication.shared.open(url, options: [:], completionHandler: nil)
    //           }
    //       }
    
    @IBAction func openLinkButtonTapped(_ sender: UIButton) {
        if let urlString = WebLbl.text, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Handle invalid URL case
            let alert = UIAlertController(title: "Invalid URL", message: "The URL is not valid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnViewreview(_ sender: UIButton) {
        guard let documentURLString = self.BussinessDetailData?.document?.first?.doc,
              let url = URL(string: documentURLString) else {
            self.showAlert(message: "Document not found.")
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let pdfVC = storyboard.instantiateViewController(withIdentifier: "PDFViewController") as? PDFViewController {
            pdfVC.pdfURL = url
            pdfVC.shouldHideDeleteButton = true
             self.navigationController?.pushViewController(pdfVC, animated: true)
        }
    }


    @IBAction func btRating(_ : UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier:"BusinessRatingViewController")as! BusinessRatingViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc , animated: true)
        
    }
    
    @IBAction func SendBtn(_ sender: UIButton) {
        if tvmessage.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let alert = UIAlertController(title: "", message: "Please Enter review", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            callReviewCommentWebService { [weak self] in
                guard let self = self else { return }

                tvmessage.text = ""
                tvmessage.resignFirstResponder()
                self.commentView.isHidden = true
                self.commentViewLine.isHidden = true

                /// ✅ Business detail API call and UI update inside closure
                self.callBussinesDetailPostWebService {
                    DispatchQueue.main.async {
                        self.updateBusinessDetailUI()
                    }
                }
            }
        }
    }


    
    func updateBusinessDetailUI() {
        guard let data = self.BussinessDetailData else { return }

        self.TacosLbl.text = data.description
        self.DocTypeLbl.text = data.doctype
        self.lblOpen.text = data.opentime
        self.AddressLbl.text = data.bisaddress
        self.WebLbl.text = data.web
        self.GmailLbl.text = data.email
        self.lblMob.text = data.mobile
        self.UserLbl.text = data.username
        self.lblWeek.text = data.weeklyOff
        self.CategoryLbl.text = data.category
        self.BussinessLbl.text = data.businessName
        self.lblHeading.text = data.businessName

        if let rating = data.rating, rating != "0.0", !rating.isEmpty {
            self.RatingLbl.text = rating
        } else {
            self.RatingLbl.text = "--"
        }

        if let review = data.review, review != "0", review.lowercased() != "o", !review.isEmpty {
            self.ReviewLbl.text = review
        } else {
            self.ReviewLbl.text = "No"
        }

        let url = URL(string: data.userpic ?? "")
        self.profileImgView.kf.indicatorType = .activity
        self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: ""))

        // Fonts (optional: move to viewDidLoad)
        self.ReviewLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.ReviewText.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.LblBusinessOwner.font = UIFont(name: "Montserrat-Regular", size: 12)
    }

    
//    @IBAction func SendBtn(_ sender: UIButton){
//        
//        if tvmessage.text == "" {
//            let alert = UIAlertController(title: "", message: "Please Enter review", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            
//        }
//        
//        else{
//            
//            callReviewCommentWebService{ [self] in
//                tvmessage.text = ""
//                
//            }
//            
//        }
//        
//        
//    }
    
    @IBAction func DeletePopUpBtnAction(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier:"DeleteBusinessPopUpViewController")as! DeleteBusinessPopUpViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        //    vc.businessid = BusinessDeleteData?.id
        // vc.userid = GroupListData?.listdata![indexPath.row].userid ?? ""
        self.present(vc , animated: true)
        
    }
    
    @IBAction func btnProfile(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "OwnerProfileViewController") as? OwnerProfileViewController else {return}
        vc.Newid = otherid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnEdit(_ : UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateBusinessViewController") as? UpdateBusinessViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BussinessDetailData?.image?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessDetailsCollectionViewCell", for: indexPath) as! BusinessDetailsCollectionViewCell
        let imageData = BussinessDetailData?.image?[indexPath.row]
        cell.configureCell(with: imageData ?? ImageBd(img: nil, video: nil)) // Default to empty if nil
        cell.numberLabel.text = "\(indexPath.item + 1)"
        let totalNumberOfImages =  BussinessDetailData?.image?.count ?? 0
        cell.totalImagesLabel.text =  "/ \(totalNumberOfImages)"
        cell.numberLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.totalImagesLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.FullImgCallback = { [self] value in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let postEnlargeVC = storyboard.instantiateViewController(withIdentifier: "BusinessEnlargmentViewController") as? BusinessEnlargmentViewController {
                postEnlargeVC.imageUrls = BussinessDetailData?.image ?? []
                postEnlargeVC.selectedImageIndex = indexPath.row
                self.navigationController?.pushViewController(postEnlargeVC, animated: true)
            }
            
        }
        
        return cell
    }
    
    
    
    // MARK: - did select itme AT indexPath call and pass tha data
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("🟢 Collection View Item Selected at Index: \(indexPath.row)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let postEnlargeVC = storyboard.instantiateViewController(withIdentifier: "PostViewShowImgVideosDataVC") as? PostViewShowImgVideosDataVC {
            postEnlargeVC.imageUrls = BussinessDetailData?.image ?? []
            
            self.navigationController?.pushViewController(postEnlargeVC, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let images = BussinessDetailData?.image, indexPath.row < images.count else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }

        let postImage = images[indexPath.row]
        let isImageEmpty = postImage.img?.isEmpty ?? true
        let isVideoEmpty = postImage.video?.isEmpty ?? true

        if isImageEmpty && isVideoEmpty {
            return CGSize(width: collectionView.frame.width, height: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: 500)
        }
    }


    
    
    
    func callBussinesDetailPostWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        let Newid = UserDefaults.standard.string(forKey: "useidProfile")
        let Busid = UserDefaults.standard.string(forKey: "Businessid")
        let Busimg = UserDefaults.standard.string(forKey: "Businessfirstimg")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "" ,
            "business_id":business_id ?? "",]
        WebService.sharedInstance.callBussinesDetailPostWebService(withParams: dictParams) { data in
            self.BussinessDetailData = data
            if id == self.BussinessDetailData?.userid {
                self.btnEdit.isHidden = false
                self.btnDelete.isHidden = false
            } else {
                self.btnEdit.isHidden = true
                self.btnDelete.isHidden = true
            }
            //  UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
            
            //  let url = URL(string: (imgData[indexPath.row].img ?? ""))
            //   UserDefaults.standard.set(self.imgData[IndexPath.row].postid, forKey: "postid")
            UserDefaults.standard.set(self.BussinessDetailData?.userid, forKey: "useidProfile")
            UserDefaults.standard.set(self.BussinessDetailData?.id, forKey: "Businessid")
            UserDefaults.standard.set(self.BussinessDetailData?.image?.first?.img, forKey: "Businessfirstimg")
            // UserDefaults.standard.set(self.PostListData?.em.id, forKey: "id")
            // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")
            
            completionClosure()
        }
    }
    
    
    func callReviewCommentWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "business_id":business_id ?? "",
            "review": self.tvmessage.text ?? "",
        ]
        WebService.sharedInstance.callReviewCommentWebService(withParams: dictParams) { data in
            self.ReviewCommentData = data
           
            
            completionClosure()
        }
    }
    
    func callDeleteBusinessWebService(_ completionClosure: @escaping () -> ()) {
        // let id = UserDefaults.standard.string(forKey: "userid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "businessid": business_id ?? "",
            
        ]
        WebService.sharedInstance.callDeleteBusinessWebService(withParams: dictParams) { data in
            //   self.GrouDeleteData = data
            
            
            completionClosure()
        }
    }
    
    
    
    // Snapping effect to stop at the nearest item
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionViewEvent.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = collectionViewEvent.frame.width // Full screen width
        
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: CGFloat
        
        if velocity.x > 0 {
            index = ceil(estimatedIndex)
        } else if velocity.x < 0 {
            index = floor(estimatedIndex)
        } else {
            index = round(estimatedIndex)
        }
        
        targetContentOffset.pointee = CGPoint(x: index * cellWidthIncludingSpacing, y: 0)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionViewEvent {
            pauseAllVideosInVisibleCells()
        }
    }
    
    func pauseAllVideosInVisibleCells() {
        let visibleCells = collectionViewEvent.visibleCells.compactMap { $0 as? BusinessDetailsCollectionViewCell }
        
        // Visible cells mein sabhi videos pause karein
        visibleCells.forEach { cell in
            if let player = cell.player {
                player.pause()
                cell.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal) // Button ko update karein
            }
        }
    }
    
    
    
}


