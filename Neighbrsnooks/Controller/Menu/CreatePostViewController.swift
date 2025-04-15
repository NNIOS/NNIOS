//
//  CreatePostViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 04/03/24.
//

import UIKit
 
import Alamofire
import Photos
import PhotosUI
import TOCropViewController
import AVKit
import AVFoundation

@available(iOS 16.0, *)
class CreatePostViewController: BaseViewController, UITextViewDelegate,CropViewControllerDelegate,PHPickerViewControllerDelegate, PostDataSelectionDelegate  {
    
    
    
    @IBOutlet weak var DescriptionText: UITextView!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    weak var delegate: ImageCollectionGalViewControllerDelegate?
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tpyePostLbl: UILabel!
    
    @IBOutlet weak var lblUploadImgVideo: UILabel!
    @IBOutlet weak var lblMaxImgVid: UILabel!
    @IBOutlet weak var lblMediaCount: UILabel!
    @IBOutlet weak var btnPreview: UIButton!
    
    @IBOutlet weak var btnPlusImg: UIButton!
    @IBOutlet weak var createPostView: UIView!
    @IBOutlet weak var SelectPostView: UIView!
    @IBOutlet weak var DescView: UIView!
    
    @IBOutlet weak var UploadView: UIView!
    
//    var serviceDropdownData = DropDown()
    var serviceName = [String]()
    var CategoryPostData : CategoryPostModel?
    var CreatePostData : CreatePostModel?
    var postImageSize: Int = 5 * 1024 * 1024 // 5 MB
    var postVideoSize: Int = 25 * 1024 * 1024 // 25 MB
    
    
    let pickerView = UIPickerView()
    var thisWidth:CGFloat = 0
    var imageArray = [UIImage]()
    var videoArray: [URL] = []
    var CamimageArray = [UIImage]()
    var selectedImages: [UIImage] = []
    var images: [UIImage] = []
    
    
    var imagePicker:UIImagePickerController?
    var selectedImge: UIImage? = nil
    var from = 0
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var NewselectedImages: [UIImage] = []
    let NewmagePicker = UIImagePickerController()
    var cropViewController: TOCropViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPlusImg.layer.cornerRadius = btnPlusImg.frame.height/2
        btnPlusImg.clipsToBounds = true
        btnPlusImg.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btnPlusImg.imageView?.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(previewLabelTapped))
        lblMediaCount.isUserInteractionEnabled = true
        lblMediaCount.addGestureRecognizer(tapGesture)
        
        self.serviceName.append("Select Post Type")
        placeholderLabel.text = "What's on your mind?"
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !DescriptionText.text.isEmpty
        setupActivityIndicator()
        DescriptionText.delegate = self
        tfCategory.inputView = pickerView
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

        
        self.tpyePostLbl.font  = UIFont(name: "Montserrat-Regular", size: 16)
        self.tpyePostLbl.tintColor = .darkGray
        self.lblMaxImgVid.font  = UIFont(name: "Montserrat-Regular", size: 12)
        self.lblUploadImgVideo.font  = UIFont(name: "Montserrat-Regular", size: 16)
        self.placeholderLabel.font  = UIFont(name: "Montserrat-Regular", size: 16)
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        callCategoryPostWebService()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.isOpaque = false
        setupGestures()
        
        // Add gesture recognizer setup
        if lblMediaCount.gestureRecognizers?.isEmpty ?? true {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(previewLabelTapped))
            lblMediaCount.isUserInteractionEnabled = true
            lblMediaCount.addGestureRecognizer(tapGesture)
        }
        
    }
    @objc func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }
    // Loader setup function
    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openSelectPostVC))
        tpyePostLbl.isUserInteractionEnabled = true
        tpyePostLbl.addGestureRecognizer(tapGesture)
    }
    
    @objc func openSelectPostVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let selectPostVC = storyboard.instantiateViewController(withIdentifier: "SelectPostViewController") as? SelectPostViewController {
            
            selectPostVC.labelTag = 1
            selectPostVC.postData = CategoryPostData?.nbdata.map { $0.postTitle ?? "" } ?? []
            // Transparent Background Ke Liye
            selectPostVC.delegate = self
            selectPostVC.modalPresentationStyle = .overCurrentContext
            selectPostVC.modalTransitionStyle = .crossDissolve
            present(selectPostVC, animated: true, completion: nil)
        }
    }
    
    func didSelectItems(selectedItems: [String], forLabel tag: Int) {
        if tag == 1 {
            tpyePostLbl.text = selectedItems.first ?? "Select"
        }
    }
    //     opne select post type VC start
    @objc func professionLabelTapped() {
        showPopup(for: 1, allowMultipleSelection: false) // Single selection for profession
    }
    
    
    // opne selectpostviewcontroller
    func showPopup(for labelTag: Int, allowMultipleSelection: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "SelectPostViewController") as? SelectPostViewController {
            popupVC.allowMultipleSelection = allowMultipleSelection
            popupVC.labelTag = labelTag
            popupVC.delegate = self
            // Pass profession data if labelTag is for Profession
            if labelTag == 1 {
                // Profession
                if let professionData = CategoryPostData?.nbdata.map({ $0.postTitle ?? "" }) {
                    popupVC.postData = professionData // Pass profession data to postData array
                }
            }
            // Popup style and animation
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            self.present(popupVC, animated: true, completion: nil)
        }
    }
   
    // MARK: - deleteMedia Protocol Method
    func didUpdateMedia(imageArray: [UIImage], videoArray: [URL]) {
        self.imageArray = imageArray
        self.videoArray = videoArray
        
        // ✅ UI Update karo
        DispatchQueue.main.async {
            self.updateMediaCount()
        }
    }
    
    
    
    func updateMediaCount() {
        let totalMedia = imageArray.count + videoArray.count
        lblMediaCount.text = "\(totalMedia) preview"
        
        // Button remove kar diya hai, so isko use nahi karna
        // btnPreview.isHidden = totalMedia == 0
        
        lblMediaCount.isHidden = totalMedia == 0 // Agar koi media nahi hai toh label bhi hide ho jaye
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
        vc.countDelegate = self // Yahan delegate set karein
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    //    end
    
    @IBAction func openNewCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
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
           
            createPostView.backgroundColor = .black
            SelectPostView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            DescView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            UploadView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            SelectPostView.layer.borderWidth = 1.0 // Enable border in dark mode
            DescView.layer.borderWidth = 1.0
            UploadView.layer.borderWidth = 1.0
            createPostView.backgroundColor = .black
            SelectPostView.backgroundColor = .black
            DescView.backgroundColor = .black
            UploadView.backgroundColor = .black
        } else {
            // Light mode mein storyboard ke original colors preserve karna
           

            // Light mode mein PollsView ka background red karna
            createPostView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            SelectPostView.layer.borderWidth = 0 // Enable border in dark mode
            DescView.layer.borderWidth = 0
            UploadView.layer.borderWidth = 0
            
            createPostView.backgroundColor = .white
            SelectPostView.backgroundColor = .white
            DescView.backgroundColor = .white
            UploadView.backgroundColor = .white
            
            SelectPostView.isUserInteractionEnabled = true // Disable in light mode
            DescView.isUserInteractionEnabled = true
            UploadView.isUserInteractionEnabled = true
            
            
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @objc func imageViewTapped(_ sender:AnyObject){
    }
    
    @IBAction func PicUploadBtnAction(_ sender: UIButton) {
    }
    
//    @IBAction func serviceBtnAction(_ sender: UIButton) {
//        self.view.endEditing(true)
//        self.showDropdownData(showOn: tfCategory, DropdownName: serviceDropdownData)
//        serviceDropdownData.cellHeight = 35
//        serviceDropdownData.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
//    }
//    
//    private func showDropdownData(showOn textField: UITextField, DropdownName dropdown : DropDown) {
//        dropdown.show()
//        dropdown.anchorView = textField
//        dropdown.bottomOffset = CGPoint(x: 30, y: (dropdown.anchorView?.plainView.bounds.height)!)
//        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
//            if index != 0{
//                self.tfCategory.text = self.serviceName[index]
//            }else{
//                self.tfCategory.text = ""
//            }
//            // self.serviceId = "\(AddProjectData?.nbdata[index].id ?? 0)"
//            UserDefaults.standard.set(self.serviceName[index], forKey: "id")
//            if index != 0{
//                UserDefaults.standard.set(self.CategoryPostData?.nbdata[index - 1].id, forKey: "idCategory")
//            }
//            dropdown.backgroundColor = UIColor.white
//            dropdown.cellHeight = 35
//            dropdown.direction = .bottom
//            dropdown.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
//            DropDown.appearance().setupCornerRadius(10)
//            //dropdown.serviceName = .left
//            dropdown.width = 200
//        }
//    }
//    
    func dismissAndNavigateToMenuGroupViewController() {
        // Dismiss the current view controller
        self.dismiss(animated: true) { [weak self] in
            // Present the new view controller
            guard let newViewController = self?.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController else {
                return
            }
            newViewController.modalPresentationStyle = .overFullScreen
            self?.present(newViewController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostViewController",
           let postVC = segue.destination as? PostViewController {
            
        }
    }
    
    @IBAction func CreateBtn(_ sender: UIButton){
        activityIndicator.startAnimating()
        sender.isEnabled = false // Button ko disable karo to prevent multiple taps
        
        // Check Category
        guard let categoryText = tpyePostLbl.text, !categoryText.isEmpty else {
            showAlert(with: "Please enter post type", sender: sender)
            stopLoader(sender)
            return
        }
        
        // Check Description
        guard let descriptionText = DescriptionText.text, !descriptionText.isEmpty else {
            showAlert(with: "Please enter description", sender: sender)
            stopLoader(sender)
            return
        }
        
        // Image Size Validation
        for image in imageArray {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let imageSizeMB = Double(imageData.count) / (1024 * 1024)
                if imageSizeMB > 10 {
                    showAlert(with: "Each image must be less than 5 MB", sender: sender)
                    stopLoader(sender)
                    return
                }
            }
        }
        
        // Image Count Validation
        if imageArray.count > 2 {
            showAlert(with: "You can upload a maximum of 2 images", sender: sender)
            stopLoader(sender)
            return
        }
        
        // Video Size Validation
        for videoURL in videoArray {
            do {
                let videoData = try Data(contentsOf: videoURL)
                let videoSizeMB = Double(videoData.count) / (1024 * 1024)
                print("Video Size: \(videoSizeMB) MB") // Debug print for video size
                if videoSizeMB > 25 { // Check agar video size 25 MB se zyada hai
                    showAlert(with: "Each video must be less than 25 MB", sender: sender)
                    stopLoader(sender)
                    return
                }
            } catch {
                print("Error calculating video size: \(error.localizedDescription)")
                stopLoader(sender)
                return
            }
        }
        
        // Video Count Validation
        if videoArray.count > 1 {
            showAlert(with: "You can upload a maximum of 1 video", sender: sender)
            stopLoader(sender)
            return
        }
        
        // Call the create post API if all validations pass
        callCreatePostWebService {
            self.stopLoader(sender)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Helper function for showing alerts and stopping loader
    private func showAlert(with message: String, sender: UIButton) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        stopLoader(sender)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // Stop Loader function
    func stopLoader(_ button: UIButton) {
        activityIndicator.stopAnimating()
        button.isEnabled = true // Button enable karo jab process complete ho
    }
    
    
    @IBAction func selectPhotos(_ sender: UIButton) {
        // Agar user ne max 2 images aur 1 video upload kar liya hai to alert show karna hai
        if imageArray.count >= 2 && videoArray.count >= 1 {
            showAlert(message: "You can only add up to 3 media items (1 video and 2 images).")
            return
        }
        // Warna permission check karke image/video select karne dena hai
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.selectImages()
            }
        }
    }

    
    

        
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
        
         
        
        func resetMediaArrays() {
            imageArray.removeAll()  // Clear all images
            videoArray.removeAll()  // Clear all videos
            DispatchQueue.main.async {
                self.updateMediaCount()  // Update the media count to 0
            }
        }
        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            picker.dismiss(animated: true, completion: nil)
//            
//            if let image = info[.originalImage] as? UIImage {
//                if imageArray.count >= 2 {
//                    showAlert(message: "You can only upload a maximum of 2 images.")
//                    return
//                }
//                if !imageArray.contains(where: { $0 == image }) {
//                    imageArray.append(image)
//                    DispatchQueue.main.async {
//                        self.updateMediaCount()
//                    }
//                    
//                }
//            } else if let videoURL = info[.mediaURL] as? URL {
//                if videoArray.count >= 1 {
//                    showAlert(message: "You can only upload a maximum of 1 video.")
//                    return
//                }
//                if !videoArray.contains(where: { $0 == videoURL }) {
//                    videoArray.append(videoURL)
//                    DispatchQueue.main.async {
//                        self.updateMediaCount()
//                    }
//                }
//            }
//        }
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            picker.dismiss(animated: true, completion: nil)
//            
//            // Selected media ka count check karo
//            let selectedImages = results.filter { $0.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) }
//            let selectedVideos = results.filter { $0.itemProvider.hasItemConformingToTypeIdentifier(UTType.video.identifier) }
//            
//            // Agar images aur videos ka total count exceed kar raha hai toh return karo
//            if imageArray.count + selectedImages.count > 2 {
//                showAlert(message: "You can only upload a maximum of 2 images.")
//                return
//            }
//            
//            if videoArray.count + selectedVideos.count > 1 {
//                showAlert(message: "You can only upload a maximum of 1 video.")
//                return
//            }
//
//            for result in results {
//                if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
//                    result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
//                        if let imageNew = object as? UIImage {
//                            DispatchQueue.main.async {
//                                if self.imageArray.count < 2 {
//                                    self.imageArray.append(imageNew)
//                                    self.updateMediaCount()
//                                    
//                                }
//                            }
//                        }
//                    }
//                } else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.video.identifier) {
//                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.video.identifier) { (url, error) in
//                        if let videoURL = url {
//                            DispatchQueue.main.async {
//                                if self.videoArray.count < 1 {
//                                    self.videoArray.append(videoURL)
//                                    self.updateMediaCount()
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }

    
    
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        
//        if let image = info[.originalImage] as? UIImage {
//            if imageArray.count >= 2 {
//                showAlert(message: "You can only upload a maximum of 2 images.")
//                return
//            }
//            showCrop(image: image) // Cropping Function Call
//        } else if let videoURL = info[.mediaURL] as? URL {
//            if videoArray.count >= 1 {
//                showAlert(message: "You can only upload a maximum of 1 video.")
//                return
//            }
//            if !videoArray.contains(where: { $0 == videoURL }) {
//                videoArray.append(videoURL)
//                DispatchQueue.main.async {
//                    self.updateMediaCount()
//                }
//            }
//        }
//    }
//
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        
//        let selectedImages = results.filter { $0.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) }
//        let selectedVideos = results.filter { $0.itemProvider.hasItemConformingToTypeIdentifier(UTType.video.identifier) }
//        
//        if imageArray.count + selectedImages.count > 2 {
//            showAlert(message: "You can only upload a maximum of 2 images.")
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
//                            self.showCrop(image: imageNew) // Cropping Function Call
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
//

    
    // MARK: - Image Picker Delegates (Keep your original code exactly as is)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            if imageArray.count >= 2 {
                showAlert(message: "You can only upload a maximum of 2 images.")
                return
            }
            showCrop(image: image)
        } else if let videoURL = info[.mediaURL] as? URL {
            if videoArray.count >= 1 {
                showAlert(message: "You can only upload a maximum of 1 video.")
                return
            }
            if !videoArray.contains(where: { $0 == videoURL }) {
                videoArray.append(videoURL)
                DispatchQueue.main.async {
                    self.updateMediaCount()
                }
            }
        }
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let selectedImages = results.filter { $0.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) }
        let selectedVideos = results.filter { $0.itemProvider.hasItemConformingToTypeIdentifier(UTType.video.identifier) }
        
        if imageArray.count + selectedImages.count > 2 {
            showAlert(message: "You can only upload a maximum of 2 images.")
            return
        }
        
        if videoArray.count + selectedVideos.count > 1 {
            showAlert(message: "You can only upload a maximum of 1 video.")
            return
        }

        for result in results {
            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let imageNew = object as? UIImage {
                        DispatchQueue.main.async {
                            self.showCrop(image: imageNew)
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

    
    
    
    
    
    
    // Alert show karne ka function
    func showAlert(title: String = "", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // ✅ OK button add karein, jo alert ko turant dismiss karega
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true) {
            // ✅ 2 second ke baad alert automatically dismiss hoga
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                alert.dismiss(animated: true, completion: nil)
//            }
        }
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
    
    
    
    func callCategoryPostWebService() {
        
        let dictParams: Dictionary<String, Any> = ["":""]
        
        WebService.sharedInstance.callCategoryPostWebService(withParams: dictParams) { data in
            self.CategoryPostData = data
            
            
            for value in self.CategoryPostData?.nbdata ?? [] {
                self.serviceName.append(value.postTitle ?? "")
                
            }
//            self.serviceDropdownData.dataSource = self.serviceName
            
            
            
        }
    }
    
    
    //  -----------------------------******************* video and image upload create post api-------------********---------******/
    
    func callCreatePostWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let idcategory = UserDefaults.standard.string(forKey: "idCategory") ?? ""
        // Confirming idCategory retrieved from UserDefaults
        print("Retrieved idCategory from UserDefaults in callCreatePostWebService: \(idcategory)")
        
        let dictParams: Dictionary<String, Any> = [
            "userid": id,
            "posttype": idcategory,
            "postmsg": self.DescriptionText.text ?? ""
        ]
        
        // Check if both images and videos are available
        if !imageArray.isEmpty || !videoArray.isEmpty {
            callsendMediaAPI(param: dictParams, images: imageArray, videos: videoArray, mediaKey: "photo[]", URlName: kBASEURL + WebServiceName.kCreatePost) {
                print("Upload successful") // Success message
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            print("No media available for upload.")
        }
    }
    
    func callsendMediaAPI(param:[String: Any], images:[UIImage], videos:[URL], mediaKey:String, URlName:String, withblock:@escaping ()->Void) {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            // Add parameters
            for (key, value) in param {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            
            // Add images
            for img in images {
                guard let imgData = img.jpegData(compressionQuality: 0.1) else { return }
                multipartFormData.append(imgData, withName: mediaKey, fileName: "\(NSDate().timeIntervalSince1970.rounded()).jpeg", mimeType: "image/jpeg")
            }
            
            // Add videos
            for video in videos {
                do {
                    let videoData = try Data(contentsOf: video)
                    multipartFormData.append(videoData, withName: mediaKey, fileName: "\(NSDate().timeIntervalSince1970.rounded()).mp4", mimeType: "video/mp4")
                } catch {
                    print("Error loading video file: \(error)")
                }
            }
            
        }, to: URL(string: URlName)!, method: .post, headers: headers).response { response in
            if let error = response.error {
                print("Error during media upload: \(error.localizedDescription)")
                // Implement retry logic here if needed
                self.retryUpload(param: param, images: images, videos: videos, mediaKey: mediaKey, URlName: URlName, withblock: withblock) // Retry logic
            } else {
                if let jsonData = response.data {
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print("Parsed response: \(parsedData)")
                        withblock()  // Call the completion block if successful
                    } catch {
                        print("Error parsing JSON response: \(error)")
                    }
                }
            }
        }
    }
    
    // Retry Function
    func retryUpload(param: [String: Any], images: [UIImage], videos: [URL], mediaKey: String, URlName: String, withblock: @escaping () -> Void) {
        // Implement a delay before retrying
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.callsendMediaAPI(param: param, images: images, videos: videos, mediaKey: mediaKey, URlName: URlName, withblock: withblock)
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
extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showCrop(image: UIImage) {
        let vc = TOCropViewController(image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Continue"
        vc.cancelButtonTitle = "Quit"
        vc.delegate = self
        vc.aspectRatioPreset = .presetOriginal
        vc.aspectRatioLockEnabled = false
        present(vc, animated: true)
    }

    
}

 
@available(iOS 16.0, *)
extension CreatePostViewController: MediaCountUpdateDelegate {
    func didUpdateMediaCount(totalMedia: Int) {
        lblMediaCount.text = "\(totalMedia) preview"
        lblMediaCount.isHidden = totalMedia == 0
    }
}

//
//// TOCropViewController delegate method - Crop hone ke baad image save karein
@available(iOS 16.0, *)
extension CreatePostViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, withRect cropRect: CGRect, angle: Int) {
        print("Crop completed successfully!")
        cropViewController.dismiss(animated: true) {
            if self.imageArray.count < 2 {
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
            if self.imageArray.count < 2 {
                self.imageArray.append(image)
                print("Image added to array. Current count: \(self.imageArray.count)")
                self.updateMediaCount()
            } else {
                print("Image count limit reached!")
            }
        }
    }

}




 
