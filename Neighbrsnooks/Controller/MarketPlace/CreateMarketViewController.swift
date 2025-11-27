//
//  CreateMarketViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 13/09/24.
//
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
class CreateMarketViewController: BaseViewController, UIPickerViewDelegate,UITextFieldDelegate ,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TOCropViewControllerDelegate, UITextViewDelegate, ImageCollectionViewControllerDelegate, ImageCollectionGalViewControllerDelegate  {
    
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
    var selectedCategoryName: String?
    
    enum MediaType {
        case image(UIImage)
        case video(URL)
    }
    
    struct Media {
        var type: MediaType
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCreate.isUserInteractionEnabled = true
        callMarketCatWebService{}
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
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    @IBAction func selectPhotos(_ sender: UIButton) {
        guard let imageLimit = MarketCatDataNew?.mpkProductImgLimit,
              let videoLimit = MarketCatDataNew?.mpkProductVideoLimit else {
            showAlert(message: "Image or video limit not set")
            return
        }
        
        let isImageLimitReached = imageArray.count >= imageLimit
        let isVideoLimitReached = videoArray.count >= videoLimit
        
        if isImageLimitReached && isVideoLimitReached {
            showAlert(message: "You have reached the max limit of image & video")
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
        let itemName = tfItemName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let itemPrice = tfItemPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let itemDescRaw = tfDesc.text
        let itemDesc = itemDescRaw?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        sender.isEnabled = false
        
        // Validation
        if itemName.isEmpty {
            showAlert(message: "Please enter item name")
            sender.isEnabled = true
            return
        }
        if tpyePostLbl.text == "Select category"{
            showAlert(message: "Please select a category")
            sender.isEnabled = true
            return
        }
        
        if docType.isEmpty {
            showAlert(message: "Select Sell or Donate to continue")
            sender.isEnabled = true
            return
        }
        
        if docType == "Sell", itemPrice.isEmpty {
            showAlert(message: "Please enter item price")
            sender.isEnabled = true
            return
        }
        if tfDesc.text == "Describe your item ..." || tfDesc.text == "" {
            showAlert(message: "Please enter description")
            sender.isEnabled = true
            return
        }
        
        if isFirstCharacterZero(textField: tfItemPrice) {
            showAlert(message: "Price can not start from 0")
            sender.isEnabled = true
            return
        }
        
        
        if imageArray.isEmpty && videoArray.isEmpty {
            showAlert(message: "Please select at least one image or video")
            sender.isEnabled = true
            return
        }
        
        // Bad word checks
        if containsBadWords(itemName) {
            showAlert(message: "Please remove inappropriate words from Item Name")
            sender.isEnabled = true
            return
        }
        
        if containsBadWords(itemDesc ) {
            showAlert(message: "Please remove inappropriate words from Description")
            sender.isEnabled = true
            return
        }
        
        uploadProductNew(
            
            title: itemName,
            description: itemDesc,
            saleType: docType,
            salePrice: Double(itemPrice) ?? 0,
            images: imageArray,
            videos: videoArray
        )
        SVProgressHUD.show()
        btnCreate.isUserInteractionEnabled = false
    }
    
    func isFirstCharacterZero(textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        return text.first == "0"
    }
    
    @objc func professionLabelTapped() {
        showPopup(for: 3, allowMultipleSelection: false) // Single selection for profession
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

    func showAlert(message: String) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let attributedMessage = NSAttributedString(
                string: message,
                attributes: [.font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)])
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            okAction.setValue(#colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1), forKey: "titleTextColor")
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        func selectImages(isImageLimitReached: Bool, isVideoLimitReached: Bool) {
            let actionSheet = UIAlertController(title: "Select Media", message: nil, preferredStyle: .actionSheet)
            
            // Add Photo options only if image limit is not reached
            if !isImageLimitReached {
                actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                    self.openCamera()
                }))
                actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
                    self.openGallery()
                }))
            }
            
            // Add Video options only if video limit is not reached
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
            
            guard let limit = MarketCatDataNew?.mpkProductImgLimit else {
                showAlert(message: "Image limit not set")
                return
            }
            
            let remainingLimit = limit - imageArray.count
            
            if remainingLimit <= 0 {
                showAlert(message: "You have reached the max image limit")
                return
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .camera
                imagePickerController.cameraCaptureMode = .photo
                present(imagePickerController, animated: true, completion: nil)
            } else {
                showAlert(message: "Camera is not available")
            }
        }
        
        
        func openGallery() {
            from = 1  // ✅ Keep this as required
            
            guard let limit = MarketCatDataNew?.mpkProductImgLimit else {
                showAlert(message: "Image limit not set")
                return
            }
            
            let remainingLimit = limit - imageArray.count
            
            if remainingLimit <= 0 {
                self.updateMediaCount()
                showAlert(message: "You have reached the maximum image limit")
                return
            }
            
            var config = PHPickerConfiguration()
            config.selectionLimit = remainingLimit  // ✅ Only allow remaining count
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
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            
            if let image = info[.originalImage] as? UIImage {
                presentCropViewController(image: image)
                imageArray.append(image)
                DispatchQueue.main.async {
                    self.updateMediaCount()
                    self.collectionViewEvent.reloadData()
                }
            } else if let videoURL = info[.mediaURL] as? URL {
                videoArray.append(videoURL)
                DispatchQueue.main.async {
                    self.updateMediaCount()
                    self.collectionViewEvent.reloadData()
                }
            }
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            for result in results {
                if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                        if let imageNew = object as? UIImage {
                            self.imageArray.append(imageNew)
                            DispatchQueue.main.async {
                                self.lblMediaCount.isHidden = false
                                self.updateMediaCount()
                                self.collectionViewEvent.reloadData()
                                self.presentCropViewController(image: imageNew)
                            }
                        }
                    }
                } else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.video.identifier) {
                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.video.identifier) { (url, error) in
                        if let videoURL = url {
                            self.videoArray.append(videoURL)
                            DispatchQueue.main.async {
                                self.updateMediaCount()
                                self.lblMediaCount.isHidden = false
                                self.collectionViewEvent.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        // Crop function jo pehle se available hai
        func presentCropViewController(image: UIImage) {
            let cropViewController = TOCropViewController(image: image)
            cropViewController.delegate = self
            self.present(cropViewController, animated: true, completion: nil)
        }
        
        
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
        
        
        func didTapDeleteButton(at index: Int) {
            didDeleteImage(at: index)
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
        
        func uploadProductNew(
            title: String,
            description: String,
            saleType: String,
            salePrice: Double,
            images: [UIImage],
            videos: [URL]
        ) {
            print("Uploading title: \(title)")
            let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
            let id = UserDefaults.standard.string(forKey: "userid")
            
            let dictParams: [String: Any] = [
                "created_by": id ?? "",
                "p_title": title,
                "p_description": description,
                "sale_type": saleType,
                "sale_price": salePrice,
                "total_price": salePrice,
                "brand_name": "Puma",
                "cat_id": selectedCategoryId ?? "",
                "p_status": "1",
                "neighborhood_id": idNeighbour ?? "",
                "p_quantity": 0
            ]
            print("Params is : \(dictParams)")
            
            let url = "https://laravelpanel.neighbrsnook.com/api/mpk_product_add"  // dev.
            let dispatchGroup = DispatchGroup()
            var convertedVideos: [URL] = []
            
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
                        for (key, value) in dictParams {
                            if let valueData = "\(value)".data(using: .utf8) {
                                multipartFormData.append(valueData, withName: key)
                            }
                        }
                        
                        // Append images
                        for (index, image) in images.enumerated() {
                            if let imageData = image.jpegData(compressionQuality: 0.8) {
                                multipartFormData.append(
                                    imageData,
                                    withName: "p_images[]",
                                    fileName: "image_\(index).jpg",
                                    mimeType: "image/jpeg"
                                )
                            }
                        }
                        
                        // Append converted videos
                        for (index, videoURL) in convertedVideos.enumerated() {
                            do {
                                let videoData = try Data(contentsOf: videoURL)
                                multipartFormData.append(
                                    videoData,
                                    withName: "p_images[]",
                                    fileName: "video_\(index).mp4",
                                    mimeType: "video/mp4"
                                )
                            } catch {
                                print("Error reading video file \(videoURL.lastPathComponent): \(error.localizedDescription)")
                            }
                        }
                    },
                    to: url
                )
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        print("Upload successful: \(data)")
                        SVProgressHUD.dismiss()
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error):
                        print("Upload failed: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.showAlert(title: "Error", message: "Failed to create post. Please try again.")
                        }
                    }
                }
            }
        }
        
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
                    completion(outputURL)  // Successfully converted to MP4
                case .failed, .cancelled:
                    print("Error during conversion: \(exportSession?.error?.localizedDescription ?? "Unknown error")")
                    completion(nil)  // Conversion failed
                default:
                    break
                }
            }
        }
        
        func callMarketCatWebService(completion: @escaping () -> Void) {
            let url = "https://laravelpanel.neighbrsnook.com/api/category"     // dev.
            let dictParams: Dictionary<String, Any> = ["":""]
            RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
            {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                switch statusCode {
                case .SUCCESS ,.CREATED:
                    do {
                        let data = try JSONDecoder().decode(MarketCategoryModel.self, from: result!)
                        self.MarketCatDataNew = data
                        let imageCount = self.imageArray.count
                        let videoCount = self.videoArray.count
                        let imageLimit = self.MarketCatDataNew?.mpkProductImgLimit ?? 0
                        let totalMedia = imageCount + videoCount
                        
                        if imageCount == imageLimit && videoCount == 1 {
                            self.lblMediaCount.text = "\(totalMedia) preview"
                        } else if imageCount == 1 && videoCount == 1 {
                            self.lblMediaCount.text = "\(totalMedia) preview"
                        } else if imageCount > 1 && videoCount == 1 {
                            self.lblMediaCount.text = "\(totalMedia) previews"
                        } else {
                            self.lblMediaCount.text = "\(totalMedia) preview"
                        }
                        
                        self.lblMaxLimit.text = "Max limit: \(self.MarketCatDataNew?.mpkProductImgLimit ?? 0) Images & \(self.MarketCatDataNew?.mpkProductVideoLimit ?? 0) video"
                        print("Model data for callMarketCatWebService is :\(data)")
                        DispatchQueue.global().async {
                            sleep(2)
                            self.MarketCatDataNew = data
                            for (index, value) in self.MarketCatDataNew?.category?.enumerated() ?? [].enumerated() {
                                self.serviceName.append(value.catTitle ?? "")
                                if index == 0 {
                                    UserDefaults.standard.setValue(value.id ?? "", forKey: "idCategoryMarket")
                                }
                            }
                            DispatchQueue.main.async {
                                completion()
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                    do {
                        let data = try JSONDecoder().decode(MarketCategoryModel.self, from: result!)
                        print("Data is :\(data)")
                    } catch {
                        print(error.localizedDescription)
                    }
                case .UNAUTHORIZED:
                    print(error?.localizedDescription ?? "")
                default:
                    break
                }
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
            
            // ✅ UI Update karo
            DispatchQueue.main.async {
                self.updateMediaCount()
            }
        }
        
        func updateMediaCount() {
            let imageCount = self.imageArray.count
            let videoCount = self.videoArray.count
            let imageLimit = self.MarketCatDataNew?.mpkProductImgLimit ?? 0
            let totalMedia = imageCount + videoCount
            
            if imageCount == imageLimit && videoCount == 1 {
                self.lblMediaCount.text = "\(totalMedia) preview"
            } else if imageCount == 1 && videoCount == 1 {
                self.lblMediaCount.text = "\(totalMedia) preview"
            } else if imageCount > 1 && videoCount == 1 {
                self.lblMediaCount.text = "\(totalMedia) previews"
            } else {
                self.lblMediaCount.text = "\(totalMedia) preview"
            }
            lblMediaCount.isHidden = totalMedia == 0
        }
    }
