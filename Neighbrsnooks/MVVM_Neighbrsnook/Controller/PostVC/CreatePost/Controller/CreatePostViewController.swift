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
import CropViewController

enum MediaTypeImageVid {
    case image(UIImage)
    case video(URL)
}

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
    var selectedPostTypeId: String?
    
    var imagePicker:UIImagePickerController?
    var selectedImge: UIImage? = nil
    var from = 0
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var NewselectedImages: [UIImage] = []
    let NewmagePicker = UIImagePickerController()
    var cropViewController: TOCropViewController?
    var imagesToCrop: [UIImage] = []
    var selectedPostTypeFullData: PostTypeResponse?
    var postTypeData: PostTypeResponse?
    
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        updateColors()
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
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            NewmagePicker.sourceType = .camera
        } else {
            print("📵 Camera not available, using photo library instead")
            NewmagePicker.sourceType = .photoLibrary
        }
        
        self.tpyePostLbl.tintColor = .darkGray
        self.lblMaxImgVid.font  = UIFont(name: "Montserrat-Regular", size: 12)
        self.lblUploadImgVideo.font  = UIFont(name: "Montserrat-Regular", size: 16)
        self.placeholderLabel.font  = UIFont(name: "Montserrat-Regular", size: 16)
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
       
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.isOpaque = false
        setupGestures()
        getAndDecryptPostTypeCategory()
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
            selectPostVC.delegate = self
            // ✅ Map data correctly
            selectPostVC.modalPresentationStyle = .overCurrentContext
            selectPostVC.modalTransitionStyle = .crossDissolve
            present(selectPostVC, animated: true, completion: nil)
        }
    }

    func didSelectItems(selectedTitle: String, selectedId: String, forLabel tag: Int) {
        if tag == 1 {
            tpyePostLbl.text = selectedTitle
            selectedPostTypeId = selectedId
            print("Selected Post Type ID: \(selectedPostTypeId ?? "")")
        }
    }



    //     opne select post type VC start
    @objc func professionLabelTapped() {
        showPopup(for: 1, allowMultipleSelection: false)
    }


    func showPopup(for labelTag: Int, allowMultipleSelection: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "SelectPostViewController") as? SelectPostViewController {
            popupVC.allowMultipleSelection = allowMultipleSelection
            popupVC.labelTag = labelTag
            popupVC.delegate = self
            
            
            
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            present(popupVC, animated: true, completion: nil)
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
            let totalMediaCount = imageArray.count + videoArray.count
            lblMediaCount.text = "\(totalMediaCount) preview\(totalMediaCount > 1 ? "s" : "")"
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
        //        updateColors()
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
            
            createPostView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            SelectPostView.layer.borderWidth = 0 // Enable border in dark mode
            DescView.layer.borderWidth = 0
            UploadView.layer.borderWidth = 0
            
            
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
            //            updateColors()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @objc func imageViewTapped(_ sender:AnyObject){
    }
    
    @IBAction func PicUploadBtnAction(_ sender: UIButton) {
    }
    
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
 
    
    
    // MARK: - Button Action with loader inside button
    @IBAction func CreateBtn(_ sender: UIButton) {
        
        guard let postTypeId = selectedPostTypeId, !postTypeId.isEmpty else {
            showAlert(message: "Please select a post type")
            return
        }
        
        guard let description = DescriptionText.text, !description.isEmpty else {
            showAlert(message: "Please enter a description")
            return
        }
        
        createPostWithImagesApi(
            title: description,
            postTypeId: postTypeId
        )
    }

    // MARK: - Create Post Type
    func createPostWithImagesApi(title: String, postTypeId: String) {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        UtilityMethods.showIndicator()
        
        var parameters: Parameters = [
            "message": title,
            "post_type_id": postTypeId
        ]
        
        print(parameters)
        var mediaFiles: [String: MediaTypeImageVid] = [:]

        // Add Images
        for (index, image) in imageArray.enumerated() {
            mediaFiles["media[\(index)]"] = MediaTypeImageVid.image(image) // ✅ fully qualified
        }

        // Add Videos
        for (index, videoURL) in videoArray.enumerated() {
            mediaFiles["media[\(imageArray.count + index)]"] = MediaTypeImageVid.video(videoURL) // ✅ fully qualified
        }

        HttpUtility().upload_Reimburse_WithDocuments(
            url: API.createPost,
            parameters: parameters,
            mediaFiles: mediaFiles, // ✅ yahi pass karo, type nahi
            authToken: token,
            httpMethod: "POST",
            resultType: CreatePostModel.self
        ) { response in
            DispatchQueue.main.async {
                UtilityMethods.hideIndicator()
                if let model = response {
                    print("✅ Post created with media: \(model.message)")
                    self.navigationController?.popViewController(animated: true)
//                    self.showAlert(message: model.message)
                    self.resetMediaArrays()
                } else {
                    print("❌ Failed to create post with media")
                    self.showAlert(message: "Failed to create post")
                }
            }
        }

    }



    func getAndDecryptPostTypeCategory() {
        UtilityMethods.showIndicator()
        PostTypeV_M().get_PostType { [weak self] encryptedResponse in
            DispatchQueue.main.async {
                UtilityMethods.hideIndicator()
                guard let self = self, let encryptedData = encryptedResponse?.data else {
                    print("❌ Failed to fetch encrypted PostType data")
                    return
                }

                decryptPostTypeV_M(encryptedString: encryptedData) { decryptedResult in
                    DispatchQueue.main.async {
                        if let result = decryptedResult {
                            print("✅ Decrypted data: \(result)")
                        } else {
                            print("❌ Decryption failed or returned nil")
                        }
                    }
                }
            }
        }
    }
    
   

    
    private func showAlert(with message: String, sender: UIButton) {
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
             

            // Full message
            let fullMessage = message

            // Create attributed string
            let attributedMessage = NSMutableAttributedString(string: fullMessage)

            // Define fonts
            let boldFont = UIFont(name: "Montserrat-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
            let regularFont = UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 14)

            // Apply regular font to full message
            attributedMessage.addAttribute(.font, value: regularFont, range: NSRange(location: 0, length: fullMessage.count))
            attributedMessage.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1), range: NSRange(location: 0, length: fullMessage.count))

            // Apply bold only to "Inappropriate content!"
            if let boldRange = fullMessage.range(of: "Inappropriate content!") {
                let nsRange = NSRange(boldRange, in: fullMessage)
                attributedMessage.addAttribute(.font, value: boldFont, range: nsRange)
            }

            alert.setValue(attributedMessage, forKey: "attributedMessage")
            // OK Action
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               okAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor") // Set your preferred color here
               alert.addAction(okAction)
               
               self.present(alert, animated: true, completion: nil)
        }

    
    func showAlert(title: String = "", message: String) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let attributedMessage = NSAttributedString(
                string: message,
                attributes: [
                    .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                ])
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            okAction.setValue( #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1) , forKey: "titleTextColor")
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    
     
    
    @IBAction func selectPhotos(_ sender: UIButton) {
//        guard let limits = postTypeData?.data.data else {
//            showAlert(message: "⚠️ Limits not found from API")
//            return
//        }
//
//        // Image count check
//        if imageArray.count >= limits.maxImageCount {
//            showAlert(message: "You can upload maximum \(limits.maxImageCount) images.")
//            return
//        }
//
//        // Video count check
//        if videoArray.count >= limits.maxVideoCount {
//            showAlert(message: "You can upload maximum \(limits.maxVideoCount) videos.")
//            return
//        }
//
//        // File size check
//        let maxImgSizeBytes = limits.maxImageSizeMB * 1024 * 1024
//        let maxVideoSizeBytes = limits.maxVideoSizeMB * 1024 * 1024

       
        // ✅ Continue with permission
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.selectImages()
            }
        }
    }

    
    @objc func selectImages() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // ✅ Take Photo
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            checkCameraPermission { granted in
                if granted {
                    self.openCamera()
                }
            }
        }))

        // ✅ Choose Photo (no permission needed)
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallery()
        }))

        // ✅ Take Video
        actionSheet.addAction(UIAlertAction(title: "Take Video", style: .default, handler: { _ in
            checkCameraPermission { granted in
                if granted {
                    self.openVideoCamera()
                }
            }
        }))

        // ✅ Choose Video (no permission needed)
        actionSheet.addAction(UIAlertAction(title: "Choose Video", style: .default, handler: { _ in
            self.openVideoGallery()
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
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
        var config = PHPickerConfiguration()
        // Do not set config.selectionLimit
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
    
    // MARK: - Image Picker Delegates (Keep your original code exactly as is)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            showCrop(image: image)
        } else if let videoURL = info[.mediaURL] as? URL {
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

        for result in results {
            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let imageNew = object as? UIImage {
                        DispatchQueue.main.async {
                            self.imagesToCrop.append(imageNew)
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
                            self.videoArray.append(videoURL)
                            self.updateMediaCount()
                        }
                    }
                }
            }
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
            cropViewController.dismiss(animated: true) {
                self.imageArray.append(image)
                self.updateMediaCount()
                
                // Only remove if the array is not empty
                if !self.imagesToCrop.isEmpty {
                    self.imagesToCrop.removeFirst()
                }
                
                // Show next image if available
                if let nextImage = self.imagesToCrop.first {
                    self.showCrop(image: nextImage)
                }
            }
        }
    
    
 
    
}
