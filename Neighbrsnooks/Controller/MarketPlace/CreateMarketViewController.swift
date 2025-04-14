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

@available(iOS 16.0, *)
class CreateMarketViewController: BaseViewController, UIPickerViewDelegate,UITextFieldDelegate ,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TOCropViewControllerDelegate, UITextViewDelegate, ImageCollectionViewControllerDelegate, ImageCollectionGalViewControllerDelegate, MarketDataSelectionDelegate  {
   
    
    
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
   
    
    
    enum MediaType {
        case image(UIImage)
        case video(URL)
    }

    struct Media {
        var type: MediaType
    }
    
   // let pickerView = UIPickerView()
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
   // var serviceName = [String]()
    var videoURL: URL?
    var serviceName: [String] = []
       var pickerView = UIPickerView()
    
    let placeholderText = "Describe your item ..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tpyePostLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.lblUploadImg.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.tfItemName.font = UIFont(name: "Montserrat-Regular", size: 16)
        tfCategory.inputView = pickerView
        tfCategory.delegate = self
        
        tfDesc.delegate = self
              
        let placeholderText = "Describe your item ..."
        tfDesc.text = placeholderText
        tfDesc.font = UIFont(name: "Montserrat-Regular", size: 18) // Change font and size
        tfDesc.textColor = UIColor.lightGray // Optional: Set text color


              // Set initial placeholder
        tfDesc.text = placeholderText
        tfDesc.textColor = UIColor.lightGray // Make t
        tfItemName.autocapitalizationType = .sentences
      //  tfBrand.autocapitalizationType = .sentences
        tfDesc.autocapitalizationType = .sentences
        
        self.serviceName.append("Market Categories")
        let professionLabelTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
        tpyePostLbl.isUserInteractionEnabled = true
        tpyePostLbl.addGestureRecognizer(professionLabelTap)
        
        tfItemName.attributedPlaceholder = NSAttributedString(
            string: "Enter item name",
            attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 18)!,
                .foregroundColor: UIColor.lightGray
            ]
        )
        
        tfItemPrice.attributedPlaceholder = NSAttributedString(
            string: "Enter item price",
            attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 18)!,
                .foregroundColor: UIColor.lightGray
            ]
        )

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        callMarketCatWebService{}
        
       
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
            ItemNameView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            CategoryView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
//            sellView.layer.borderColor = UIColor.lightGray.cgColor
//
//            DonateView.layer.borderColor = UIColor.lightGray.cgColor
            PriceView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            DescriptionView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            UploadImageView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            UploadImageView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            btnSell.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            btnDonate.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           
//            Add1View.layer.borderColor = UIColor.lightGray.cgColor
//            Add2.layer.borderColor = UIColor.lightGray.cgColor
            
            ItemNameView.layer.borderWidth = 1.0 // Enable border in dark mode
            CategoryView.layer.borderWidth = 1.0
            btnSell.layer.borderWidth = 1.0 // Enable border in dark mode
            btnDonate.layer.borderWidth = 1.0
//            sellView.layer.borderWidth = 1.0
//            DonateView.layer.borderWidth = 1.0
            PriceView.layer.borderWidth = 1.0 // Enable border in dark mode
            
            DescriptionView.layer.borderWidth = 1.0
            UploadImageView.layer.borderWidth = 1.0
                        FullMarketView.backgroundColor = .black
            
            UploadImageView.backgroundColor = .black
            UploadImageView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            UploadImageView.layer.borderWidth = 1.0
            ItemNameView.backgroundColor = .black
            CategoryView.backgroundColor = .black
            PriceView.backgroundColor = .black
            collectionViewEvent.backgroundColor = .black
            btnSell.backgroundColor = .black
            btnDonate.backgroundColor = .black
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
          //  questionView.textColor = UIColor.secondaryLabel
            ItemNameView.backgroundColor = .white
            ItemNameView.isUserInteractionEnabled = true // Disable in light mode
            CategoryView.isUserInteractionEnabled = true
//            sellView.isUserInteractionEnabled = true
//
//            DonateView.isUserInteractionEnabled = true // Disable in light mode
            PriceView.isUserInteractionEnabled = true
            DescriptionView.isUserInteractionEnabled = true
            UploadImageView.isUserInteractionEnabled = true
            
            UploadImageView.isUserInteractionEnabled = true
            
            
            ItemNameView.layer.borderWidth = 0 // Remove border in light mode
//            DonateView.layer.borderWidth = 0
//            sellView.layer.borderWidth = 0
            PriceView.layer.borderWidth = 0
            CategoryView.layer.borderWidth = 0
            DescriptionView.layer.borderWidth = 0
            btnSell.layer.borderWidth = 0
            btnDonate.layer.borderWidth = 0
           
            UploadImageView.backgroundColor = .white
            CategoryView.backgroundColor = .white
            PriceView.backgroundColor = .white
            collectionViewEvent.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            
            UploadImageView.layer.borderWidth = 0 // Remove border in light mode
            
           // option4.layer.borderWidth = 0
            UploadImageView.layer.borderWidth = 0
            FullMarketView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            
            btnSell.backgroundColor = .white
            btnDonate.backgroundColor = .white
            
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    @IBAction func SellBtnAction(_ sender: UIButton) {
       
        
        btnSell.backgroundColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
        btnDonate.backgroundColor = UIColor.white
        btnSell.setTitleColor(UIColor.white, for: .normal)
        btnDonate.setTitleColor(UIColor.gray, for: .normal)
        docType = "Sell"

   }
    
    @IBAction func DonateBtnAction(_ sender: UIButton) {
        btnSell.backgroundColor = UIColor.white
        btnDonate.backgroundColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
        btnDonate.setTitleColor(UIColor.white, for: .normal)
        btnSell.setTitleColor(UIColor.gray, for: .normal)
        docType = "Donate"

   }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.text == placeholderText {
               textView.text = "" // Remove the placeholder text
               textView.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1) // Change the text color to black for user input
           }
       }
       
       // UITextViewDelegate method to handle when the user finishes editing
       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = placeholderText // Add the placeholder text back if the text view is empty
               textView.textColor = UIColor.lightGray // Set the placeholder text color to light gray
           }
       }
    
    @IBAction func selectPhotos(_ sender: UIButton) {
    
        selectImages()
    
       }
    
    @IBAction func PublishBtn(_ sender: UIButton){
        sender.isEnabled = false
        
        if tfItemName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(message: "Please enter item name")
            sender.isEnabled = true
            return
        } else if tpyePostLbl.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(message: "Please select category")
            sender.isEnabled = true
            return
        } else if tfItemPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(message: "Please enter item price") // Fixed the wrong message
            sender.isEnabled = true
            return
        } else if tfDesc.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(message: "Please enter description") // Fixed the wrong message
            sender.isEnabled = true
            return
        }
        
        if imageArray.isEmpty && videoArray.isEmpty {
            showAlert(message: "Please select at least one image or video")
            sender.isEnabled = true
            return
        }
        
        // Upload function call
        uploadProductNew(
            title: tfItemName.text ?? "",
            description: tfDesc.text ?? "",
            saleType: tfCategory.text ?? "",
            salePrice: Double(tfItemPrice.text ?? "0.0") ?? 0.0,
            images: imageArray,  // Passing selected images
            videos: videoArray   // Passing selected videos
        )
        
        self.navigationController?.popViewController(animated: true)
        
        sender.isEnabled = true
        
    }
    
    @objc func professionLabelTapped() {
        showPopup(for: 1, allowMultipleSelection: false) // Single selection for profession
    }

    func didSelectItems(selectedItems: [String], forLabel tag: Int) {
        let selectedItemsString = selectedItems.isEmpty ? "Select" : selectedItems.joined(separator: ", ")
        
        if tag == 1 {
            // Profession selection
            tpyePostLbl.text = selectedItems.first ?? "Select" // Show only the first item for profession
        } else {
            print("Data not found")
        }
    }
  
    func showPopup(for labelTag: Int, allowMultipleSelection: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "SelectMarketCatViewController") as? SelectMarketCatViewController {
            
            popupVC.allowMultipleSelection = allowMultipleSelection
            popupVC.labelTag = labelTag
            popupVC.delegate = self

            // Ensure you have an instance of MarketCategoryModel
            if labelTag == 1 {
                // Assuming `marketCategoryModel` is an instance of MarketCategoryModel
                if let professionData = MarketCatDataNew?.category?.compactMap({ $0.catTitle }) {
                    popupVC.postData = professionData  // Pass profession data to postData array
                }
            }
            
            self.present(popupVC, animated: true, completion: nil)
        }
    }

    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let attributedMessage = NSAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 18, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
        )
        
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            // Crop karne ke liye function ko call karein
            presentCropViewController(image: image)
            // Add image to the image array
            imageArray.append(image)
            DispatchQueue.main.async {
                self.collectionViewEvent.reloadData() // Reload the collection view
            }
        } else if let videoURL = info[.mediaURL] as? URL {
            // Add video to the video array
            videoArray.append(videoURL)
            DispatchQueue.main.async {
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
           // Remove the item from the imageArray or videoArray
           if index < imageArray.count {
               imageArray.remove(at: index)
               // Reload the collection view to reflect the changes
               collectionViewEvent.reloadData()
           } else {
               let videoIndex = index - imageArray.count
               videoArray.remove(at: videoIndex)
               // Reload the collection view to reflect the changes
               collectionViewEvent.reloadData()
           }
       }
    
    
    func didTapDeleteButton(at index: Int) {
        // Call the delete method to remove the data and refresh views
        didDeleteImage(at: index)
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewEvent
        {
            return imageArray.count + videoArray.count
            
        } else if collectionView == WicketRangeCollectionView {
            return images.count
        }else{
            
        }
        return images.count
    }
    
 
    
    
    
    
    
    
    
    
    // --------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewEvent
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell
            
            // Check if the index corresponds to an image or a video
            if indexPath.row < imageArray.count {
                // Display the image
                cell.LargeImgView.image = imageArray[indexPath.row]
            } else {
                // Display the video thumbnail
                let videoIndex = indexPath.row - imageArray.count
                let videoURL = videoArray[videoIndex]
                cell.LargeImgView.image = getVideoThumbnail(url: videoURL) // Function to get video thumbnail
            }
            // Set delete callback
            cell.DeleteCallback = { [weak self] index in
                self?.didDeleteImage(at: index)
            }
            
            cell.FullImgCallback = { [self] value in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforePostEnlargeViewController")as! BeforePostEnlargeViewController
                //
                // vc.UserName = self.UserName.self
                vc.imageArray = self.imageArray.self
                vc.videoArray = self.videoArray // Pass video array to the next view controller
                self.navigationController?.pushViewController(vc, animated: true)
 
                
            }
            
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CamPostCollectionViewCell", for: indexPath) as! CamPostCollectionViewCell
            if indexPath.row < imageArray.count {
                // Display the image
                cell.LargeImgView.image = imageArray[indexPath.row]
            } else {
                // Display the video thumbnail
                let videoIndex = indexPath.row - imageArray.count
                let videoURL = videoArray[videoIndex]
                cell.LargeImgView.image = getVideoThumbnail(url: videoURL) // Function to get video thumbnail
                
            }
            
            
            cell.FullImgCallback = { [self] value in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforeCamPostViewController")as! BeforeCamPostViewController
                //
                // vc.UserName = self.UserName.self
                vc.images = self.images.self
                vc.videoArray = self.videoArray.self // Pass video array to the next view controller
                vc.delegate = self
                
                self.navigationController?.pushViewController(vc, animated: true)

                
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                  thisWidth = CGFloat(self.collectionViewEvent.width) / 1
                  return CGSize(width: thisWidth, height: 214)
        
//        thisWidth = CGFloat(self.WicketRangeCollectionView.width) / 1
//        return CGSize(width: thisWidth, height: 80)
              }
    
    
    

// ***** upload api create market api call

    func uploadProductNew(
        title: String,
        description: String,
        saleType: String,
        salePrice: Double,
        images: [UIImage],
        videos: [URL]
    ) {
        let idCategory = UserDefaults.standard.string(forKey: "idCategoryMarket")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let id = UserDefaults.standard.string(forKey: "userid")
        let userName = UserDefaults.standard.string(forKey: "username")

        let dictParams: [String: Any] = [
            "created_by": id ?? "",
            "p_title": title,
            "p_description": description,
            "sale_type": "product",
            "sale_price": salePrice,
            "total_price": "0",
            "brand_name": "Puma",
            "seller_name": userName ?? "",
            "cat_id": idCategory ?? "",
            "p_status": "1",
            "neighborhood_id": idNeighbour ?? ""
        ]

        let url = "https://dev.neighbrsnook.com/admin/api/mpk_product_add"
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
                    DispatchQueue.main.async {
                        self.showAlert(title: "Success", message: "Post created successfully!")
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
    
    
//    @IBAction func serviceNewBtnAction(_ sender: UIButton) {
//        self.view.endEditing(true)
//        self.showDropdownData(showOn: tfCategory, DropdownName: serviceDropdownData)
//        serviceDropdownData.cellHeight = 35
//        
//        serviceDropdownData.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
//      //  serviceDropdownData.bottomOffset = CGPoint(x: 50, y: 24)
//       // self.ServiceDescriptionLabel.text = self.ServiceTypeData?.data.seri
//    }
//    
//    private func showDropdownData(showOn textField: UITextField, DropdownName dropdown: DropDown) {
//
//        // Set the anchor and dropdown position
//        dropdown.anchorView = textField
//        dropdown.bottomOffset = CGPoint(x: 30, y: (dropdown.anchorView?.plainView.bounds.height)!)
//        
//        // Set up the appearance for the dropdown
//        dropdown.backgroundColor = UIColor.white
//        dropdown.cellHeight = 35
//        dropdown.direction = .bottom
//        dropdown.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
//        DropDown.appearance().setupCornerRadius(10)
//        dropdown.width = 200
//        
//        // Apply the font settings for the first item
//        dropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
//            if index == 0 {
//                cell.optionLabel.font = UIFont.boldSystemFont(ofSize: 16) // Bold font for the first item
//            } else {
//                cell.optionLabel.font = UIFont.systemFont(ofSize: 16) // Regular font for other items
//            }
//        }
//
//        // Set the selection action after the dropdown is shown
//        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
//            if index != 0 {
//                self.tfCategory.text = self.serviceName[index]
//            } else {
//                self.tfCategory.text = ""
//            }
//
//            UserDefaults.standard.set(self.serviceName[index], forKey: "id")
//            if index != 0 {
//                UserDefaults.standard.set(self.MarketCatDataNew?.category?[index - 1].id, forKey: "idCategoryMarket")
//            }
//        }
//
//        // Show the dropdown
//        dropdown.show()
//    }

    
    
    
    
    
//    private func showDropdownData(showOn textField: UITextField, DropdownName dropdown : DropDown) {
//
//        dropdown.show()
//        dropdown.anchorView = textField
//        dropdown.bottomOffset = CGPoint(x: 30, y: (dropdown.anchorView?.plainView.bounds.height)!)
//
//        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
//            if index != 0{
//                self.tfCategory.text = self.serviceName[index]
//            }else{
//                self.tfCategory.text = ""
//            }
//           // self.serviceId = "\(AddProjectData?.nbdata[index].id ?? 0)"
//
//
//            UserDefaults.standard.set(self.serviceName[index], forKey: "id")
//            if index != 0{
//                UserDefaults.standard.set(self.MarketCatDataNew?.category?[index - 1].id, forKey: "idCategoryMarket")
//            }
//            dropdown.backgroundColor = UIColor.white
//            dropdown.cellHeight = 35
//            dropdown.direction = .bottom
//            dropdown.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
//            DropDown.appearance().setupCornerRadius(10)
//            //dropdown.serviceName = .left
//            dropdown.width = 200
//
//            // Custom cell configuration for setting font size and style
//               dropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
//                   if index == 0 {
//                       cell.optionLabel.font = UIFont.boldSystemFont(ofSize: 16) // Bold font for the first item
//                   } else {
//                       cell.optionLabel.font = UIFont.systemFont(ofSize: 16) // Regular font for other items
//                   }
//               }
//
//        }
//    }
    
    func callMarketCatWebService(completion: @escaping () -> Void) {
        let url = "https://dev.neighbrsnook.com/admin/api/category"
         let dictParams: Dictionary<String, Any> = ["":""]
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                
                do {
                    let data = try JSONDecoder().decode(MarketCategoryModel.self, from: result!)
                    self.MarketCatDataNew = data
                  //  UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "CreatorId")
//                    for value in self.MarketCatDataNew?.category ?? [] {
//                        self.serviceName.append(value.catTitle ?? "")
//                    }
//                    self.serviceDropdownData.dataSource = self.serviceName
                    
                    DispatchQueue.global().async {
                        // Simulate network delay
                        sleep(2)
                        
                        // Update MarketWDetailData with fetched data
                        // Example data assignment
                        self.MarketCatDataNew = data // Your actual data fetching logic
                        for value in self.MarketCatDataNew?.category ?? [] {
                            self.serviceName.append(value.catTitle ?? "")
                        }
                         
                        DispatchQueue.main.async {
                            completion() // Call completion handler
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(MarketCategoryModel.self, from: result!)
                    //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
//                    for value in self.MarketCatDataNew?.category ?? [] {
//                        self.serviceName.append(value.catTitle ?? "")
//                    }
//                    self.serviceDropdownData.dataSource = self.serviceName
                } catch {
                    print(error.localizedDescription)
                }
            case .UNAUTHORIZED:
                print(error?.localizedDescription)
                //   self.showLogoutAlert()
            default:
                break
            }
        }
    }

}
