//
//  CreateMarketViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 13/09/24.
//




import UIKit
import Alamofire
import Photos
import PhotosUI
import TOCropViewController
import AVFoundation
import TOCropViewController
import SVProgressHUD

@available(iOS 16.0, *)
class CreateMarketViewController: BaseViewController, UIPickerViewDelegate  {
    
    @IBOutlet weak var priceViewHightConst: NSLayoutConstraint!
    @IBOutlet weak var lblMaxLimit: UITextField!
    @IBOutlet weak var lblMediaCount: CustomLabelBus!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var collectionViewEvent: UICollectionView!
    @IBOutlet weak var WicketRangeCollectionView: UICollectionView!
    @IBOutlet weak var tfItemName: UITextField!
    @IBOutlet weak var tfItemPrice: UITextField!
    @IBOutlet weak var tfDesc: UITextView!
    @IBOutlet weak var btnSell: UIButton!
    @IBOutlet weak var btnDonate: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tpyePostLbl: UILabel!
    @IBOutlet weak var lblUploadImg: UILabel!
    @IBOutlet weak var FullMarketView: UIView!
    @IBOutlet weak var ItemNameView: UIView!
    @IBOutlet weak var CategoryView: UIView!
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var DonateView: UIView!
    @IBOutlet weak var PriceView: UIView!
    @IBOutlet weak var UploadImageView: UIView!
    @IBOutlet weak var DescriptionView: UIView!
    @IBOutlet weak var btnCreate: UIButton!
    
    var selectedCategoryId: Int?
    var selectedCategoryName: String = ""
    var MarketCatDataNew : MarketCategoryModel?
    var MarketCreateDataNew : CreateMarketModel?
    var imagePicker:UIImagePickerController?
    var imageArray = [UIImage]()
    var CamimageArray = [UIImage]()
    var selectedImages: [UIImage] = []
    var images: [UIImage] = []
    var videos: [URL] = []
    var selectedImge: UIImage? = nil
    var from = 1
    var thisWidth:CGFloat = 0
    var docType = ""
    var videoArray: [URL] = []
    var videoURL: URL?
    var serviceName: [String] = []
    var pickerView = UIPickerView()
    let placeholderText = "Describe your item ..."
    
    var token:String?
    var pendingImages: [UIImage] = []
    var objMarketData: CreateMarketResponse?
    var viewModel = SelectMarketCategoriesViewModel()
    var objSelectMarketCategoriesData:SelectMarketCategoriesResponse?
    var decryptSelectCategories:DecryptedSelctedMarketCatResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        token = UserDefaults.standard.string(forKey: "authToken")
        selectMarketCategoriesApi()
    }
    
    func setupUI() {
        btnCreate.isUserInteractionEnabled = true
        lblMediaCount.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(previewLabelTapped))
        lblMediaCount.isUserInteractionEnabled = true
        lblMediaCount.addGestureRecognizer(tapGesture)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tpyePostLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblUploadImg.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.tfItemName.font = UIFont(name: "Montserrat-Regular", size: 16)
        tfCategory.inputView = pickerView
        tfCategory.delegate = self
        tfDesc.delegate = self
        let placeholderText = "Describe your item ..."
        tfDesc.text = placeholderText
        tfDesc.font = UIFont(name: "Montserrat-Regular", size: 18)
        tfDesc.textColor = UIColor.lightGray
        tfDesc.text = placeholderText
        tfDesc.textColor = UIColor.lightGray
        tfItemName.autocapitalizationType = .sentences
        tfDesc.autocapitalizationType = .sentences
        
        self.serviceName.append("Market Categories")
        let professionLabelTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
        tpyePostLbl.isUserInteractionEnabled = true
        tpyePostLbl.addGestureRecognizer(professionLabelTap)
        tfItemName.attributedPlaceholder = NSAttributedString(string:"Enter item name",attributes:[.font:UIFont(name:"Montserrat-Regular",size:18)!,.foregroundColor:UIColor.lightGray])
        tfItemPrice.attributedPlaceholder = NSAttributedString(string:"Enter item price",attributes:[.font:UIFont(name:"Montserrat-Regular",size:18)!,.foregroundColor:UIColor.lightGray])
        lblMaxLimit.isUserInteractionEnabled = false
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SellBtnAction(_ sender: UIButton) {
        btnSell.backgroundColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
        btnDonate.backgroundColor = UIColor.white
        btnSell.setTitleColor(UIColor.white, for: .normal)
        btnDonate.setTitleColor(UIColor.gray, for: .normal)
        docType = "Sell"
        PriceView.isHidden = false
        priceViewHightConst.constant = 50
    }
    
    @IBAction func DonateBtnAction(_ sender: UIButton) {
        btnSell.backgroundColor = UIColor.white
        btnDonate.backgroundColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
        btnDonate.setTitleColor(UIColor.white, for: .normal)
        btnSell.setTitleColor(UIColor.gray, for: .normal)
        docType = "Donate"
        PriceView.isHidden = true
        priceViewHightConst.constant = 0
    }
    
    @IBAction func selectPhotos(_ sender: UIButton) {
        guard let imageLimit = decryptSelectCategories?.data.marketplace_limits.mpk_product_image_limit,
              let videoLimit = decryptSelectCategories?.data.marketplace_limits.mpk_product_video_limit else {
            self.alertToast(Message: "Image or video limit not set") //
            return
        }
        
        let isImageLimitReached = imageArray.count >= imageLimit
        let isVideoLimitReached = videoArray.count >= videoLimit
        
        if isImageLimitReached && isVideoLimitReached {
            self.alertToast(Message: "You have reached the max limit of image & video")
            return
        }
        
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.selectImages(isImageLimitReached: isImageLimitReached, isVideoLimitReached: isVideoLimitReached)
            }
        }
    }
    
    @IBAction func PublishBtn(_ sender: UIButton) {
        sender.isEnabled = false
        let itemName = tfItemName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let itemPrice = tfItemPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let itemDesc = tfDesc.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard Reach().isInternet() else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
            sender.isEnabled = true
            return
        }
        
        switch true {
        case itemName.isEmpty:
            alertToast(Message: "Please enter item name")
        case tpyePostLbl.text == "Select category":
            alertToast(Message: "Please select a category")
        case docType.isEmpty:
            alertToast(Message: "Select Sell or Donate to continue")
        case docType == "Sell" && itemPrice.isEmpty:
            alertToast(Message: "Please enter item price")
        case tfDesc.text == placeholderText || tfDesc.text?.isEmpty == true:
            alertToast(Message: "Please enter description")
        case isFirstCharacterZero(textField: tfItemPrice):
            alertToast(Message: "Price can not start from 0")
        case !pendingImages.isEmpty:
            alertToast(Message: "Please finish cropping selected images first")
            sender.isEnabled = true
            return
        case imageArray.isEmpty && videoArray.isEmpty:
            alertToast(Message: "Please select at least one image or video")
        case containsBadWords(itemName):
            alertToast(Message: "Please remove inappropriate words from Item Name")
        case containsBadWords(itemDesc):
            alertToast(Message: "Please remove inappropriate words from Description")
        default:
            callCreateMareketApi()
            return
        }
        sender.isEnabled = true
    }
    
    
    @objc func professionLabelTapped() {
        showPopup(for: 3, allowMultipleSelection: false)
    }
    
    func didSelectItems(selectedItems: [String], forLabel tag: Int) {
        let selectedItemsString = selectedItems.isEmpty ? "Select" : selectedItems.joined(separator: ", ")
        if tag == 3 {
            tpyePostLbl.text = selectedItemsString
            print("Select data is :\(selectedItemsString)")
        } else {
            print("Data not found")
        }
    }
    
    func showPopup(for labelTag: Int, allowMultipleSelection: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "SelectMarketCatViewController") as? SelectMarketCatViewController {
            popupVC.allowMultipleSelection = allowMultipleSelection
            popupVC.labelTag = 3
            popupVC.callback = { [weak self] catId, catName in
                self?.selectedCategoryName = catName
                self?.selectedCategoryId = catId
                self?.tpyePostLbl.text = catName
                print("Selected ID: \(catId), Name: \(catName)")
            }
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            self.present(popupVC, animated: true, completion: nil)
        }
    }
    
    func selectImages(isImageLimitReached: Bool, isVideoLimitReached: Bool) {
        let actionSheet = UIAlertController(title: "Select Media", message: nil, preferredStyle: .actionSheet)
        if !isImageLimitReached {
            actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                self.openCamera()
            }))
            actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
                self.openGallery()
            }))
        }
        if !isVideoLimitReached {
            actionSheet.addAction(UIAlertAction(title: "Take Video", style: .default, handler: { _ in
                self.openVideoCamera()
            }))
            actionSheet.addAction(UIAlertAction(title: "Choose Video", style: .default, handler: { _ in
                self.openVideoGallery()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
        from = 0
        guard let limit = decryptSelectCategories?.data.marketplace_limits.mpk_product_image_limit else {
            alertToast(Message: "Image limit not set")
            return
        }
        let remainingLimit = limit - imageArray.count
        if remainingLimit <= 0 {
            alertToast(Message: "You have reached the max image limit")
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.cameraCaptureMode = .photo
            present(imagePickerController, animated: true, completion: nil)
        } else {
            alertToast(Message: "Camera is not available")
        }
    }
    
    func openGallery() {
        from = 1
        guard let imageLimit = decryptSelectCategories?.data.marketplace_limits.mpk_product_image_limit else {
            alertToast(Message: "Image limit not set")
            return
        }
        let remainingLimit = imageLimit - imageArray.count
        if remainingLimit <= 0 {
            alertToast(Message: "You have reached the maximum image limit")
            return
        }
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = remainingLimit
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
    func getVideoThumbnail(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1, preferredTimescale: 600)
        var thumbnail: UIImage?
        
        do {
            let img = try assetImgGenerator.copyCGImage(at: time, actualTime: nil)
            thumbnail = UIImage(cgImage: img)
        } catch {
            print(error.localizedDescription)
        }
        
        return thumbnail
    }
    
    func convertMovToMp4(movURL: URL, completion: @escaping (URL?) -> Void) {
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
        let asset = AVAsset(url: movURL)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = .mp4
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.exportAsynchronously {
            switch exportSession?.status {
            case .completed:
                print("MOV converted to MP4 successfully!")
                completion(outputURL)
            case .failed, .cancelled:
                print("Error during conversion: \(exportSession?.error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            default:
                break
            }
        }
    }
}

// MARK: - Extension for UIViewController
extension CreateMarketViewController {
    
    func selectMarketCategoriesApi() {
        let requet = SelectMarketCategories_Request(decrypt: token ?? "")
        let  param: [String: String] = [
            "decrypt": requet.decrypt
        ]
        print("Param is:\(param)")
        let viewModel = SelectMarketCategoriesViewModel()
        viewModel.selectMarketCategories(parameter: param, request: requet) { response in
            DispatchQueue.main.async {
                if let encryptedData = response?.data {
                    self.objSelectMarketCategoriesData?.data = encryptedData
                    self.decryptselectMarketCategoriesApi(encryptedString: encryptedData)
                }
            }
        }
    }
    
    private func decryptselectMarketCategoriesApi(encryptedString: String) {
        viewModel = SelectMarketCategoriesViewModel()
        viewModel.decryptselectMarketCategoriesApi(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    if self.decryptSelectCategories == nil {
                        self.decryptSelectCategories = decryptedData
                        self.lblMaxLimit.text = "Max images: \(String(self.decryptSelectCategories?.data.marketplace_limits.mpk_product_image_limit ?? 0) ), Max Videos : \(String(self.decryptSelectCategories?.data.marketplace_limits.mpk_product_video_limit ?? 0))"
                        print("Decrypted Data is :\(decryptedData)")
                    }
                }
            } else {
                print("❌ Failed to decrypt poll list data")
            }
        }
    }
    
    func callCreateMareketApi() {
        let request = CreateMarket_Request(
            p_title: tfItemName.text ?? "",
            p_description: tfDesc.text ?? "",
            p_quantity: 1,
            sale_type: docType,
            sale_price: Int(tfItemPrice.text ?? "") ?? 0,
            brand_name: "",
            cat_id: selectedCategoryId ?? 0,
            media: [""]
        )
        
        let param: [String: Any] = [
            "p_title": request.p_title,
            "p_description": request.p_description,
            "p_quantity": request.p_quantity,
            "sale_type": request.sale_type,
            "sale_price": request.sale_price,
            "brand_name": "",
            "cat_id": request.cat_id
        ]
        
        print("Param is :\(param)")
        
        let dispatchGroup = DispatchGroup()
        var convertedVideos: [URL] = []
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        for videoURL in videos {
            dispatchGroup.enter()
            let fileExtension = videoURL.pathExtension.lowercased()
            if fileExtension == "mov" {
                convertMovToMp4(movURL: videoURL) { mp4URL in
                    if let mp4URL = mp4URL {
                        convertedVideos.append(mp4URL)
                    } else {
                        print("Failed to convert MOV to MP4 for \(videoURL.lastPathComponent)")
                    }
                    dispatchGroup.leave()
                }
            } else {
                convertedVideos.append(videoURL)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            AF.upload(
                multipartFormData: { multipartFormData in
                    UtilityMethods.showIndicator()
                    for (key, value) in param {
                        if let valueData = "\(value)".data(using: .utf8) {
                            multipartFormData.append(valueData, withName: key)
                        }
                    }
                    for (index, image) in self.imageArray.enumerated() {
                        if let imageData = image.jpegData(compressionQuality: 0.8) {
                            print("Uploading image at index: \(index), size: \(imageData.count / 1024) KB")
                            multipartFormData.append(
                                imageData,
                                withName: "media[]",
                                fileName: "image_\(index).jpg",
                                mimeType: "image/jpeg"
                            )
                        } else {
                            print("Failed to get JPEG data for image at index: \(index)")
                        }
                    }
                    for (index, videoURL) in self.videoArray.enumerated() {
                        do {
                            let videoData = try Data(contentsOf: videoURL)
                            print("Uploading video at URL: \(videoURL)")
                            multipartFormData.append(
                                videoData,
                                withName: "media[]",
                                fileName: "video_\(index).mp4",
                                mimeType: "video/mp4"
                            )
                        } catch {
                            print("Error reading video file \(videoURL.lastPathComponent): \(error.localizedDescription)")
                        }
                    }
                    
                },
                to: API.createMarket,
                method: .post,
                headers: headers
            )
            .validate()
            .responseJSON { response in
                UtilityMethods.hideIndicator()
                switch response.result {
                case .success(let data):
                    print("Upload successful: \(data)")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("Upload failed: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.alertToast(Message: "Failed to create post. Please try again.")
                    }
                }
            }
        }
    }
    
    func isImageSizeValid(_ image: UIImage) -> Bool {
        guard let maxSizeMB = decryptSelectCategories?.data.marketplace_limits.mpk_product_image_size_mb else {
            print("Max image size limit not set")
            return true
        }
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let imageSizeMB = Double(imageData.count) / (1024.0 * 1024.0)
            print("Image size: \(imageSizeMB) MB")
            if imageSizeMB > Double(maxSizeMB) {
                DispatchQueue.main.async {
                    self.alertToast(Message: "Image size exceeds the limit of \(maxSizeMB) MB")
                }
                return false
            }
            return true
        }
        
        return false
    }



    
    func isVideoSizeValid(_ videoURL: URL) -> Bool {
        guard let maxSizeMB = decryptSelectCategories?.data.marketplace_limits.mpk_product_video_size_mb else {
            print("Max video size limit not set")
            return true // If no limit set, allow
        }
        
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: videoURL.path)
            if let fileSize = fileAttributes[.size] as? UInt64 {
                let fileSizeMB = Double(fileSize) / (1024.0 * 1024.0)
                print("Video size: \(fileSizeMB) MB")
                return fileSizeMB <= Double(maxSizeMB)
            }
        } catch {
            print("Error getting video size: \(error.localizedDescription)")
        }
        
        return false
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
        vc.countDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateMediaCount() {
        let totalMedia = imageArray.count + videoArray.count
        let imageLimit = decryptSelectCategories?.data.marketplace_limits.mpk_product_image_limit ?? 0
        let videoLimit = decryptSelectCategories?.data.marketplace_limits.mpk_product_video_limit ?? 0
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.lblMediaCount.text = totalMedia == 1 ? "\(totalMedia) preview" : "\(totalMedia) previews"
            self.lblMediaCount.isHidden = totalMedia == 0
            self.lblMaxLimit.text = "Max images: \(imageLimit), Max videos: \(videoLimit)"
        }
    }


}

@available(iOS 16.0, *)
extension CreateMarketViewController: MediaCountUpdateDelegate {
    func didUpdateMediaCount(totalMedia: Int) {
        lblMediaCount.text = "\(totalMedia) preview"
        lblMediaCount.isHidden = totalMedia == 0
    }
    
    func didUpdateMedia(imageArray: [UIImage], videoArray: [URL]) {
        self.imageArray = imageArray
        self.videoArray = videoArray
        DispatchQueue.main.async {
            self.updateMediaCount()
        }
    }
}

// MARK: - PHPicker Delegate
extension CreateMarketViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TOCropViewControllerDelegate {

     func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
         picker.dismiss(animated: true, completion: nil)
         
         for result in results {
             if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                 result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                     guard let self = self else { return }
                     if let image = object as? UIImage {
                         if self.isImageSizeValid(image) {
                             DispatchQueue.main.async {
                                 self.pendingImages.append(image)
                                 self.tryPresentNextCrop()
                             }
                         } else {
                             DispatchQueue.main.async {
                                 self.alertToast(Message: "Image size exceeds the limit")
                             }
                         }
                     }
                 }
             } else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.video.identifier) {
                 result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.video.identifier) { [weak self] url, error in
                     guard let self = self else { return }
                     if let videoURL = url, self.isVideoSizeValid(videoURL) {
                         DispatchQueue.main.async {
                             self.videoArray.append(videoURL)
                             self.updateMediaCount()
                             self.collectionViewEvent.reloadData()
                         }
                     }
                 }
             }
         }
     }
     
     // MARK: - UIImagePicker Delegate (Camera / Gallery)
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         picker.dismiss(animated: true, completion: nil)
         
         if let image = info[.originalImage] as? UIImage {
             if isImageSizeValid(image) {
                 DispatchQueue.main.async {
                     self.pendingImages.append(image)
                     self.tryPresentNextCrop()
                 }
             } else {
                 alertToast(Message: "Image size exceeds the limit")
             }
         } else if let videoURL = info[.mediaURL] as? URL {
             if isVideoSizeValid(videoURL) {
                 videoArray.append(videoURL)
                 updateMediaCount()
                 collectionViewEvent.reloadData()
             } else {
                 alertToast(Message: "Video size exceeds the limit")
             }
         }
     }

     // MARK: - Crop Queue Handler
     func tryPresentNextCrop() {
         guard !pendingImages.isEmpty else { return }
         
         // Only present if no CropViewController is currently shown
         if !(self.presentedViewController is TOCropViewController) {
             let nextImage = pendingImages.first!
             let cropVC = TOCropViewController(image: nextImage)
             cropVC.delegate = self
             self.present(cropVC, animated: true)
         }
     }

     // MARK: - CropViewController Delegate
     func cropViewController(_ cropViewController: TOCropViewController, didCropTo croppedImage: UIImage, with cropRect: CGRect, angle: Int) {
         // Add cropped image to final array
         imageArray.append(croppedImage)
         
         // Remove the first pending image
         if !pendingImages.isEmpty {
             pendingImages.removeFirst()
         }
         
         cropViewController.dismiss(animated: true) {
             self.collectionViewEvent.reloadData()
             self.updateMediaCount()
             self.tryPresentNextCrop() // Present next pending image if exists
         }
     }
     
     func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
         // Remove cancelled image from queue
         if !pendingImages.isEmpty {
             pendingImages.removeFirst()
         }
         
         cropViewController.dismiss(animated: true) {
             self.tryPresentNextCrop()
         }
     }


    
    func presentCropViewController(image: UIImage) {
        let cropVC = TOCropViewController(image: image)
        cropVC.delegate = self
        self.present(cropVC, animated: true)
    }
}

extension CreateMarketViewController: UITextFieldDelegate {
    func isFirstCharacterZero(textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        return text.first == "0"
    }
}

extension CreateMarketViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: - Extension for UICollectionViewDelegateFlowLayout,UICollectionViewDataSource
extension CreateMarketViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewEvent {
            return imageArray.count + videoArray.count
        } else if collectionView == WicketRangeCollectionView {
            return images.count
        }else{ }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewEvent {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell
            if indexPath.row < imageArray.count {
                cell.LargeImgView.image = imageArray[indexPath.row]
            } else {
                let videoIndex = indexPath.row - imageArray.count
                let videoURL = videoArray[videoIndex]
                cell.LargeImgView.image = getVideoThumbnail(url: videoURL) // Function to get video thumbnail
            }
            cell.DeleteCallback = { [weak self] index in
                self?.didDeleteImage(at: index)
            }
            
            cell.FullImgCallback = { [self] value in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforePostEnlargeViewController")as! BeforePostEnlargeViewController
                vc.imageArray = self.imageArray.self
                vc.videoArray = self.videoArray
                //                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CamPostCollectionViewCell", for: indexPath) as! CamPostCollectionViewCell
            if indexPath.row < imageArray.count {
                cell.LargeImgView.image = imageArray[indexPath.row]
            } else {
                let videoIndex = indexPath.row - imageArray.count
                let videoURL = videoArray[videoIndex]
                cell.LargeImgView.image = getVideoThumbnail(url: videoURL)
            }
            cell.FullImgCallback = { [self] value in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforeCamPostViewController")as! BeforeCamPostViewController
                vc.images = self.images.self
                vc.videoArray = self.videoArray.self
                //                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.collectionViewEvent.width) / 1
        return CGSize(width: thisWidth, height: 214)
    }
}

// MARK: - Extension for ImageCollectionViewControllerDelegate
extension CreateMarketViewController: ImageCollectionViewControllerDelegate{
    func didTapDeleteButton(at index: Int) {
        didDeleteImage(at: index)
    }
}

// MARK: - Extension for ImageCollectionGalViewControllerDelegate
extension CreateMarketViewController: ImageCollectionGalViewControllerDelegate {
    func didDeleteImage(at index: Int) {
        if index < imageArray.count {
            imageArray.remove(at: index)
            updateMediaCount()
            collectionViewEvent.reloadData()
        } else {
            let videoIndex = index - imageArray.count
            videoArray.remove(at: videoIndex)
            updateMediaCount()
            collectionViewEvent.reloadData()
        }
    }
}
