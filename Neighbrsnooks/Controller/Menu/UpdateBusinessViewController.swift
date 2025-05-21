//
//  UpdateBusinessViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 13/08/24.
//

import UIKit

import Alamofire
import Photos
import PhotosUI
import TOCropViewController

@available(iOS 16.0, *)
class UpdateBusinessViewController:BaseViewController, UIPickerViewDelegate, UITextViewDelegate,CropViewControllerDelegate,PHPickerViewControllerDelegate, UICollectionViewDelegateFlowLayout, ImageCollectionViewControllerDelegate, UITextFieldDelegate, UIDocumentPickerDelegate, ImageCollectionGalViewControllerDelegate,MediaCountUpdateDelegate,SelectWeekDaysDelegate, BusinessCategorySelectionDelegate  {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var viewWeekly: UIView!
    @IBOutlet weak var btnWeekly: UIButton!
    @IBOutlet weak var viewSelectHideDay: UIView!
    @IBOutlet weak var btnOpen: UIButton!
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
    
    
    
    var UpdateBusinessData : UpdateBusinessModel?
    var BussinessDetailData : BusinessDetailModel?
    let pickerView = UIPickerView()
    let dayPickerView = UIPickerView()
    let placeholderText = "Describe your business"
    var selectedPDFURL: URL?
    var account = ""
    var docType = ""
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
    var loaderView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        setupLoader()
        btnOpenOnAllDay.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        btnSelectWeekyOf.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        btnMenu.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        btnRate.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        btnTerrif.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        btnOthers.setImage(UIImage(systemName: "circle"), for: .normal) // ⭕️ Empty circle
        lblSelectWeeklyOfDay.sizeToFit() // Text ke according label ka size adjust karein
        tfCategory.inputView = pickerView
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.tvDescribe.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.serviceName.append("Bussiness Categories")
        tfBussinessName.autocapitalizationType = .words
        tfTag.autocapitalizationType = .words
        tvDescribe.autocapitalizationType = .words
        tfAdd1.autocapitalizationType = .words
        tfAdd2.autocapitalizationType = .words
        tfWeb.autocapitalizationType = .words
        tfBussinessName.autocapitalizationType = .words
        viewWeekly.isHidden = true
        viewSelectHideDay.isHidden = true
        self.viewWeekly.roundCorners([.topLeft, .topRight], radius: 0)
        NewmagePicker.delegate = self
        NewmagePicker.sourceType = .camera
        NewmagePicker.allowsEditing = false
        NewmagePicker.mediaTypes = ["public.image"]
        NewmagePicker.showsCameraControls = true // Optional: Customize camera con
        
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
        
        // Pickers ko configure karein
        startTimePicker.datePickerMode = .time
        startTimePicker.preferredDatePickerStyle = .wheels
        
        endTimePicker.datePickerMode = .time
        endTimePicker.preferredDatePickerStyle = .wheels
        updateViewHeight()
        viewWeeklyOfHeight.constant = 0 // Reset height to 0
        
        // show tha data home to AddbussinessVC
        //        lblNeighborhood.text = UserDefaults.standard.string(forKey: "myNeighbhrhhod") ?? "N/A"
        //        lblCity.text = UserDefaults.standard.string(forKey: "city") ?? "N/A"
        //        lblState.text = UserDefaults.standard.string(forKey: "state") ?? "N/A"
        //        lblPinCode.text = UserDefaults.standard.string(forKey: "pincode") ?? "N/A"
        //        tfAdd1.text = UserDefaults.standard.string(forKey: "addressLineOne") ?? ""
        //        tfAdd2.text = UserDefaults.standard.string(forKey: "addressLineTwo") ?? ""
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoader()
        callBussinesDetailPostWebService { [self] in
            
            self.tfBussinessName.text = self.BussinessDetailData?.businessName
            self.lblHeading.text = self.BussinessDetailData?.businessName
            self.tfTag.text = self.BussinessDetailData?.tagline
            self.tfCategory.text = self.BussinessDetailData?.category
            self.tvDescribe.text = self.BussinessDetailData?.description
            
            self.lblStartTime.text = self.BussinessDetailData?.fromtime
            self.lblEndTime.text = self.BussinessDetailData?.totime
            self.tfAdd1.text = self.BussinessDetailData?.add1
            self.tfAdd2.text = self.BussinessDetailData?.add2
            self.lblState.text = self.BussinessDetailData?.state
            self.lblCity.text = self.BussinessDetailData?.city
            self.lblPinCode.text = self.BussinessDetailData?.pincode
            
            self.tfWeb.text = self.BussinessDetailData?.web
            self.tfEmail.text = self.BussinessDetailData?.email
            self.tfMob.text = self.BussinessDetailData?.mobile
            self.tfTel.text = self.BussinessDetailData?.telephone
            self.lblSelectWeeklyOfDay.text = self.BussinessDetailData?.weeklyOff
            self.lblNeighborhood.text = self.BussinessDetailData?.neighborhood
            
            // API response ke baad doctype ke basis pe button select karna
            selectButtonBasedOnDocType()
            selectWeeklyOffButton()
            
            // **Images & Videos ko API Response se set karna**
            if let imageURLs = self.BussinessDetailData?.image?.compactMap({ $0.img }) {
                self.imageArray = imageURLs.compactMap { urlString in
                    if let url = URL(string: urlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        return image
                    }
                    return nil
                }
            }
            
            if let videoURLs = self.BussinessDetailData?.image?.compactMap({ $0.video }) {
                self.videoArray = videoURLs.compactMap {
                    if let url = URL(string: $0) {
                        print("Valid Video URL: \(url)")
                        return url
                    } else {
                        print("Invalid Video URL: \($0)")
                        return nil
                    }
                }
            }
            self.updateMediaCount() // Media count update karna
            hideLoader()
        }
    }
    
    func setupLoader() {
        loaderView = UIActivityIndicatorView(style: .large)
        loaderView.center = view.center
        loaderView.hidesWhenStopped = true
        loaderView.color = .gray
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loaderView)
        
        // Centering loader in the view
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showLoader() {
        DispatchQueue.main.async {
            self.loaderView.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.loaderView.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func selectButtonBasedOnDocType() {
        guard let docType = BussinessDetailData?.doctype else { return }
        
        switch docType {
        case "Menu":
            updateSelection(selectedButton: btnMenu, allButtons: [btnMenu, btnRate, btnTerrif, btnOthers])
        case "Rate":
            updateSelection(selectedButton: btnRate, allButtons: [btnMenu, btnRate, btnTerrif, btnOthers])
        case "Tarrif":
            updateSelection(selectedButton: btnTerrif, allButtons: [btnMenu, btnRate, btnTerrif, btnOthers])
        case "Others":
            updateSelection(selectedButton: btnOthers, allButtons: [btnMenu, btnRate, btnTerrif, btnOthers])
        default:
            break
        }
    }
    func selectWeeklyOffButton() {
        guard let weeklyOff = BussinessDetailData?.weeklyOff?.lowercased() else { return }
        
        if weeklyOff == "weekly_off" {
            actionopenOnAllDay(btnOpenOnAllDay) // Automatically call the button function
        } else {
            actionSelectWeekyOf(btnSelectWeekyOf) // Automatically call the button function
            lblSelectWeeklyOfDay.text = weeklyOff // Show weekly off days
        }
    }
    
    
    // Start Time label click event
    @objc func startTimeTapped() {
        showPickerAlert(title: "Select Start Time", picker: startTimePicker, label: lblStartTime)
    }
    
    // End Time label click event
    @objc func endTimeTapped() {
        showPickerAlert(title: "Select End Time", picker: endTimePicker, label: lblEndTime)
    }
    
    // Function to show time picker in an alert
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
    
    // Update the UILabel with selected time
    func updateLabel(_ sender: UIDatePicker, label: UILabel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"  // AM/PM format
        label.text = formatter.string(from: sender.date)
    }
    
    @objc func openWeekDaysPopup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "SelectWeekDaysPopupVC") as? SelectWeekDaysPopupVC {
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overFullScreen  // ✅ Full screen transparent modal
            popupVC.modalTransitionStyle = .crossDissolve    // ✅ Smooth animation
            self.present(popupVC, animated: true)
        }
    }
    
    
    // ✅ Delegate method jo selected days update karega
    func didSelectWeekDays(_ selectedDays: [String]) {
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
        print("Image Count: \(imageArray.count)")
        print("Video Count: \(videoArray.count)")
        let totalMedia = imageArray.count + videoArray.count
        lblMediaCount.text = "\(totalMedia) preview"
        lblMediaCount.isHidden = totalMedia == 0 // Hide the label if no media
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
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1) // Placeholder color #5C5C5C
            
        }
    }
    
    func setupTextView() {
        tvDescribe.delegate = self
        tvDescribe.text = placeholderText
        tvDescribe.font = UIFont.systemFont(ofSize: 14)
        tvDescribe.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1) // Placeholder color #5C5C5C
        
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
    
    
    @IBAction func selectDocPhotos(_ sender: UIButton) {
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                self.selectImages()
            }
        }
        
    }
    
    
    //-------------------- opne tha camra and upload image and videos ---------
    
    @objc func selectImages() {
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
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
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
        var config = PHPickerConfiguration()
        config.selectionLimit = 0 // 0 means no limit
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    func openVideoCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let videoPickerController = UIImagePickerController()
            videoPickerController.delegate = self
            videoPickerController.sourceType = .camera
            videoPickerController.mediaTypes = ["public.movie"]
            present(videoPickerController, animated: true, completion: nil)
        }
    }
    
    func openVideoGallery() {
        let videoPickerController = UIImagePickerController()
        videoPickerController.delegate = self
        videoPickerController.sourceType = .photoLibrary
        videoPickerController.mediaTypes = ["public.movie"]
        present(videoPickerController, animated: true, completion: nil)
    }
    
    
    
    
    func presentCropViewController(image: UIImage) {
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            // Crop karne ke liye function ko call karein
            presentCropViewController(image: image)
            // Add image to the image array
            imageArray.append(image)
            DispatchQueue.main.async {
                self.updateMediaCount()
            }
        } else if let videoURL = info[.mediaURL] as? URL {
            // Add video to the video array
            videoArray.append(videoURL)
            DispatchQueue.main.async {
                self.updateMediaCount() // ✅ Video count update ho jayega
            }
        }
    }
    
    
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        for result in results {
            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let imageNew = object as? UIImage {
                        DispatchQueue.main.async {
                            self.imageArray.append(imageNew)
                            self.updateMediaCount() // ✅ Media count update ho raha hai
                            self.presentCropViewController(image: imageNew)
                        }
                    }
                }
            } else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.video.identifier) {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.video.identifier) { (url, error) in
                    if let videoURL = url {
                        DispatchQueue.main.async {
                            self.videoArray.append(videoURL)
                            self.updateMediaCount() // ✅ Video count update ho jayega
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
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        updateViewHeight() // Call function to update height dynamically
    }
    
    
    func updateViewHeight() {
        let maxWidth = lblSelectWeeklyOfDay.frame.width  // Label ke width ko lein
        let newSize = lblSelectWeeklyOfDay.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)) // Required height calculate karein
        
        let newHeight = newSize.height + 20 // Extra padding ke liye 20 add karein
        
        viewWeeklyOfHeight.constant = newHeight // UIView ki height update karein
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // Smooth animation effect ke liye
        }
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
            self.present(popupVC, animated: true)
        }
        
    }
    
    
    
    // ✅ **Step 2: Implement Delegate Method**
    func didSelectCategory(id: String, title: String) {
        self.selectedCategoryID = id
        self.tfCategory.text = title // ✅ TextField me value dikhana
        UserDefaults.standard.set(id, forKey: "idCategory") // ✅ ID Store Karna
    }
    
    
    
    func callCatBussinessWebService() {
        
        let dictParams: Dictionary<String, Any> = ["":""]
        
        WebService.sharedInstance.callCatBussinessWebService(withParams: dictParams) { data in
            self.AddPCategoryData = data
            UserDefaults.standard.set(self.AddPCategoryData?.nbdata.first?.id, forKey: "id")
            UserDefaults.standard.set(self.AddPCategoryData?.businessImgLimit, forKey: "imageLimit")
            for value in self.AddPCategoryData?.nbdata ?? [] {
                self.serviceName.append(value.businessTitle ?? "")
            }
            //            self.serviceDropdownData.dataSource = self.serviceName
            
            
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
    
    @IBAction func PublishBtn(_ sender: UIButton){
        
           // Form Validation
        if tfBussinessName.text == "" {
   
            sender.isEnabled = true // Enable the button
            let alert = UIAlertController(title: "", message: "Please Enter Business Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if tfTag.text == "" {
 
            let alert = UIAlertController(title: "", message: "Please Enter Category", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // Simulate API call delay for testing loader
            // API Call Simulation
            callCreateBussinessWebService {
                DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                    DispatchQueue.main.async {
 
                         
                        // Safe storyboard VC instantiation
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController") as? NeigbrnookViewController {
                            self.navigationController?.pushViewController(vc, animated: false)
                        } else {
                            print("❌ Could not find 'NeigbrnookViewController'. Check Storyboard ID.")
                        }
                    }
                }
            }
        }
    }
    
    
    func callCreateBussinessWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idcategory = UserDefaults.standard.string(forKey: "idCategory") // ✅ Selected Category ID
        
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "businessname": self.tfBussinessName.text ?? "",
            "tagline": self.tfTag.text ?? "",
            "cat": idcategory ?? "", // ✅ **Pass Selected Category ID**
            "description": self.tvDescribe.text ?? "",
            "image[]": "",
            "opentime": self.lblStartTime.text ?? "", // change irshad malik
            "closetime": self.lblEndTime.text ?? "", // change irshad malik
            "weekoff": self.lblSelectWeeklyOfDay.text ?? "",
            "doctype": docType,
            "address1": self.tfAdd1.text ?? "",
            "address2": self.tfAdd2.text ?? "",
            "pin": self.lblPinCode.text ?? "",
            "web": self.tfWeb.text ?? "",
            "email": self.tfEmail.text ?? "",
            "mobile": self.tfMob.text ?? "",
            "telephone": self.tfTel.text ?? ""
        ]
        
        print(dictParams)
        if !imageArray.isEmpty || !videoArray.isEmpty || selectedPDFURL != nil {
            callsendMediaAPI(param: dictParams, images: imageArray, videos: videoArray, pdfURL: selectedPDFURL, mediaKey: "image[]", URlName: kBASEURL + WebServiceName.kCreateBussines) {
                print("Upload successful")
                completionClosure()
            }
        } else {
            print("No media available for upload.")
            completionClosure()
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
            "business_id":Busid ?? "",]
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
    
    
    func callsendMediaAPI(param: [String: Any], images: [UIImage], videos: [URL], pdfURL: URL?, mediaKey: String, URlName: String, withblock: @escaping () -> Void) {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            // Add parameters
            for (key, value) in param {
                if let valueString = value as? String {
                    multipartFormData.append(valueString.data(using: .utf8)!, withName: key)
                }
            }
            
            // Add images
            for img in images {
                if let imgData = img.jpegData(compressionQuality: 0.7) {
                    multipartFormData.append(imgData, withName: mediaKey, fileName: "image\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
                }
            }
            
            // Add videos
            for videoURL in videos {
                do {
                    let videoData = try Data(contentsOf: videoURL)
                    multipartFormData.append(videoData, withName: mediaKey, fileName: "video\(Date().timeIntervalSince1970).mp4", mimeType: "video/mp4")
                } catch {
                    print("Error loading video: \(error.localizedDescription)")
                }
            }
            
            // Add PDF file (if exists)
            if let pdfURL = pdfURL, let pdfData = try? Data(contentsOf: pdfURL) {
                multipartFormData.append(pdfData, withName: "document[]", fileName: "document\(Date().timeIntervalSince1970).pdf", mimeType: "application/pdf")
            }
            
        }, to: URlName, method: .post, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: [])
                    print("Upload successful: \(parsedData)")
                    withblock() // Callback
                } catch {
                    print("JSON parsing error: \(error)")
                }
            case .failure(let error):
                print("Upload failed: \(error.localizedDescription)")
                self.retryUpload(param: param, images: images, videos: videos, pdfURL: pdfURL, mediaKey: mediaKey, URlName: URlName, withblock: withblock)
                
            }
        }
    }
    
    
    
    
    // Retry Function
    func retryUpload(param: [String: Any], images: [UIImage], videos: [URL], pdfURL: URL?, mediaKey: String, URlName: String, withblock: @escaping () -> Void) {
        // Implement a delay before retrying
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.callsendMediaAPI(param: param, images: images, videos: videos, pdfURL: pdfURL, mediaKey: mediaKey, URlName: URlName, withblock: withblock)
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
extension UpdateBusinessViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
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
extension UpdateBusinessViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, withRect cropRect: CGRect, angle: Int)
    
    {
        self.imageArray.append(image)
        self.images.append(image)
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    @nonobjc func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

