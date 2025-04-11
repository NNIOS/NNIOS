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
class BusinessDetailsViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, UITextViewDelegate,ConfirmBusinessDelegate, ConfirmNewDelegate, UIGestureRecognizerDelegate {
    
    
    
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
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var DocImgView : UIImageView!
    @IBOutlet weak var DocView: UIView!
    @IBOutlet weak var btnReviewHide : UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var bussData = [ImageBussi]()
    var thisWidth:CGFloat = 0
    var BussinessDetailData : BusinessDetailModel?
    var ReviewCommentData : ReviewCommentModel?
    var business_id : String?
    var otherid : String?
    var BusinessDeleteData : DeleteBusinessModel?
    var id : String?
    var images: [ImageBussi] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //   callGroupListWebService{}
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
        
        
        callBussinesDetailPostWebService{
            SVProgressHUD.dismiss()
            self.collectionViewEvent.reloadData()
            self.TacosLbl.text = self.BussinessDetailData?.description
            self.DocTypeLbl.text = self.BussinessDetailData?.doctype
            self.lblOpen.text = self.BussinessDetailData?.opentime
            
            self.AddressLbl.text = self.BussinessDetailData?.bisaddress
            self.WebLbl.text = self.BussinessDetailData?.web
            self.GmailLbl.text = self.BussinessDetailData?.email
            
            self.lblMob.text = self.BussinessDetailData?.mobile
            self.UserLbl.text = self.BussinessDetailData?.username
            
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
            self.DocTypeLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.lblOpen.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.AddressLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.WebLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.GmailLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.lblMob.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.UserLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.lblWeek.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.CategoryLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
            // self.LblUploadDoc.font = UIFont(name: "Montserrat-Regular", size: 15)
            self.BussinessLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
            self.RatingLbl.font = UIFont(name: "Montserrat-SemiBold", size: 14)
            self.ReviewLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
            self.ReviewText.font = UIFont(name: "Montserrat-Regular", size: 12)
            self.LblBusinessOwner.font = UIFont(name: "Montserrat-Regular", size: 12)
            
            
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Show or hide placeholder label based on text view content
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @IBAction func btnBusinessreview(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessReviwDetailViewController") as? BusinessReviwDetailViewController else {return}
        ActivityIndicatorManager.shared.start(in: self.view)
        vc.business_id = business_id
        vc.height = 200
        vc.topCornerRadius = 10.0
        vc.presentDuration = 0.5
        vc.dismissDuration = 0.5
        vc.view.backgroundColor = .white
        vc.callback = { range in}
        ActivityIndicatorManager.shared.stop()
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnreview(_ : UIButton){
        scrollToBottom()
        commentView.isHidden = false
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
    
    @IBAction func btnViewreview(_ : UIButton){
        
        
    }
    
    @IBAction func btnViewreviewHideden(_ : UIButton){
        
        
        
    }
    @IBAction func btnViewdocHideden(_ : UIButton){
        
        
        
    }
    
    @IBAction func btRating(_ : UIButton){
        
        let vc = storyboard?.instantiateViewController(withIdentifier:"BusinessRatingViewController")as! BusinessRatingViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc , animated: true)
        
    }
    
    @IBAction func SendBtn(_ sender: UIButton){
   
        if tvmessage.text == "" {
            let alert = UIAlertController(title: "", message: "Please Enter review", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
       
        else{
            
            callReviewCommentWebService{ [self] in
                tvmessage.text = ""
                
            }
            
        }
        
        
    }
    
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
        
        //        let url = URL(string: (BussinessDetailData?.image?[indexPath.row].img ?? ""))
        //        cell.profileImgView.kf.indicatorType = .activity
        //        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
        //
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
    
    
    //    9639851522
    
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
        thisWidth = CGFloat(self.collectionViewEvent.width) / 1
        return CGSize(width: thisWidth, height: 500)
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
            //      UserDefaults.standard.set(self.DirectMessageData?.nbdata[IndexPath.row].userpic, forKey: "id")
            //  UserDefaults.standard.set("\(self.MemberListData?.listdata.first?.id ?? 0)", forKey: "userid")
            //              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
            // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
            // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")
            
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


