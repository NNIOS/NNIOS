//
//  ReportPostViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 25/10/24.
//

import UIKit

@available(iOS 16.0, *)
class ReportPostViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,PopupSelectionDelegate, PopupSelectionReportDelegate {
    
    
    
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var collectionViewBannerHeight: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    @IBOutlet weak var lblGeneral: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblmonth: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var UserPicImgView : UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tvQuest: UITextView!
    @IBOutlet weak var tfcategory: UITextField!
    @IBOutlet weak var tpyePostLbl: UILabel!
    
    var thisWidth:CGFloat = 0
    var UserName = ""
    var sectorName = ""
    var MonthName = ""
    var GeneralName = ""
    var DescriptionlName = ""
    var CommentName = ""
    var likeName = ""
    var postid = ""
    var emoji = ""
    var timer: Timer?
    var counter = 0
    var serviceName = [String]()
    //    var imgData = [PostImage]()
    //    var imgDataAll = [postImagesN]()
    var imgDataF = [PostImageF]()
    var PostidDe = [Postlistdatum]()
    var PostListData : PostListModel?
    var ReportCatData : ReportCategory?
    var ReportFinalData : FinalReportModel?
    let placeholderText = "State your concern"
    //    var serviceDropdownData = DropDown()
    var imgDataAll: [String] = []  // Images
    var videoDataAll: [String] = [] // Videos
    var mediaData: [PostImage] = []
    var mediaDatas: [postImagesN] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(postid)
        self.view.layoutIfNeeded()

        // Check media data and update height
           if mediaData.isEmpty {
               // No media, so hide the collection view
               collectionViewBanner.isHidden = true
               collectionViewBannerHeight.constant = 0
               print("⚠️ No media found, hiding collection view")
           } else {
               // Media is present, show collection view
               collectionViewBanner.isHidden = false
               collectionViewBannerHeight.constant = 500
               print("✅ Media found, showing collection view with height 500")
           }
           
         collectionViewBanner.delegate = self
        collectionViewBanner.dataSource = self
        collectionViewBanner.reloadData()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.tvQuest.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblName.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblSector.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.lblmonth.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.lblGeneral.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblDescription.font = UIFont(name: "Montserrat-Regular", size: 16)
        tvQuest.delegate = self
        
        // Set initial placeholder
        tvQuest.text = placeholderText
        tvQuest.textColor =  .darkGray
        tvQuest.autocapitalizationType = .sentences
        
        let professionLabelTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
        tfcategory.isUserInteractionEnabled = true
        tfcategory.addGestureRecognizer(professionLabelTap)
        
        self.tpyePostLbl.font  = UIFont(name: "Montserrat-Regular", size: 16)
        self.tpyePostLbl.tintColor = .darkGray
        
        
        //        self.lblSector.font = UIFont(name: "Montserrat-Regular", size: 11)
        //        self.lblmonth.font = UIFont(name: "Montserrat-Regular", size: 11)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        lblName.text = UserName
        lblSector.text = sectorName
        lblGeneral.text = GeneralName
        lblDescription.text = DescriptionlName
        lblmonth.text = MonthName
        //  lblmonth.text = MonthName
        //        lblComment.text = CommentName
        //        lblLike.text = likeName
        
        let urlString = UserDefaults.standard.object(forKey: "userphoto") as? String
        let url = URL(string: (urlString ?? ""))
        self.UserPicImgView.kf.indicatorType = .activity
        self.UserPicImgView.kf.setImage(with:url,placeholder:UIImage(named: "My-profile"))
        callReportPostWebService(
            
            
        )
        
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func professionLabelTapped() {
        showPopup(for: 1, allowMultipleSelection: false) // Single selection for profession
    }
    
    func showPopup(for labelTag: Int, allowMultipleSelection: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "ReportDropDownViewController") as? ReportDropDownViewController {
            
            popupVC.allowMultipleSelection = allowMultipleSelection
            popupVC.labelTag = labelTag
            popupVC.delegate = self
            
            // Pass profession data if labelTag is for Profession
            if labelTag == 1 {
                // Profession
                if let professionData = ReportCatData?.listdata?.compactMap({ $0.name }) {
                    popupVC.postData = professionData  // Pass profession data to postData array
                }
            }
            // Popup style and animation
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            
            self.present(popupVC, animated: true, completion: nil)
        }
    }
    
    // Delegate method to receive selected items
    func didSelectItems(selectedItems: [String], forLabel tag: Int) {
        let selectedItemsString = selectedItems.isEmpty ? "Select" : selectedItems.joined(separator: ", ")
        
        if tag == 1 {
            // Profession selection
            tpyePostLbl.text = selectedItems.first ?? "Select" // Show only the first item for profession
        } else {
            print("Data not found")
        }
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = "" // Remove the placeholder text
            textView.textColor = UIColor.black // Change the text color to black for user input
        }
    }
    
    // UITextViewDelegate method to handle when the user finishes editing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText // Add the placeholder text back if the text view is empty
            textView.textColor = UIColor.lightGray // Set the placeholder text color to light gray
        }
    }
    
    
    @IBAction func PublishBtn(_ sender: UIButton){
        if tpyePostLbl.text == "" {
            let alert = UIAlertController(title: "", message: "Please select category", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if tvQuest.text == ""{
            let alert = UIAlertController(title: "", message: "Please Enter description", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            callReportPostFinalWebService {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportPostCollectionViewCell", for: indexPath) as? ReportPostCollectionViewCell else {
            fatalError("❌ Failed to dequeue PostBannerCollectionViewCell")
        }
        
        let media = mediaData[indexPath.row]
        
        if let imageUrl = media.img, !imageUrl.isEmpty {
            print("🖼 Setting Image: \(imageUrl)")
            if let url = URL(string: imageUrl) {
                cell.profileImgView.kf.setImage(with: url)
            }
        } else if let videoUrl = media.video, !videoUrl.isEmpty {
            print("🎥 Setting Video: \(videoUrl)")
            if let url = URL(string: videoUrl) {
                cell.configureVideo(with: url)
            }
        }
        
        return cell
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        print("Item selected at \(indexPath.row)") // Debugging line
    //        let selectedImage = imgData[indexPath.row] // Get the selected image
    //
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        if let postEnlargeImageVC = storyboard.instantiateViewController(withIdentifier: "PostEnlargeImageViewController") as? PostEnlargeImageViewController {
    //            postEnlargeImageVC.UserName = self.UserName.self
    //            postEnlargeImageVC.imgData = self.imgData.self
    //            self.navigationController?.pushViewController(postEnlargeImageVC, animated: true)
    //        }
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.collectionViewBanner.width) / 1
        return CGSize(width: thisWidth, height: 500)
    }
    
    
    
    //     MARK: - call api Report
    
    func callReportPostFinalWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idcategory = UserDefaults.standard.string(forKey: "idCategory") ?? ""
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "flag": "doreport",
            "neighbrhood":idNeighbour ?? "",
            "report_id" :postid,
            "type": "Post",
            "description": self.tvQuest.text ?? "",
            "tags": idcategory
            
        ]
        
        print("Request Parameters: \(dictParams)")
        
        WebService.sharedInstance.callReportPostFinalWebService(withParams: dictParams) { data in
            // Directly assign the PollVotedModel object to self.PollVotedData
            self.ReportFinalData = data  // Assuming data is already of type PollVotedModel
            
            // Log response data
            print("Response Data: \(self.ReportFinalData)")
            
            completionClosure()
        }
    }
    
    func callReportPostWebService() {
        
        let dictParams: Dictionary<String, Any> = ["":""]
        
        WebService.sharedInstance.callReportPostWebService(withParams: dictParams) { data in
            self.ReportCatData = data
            for value in self.ReportCatData?.listdata ?? [] {
                self.serviceName.append(value.name ?? "")
            }
            //            self.serviceDropdownData.dataSource = self.serviceName
        }
    }
}
