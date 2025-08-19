//
//  AddBussinessViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 30/05/24.
//

import UIKit

import Alamofire
import Photos
import PhotosUI
import TOCropViewController
import PDFKit

@available(iOS 16.0, *)
class AddBussinessViewController: BaseViewController, UIPickerViewDelegate, UITextViewDelegate,CropViewControllerDelegate,PHPickerViewControllerDelegate, UICollectionViewDelegateFlowLayout, ImageCollectionViewControllerDelegate, UITextFieldDelegate, UIDocumentPickerDelegate, ImageCollectionGalViewControllerDelegate,MediaCountUpdateDelegate,SelectWeekDaysDelegate, BusinessCategorySelectionDelegate  {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var viewWeekly: UIView!
    @IBOutlet weak var viewSelectHideDay: UIView!
    @IBOutlet weak var viewWeeklyOfHeight: NSLayoutConstraint!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var SizeLbl: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var btnTerrif: UIButton!
    @IBOutlet weak var btnOthers: UIButton!
    @IBOutlet weak var tfBussinessName: UITextField!
    @IBOutlet weak var tfTag: UITextField!
    @IBOutlet weak var tvDescribe: UITextView!
    @IBOutlet weak var tfAdd1: UITextField!
    @IBOutlet weak var tfAdd2: UITextField!
    @IBOutlet weak var tfWeb: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfMob: UITextField!
    @IBOutlet weak var tfTel: UITextField!
    // @IBOutlet weak var tfSunday: UITextField!
    @IBOutlet weak var WeekLbl: UILabel!
    @IBOutlet weak var lblSelectWeeklyOfDay: UILabel!
    @IBOutlet weak var lblMediaCount: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var btnSelectWeekyOf: UIButton!
    @IBOutlet weak var btnOpenOnAllDay: UIButton!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblPinCode: UILabel!
    @IBOutlet weak var lblNeighborhood: UILabel!
    @IBOutlet weak var lblCountPdfFile: UILabel!
    @IBOutlet weak var BussinesssView: UIView!
    @IBOutlet weak var BusinesNameView: UIView!
    @IBOutlet weak var TagLineView: UIView!
    @IBOutlet weak var CategoryView: UIView!
    //  @IBOutlet weak var DescView: UIView!
    @IBOutlet weak var UploadImgView: UIView!
    @IBOutlet weak var BussinessHoursView: UIView!
    @IBOutlet weak var DocTypeView: UIView!
    @IBOutlet weak var BussinessAddView: UIView!
    
    @IBOutlet weak var FlatView: UIView!
    @IBOutlet weak var StreetView: UIView!
    
    //    let doPickerView = UIPickerView()
    let pickerView = UIPickerView()
    let dayPickerView = UIPickerView()
    let placeholderText = "Describe your business"
    var selectedPDFURL: URL?
    var sourceViewController: String?
    var account = ""
    var docType: String?
    //    var serviceDropdownData = DropDown()
    var serviceName = [String]()
    var AddPCategoryData : CategoryBussinessModel?
    var stateData : StateModel?
    var cityData : cityModel?
    var createBusinessData : CreateBussinessModel?
    var selectedCategoryID: String? // ✅ ID Store Karne Ke Liye
    //    var stateDropdownData = DropDown()
    //    var cityDropdownData = DropDown()
    var cityName = [String]()
    var stateName = [String]()
    var stateId : String?
    var cityId : String?
    //    var GenderDropdownData = DropDown()
    var thisWidth:CGFloat = 0
    var imageArray = [UIImage]()
    var videoArray: [URL] = []
    var CamimageArray = [UIImage]()
    var selectedImages: [UIImage] = []
    var images: [UIImage] = []
    var tfSunday: UITextField!
    private let bottomPanelView = BottomPanelView()
    var imagePicker:UIImagePickerController?
    private weak var delegate: UIImagePickerControllerDelegate?
    var selectedImge: UIImage? = nil
    var from = 0
    var NewselectedImages: [UIImage] = []
    let NewmagePicker = UIImagePickerController()
    var selectedDays: [String] = []
    let startTimePicker = UIDatePicker()
    let endTimePicker = UIDatePicker()
    let hiddenTextField = UITextField()
    var Oid: String?
    var Newid: String?
    var profileData : ProfileModel?
    var imagesToCrop: [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        updateColors()
        setupTextView()
        btnOpenOnAllDay.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        btnSelectWeekyOf.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        btnMenu.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        btnRate.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        btnTerrif.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        btnOthers.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        
        lblSelectWeeklyOfDay.sizeToFit() // Text ke according label ka size adjust karein
        tfCategory.inputView = pickerView
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.tvDescribe.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lblNeighborhood.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lblCity.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lblPinCode.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.serviceName.append("Bussiness Categories")
        tfTag.autocapitalizationType = .words
        //        tvDescribe.autocapitalizationType = .words
        tfAdd1.autocapitalizationType = .words
        tfAdd2.autocapitalizationType = .words
        tfWeb.autocapitalizationType = .words
        tfBussinessName.autocapitalizationType = .words
        viewWeekly.isHidden = true
        viewSelectHideDay.isHidden = true
        self.viewWeekly.roundCorners([.topLeft, .topRight], radius: 0)
        NewmagePicker.delegate = self
        //        NewmagePicker.sourceType = .camera
        //        NewmagePicker.allowsEditing = false
        //        NewmagePicker.mediaTypes = ["public.image"]
        //        NewmagePicker.showsCameraControls = true // Optional: Customize camera con
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            NewmagePicker.sourceType = .camera
        } else {
            print("📵 Camera not available, using photo library instead")
            NewmagePicker.sourceType = .photoLibrary
        }
        
        let tapGesturePdf = UITapGestureRecognizer(target: self, action: #selector(lblCountPdfFileTapped))
        lblCountPdfFile.isUserInteractionEnabled = true
        lblCountPdfFile.addGestureRecognizer(tapGesturePdf)
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        callCatBussinessWebService()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(previewLabelTapped))
        lblMediaCount.isUserInteractionEnabled = true
        lblMediaCount.addGestureRecognizer(tapGesture)
        
        // Add gesture recognizer setup
        if lblMediaCount.gestureRecognizers?.isEmpty ?? true {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(previewLabelTapped))
            lblMediaCount.isUserInteractionEnabled = true
            lblMediaCount.addGestureRecognizer(tapGesture)
        }
        
        let lblTapGesture = UITapGestureRecognizer(target: self, action: #selector(openWeekDaysPopup))
        lblSelectWeeklyOfDay.isUserInteractionEnabled = true
        lblSelectWeeklyOfDay.addGestureRecognizer(lblTapGesture)
        lblSelectWeeklyOfDay.text = selectedDays.isEmpty ? "Select day" : selectedDays.joined(separator: ", ")
        
        // UILabels ko clickable banane ke liye Tap Gesture add karein
        let startTimeTap = UITapGestureRecognizer(target: self, action: #selector(startTimeTapped))
        lblStartTime.isUserInteractionEnabled = true
        lblStartTime.addGestureRecognizer(startTimeTap)
        
        let endTimeTap = UITapGestureRecognizer(target: self, action: #selector(endTimeTapped))
        lblEndTime.isUserInteractionEnabled = true
        lblEndTime.addGestureRecognizer(endTimeTap)
        
        // ✅ Default values set
        lblStartTime.text = "10:00 AM"
        lblEndTime.text = "07:00 PM"
        
        // Pickers ko configure karein
        startTimePicker.datePickerMode = .time
        startTimePicker.preferredDatePickerStyle = .wheels
        
        endTimePicker.datePickerMode = .time
        endTimePicker.preferredDatePickerStyle = .wheels
        updateViewHeight()
        viewWeeklyOfHeight.constant = 0 // Reset height to 0
        
        // show tha data home to AddbussinessVC
        lblNeighborhood.text = UserDefaults.standard.string(forKey: "myNeighbhrhhod") ?? "N/A"
        lblCity.text = UserDefaults.standard.string(forKey: "city") ?? "N/A"
        lblState.text = UserDefaults.standard.string(forKey: "state") ?? "N/A"
        lblPinCode.text = UserDefaults.standard.string(forKey: "pincode") ?? "N/A"
        tfAdd1.text = UserDefaults.standard.string(forKey: "addressLineOne") ?? ""
        tfAdd2.text = UserDefaults.standard.string(forKey: "addressLineTwo") ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(handlePDFDeleted), name: NSNotification.Name("PDFDeleted"), object: nil)
        //        docType = "Menu"
        //        updateSelection(selectedButton: btnMenu, allButtons: [btnMenu, btnRate, btnTerrif, btnOthers])
      
        configureTimePickers()
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        updateColors()
    //    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        SVProgressHUD.show()
        
        callUserProfileWebService { [self] in
            
            //            SVProgressHUD.dismiss()
            let loginUserId = UserDefaults.standard.string(forKey: "userid") ?? ""
            let profileUserId = self.Oid ?? "" // From pushed VC
            print("Login User ID: \(loginUserId), Profile User ID: \(profileUserId)")
        }
    }
    
    func setupTimePickers() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        let minTime = formatter.date(from: "10:00 AM")!
        let maxTime = formatter.date(from: "07:00 PM")!
        
        [startTimePicker, endTimePicker].forEach { picker in
            picker.datePickerMode = .time
            picker.locale = Locale(identifier: "en_US")
            picker.minimumDate = minTime
            picker.maximumDate = maxTime
            picker.date = minTime  // Default time = 10:00 AM
        }
    }
    
    
    
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            
            BussinesssView.backgroundColor = .black
            BusinesNameView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            TagLineView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            CategoryView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            UploadImgView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            BussinessHoursView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            DocTypeView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            BussinessAddView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            viewWeekly.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            tvDescribe.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            
            BusinesNameView.backgroundColor = .black
            TagLineView.backgroundColor = .black
            CategoryView.backgroundColor = .black
            UploadImgView.backgroundColor = .black
            BussinessHoursView.backgroundColor = .black
            DocTypeView.backgroundColor = .black
            BussinessAddView.backgroundColor = .black
            viewWeekly.backgroundColor = .black
            tvDescribe.backgroundColor = .black
            FlatView.backgroundColor = .black
            StreetView.backgroundColor = .black
            
            BusinesNameView.layer.borderWidth = 1.0 // Enable border in dark mode
            TagLineView.layer.borderWidth = 1.0
            CategoryView.layer.borderWidth = 1.0
            
            UploadImgView.layer.borderWidth = 1.0 // Enable border in dark mode
            BussinessHoursView.layer.borderWidth = 1.0
            DocTypeView.layer.borderWidth = 1.0
            BussinessAddView.layer.borderWidth = 1.0
            viewWeekly.layer.borderWidth = 1.0
            tvDescribe.layer.borderWidth = 1.0
            
        } else {
            
            BussinesssView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            BusinesNameView.isUserInteractionEnabled = true
            TagLineView.isUserInteractionEnabled = true
            CategoryView.isUserInteractionEnabled = true
            UploadImgView.isUserInteractionEnabled = true
            BussinessHoursView.isUserInteractionEnabled = true
            DocTypeView.isUserInteractionEnabled = true
            BussinessAddView.isUserInteractionEnabled = true
            tvDescribe.isUserInteractionEnabled = true
            BusinesNameView.layer.borderWidth = 0 // Remove border in light mode
            TagLineView.layer.borderWidth = 0
            CategoryView.layer.borderWidth = 0
            UploadImgView.layer.borderWidth = 0 // Remove border in light mode
            BussinessHoursView.layer.borderWidth = 0
            DocTypeView.layer.borderWidth = 0
            BussinessAddView.layer.borderWidth = 0
            viewWeekly.layer.borderWidth = 0
            tvDescribe.layer.borderWidth = 0
            BusinesNameView.backgroundColor = .white
            TagLineView.backgroundColor = .white
            CategoryView.backgroundColor = .white
            UploadImgView.backgroundColor = .white
            BussinessHoursView.backgroundColor = .white
            DocTypeView.backgroundColor = .white
            BussinessAddView.backgroundColor = .white
            viewWeekly.backgroundColor = .white
            FlatView.backgroundColor = .white
            StreetView.backgroundColor = .white
            
        }
        //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    //    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    //        super.traitCollectionDidChange(previousTraitCollection)
    //
    //        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
    //            updateColors()
    //        }
    //    }
    
    
    
    func configureTimePickers() {
        startTimePicker.datePickerMode = .time
        endTimePicker.datePickerMode = .time
        
        // Default start time = 10:00 AM
        if let defaultStartTime = getDateFromString("10:00 AM") {
            startTimePicker.date = defaultStartTime
        }

        // Default end time = 07:00 PM
        if let defaultEndTime = getDateFromString("07:00 PM") {
            endTimePicker.date = defaultEndTime
        }

        // Optional: Use 12-hour format
        if #available(iOS 13.4, *) {
            startTimePicker.preferredDatePickerStyle = .wheels
            endTimePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    
    func getDateFromString(_ timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.date(from: timeString)
    }

    @objc func startTimeTapped() {
        showPickerAlert(title: "Select Start Time", picker: startTimePicker, label: lblStartTime)
    }

    @objc func endTimeTapped() {
        showPickerAlert(title: "Select End Time", picker: endTimePicker, label: lblEndTime)
    }

    // Picker Alert Function
    func showPickerAlert(title: String, picker: UIDatePicker, label: UILabel) {
        let alert = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)

        picker.frame = CGRect(x: 10, y: 10, width: alert.view.frame.width - 20, height: 200)
        alert.view.addSubview(picker)

        let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
            self.updateLabel(picker, label: label)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(selectAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func updateLabel(_ sender: UIDatePicker, label: UILabel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        label.text = formatter.string(from: sender.date)
    }
    
    
//    // Start Time label click event
//    @objc func startTimeTapped() {
//        showPickerAlert(title: "Select Start Time", picker: startTimePicker, label: lblStartTime)
//    }
//    
//    // End Time label click event
//    @objc func endTimeTapped() {
//        showPickerAlert(title: "Select End Time", picker: endTimePicker, label: lblEndTime)
//    }
//    
//    // Function to show time picker in an alert
//    func showPickerAlert(title: String, picker: UIDatePicker, label: UILabel) {
//        let alert = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
//        
//        picker.frame = CGRect(x: 10, y: 10, width: alert.view.frame.width - 20, height: 200)
//        picker.datePickerMode = .time  // Time mode set kar rahe hain
//        picker.locale = Locale(identifier: "en_US")  // 12-hour format ke liye
//        
//        alert.view.addSubview(picker)
//        
//        let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
//            self.updateLabel(picker, label: label)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        
//        alert.addAction(selectAction)
//        alert.addAction(cancelAction)
//        present(alert, animated: true)
//    }
//    
//    
//    // Update the UILabel with selected time
//    func updateLabel(_ sender: UIDatePicker, label: UILabel) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hh:mm a"  // AM/PM format
//        label.text = formatter.string(from: sender.date)
//    }
    
//    @objc func openWeekDaysPopup() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let popupVC = storyboard.instantiateViewController(withIdentifier: "SelectWeekDaysPopupVC") as? SelectWeekDaysPopupVC {
//            popupVC.delegate = self
//            popupVC.modalPresentationStyle = .overFullScreen
//            popupVC.modalTransitionStyle = .crossDissolve
//            
//            
//            self.present(popupVC, animated: true)
//        }
//    }
    
    @objc func openWeekDaysPopup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "SelectWeekDaysPopupVC") as? SelectWeekDaysPopupVC {
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve

            // 🔁 Pass currently selected days
            popupVC.selectedDays = self.selectedDays
            
            self.present(popupVC, animated: true)
        }
    }

    
    
    
    // ✅ Delegate method jo selected days update karega
    func didSelectWeekDays(_ selectedDays: [String]) {
        self.selectedDays = selectedDays // 🔁 Store updated values
        lblSelectWeeklyOfDay.text = selectedDays.joined(separator: ", ")
        lblSelectWeeklyOfDay.text = selectedDays.isEmpty ? "Select day" : selectedDays.joined(separator: ", ")
        updateViewHeight() // ✅ Dynamically UIView ki height adjust karein
    }
    
    // MARK: - deleteMedia Protocol Method
    func didUpdateMedia(imageArray: [UIImage], videoArray: [URL]) {
        self.imageArray = imageArray
        self.videoArray = videoArray
        updateMediaCount()
    }
    
    func updateMediaCount() {
        let totalMedia = imageArray.count + videoArray.count
        self.lblMediaCount.text = totalMedia == 1 ? "1 preview" : "\(totalMedia) previews"
        self.lblMediaCount.isHidden = totalMedia == 0
    }
    
    
    @objc func previewLabelTapped() {
        if imageArray.isEmpty && videoArray.isEmpty {
            print("No media to preview")
            return
        }
        
        print("Label Tapped - Navigating to BeforePostEnlargeViewController")
        print("Images Count: \(imageArray.count)")
        print("Videos Count: \(videoArray.count)")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforePostEnlargeViewController") as! BeforePostEnlargeViewController
        vc.imageArray = self.imageArray
        vc.videoArray = self.videoArray
        vc.delegate = self
        vc.countDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            //            textView.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            //            textView.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1) // Placeholder color #5C5C5C
            
        }
    }
    
    func setupTextView() {
        tvDescribe.delegate = self
        tvDescribe.text = placeholderText
        //        tvDescribe.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1) // Placeholder color #5C5C5C
        
    }
    
    @objc func handlePDFDeleted() {
        selectedPDFURL = nil
        lblCountPdfFile.text = ""
    }
    
    
    private func setupBottomPanel() {
        bottomPanelView.delegate = self
        bottomPanelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomPanelView)
        
        NSLayoutConstraint.activate([
            bottomPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5), // Moves it downward
            bottomPanelView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func imageViewTapped(_ sender:AnyObject){
        //   selectPictureThroughPhotoGallery()
        openCameraGallery()
        
    }
    
    
//    @IBAction func selectDocPhotos(_ sender: UIButton) {
//        if imageArray.count >= getImageLimit() && videoArray.count >= 1 {
//            showAlert(message: "You can only add up to 3 media items (1 video and \(getImageLimit()) images).")
//            return
//        }
//        // Warna permission check karke image/video select karne dena hai
//        checkCameraPermission { [weak self] granted in
//            guard let self = self else { return }
//            if granted {
//                self.selectImages()
//            }
//        }
//    }
    
    @IBAction func selectDocPhotos(_ sender: UIButton) {
            let imageLimit = Int("\(AddPCategoryData?.businessImgLimit ?? "0")") ?? 0
            let videoLimit = Int("\(AddPCategoryData?.businessVideoLimit ?? "0")") ?? 0
            let totalMediaLimit = imageLimit + videoLimit
            let currentMediaCount = imageArray.count + videoArray.count
            if currentMediaCount >= totalMediaLimit {
                let alert = UIAlertController(title: nil, message: "You can only add up to \(totalMediaLimit) media items (\(videoLimit) video & \(imageLimit) image).", preferredStyle: .alert)
                let attributedMessage = NSAttributedString(
                    string: "You can only add up to \(totalMediaLimit) media items (\(videoLimit) video & \(imageLimit) image).",
                    attributes: [
                        .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
                    ])
                alert.setValue(attributedMessage, forKey: "attributedMessage")
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }

            checkCameraPermission { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    self.selectImages()
                }
            }
        }
    
    
    @objc func selectImages() {
        if imageArray.count >= getImageLimit() && videoArray.count >= getVideoLimit() {
            showAlert(message: "You have reached the maximum media limit.")
            return
        }
        
        let actionSheet = UIAlertController()
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallery()
        }))
        actionSheet.addAction(UIAlertAction(title: "Take Video", style: .default, handler: { _ in
            self.openVideoCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Video", style: .default, handler: { _ in
            self.openVideoGallery()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
    
    func getImageLimit() -> Int {
        return Int(UserDefaults.standard.string(forKey: "imageLimit") ?? "0") ?? 0
    }
    
    func getVideoLimit() -> Int {
        return Int(UserDefaults.standard.string(forKey: "videoLimit") ?? "0") ?? 0
    }
    
    
    func didCrop(image: UIImage) {
            if imageArray.count >= getImageLimit() {
                showAlert(message: "You can only add \(getImageLimit()) image(s).")
                return
            }
            imageArray.append(image)
            updateMediaCount() // ✅ ADD THIS LINE
        }
    
    
//    func didCrop(image: UIImage) {
//        if imageArray.count >= getImageLimit() {
//            showAlert(message: "You can only add \(getImageLimit()) image(s).")
//            return
//        }
//        imageArray.append(image)
//        updateMediaCount() // ✅ ADD THIS LINE
//    }
    
    
//    func openCamera() {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let imagePickerController = UIImagePickerController()
//            imagePickerController.delegate = self
//            imagePickerController.sourceType = .camera
//            imagePickerController.cameraCaptureMode = .photo // Use default photo mode
//            present(imagePickerController, animated: true, completion: nil)
//        } else {
//            // Handle case where camera is not available
//            print("Camera is not available")
//        }
//    }
//    
//    
//    func openGallery() {
//        from = 1
//        var config = PHPickerConfiguration()
//        config.selectionLimit = 0 // 0 means no limit
//        config.filter = .images
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = self
//        present(picker, animated: true, completion: nil)
//    }
//    
//    
//    func openVideoCamera() {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let videoPickerController = UIImagePickerController()
//            videoPickerController.delegate = self
//            videoPickerController.sourceType = .camera
//            videoPickerController.mediaTypes = ["public.movie"]
//            present(videoPickerController, animated: true, completion: nil)
//        }
//    }
//    
//    func openVideoGallery() {
//        let videoPickerController = UIImagePickerController()
//        videoPickerController.delegate = self
//        videoPickerController.sourceType = .photoLibrary
//        videoPickerController.mediaTypes = ["public.movie"]
//        present(videoPickerController, animated: true, completion: nil)
//    }
    
    
    
    func openCamera() {
            let totalLimit = Int(AddPCategoryData?.businessImgLimit ?? "") ?? 0 // 0 means no limit
               let remainingLimit = totalLimit - imageArray.count
               guard remainingLimit > 0 else {
                   let alert = UIAlertController(title: nil, message: "You have already reached maximum limit for images.", preferredStyle: .alert)
                   let attributedMessage = NSAttributedString(
                       string: "You have already reached maximum limit for images.",
                       attributes: [
                           .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                       ])
                   alert.setValue(attributedMessage, forKey: "attributedMessage")
                   
                   let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                   okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
                   alert.addAction(okAction)
                   self.present(alert, animated: true, completion: nil)
                   return
               }
               
               if UIImagePickerController.isSourceTypeAvailable(.camera) {
                   let imagePickerController = UIImagePickerController()
                   imagePickerController.delegate = self
                   imagePickerController.sourceType = .camera
                   imagePickerController.cameraCaptureMode = .photo // Use default photo mode
                   present(imagePickerController, animated: true, completion: nil)
               } else {
                   // Handle case where camera is not available
                   print("Camera is not available")
               }
        }
        
        
        func openGallery() {
            from = 1
            let totalLimit = Int(AddPCategoryData?.businessImgLimit ?? "") ?? 0
            let remainingLimit = totalLimit - imageArray.count
            guard remainingLimit > 0 else {
                let alert = UIAlertController(title: nil, message: "You have already reached maximum limit for images.", preferredStyle: .alert)
                let attributedMessage = NSAttributedString(
                    string: "You have already reached maximum limit for images.",
                    attributes: [
                        .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                    ])
                alert.setValue(attributedMessage, forKey: "attributedMessage")
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }

            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = remainingLimit // respect remaining limit
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }

        
        
        
        
        func openVideoCamera() {
            
            let totalLimit = Int(AddPCategoryData?.businessVideoLimit ?? "") ?? 0
            let remainingLimit = totalLimit - videoArray.count
            guard remainingLimit > 0 else {
                let alert = UIAlertController(title: nil, message: "You have already reached the maximum video limit.", preferredStyle: .alert)
                            let attributedMessage = NSAttributedString(
                                string: "You have already reached the maximum video limit.",
                                attributes: [
                                    .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                                ])
                            alert.setValue(attributedMessage, forKey: "attributedMessage")
                            
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                return
            }

            let videoPickerController = UIImagePickerController()
            videoPickerController.delegate = self
            videoPickerController.sourceType = .camera
            videoPickerController.mediaTypes = ["public.movie"]
            videoPickerController.videoQuality = .typeMedium
            present(videoPickerController, animated: true, completion: nil)
        }
        
        func openVideoGallery() {
            let totalLimit = Int(AddPCategoryData?.businessVideoLimit ?? "") ?? 0
              let remainingLimit = totalLimit - videoArray.count
              guard remainingLimit > 0 else {
                  let alert = UIAlertController(title: nil, message: "You have already reached the maximum video limit.", preferredStyle: .alert)
                              let attributedMessage = NSAttributedString(
                                  string: "You have already reached the maximum video limit.",
                                  attributes: [
                                      .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                                  ])
                              alert.setValue(attributedMessage, forKey: "attributedMessage")
                              
                              let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                              okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
                              alert.addAction(okAction)
                              self.present(alert, animated: true, completion: nil)
                  return
              }

              let videoPickerController = UIImagePickerController()
              videoPickerController.delegate = self
              videoPickerController.sourceType = .photoLibrary
              videoPickerController.mediaTypes = ["public.movie"]
              videoPickerController.videoQuality = .typeMedium
                present(videoPickerController, animated: true, completion: nil)
        }
    
    
    
    func resetMediaArrays() {
        imageArray.removeAll()  // Clear all images
        videoArray.removeAll()  // Clear all videos
        DispatchQueue.main.async {
            self.updateMediaCount()  // Update the media count to 0
        }
    }
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        
//        if let mediaType = info[.mediaType] as? String {
//            if mediaType == "public.image" {
//                if let image = info[.originalImage] as? UIImage {
//                    if imageArray.count >= getImageLimit() {
//                        showAlert(message: "Only \(getImageLimit()) image(s) allowed.")
//                        return
//                    }
//                    showCrop(image: image)
//                }
//            } else if mediaType == "public.movie" {
//                if videoArray.count >= getVideoLimit() {
//                    showAlert(message: "Only \(getVideoLimit()) video(s) allowed.")
//                    return
//                }
//                
//                if let videoURL = info[.mediaURL] as? URL {
//                    self.videoArray.append(videoURL)
//                    self.updateMediaCount()
//                }
//            }
//        }
//    }
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        
//        let selectedImages = results.filter { $0.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) }
//        let selectedVideos = results.filter { $0.itemProvider.hasItemConformingToTypeIdentifier(UTType.video.identifier) }
//        
//        if imageArray.count + selectedImages.count > getImageLimit() {
//            showAlert(message: "You can only upload a maximum of \(getImageLimit()) images.")
//            return
//        }
//        
//        if videoArray.count + selectedVideos.count > 1 {
//            showAlert(message: "You can only upload a maximum of 1 video.")
//            return
//        }
//        
//        for result in results {
//            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
//                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
//                    if let imageNew = object as? UIImage {
//                        DispatchQueue.main.async {
//                            self.showCrop(image: imageNew)
//                        }
//                    }
//                }
//            } else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.video.identifier) {
//                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.video.identifier) { (url, error) in
//                    if let videoURL = url {
//                        DispatchQueue.main.async {
//                            if self.videoArray.count < 1 {
//                                self.videoArray.append(videoURL)
//                                self.updateMediaCount()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            
            if let mediaType = info[.mediaType] as? String {
                if mediaType == "public.image" {
                    if let image = info[.originalImage] as? UIImage {
                        if imageArray.count >= getImageLimit() {
                            let alert = UIAlertController(title: nil, message:"Only \(getImageLimit()) image(s) allowed.", preferredStyle: .alert)
                            let attributedMessage = NSAttributedString(
                                string: "Only \(getImageLimit()) image(s) allowed.",
                                attributes: [
                                    .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                                ])
                            alert.setValue(attributedMessage, forKey: "attributedMessage")
                            
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        self.imagesToCrop = [image] // single image, fine for camera
                        showCrop(image: image)
                    }
                } else if mediaType == "public.movie" {
                    if videoArray.count >= getVideoLimit() {
                        let alert = UIAlertController(title: nil, message: "Only \(getVideoLimit()) video(s) allowed.", preferredStyle: .alert)
                        let attributedMessage = NSAttributedString(
                            string: "Only \(getVideoLimit()) video(s) allowed.",
                            attributes: [
                                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                            ])
                        alert.setValue(attributedMessage, forKey: "attributedMessage")
                        
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    if let videoURL = info[.mediaURL] as? URL {
                        self.videoArray.append(videoURL)
                        self.updateMediaCount()
                    }
                }
            }
        }

        
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            
            let selectedImages = results.filter { $0.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) }
            let selectedVideos = results.filter { $0.itemProvider.hasItemConformingToTypeIdentifier(UTType.video.identifier) }
            
            if imageArray.count + selectedImages.count > getImageLimit() {
                let alert = UIAlertController(title: nil, message: "You can only upload a maximum of \(getImageLimit()) images.", preferredStyle: .alert)
                            let attributedMessage = NSAttributedString(
                                string: "You can only upload a maximum of \(getImageLimit()) images.",
                                attributes: [
                                    .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                                ])
                            alert.setValue(attributedMessage, forKey: "attributedMessage")
                            
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                return
            }
            
            if videoArray.count + selectedVideos.count > 1 {
                let alert = UIAlertController(title: nil, message: "You can only upload a maximum of 1 video.", preferredStyle: .alert)
                            let attributedMessage = NSAttributedString(
                                string: "You can only upload a maximum of 1 video.",
                                attributes: [
                                    .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                                ])
                            alert.setValue(attributedMessage, forKey: "attributedMessage")
                            
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                return
            }

            // Clear old crop queue
            self.imagesToCrop = []

            for result in results {
                if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                        if let imageNew = object as? UIImage {
                            DispatchQueue.main.async {
                                self.imagesToCrop.append(imageNew)
                                
                                // Start cropping the first image only once
                                if self.imagesToCrop.count == 1 {
                                    self.showCrop(image: imageNew)
                                }
                            }
                        }
                    }
                } else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.video.identifier) {
                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.video.identifier) { (url, error) in
                        if let videoURL = url {
                            DispatchQueue.main.async {
                                if self.videoArray.count < 1 {
                                    self.videoArray.append(videoURL)
                                    self.updateMediaCount()
                                }
                            }
                        }
                    }
                }
            }
        }
    
    
    
 
    
    func didTapDeleteButton(at index: Int) {
        didDeleteImage(at: index)
    }
    func didUpdateMediaCount(totalMedia: Int) {
        DispatchQueue.main.async {
            self.lblMediaCount.text = "\(totalMedia) preview"
            self.lblMediaCount.isHidden = totalMedia == 0
        }
    }
    
    
    func didDeleteImage(at index: Int) {
        // Delete image or video from arrays
        if index < imageArray.count {
            imageArray.remove(at: index) // Remove image from imageArray
        } else {
            let videoIndex = index - imageArray.count
            videoArray.remove(at: videoIndex) // Remove video from videoArray
        }
        // Update the media count
        updateMediaCount()
    }
    
    
    
    
    
    func getVideoThumbnail(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1, preferredTimescale: 600) // Capture thumbnail at 1 second
        var thumbnail: UIImage?
        do {
            let img = try assetImgGenerator.copyCGImage(at: time, actualTime: nil)
            thumbnail = UIImage(cgImage: img)
        } catch {
            print(error.localizedDescription)
        }
        return thumbnail
    }
    // code irshad malik
    // ✅ Button Actions - Call the common function
    @IBAction func actionopenOnAllDay(_ sender: UIButton) {
        viewWeekly.isHidden = true
        viewWeeklyOfHeight.constant = 0 // Reset height to 0
        updateSelection(selectedButton: btnOpenOnAllDay, allButtons: [btnOpenOnAllDay, btnSelectWeekyOf])
    }
    
    @IBAction func actionSelectWeekyOf(_ sender: UIButton) {
        viewWeekly.isHidden = false
        updateSelection(selectedButton: btnSelectWeekyOf, allButtons: [btnOpenOnAllDay, btnSelectWeekyOf])
        
        updateViewHeight() // Call function to update height dynamically
    }
    
    
    func updateViewHeight() {
        let maxWidth = lblSelectWeeklyOfDay.frame.width  // Label ke width ko lein
        let newSize = lblSelectWeeklyOfDay.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)) // Required height calculate karein
        
        let newHeight = newSize.height + 20 // Extra padding ke liye 20 add karein
        
        viewWeeklyOfHeight.constant = newHeight // UIView ki height update karein
        
    }
    func updateSelection(selectedButton: UIButton, allButtons: [UIButton]) {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular) // Set the same size for all buttons
        let selectedImage = UIImage(systemName: "largecircle.fill.circle", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        let unselectedImage = UIImage(systemName: "circle", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        
        for button in allButtons {
            if button == selectedButton {
                button.setImage(selectedImage, for: .normal)
                button.tintColor = UIColor(red: 0, green: 100/255.0, blue: 0, alpha: 1) // Dark green for selected
            } else {
                button.setImage(unselectedImage, for: .normal)
                button.tintColor = .darkGray // Black for unselected
            }
        }
    }
    
    
    
    
    
    // Change Code Irshad Malik
    
    @IBAction func acctionMenu(_ sender: UIButton) {
        docType = "Menu"
        updateSelection(selectedButton: btnMenu, allButtons: [btnMenu, btnRate, btnTerrif, btnOthers])
    }
    
    @IBAction func actionRate(_ sender: UIButton) {
        docType = "Rate"
        updateSelection(selectedButton: btnRate, allButtons: [btnMenu, btnRate, btnTerrif, btnOthers])
    }
    
    @IBAction func actionTarrif(_ sender: UIButton) {
        docType = "Tarrif"
        updateSelection(selectedButton: btnTerrif, allButtons: [btnMenu, btnRate, btnTerrif, btnOthers])
    }
    
    @IBAction func actionOthers(_ sender: UIButton) {
        docType = "Others"
        updateSelection(selectedButton: btnOthers, allButtons: [btnMenu, btnRate, btnTerrif, btnOthers])
    }
    
    
    
    @IBAction func serviceBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //        self.showDropdownData(showOn: tfCategory, DropdownName: serviceDropdownData)
        //        serviceDropdownData.cellHeight = 35
        //
        //        serviceDropdownData.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // ✅ Apna storyboard ka naam check karein
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "BusinessSelectCategoryPopupVC") as? BusinessSelectCategoryPopupVC {
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overFullScreen  // ✅ Background transparent hoga
            popupVC.modalTransitionStyle = .crossDissolve    // ✅ Smooth animation hoga
            popupVC.modalPresentationStyle = .overCurrentContext
            
            self.present(popupVC, animated: true)
        }
        
    }
    
    
    
    // ✅ **Step 2: Implement Delegate Method**
    func didSelectCategory(id: String, title: String) {
        self.selectedCategoryID = id
        self.tfCategory.text = title // ✅ TextField me value dikhana
        UserDefaults.standard.set(id, forKey: "idCategory") // ✅ ID Store Karna
    }
    
    
    // MARK: - call api callCatBussinessWebService for image limit video limit
    
    func callCatBussinessWebService() {
        let dictParams: Dictionary<String, Any> = ["":""]
        WebService.sharedInstance.callCatBussinessWebService(withParams: dictParams) { data in
            self.AddPCategoryData = data
            UserDefaults.standard.set(self.AddPCategoryData?.nbdata.first?.id, forKey: "id")
            UserDefaults.standard.set(self.AddPCategoryData?.businessImgLimit, forKey: "imageLimit")
            
            // ✅ Save image and video limits here
            
            UserDefaults.standard.set(self.AddPCategoryData?.businessImgLimit, forKey: "imageLimit")
            UserDefaults.standard.set(self.AddPCategoryData?.businessVideoSize, forKey: "videoLimit")
            
            for value in self.AddPCategoryData?.nbdata ?? [] {
                self.serviceName.append(value.businessTitle ?? "")
            }
            
        }
    }
    
    
    
    
    
    func selectPDF() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func pdfrBtnAction(_ sender: UIButton) {
        
        // Initialize the document picker
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false // Single file selection
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        
        // Save the selected PDF URL to use it later
        selectedPDFURL = selectedFileURL
        lblCountPdfFile.text = "preview"
//        lblCountPdfFile.text = "preview: \(selectedPDFURL != nil ? "1" : "0")"
        // Optionally: Print the URL and size
        print("Selected PDF URL: \(selectedFileURL)")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("User cancelled document picker.")
    }
    
    // Function to upload PDF file
    func uploadPDFFile(fileURL: URL, fileData: Data) {
        // Implement your API call or upload logic here
        print("PDF File URL: \(fileURL)")
        print("PDF File Size: \(fileData.count / 1024) KB")
    }
    
    
    @objc func lblCountPdfFileTapped() {
        guard let pdfURL = selectedPDFURL else {
            print("No PDF selected.")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let pdfViewController = storyboard.instantiateViewController(withIdentifier: "PDFViewController") as? PDFViewController {
            pdfViewController.pdfURL = pdfURL
            navigationController?.pushViewController(pdfViewController, animated: true)
        }
    }
    
    
    
    @IBAction func actionShowPdf(_ sender: Any) {
        // Check if a PDF URL is selected
        guard let pdfURL = selectedPDFURL else {
            print("No PDF selected.")
            return
        }
        
        // Pass the selected PDF URL to PDFViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let pdfViewController = storyboard.instantiateViewController(withIdentifier: "PDFViewController") as? PDFViewController {
            pdfViewController.pdfURL = pdfURL  // Pass the PDF URL to PDFViewController
            navigationController?.pushViewController(pdfViewController, animated: true)
        }
    }
    
    @IBAction func PublishBtn(_ sender: UIButton) {
        sender.isEnabled = false

        // ✅ Loader setup
        let loader = UIActivityIndicatorView(style: .medium)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.color = .white
        sender.addSubview(loader)

        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: sender.centerYAnchor)
        ])
        loader.startAnimating()

        // ✅ Business Name
        guard let businessName = tfBussinessName.text?.trimmingCharacters(in: .whitespacesAndNewlines), !businessName.isEmpty else {
            showValidationError("Please enter Business Name")
            return
        }

        // ✅ Category
        guard let category = tfCategory.text?.trimmingCharacters(in: .whitespacesAndNewlines), !category.isEmpty else {
            showValidationError("Please enter Category")
            return
        }

        // ✅ Address Line 1
        guard let add1 = tfAdd1.text?.trimmingCharacters(in: .whitespacesAndNewlines), !add1.isEmpty else {
            showValidationError("Please enter Address Line 1")
            return
        }

        // ✅ Address Line 2
        guard let add2 = tfAdd2.text?.trimmingCharacters(in: .whitespacesAndNewlines), !add2.isEmpty else {
            showValidationError("Please enter Address Line 2")
            return
        }

        // ✅ Start Time
        guard let startTime = lblStartTime.text?.trimmingCharacters(in: .whitespacesAndNewlines), !startTime.isEmpty else {
            showValidationError("Please select Start Time")
            return
        }

        // ✅ End Time
        guard let endTime = lblEndTime.text?.trimmingCharacters(in: .whitespacesAndNewlines), !endTime.isEmpty else {
            showValidationError("Please select End Time")
            return
        }

        // ✅ Description
        let description = tvDescribe.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if description.isEmpty || description == "Describe your business" {
            showValidationError("Please enter a valid Description")
            return
        }

        // ✅ Inappropriate Content Check
        if containsBadWords(description) {
            showValidationError("""
            Inappropriate content!
            This post goes against our community guidelines.
            Please keep things respectful.
            """)
            return
        }

        // ✅ Weekly Off Day
//        let weekoff = lblSelectWeeklyOfDay.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        if weekoff.isEmpty || weekoff == "Select day" {
//            showValidationError("Please select a weekly off day")
//            return
//        }

        // ✅ Everything is validated, call API now
//        callCreateBussinessWebService {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                loader.stopAnimating()
//                loader.removeFromSuperview()
//                sender.isEnabled = true
//
//                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BussinesViewController") as? BussinesViewController else { return }
//                vc.sourceViewControlleraddbuss = "AddBussiness"
//                vc.Newid = UserDefaults.standard.string(forKey: "userid") ?? ""
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
        
        callCreateBussinessWebService {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                loader.stopAnimating()
                loader.removeFromSuperview()
                sender.isEnabled = true
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BussinesViewController") as? BussinesViewController else { return }
                vc.sourceViewControlleraddbuss = "AddBussiness"
                vc.Newid = UserDefaults.standard.string(forKey: "userid") ?? ""
                if let myProfileVC = self.navigationController?.viewControllers.first(where: { $0 is MyProfileViewController }) {
                          (myProfileVC as? MyProfileViewController)?.fromScreen = "AddBussiness" // ✅ Pass fromScreen
                          self.navigationController?.setViewControllers([myProfileVC, vc], animated: true)
                      } else {
                          let storyboard = UIStoryboard(name: "Main", bundle: nil)
                          guard let myProfileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {
                              return
                          }
                          myProfileVC.fromScreen = "AddBussiness" // ✅ Pass fromScreen
                          self.navigationController?.setViewControllers([myProfileVC, vc], animated: true)
                      }
            }
        }



        // ✅ Helper to handle loader + alert
        func showValidationError(_ message: String) {
            loader.stopAnimating()
            loader.removeFromSuperview()
            sender.isEnabled = true
            showAlert(message: message)
        }
    }

    
    
    
    
    
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "idOther")
        var dictParams: [String: Any] = [:]
        print("\n\n✅ Profile Data Response:\n\(String(describing: self.profileData))\n\n")
        
        // Determine parameters based on the source view controller
        if sourceViewController == "MessageViewController" {
            dictParams = [
                "userid": Newid ?? "",
                "loggeduser": id ?? ""
            ]
        } else if sourceViewController == "MyProfile" {
            dictParams = [
                "userid": Oid ?? "",
                "loggeduser": id ?? ""
            ]
        }
        else if sourceViewController == "HomeViewController" {
            dictParams = [
                "userid": id ?? "",
                "loggeduser": id ?? ""
            ]
        } else {
            // Default behavior for other sources
            dictParams = [
                "userid": Oid ?? "",
                "loggeduser": Oid ?? ""
            ]
        }
        
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
    
    
    func callCreateBussinessWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let idcategory = UserDefaults.standard.string(forKey: "idCategory") ?? ""

        var dictParams: [String: Any] = [
            "userid": id,
            "businessname": tfBussinessName.text ?? "",
            "tagline": tfTag.text ?? "",
            "cat": idcategory,
            "description": tvDescribe.text ?? "",
            "opentime": lblStartTime.text ?? "",
            "closetime": lblEndTime.text ?? "",
            "weekoff": lblSelectWeeklyOfDay.text ?? "",
            "address1": tfAdd1.text ?? "",
            "address2": tfAdd2.text ?? "",
            "pin": lblPinCode.text ?? "",
            "web": tfWeb.text ?? "",
            "email": tfEmail.text ?? "",
            "mobile": tfMob.text ?? "",
            "telephone": tfTel.text ?? ""
        ]

        // ✅ Only add doctype if it's not nil or empty
        if let docType = docType, !docType.isEmpty {
            dictParams["doctype"] = docType
        }

        print("📤 Params:", dictParams)

        // ✅ Make sure URL is properly formatted
        var urlString = kBASEURL + WebServiceName.kCreateBussines
        if !urlString.contains("?") {
            urlString += "?flag=newcreatebusiness"
        } else {
            urlString += "&flag=newcreatebusiness"
        }

        // ✅ Upload logic
        if !imageArray.isEmpty || !videoArray.isEmpty || selectedPDFURL != nil {
            callsendMediaAPI(param: dictParams, images: imageArray, videos: videoArray, pdfURL: selectedPDFURL, mediaKey: "image[]", URlName: urlString) {
                print("✅ Upload with media done")
                completionClosure()
            }
        } else {
            callsendMediaAPI(param: dictParams, images: [], videos: [], pdfURL: nil, mediaKey: "image[]", URlName: urlString) {
                print("✅ Upload without media done")
                completionClosure()
            }
        }
    }


    
    
    
    
    //    func callCreateBussinessWebService(_ completionClosure: @escaping () -> ()) {
    //        let id = UserDefaults.standard.string(forKey: "userid")
    //        let idcategory = UserDefaults.standard.string(forKey: "idCategory") // ✅ Selected Category ID
    //
    //        let dictParams: Dictionary<String, Any> = [
    //            "userid": id ?? "",
    //            "businessname": self.tfBussinessName.text ?? "",
    //            "tagline": self.tfTag.text ?? "",
    //            "cat": idcategory ?? "", // ✅ **Pass Selected Category ID**
    //            "description": self.tvDescribe.text ?? "",
    //            "image[]": "",
    //            "opentime": self.lblStartTime.text ?? "", // change irshad malik
    //            "closetime": self.lblEndTime.text ?? "", // change irshad malik
    //            "weekoff": self.lblSelectWeeklyOfDay.text ?? "",
    //            "doctype": self.docType ?? "",
    //            "address1": self.tfAdd1.text ?? "",
    //            "address2": self.tfAdd2.text ?? "",
    //            "pin": self.lblPinCode.text ?? "",
    //            "web": self.tfWeb.text ?? "",
    //            "email": self.tfEmail.text ?? "",
    //            "mobile": self.tfMob.text ?? "",
    //            "telephone": self.tfTel.text ?? ""
    //        ]
    //
    //        print(dictParams)
    //        if !imageArray.isEmpty || !videoArray.isEmpty || selectedPDFURL != nil {
    //            callsendMediaAPI(param: dictParams, images: imageArray, videos: videoArray, pdfURL: selectedPDFURL, mediaKey: "image[]", URlName: kBASEURL + WebServiceName.kCreateBussines) {
    //                print("Upload successful")
    //                self.navigationController?.popViewController(animated: true)
    //            }
    //        } else {
    //            print("No media available for upload.")
    //        }
    //    }
    
    
    
    func callsendMediaAPI(param: [String: Any],
                          images: [UIImage],
                          videos: [URL],
                          pdfURL: URL?,
                          mediaKey: String,
                          URlName: String,
                          withblock: @escaping () -> Void) {

        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]

        AF.upload(multipartFormData: { multipartFormData in

            // ✅ Append only non-empty string parameters
            for (key, value) in param {
                if let valueString = value as? String, !valueString.isEmpty {
                    if let data = valueString.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }

            // ✅ Append images
            for img in images {
                if let imgData = img.jpegData(compressionQuality: 0.7) {
                    multipartFormData.append(imgData, withName: mediaKey, fileName: "image\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
                }
            }

            // ✅ Append videos
            for videoURL in videos {
                do {
                    let videoData = try Data(contentsOf: videoURL)
                    multipartFormData.append(videoData, withName: mediaKey, fileName: "video\(Date().timeIntervalSince1970).mp4", mimeType: "video/mp4")
                } catch {
                    print("❌ Error loading video: \(error.localizedDescription)")
                }
            }

            // ✅ Append PDF if available
            if let pdfURL = pdfURL {
                do {
                    let pdfData = try Data(contentsOf: pdfURL)
                    multipartFormData.append(pdfData, withName: "document[]", fileName: "document\(Date().timeIntervalSince1970).pdf", mimeType: "application/pdf")
                } catch {
                    print("❌ Error loading PDF: \(error.localizedDescription)")
                }
            }

        }, to: URlName, method: .post, headers: headers).response { response in

            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        let parsed = try JSONSerialization.jsonObject(with: data, options: [])
                        print("✅ Upload successful:", parsed)
                        withblock()
                    } catch {
                        print("❌ JSON parsing error:", error.localizedDescription)
                        if let raw = response.data, let rawStr = String(data: raw, encoding: .utf8) {
                            print("🔍 Raw response:", rawStr)
                        }
                    }
                } else {
                    print("❌ Empty response data.")
                }

            case .failure(let error):
                print("❌ Upload failed:", error.localizedDescription)
                self.retryUpload(param: param, images: images, videos: videos, pdfURL: pdfURL, mediaKey: mediaKey, URlName: URlName, withblock: withblock)
            }
        }
    }

    
    
    
    // Retry Function
    func retryUpload(param: [String: Any],
                     images: [UIImage],
                     videos: [URL],
                     pdfURL: URL?,
                     mediaKey: String,
                     URlName: String,
                     withblock: @escaping () -> Void) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.callsendMediaAPI(param: param,
                                  images: images,
                                  videos: videos,
                                  pdfURL: pdfURL,
                                  mediaKey: mediaKey,
                                  URlName: URlName,
                                  withblock: withblock)
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
                        
                        if let jsonArray = parsedData["data"] as? [[String: Any]] {
                            
                        }
                        
                        
                    }
                }catch{
                    print("error message")
                }
            }else{
                print(response.error?.localizedDescription ?? "hgh")
            }
        }
    }
}

@available(iOS 16.0, *)
extension AddBussinessViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
//        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "continue"
        vc.cancelButtonTitle = "Quit"
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    func openCameraGallery()
    {
        
        
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
            print("User click Camera button")
            self.present(self.imagePicker!, animated: true, completion: {
                self.imagePicker?.sourceType = .camera
                self.imagePicker?.allowsEditing = true
                self.imagePicker?.delegate = self
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default , handler:{ (UIAlertAction)in
            print("User click Gallery button")
            
            self.present(self.imagePicker!, animated: true, completion: {
                self.imagePicker?.sourceType = .photoLibrary
                self.imagePicker?.allowsEditing = true
                self.imagePicker?.delegate = self
                
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    
}

@available(iOS 16.0, *)
extension AddBussinessViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, withRect cropRect: CGRect, angle: Int) {
        print("Crop completed successfully!")
        cropViewController.dismiss(animated: true) {
            if self.imageArray.count < 3 {
                self.imageArray.append(image)
                print("Image added to array. Current count: \(self.imageArray.count)")
                self.updateMediaCount()
            } else {
                print("Image count limit reached!")
            }
        }
    }
    
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        print("Crop completed successfully!")
        cropViewController.dismiss(animated: true) {
            if self.imageArray.count < 3 {
                self.imageArray.append(image)
                print("Image added to array. Current count: \(self.imageArray.count)")
                self.updateMediaCount()
            } else {
                print("Image count limit reached!")
            }
        }
    }
    
}






