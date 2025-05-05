//
//  EventsDetailViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 17/08/24.
//

import UIKit
import SVProgressHUD
import Alamofire
import Photos
import PhotosUI
import Kingfisher
import TOCropViewController
@available(iOS 16.0, *)
class EventsDetailViewController: UIViewController , UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, ConfirmEventDelegate, ConfirmNoEventDelegate, ConfirmDeleteEvent, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCollectionViewControllerDelegate {
    
    func didTapDeleteButton(at index: Int) {
        
    }
    
    
    
    func didDeleteImage(at index: Int) {
        images.remove(at: index)
    }
    
       
    @IBOutlet weak var collectionViewEvent: UICollectionView!
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
    @IBOutlet weak var collectionViewNewEvent: UICollectionView!
    @IBOutlet weak var WicketRangeCollectionView: UICollectionView!
    @IBOutlet weak var AttendesCollectionView: UICollectionView!
   
    
   
    
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
    
    var eventid = ""
    var notiid = ""
    
    var EventDetauilData : EventDetailModel?
    var EventUploadPicData : UploadEventDetailModel?
    var DelImgData : DeleteImgEventModel?
    var EventYesData : EventYesJointModel?
    var selection = 1
  //  var EventDetauilData : EventDetailModel?
    var thisWidth:CGFloat = 0
    var from = 1
    var imagePicker:UIImagePickerController?
    var imageArray = [UIImage]()
    var attendeesArray = [UIImage]()
    var CamimageArray = [UIImage]()
    var selectedImages: [UIImage] = []
    var images: [UIImage] = []
    var selectedImge: UIImage? = nil
    var MarketWDeleteData : DelMarketProductModel?
    var id = UserDefaults.standard.string(forKey: "userid")
    var idCr = UserDefaults.standard.string(forKey: "usercr")
    
    func tapConfirm() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateColors()
        DispatchQueue.main.async {
            self.updateNewViewConstraints()
            self.updateLblOwnerConstraints()
        }
        // Animate again to ensure correct layout
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
        SVProgressHUD.show()
        collectionViewEvent.delegate = self
        collectionViewEvent.dataSource = self
        AttendesCollectionView.delegate = self
        AttendesCollectionView.dataSource = self
        NetworkMonitor.shared.startMonitoring()
        self.UserNameLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.HradingTitleLbl.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.DateLbl.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.TitleLbl.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        self.VenueLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.Add2Lbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.StartDateLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.EndDateLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.StartTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        
        self.EndTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.LikeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.StartTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.EventDetailLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        
        self.StcStartDateLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.StcEndDateLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.StcStartTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        
        self.StcEndTimeLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblImgLimit.font = UIFont(name: "Montserrat-Regular", size: 10)
        self.LblAttendesPhoto.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.LblOwnerPhoto.font = UIFont(name: "Montserrat-Regular", size: 14)
        btnUplImg.isHidden = true
        
        DispatchQueue.main.async {
               self.updateNewViewConstraints()
            self.updateLblOwnerConstraints()
           }
        
        super.viewDidLayoutSubviews()
           

        
        if let userAttends = self.EventDetauilData?.userattends {
                switch userAttends {
                case .intValue(let intValue):
                    if intValue == 1 {
                        btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                        if selection != 1 {  // Ensure it doesn't override btnYes action
                            UploadImgView.isHidden = false
                            collectionViewEvent.isHidden = false
                            AttendesCollectionView.isHidden = false
                        }
                    } else if intValue == 0 {
                        btnNo.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.2117647059, blue: 0.04705882353, alpha: 1)
                        if selection != 1 {
                            UploadImgView.isHidden = true
                            collectionViewEvent.isHidden = true
                            AttendesCollectionView.isHidden = true
                        }
                    }
                case .stringValue(let stringValue):
                    if stringValue == "1" {
                        btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                        if selection != 1 {
                            UploadImgView.isHidden = false
                            collectionViewEvent.isHidden = false
                            AttendesCollectionView.isHidden = false
                        }
                    } else if stringValue == "0" {
                        btnNo.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.2117647059, blue: 0.04705882353, alpha: 1)
                        if selection != 1 {
                            UploadImgView.isHidden = true
                            collectionViewEvent.isHidden = true
                            AttendesCollectionView.isHidden = true
                        }
                    }
                    
                case .intValue(let intValue):
                    print("userAttends intValue:", intValue)  // Debugging
                    if intValue == 2 {
                        DispatchQueue.main.async {
                            self.UploadImgView.isHidden = true
                            self.collectionViewEvent.isHidden = true
                            self.AttendesCollectionView.isHidden = true
                        }
                    }

                case .stringValue(let stringValue):
                    print("userAttends stringValue:", stringValue)  // Debugging
                    if stringValue == "2" {
                        DispatchQueue.main.async {
                            self.UploadImgView.isHidden = true
                            self.collectionViewEvent.isHidden = true
                            self.AttendesCollectionView.isHidden = true
                        }
                    }

                    
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
                yesNewView.isHidden = false
              //  btnEdit.isHidden = true
                appLbl.isHidden = true
                DeclLbl.isHidden = true
                btnAccpt.isHidden = true
                btnAccptIcon.isHidden = true
                btnDeclineIcon.isHidden = true
                btnDec.isHidden = true
                UploadImgView.isHidden = true
                lblImgLimit.isHidden = true
                btnDelete.isHidden = true
                btnEdit.isHidden = true
                
            }
        } else {
            print("UserDefaults values are nil") // Handle nil case
        }

     
    }
    


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      //  self.MembersLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
       
        
        SVProgressHUD.show()
        
        
        callEventDetailWebService{ [self] in
            
            SVProgressHUD.dismiss()
            self.collectionViewEvent.reloadData()
            self.AttendesCollectionView.reloadData()
            
            updateNewViewConstraints()
            updateLblOwnerConstraints()
            
            if let futureEventStatusString = EventDetauilData?.futureeventstatus,
               let futureEventStatus = Int(futureEventStatusString),
               let eventId = UserDefaults.standard.string(forKey: "userid"),  // Ensure id exists
             //  let id = UserDefaults.standard.string(forKey: "userid")
               let idCr = UserDefaults.standard.string(forKey: "usercr") {  // Get idCr from UserDefaults

                print("Future Event Status:", futureEventStatus)
                print("Event ID:", eventId)
                print("User ID (idCr):", idCr)

                DispatchQueue.main.async {  // Ensure UI updates on main thread
                    if futureEventStatus == 0 || (futureEventStatus == 1 && eventId == idCr) {
                        self.UploadImgView.isHidden = false
                        self.lblImgLimit.isHidden = false
                    } else {
                        self.UploadImgView.isHidden = true
                        self.lblImgLimit.isHidden = true
                    }
                }
            } else {
                print("⚠️ futureeventstatus is nil, not a valid number, or id is missing")
            }








            if let imageDataArray = UserDefaults.standard.array(forKey: "savedImages") as? [Data] {
                   selectedImages = imageDataArray.compactMap { UIImage(data: $0) }
               }

            
           
            self.UserNameLbl.text = self.EventDetauilData?.createby
            self.DateLbl.text = self.EventDetauilData?.datetimeandneighbrhood
            self.TitleLbl.text = self.EventDetauilData?.title
            self.HradingTitleLbl.text = self.EventDetauilData?.title
            
            self.VenueLbl.text = self.EventDetauilData?.addlineone
            self.Add2Lbl.text = self.EventDetauilData?.addlinetwo
            self.StartDateLbl.text = self.EventDetauilData?.eventStartDate
            
            self.EndDateLbl.text = self.EventDetauilData?.eventEndDate
            self.Add2Lbl.text = self.EventDetauilData?.addlinetwo
            self.StartTimeLbl.text = self.EventDetauilData?.eventStarttime
            
            self.EndTimeLbl.text = self.EventDetauilData?.eventEndtime
            self.LikeLbl.text = self.EventDetauilData?.userlikes
            self.StartTimeLbl.text = self.EventDetauilData?.eventStarttime
            self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
            self.appLbl.text = self.EventDetauilData?.totalJoin
            self.DeclLbl.text = self.EventDetauilData?.nojoin
            self.LikeLbl.text = self.EventDetauilData?.totalLike
            
            if let userAttends = self.EventDetauilData?.userattends {
                    switch userAttends {
                    case .intValue(let intValue):
                        if intValue == 1 {
                            btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                            if selection != 1 {  // Ensure it doesn't override btnYes action
                                UploadImgView.isHidden = false
                                collectionViewEvent.isHidden = false
                                AttendesCollectionView.isHidden = false
                            }
                        } else if intValue == 0 {
                            btnNo.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.2117647059, blue: 0.04705882353, alpha: 1)
                            if selection != 1 {
                                UploadImgView.isHidden = true
                                collectionViewEvent.isHidden = true
                                AttendesCollectionView.isHidden = true
                            }
                        }
                    case .stringValue(let stringValue):
                        if stringValue == "1" {
                            btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                            if selection != 1 {
                                UploadImgView.isHidden = false
                                collectionViewEvent.isHidden = false
                                AttendesCollectionView.isHidden = false
                            }
                        } else if stringValue == "0" {
                            btnNo.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.2117647059, blue: 0.04705882353, alpha: 1)
                            if selection != 1 {
                                UploadImgView.isHidden = true
                                collectionViewEvent.isHidden = true
                                AttendesCollectionView.isHidden = true
                            }
                        }
                    }
                }
            
            profileImgView.isUserInteractionEnabled = true
               let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
               profileImgView.addGestureRecognizer(tapGesture)
            
            self.lblImgLimit.text = "Max Images: " + (self.EventDetauilData?.eventImgRemainLimit ?? "")
            var idCr = UserDefaults.standard.string(forKey: "usercr")
            
            if id == idCr {
                yesNewView.isHidden = true
                btnEdit.isHidden = false
                btnDelete.isHidden = false
                DeclLbl.isHidden = false
                btnAccpt.isHidden = false
                btnDec.isHidden = false
                
                btnAccptIcon.isHidden = false
                btnDeclineIcon.isHidden = false
                yesNewView.isHidden = true
            } else {
                yesNewView.isHidden = false
                btnEdit.isHidden = true
                btnDelete.isHidden = true
                appLbl.isHidden = true
                DeclLbl.isHidden = true
                btnAccpt.isHidden = true
                btnAccptIcon.isHidden = true
                btnDeclineIcon.isHidden = true
                btnDec.isHidden = true
               UploadImgView.isHidden = true
                lblImgLimit.isHidden = true
               
            }
            
            DispatchQueue.main.async {
                if let isEventRunning = EventDetauilData?.iseventrunning, Int(isEventRunning) == 0 {
                    yesNewView.isHidden = true
                    UploadImgView.isHidden = true
                    lblImgLimit.isHidden = true
                } else {
//                    yesNewView.isHidden = false
//                    UploadImgView.isHidden = false
//                    lblImgLimit.isHidden = false
                }

            }


            
            
            if self.EventDetauilData?.totalLike == "0" {
                self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup")
            } else {
                self.ThumbsImgView.image = UIImage(systemName: "hand.thumbsup.fill")
            }

            
          
            
            let url = URL(string: (self.EventDetauilData?.coverImage ?? ""))
            self.profileImgView.kf.indicatorType = .activity
           self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "EventImage"))
            
            let urlU = URL(string: (self.EventDetauilData?.userpic ?? ""))
            self.UserImgView.kf.indicatorType = .activity
           self.UserImgView.kf.setImage(with:urlU ,placeholder: UIImage(named: "EventImage"))
        }
      //  callEventUploadImgWebService {}
    }
    
    

    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
     //   idCr = ""
        
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
            UserNameLbl.textColor = UIColor.secondaryLabel
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
    
    func updateNewViewConstraints() {
        if yesNewView.isHidden {
            yesNewViewHeightConstraint.constant = 0
            uploadImgViewTopConstraint.constant = 0 // No gap when hidden
        } else {
            yesNewViewHeightConstraint.constant = 60 // Set the original height of yesNewView
            uploadImgViewTopConstraint.constant = 5  // Maintain a 20-point gap when visible
        }

        // Animate the layout update
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updateLblOwnerConstraints() {
        if UploadImgView.isHidden {
            uploadImgViewTopConstraint.constant = 0
            LblOwnerPhotoTopConstraint.constant = 0 // No gap when hidden
        } else {
            uploadImgViewTopConstraint.constant = 5 // Set the original height of yesNewView
            LblOwnerPhotoTopConstraint.constant = 5  // Maintain a 20-point gap when visible
        }

        // Animate the layout update
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    
    @IBAction func PostimgAction(_ : UIButton){

        callEventUploadImgWebService {}

    }
  //  self.EventDetauilData?.title
    @IBAction func btnProfile(_ : UIButton){
        
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
            
            // Present the ImageEnlargeViewController modally
         //   self.present(enlargeVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(enlargeVC, animated: true)
            // OR push to the navigation stack if you prefer
            // self.navigationController?.pushViewController(enlargeVC, animated: true)
        }
    }
    
    @IBAction func btnYes(_ sender: UIButton) {
        selection = 1  // ✅ यह flag सेट करेगा कि user ने manually Yes दबाया है।

            btnyes.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
            btnNo.backgroundColor = #colorLiteral(red: 0.6286745071, green: 0.6286745071, blue: 0.6286745071, alpha: 1)

            btnyes.setTitleColor(.white, for: .normal)
            btnNo.setTitleColor(.white, for: .normal)

            // ✅ UI को तुरंत दिखाएं
            UploadImgView.isHidden = false
            collectionViewEvent.isHidden = false
            AttendesCollectionView.isHidden = false

        DispatchQueue.main.async { [self] in
                self.collectionViewEvent.reloadData()
                self.AttendesCollectionView.reloadData()
                
                if let data = EventDetauilData {
                    if data.futureeventstatus == "0" {
                        UploadImgView.isHidden = false
                        lblImgLimit.isHidden = false
                    } else if data.futureeventstatus == "1" {
                        UploadImgView.isHidden = true
                        lblImgLimit.isHidden = true
                    }
                } else {
                    print("EventDetauilData is nil")
                }
            }

            // ✅ API कॉल करने के बाद UI को ऑटो-हाइड करने से बचाएं
            callEventDetailWebService { [self] in
                SVProgressHUD.dismiss()

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
                self.LikeLbl.text = self.EventDetauilData?.userlikes
                self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
                self.appLbl.text = self.EventDetauilData?.totalJoin
                self.DeclLbl.text = self.EventDetauilData?.nojoin

              //  lblImgLimit.isHidden = false

                // ✅ अगर UI पहले से visible है तो इसे hide ना करें
                if collectionViewEvent.isHidden == false && AttendesCollectionView.isHidden == false {
                    return
                }

//                if EventDetauilData?.futureeventstatus == "0" {
//                    UploadImgView.isHidden = false
//                    lblImgLimit.isHidden = false
//                } else if EventDetauilData?.futureeventstatus == "1" {
//                    UploadImgView.isHidden = true
//                    lblImgLimit.isHidden = true
//                }

                DispatchQueue.main.async {
                    self.collectionViewEvent.reloadData()
                    self.AttendesCollectionView.reloadData()
                }

                if let coverImageUrl = URL(string: self.EventDetauilData?.coverImage ?? "") {
                    self.profileImgView.kf.indicatorType = .activity
                    self.profileImgView.kf.setImage(with: coverImageUrl, placeholder: UIImage(named: "EventImage"))
                }

                if let userPicUrl = URL(string: self.EventDetauilData?.userpic ?? "") {
                    self.UserImgView.kf.indicatorType = .activity
                    self.UserImgView.kf.setImage(with: userPicUrl, placeholder: UIImage(named: "EventImage"))
                }
            }
    }
    
    @IBAction func btnNo(_ sender: UIButton) {
        selection = 2

            // तुरंत Labels को हाइड करें
            self.LblOwnerPhoto.isHidden = true
            self.LblAttendesPhoto.isHidden = true

            btnyes.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.7764705882, blue: 0.7725490196, alpha: 1)
            btnNo.backgroundColor =  #colorLiteral(red: 0.7490196078, green: 0.2117647059, blue: 0.04705882353, alpha: 1)

            btnyes.setTitleColor(.white, for: .normal)
            btnNo.setTitleColor(.white, for: .normal)

            callEventDetailWebService { [self] in
                print("Web service completed")  // Debugging line
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.collectionViewEvent.reloadData()
                    self.AttendesCollectionView.reloadData()
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
                    self.LikeLbl.text = self.EventDetauilData?.userlikes
                    self.EventDetailLbl.text = self.EventDetauilData?.eventDetail
                    self.appLbl.text = self.EventDetauilData?.totalJoin
                    self.DeclLbl.text = self.EventDetauilData?.nojoin

                    // सभी Views को छिपाएँ
                    self.collectionViewEvent.isHidden = true
                    self.UploadImgView.isHidden = true
                    self.lblImgLimit.isHidden = true
                    self.AttendesCollectionView.isHidden = true

                    // Labels को फिर से हाइड करें ताकि यह API कॉल के बाद visible न हों
                    DispatchQueue.main.async {
                        self.LblOwnerPhoto.isHidden = true
                        self.LblAttendesPhoto.isHidden = true
                    }

                    
                    print("LblOwnerPhoto hidden:", self.LblOwnerPhoto.isHidden)
                    print("LblAttendesPhoto hidden:", self.LblAttendesPhoto.isHidden)

                    if let coverImage = self.EventDetauilData?.coverImage, let url = URL(string: coverImage) {
                        self.profileImgView.kf.indicatorType = .activity
                        self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "EventImage"))
                    }

                    if let userPic = self.EventDetauilData?.userpic, let urlU = URL(string: userPic) {
                        self.UserImgView.kf.indicatorType = .activity
                        self.UserImgView.kf.setImage(with: urlU, placeholder: UIImage(named: "EventImage"))
                    }

                    print("UI Updated Successfully")  // Debugging line
                }
            }
    }
    
    @IBAction func btnJoinList(_ : UIButton){



    }
    
    @IBAction func JoinPopUpBtnAction(_ sender: UIButton) {
      
        let vc = storyboard?.instantiateViewController(withIdentifier:"EventJoinListViewController")as! EventJoinListViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        vc.eventid = (EventDetauilData?.id)!
    
        self.present(vc , animated: true)

   }
    
    @IBAction func EventJoinLikeListBtnAction(_ sender: UIButton) {
      
        let vc = storyboard?.instantiateViewController(withIdentifier:"EventLikeListViewController")as! EventLikeListViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        vc.eventid = (EventDetauilData?.id)!
    
        self.present(vc , animated: true)

   }
    
    
    @IBAction func btnEdit(_ : UIButton){

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateEventViewController")as! UpdateEventViewController
        
        vc.eventid = (EventDetauilData?.id)!
        self.navigationController?.pushViewController(vc, animated: true)
       }
    
    @IBAction func NoJoinPopUpBtnAction(_ sender: UIButton) {
      
        let vc = storyboard?.instantiateViewController(withIdentifier:"EventNoJoinViewController")as! EventNoJoinViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        vc.eventid = (EventDetauilData?.id)!
    //    vc.businessid = BusinessDeleteData?.id
       // vc.userid = GroupListData?.listdata![indexPath.row].userid ?? ""
        self.present(vc , animated: true)

   }
    

//
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
                    // Pop one screen back after the API call is successful
                    self.navigationController?.popViewController(animated: true)
                }
            }
            yesAction.setValue(yesColor, forKey: "titleTextColor") // Set Yes button color

            // No Action
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            noAction.setValue(noColor, forKey: "titleTextColor") // Set No button color

            alertController.addAction(yesAction)
            alertController.addAction(noAction)

            // Present the alert
            self.present(alertController, animated: true, completion: nil)
   }
    
    
    
    @IBAction func selectPhotos(_ sender: UIButton) {
       
     //   self.lblImgLimit.text = "Images remaining: " + (self.EventDetauilData?.eventImgRemainLimit ?? "")
        if EventDetauilData?.eventImgRemainLimit == "0" {
            
               // Show a popup alert
               let alert = UIAlertController(title: "Limit Exceeded", message: "You have reached the image limit.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           } else {
               selectImages()
               btnUplImg.isHidden = false
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
   
    func updateImageCountLabel() {
        DispatchQueue.main.async {
            self.imgCountlLbl.text = "Images: \(self.selectedImages.count + self.images.count)"
        }
    }



    @IBAction func previewButtonTapped(_ sender: UIButton) {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           if let previewVC = storyboard.instantiateViewController(withIdentifier: "PreviewEventDetailViewController") as? PreviewEventDetailViewController {
               previewVC.selectedImages = self.selectedImages // Pass the selected images
               previewVC.images = self.images
               
               self.navigationController?.pushViewController(previewVC, animated: true)
           }
       }
    
    
    @objc func selectImages() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.btnUplImg.isHidden = true
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }


    
    func openCamera() {
        from = 2
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
    }
//
//    func openGallery() {
//         from = 1
//             var config = PHPickerConfiguration()
//             config.selectionLimit = 0 // 0 means no limit
//             config.filter = .images
//
//             let picker = PHPickerViewController(configuration: config)
//             picker.delegate = self
//             present(picker, animated: true, completion: nil)
//         }
 
    func openGallery() {
        from = 1
        
        // Get the remaining limit from the label text
        let limitText = self.lblImgLimit.text?.replacingOccurrences(of: "Max Images: ", with: "") ?? "0"
        let selectionLimit = Int(limitText) ?? 0
        
        var config = PHPickerConfiguration()
        config.selectionLimit = selectionLimit  // set limit from lblImgLimit
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    
    func presentCropViewController(image: UIImage) {
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    self.presentCropViewController(image: image)
                    self.images.append(image)
                    self.updateImageCountLabel() // Update count label
                    //  self.presentCropViewController(image: image)
                    self.WicketRangeCollectionView.reloadData()
                    self.collectionViewNewEvent.reloadData()
                    self.updateImageCountLabel()
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
    
   

    

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        let group = DispatchGroup()

        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let imageNew = object as? UIImage {
                   // self.showCrop(image: imageNew)
                    self.selectedImages.append(imageNew) // Add image to the array
                    self.imageArray.append(imageNew)
                    
                    self.selectedImge = imageNew
                    DispatchQueue.main.async {
                        self.presentCropViewController(image: imageNew)
                        self.collectionViewEvent.reloadData()
                        self.AttendesCollectionView.reloadData()
                    }
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.updateImageCountLabel() // Update count label after all images are loaded
        }
    }


    func callEventDetailWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "usercr")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "eventid": eventid ?? "",
                                                   
                                                                        ]
          WebService.sharedInstance.callEventDetailWebService(withParams: dictParams) { data in
            self.EventDetauilData = data
              UserDefaults.standard.set(self.EventDetauilData?.id, forKey: "eventid")
              UserDefaults.standard.set(self.EventDetauilData?.userid, forKey: "usercr")
              
              

            completionClosure()
          }
        }
    
    func callEventDeleteListWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
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
        let idName = UserDefaults.standard.string(forKey: "name")
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
           //   UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
           

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
           //   UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
           

            completionClosure()
          }
        }
    
    
    func callEventUploadImgWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
          let dictParams: Dictionary<String, Any> = [
                                                     
                                                    "event_id": idEvent ?? "",
                                                    "userid":id ?? "",
                                                                        ]
        if self.from == 1
        {
            
            callsendImageAPI(param: dictParams, arrImage: imageArray, imageKey: "image[]", URlName: kBASEURL + WebServiceName.kUploadImageEventt, withblock: {
                
                self.navigationController?.popViewController(animated: true)
            })
//            callsendImageAPI(param: dictParams, arrImage: imageArray, imageKey: "document[]", URlName: kBASEURL + WebServiceName.kCreateBussines, withblock: {
//
//                self.navigationController?.popViewController(animated: true)
//            })
        }
        else if self.from == 2
        {
            callsendImageAPI(param: dictParams, arrImage: images, imageKey: "image[]", URlName: kBASEURL + WebServiceName.kUploadImageEventt, withblock: {
                
                self.navigationController?.popViewController(animated: true)
            })
            
        }
        }
    
    func callsendImageAPI(param:[String: Any],arrImage:[UIImage],imageKey:String,URlName:String, withblock:@escaping ()->Void){

        let headers: HTTPHeaders
        headers = ["Content-type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            
            for img in arrImage {
            guard let imgData = img.jpegData(compressionQuality:0.1) else { return }
            multipartFormData.append(imgData, withName: imageKey, fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
//            guard let imgData2 = self.profilePic.image?.jpegData(compressionQuality: 1) else { return }
//            multipartFormData.append(imgData, withName: "aadharBack", fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
            
            }
            
            
        },to: URL.init(string: URlName)!, usingThreshold: UInt64.init(),
          method: .post,
          headers: headers).response{ response in
            
            if((response.error == nil)){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                        withblock()
                     //   withblock(parsedData)
//                        let status = parsedData[Message.Status] as? NSInteger ?? 0
//
//                        if (status == 1){
                            if let jsonArray = parsedData["data"] as? [[String: Any]] {
                               
                            }
//
//                        }else if (status == 2){
//                            print("error message")
//                        }else{
//                            print("error message")
//                        }
                    }
                }catch{
                    print("error message")
                }
            }else{
                print(response.error?.localizedDescription ?? "hgh")
            }
        }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0

        if collectionView == collectionViewEvent {
            count = EventDetauilData?.images?.filter { $0.type == "owner" }.count ?? 0
            LblOwnerPhoto.isHidden = (count == 0)  // Hide if count is 0
        } else if collectionView == collectionViewNewEvent {
            count = imageArray.count
        } else if collectionView == AttendesCollectionView {
            count = EventDetauilData?.images?.filter { $0.type == "user" }.count ?? 0
            LblAttendesPhoto.isHidden = (count == 0)  // Hide if count is 0
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
                
                let url = URL(string: imageData.img ?? "")
                cell.profileImgView.kf.indicatorType = .activity
                cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "EventImage"))
                
                // Show btnDelImg only if there are owner images
                cell.btnDel.isHidden = ownerImages.isEmpty
                
                cell.indexPath = indexPath
                cell.FullImgCallback = { [self] value in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventEnlargementViewController") as! EventEnlargementViewController
                    vc.url = url
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                cell.configure(with: imageData)
            } else {
                // Hide btnDelImg if no owner images are found
                cell.btnDel.isHidden = true
            }


          
            if let imageData = EventDetauilData?.images?[indexPath.row] {
                cell.configure(with: imageData)
                

            }
            
            if let id = UserDefaults.standard.string(forKey: "userid"),
               let idCr = UserDefaults.standard.string(forKey: "usercr") {
                print("id: \(id), idCr: \(idCr)") // Debugging output
                
                if id == idCr {
                    cell.btnDel.isHidden = false
                   // btnEdit.isHidden = false
                    
                } else {
                    cell.btnDel.isHidden = true
                 
                    
                }
            } else {
                print("UserDefaults values are nil") // Handle nil case
                
                
            }
            
            cell.DelCallback = { [self] value in
                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)

                // Customize the message attributes
                let messageText = "Are you sure you want to delete?"
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                ]
                
                let attributedMessage = NSAttributedString(string: messageText, attributes: attributes)
                alertController.setValue(attributedMessage, forKey: "attributedMessage")
                
                let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                    if let indexPath = cell.indexPath {
                        callEventImgDelWebService(for: indexPath) {
                            callEventDetailWebService {
                                self.collectionViewEvent.reloadData()
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
        
        else if collectionView == collectionViewNewEvent
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell
            
            cell.LargeImgView.image = imageArray[indexPath.row]
            
            cell.FullImgCallback = { [self] value in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforePostEnlargeViewController")as! BeforePostEnlargeViewController
                //
                // vc.UserName = self.UserName.self
                vc.imageArray = self.imageArray.self
                
                self.navigationController?.pushViewController(vc, animated: true)

            }
            
            return cell
        }
        
        if collectionView == AttendesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttendesCollectionViewCell", for: indexPath) as! AttendesCollectionViewCell
            
            // Ensure EventDetauilData has images and filter user type images
            if let userImages = EventDetauilData?.images?.filter({ $0.type == "user" }),
               indexPath.row < userImages.count {
                
                let imageData = userImages[indexPath.row]
                
                if let imageUrl = imageData.img, let url = URL(string: imageUrl) {
                    cell.profileImgView.kf.indicatorType = .activity
                    cell.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "EventImage"))
                } else {
                    cell.profileImgView.image = UIImage(named: "EventImage") // Default image
                }
                
                // Hide delete button if no user images
                cell.btnDel.isHidden = userImages.isEmpty
                
                // Assign the correct indexPath to the cell
                cell.indexPath = indexPath
                
                // Setup callback for full image view
                cell.FullImgCallback = { [weak self] value in
                    guard let self = self else { return }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventEnlargementViewController") as! EventEnlargementViewController
                    vc.url = URL(string: imageData.img ?? "")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                // Configure cell with image data
                cell.configure(with: imageData)
            } else {
                cell.profileImgView.image = UIImage(named: "EventImage") // Default image
            }
         
            
            
            cell.DelAttendeCallback = { [self] value in
                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)

                // Customize the message attributes
                let messageText = "Are you sure you want to delete?"
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                ]
                
                let attributedMessage = NSAttributedString(string: messageText, attributes: attributes)
                alertController.setValue(attributedMessage, forKey: "attributedMessage")
                
                let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                    if let indexPath = cell.indexPath {
                        callEventAttendesImgDelWebService(for: indexPath) {
                            callEventDetailWebService {
                                self.collectionViewEvent.reloadData()
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
                //
                // vc.UserName = self.UserName.self
                vc.images = self.images.self
                vc.delegate = self
                
                self.navigationController?.pushViewController(vc, animated: true)

                
            }
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionViewEvent.frame.width / 3 - 15
       let height = width + 40
        return CGSize(width: width , height: height)
        
    
    }
    
}

@available(iOS 16.0, *)
extension EventsDetailViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, withRect cropRect: CGRect, angle: Int)
    
    {
        self.imageArray.append(image)
        self.collectionViewNewEvent.reloadData()
        self.images.append(image)
        self.WicketRangeCollectionView.reloadData()
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    @nonobjc func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}


