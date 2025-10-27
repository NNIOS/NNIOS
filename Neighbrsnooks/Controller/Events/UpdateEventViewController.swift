//
//  UpdateEventViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 29/01/25.
//

import UIKit
import SVProgressHUD
import Alamofire
import Photos
import CropViewController

@available(iOS 16.0, *)
class UpdateEventViewController:  BaseViewController,CropViewControllerDelegate {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfSrartDate: UITextField!
    @IBOutlet weak var tfEndDate: UITextField!
    @IBOutlet weak var tfStartTime: UITextField!
    @IBOutlet weak var tfEndTime: UITextField!
    @IBOutlet weak var tvDesc: UITextView!

    @IBOutlet weak var tfAdd1: UITextField!
    @IBOutlet weak var tfAdd2: UITextField!
    
    @IBOutlet weak var collectionViewEvent: UICollectionView!
    @IBOutlet weak var WicketRangeCollectionView: UICollectionView!
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var lblEventAddress: UILabel!
    @IBOutlet weak var lblUploadEvent: UILabel!
    @IBOutlet weak var lblmaxImg: UILabel!
    @IBOutlet weak var TitleeView: UIView!
    @IBOutlet weak var EndDateView: UIView!
    
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var startTimeView: UIView!
    @IBOutlet weak var EndTimeView: UIView!
    @IBOutlet weak var Description: UIView!
    
    @IBOutlet weak var UploadImageView: UIView!
    @IBOutlet weak var Add1View: UIView!
    @IBOutlet weak var Add2: UIView!
    @IBOutlet weak var createEventView: UIView!
    @IBOutlet weak var AddressEventView: UIView!
    
    @IBOutlet weak var profileImgView : UIImageView!
    var eventid = ""
    
    var EventDetauilData : EventDetailModel?
    var EventUpdatesData : UpdateEventModel?
    var objDecryptEventData:decryptEvent?
    var from = 1
    var fromDate = 1
    var timePickerContainer = UIView()
    var thisWidth:CGFloat = 0
    var titleLabel: String?
    let timePicker = UIDatePicker()
    let datePicker = UIDatePicker()
    var imagePicker:UIImagePickerController?
    var imageArray = [UIImage]()
    var CamimageArray = [UIImage]()
    var selectedImages: [UIImage] = []
    var images: [UIImage] = []
    var selectedImge: UIImage? = nil
    
    var jEventId:Int?
    var objEventData:EventItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = objDecryptEventData?.data?.data
        lblHeading.text = item?.title
        tfTitle.text = item?.title
        tfSrartDate.text = item?.event_date
        tfEndDate.text = item?.event_end_date
        tfStartTime.text = item?.event_start_time
        tfEndTime.text = item?.event_end_time
        tvDesc.text = item?.event_detail
        tfAdd1.text = item?.address_line_one
        tfAdd2.text = item?.address_line_two
        ImageLoader.shared.setImage(on: profileImgView, urlString: item?.cover_image, placeholder: "check")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        tfTitle.autocapitalizationType = .sentences
        tfAdd1.autocapitalizationType = .sentences
        tfAdd2.autocapitalizationType = .sentences
        self.tfStartTime.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfEndTime.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfSrartDate.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfEndDate.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tvDesc.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfTitle.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblEventAddress.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblUploadEvent.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfAdd1.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfAdd2.font = UIFont(name: "Montserrat-Regular", size: 17)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            TitleeView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            EndDateView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            startDateView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            
            EndTimeView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            tfEndTime.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            Description.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            UploadImageView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            startTimeView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            AddressEventView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
//            Add1View.layer.borderColor = UIColor.lightGray.cgColor
//            Add2.layer.borderColor = UIColor.lightGray.cgColor
            
            TitleeView.layer.borderWidth = 1.0 // Enable border in dark mode
            EndDateView.layer.borderWidth = 1.0
            startDateView.layer.borderWidth = 1.0
            startTimeView.layer.borderWidth = 1.0
            EndTimeView.layer.borderWidth = 1.0 // Enable border in dark mode
            
            Description.layer.borderWidth = 1.0
            Add1View.layer.borderWidth = 1.0
            Add2.layer.borderWidth = 1.0
            AddressEventView.layer.borderWidth = 1.0
            createEventView.backgroundColor = .black
            Description.backgroundColor = .black
            TitleeView.backgroundColor = .black
            Add1View.backgroundColor = .black
            Add2.backgroundColor = .black
            tfAdd1.backgroundColor = .black
            tfAdd2.backgroundColor = .black
            UploadImageView.backgroundColor = .black
            UploadImageView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            UploadImageView.layer.borderWidth = 1.0
           
            
        } else {
          //  questionView.textColor = UIColor.secondaryLabel
            TitleeView.isUserInteractionEnabled = true // Disable in light mode
            EndDateView.isUserInteractionEnabled = true
            startDateView.isUserInteractionEnabled = true
            
            EndTimeView.isUserInteractionEnabled = true // Disable in light mode
            tfEndTime.isUserInteractionEnabled = true
            Description.isUserInteractionEnabled = true
            UploadImageView.isUserInteractionEnabled = true
            
            Add1View.isUserInteractionEnabled = true
            Add2.isUserInteractionEnabled = true
            startTimeView.isUserInteractionEnabled = true
            
            TitleeView.layer.borderWidth = 0 // Remove border in light mode
            tfSrartDate.layer.borderWidth = 0
            startDateView.layer.borderWidth = 0
            startTimeView.layer.borderWidth = 0
            EndDateView.layer.borderWidth = 0
            AddressEventView.layer.borderWidth = 0
            tfAdd1.backgroundColor = .white
            tfAdd2.backgroundColor = .white
            
            Add1View.backgroundColor = .white
            Add2.backgroundColor = .white
            UploadImageView.backgroundColor = .white
            
            EndTimeView.layer.borderWidth = 0 // Remove border in light mode
            tfEndTime.layer.borderWidth = 0
            Description.layer.borderWidth = 0
            Add1View.layer.borderWidth = 0
            Add2.layer.borderWidth = 0
           // option4.layer.borderWidth = 0
            UploadImageView.layer.borderWidth = 0
            createEventView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnStartTime(_ sender: UIButton) {
        from = 1
        openTimePicker()
    }
    
    @IBAction func btnEndTime(_ sender: UIButton) {
        from = 2
        openTimePicker()
    }
    
    @IBAction func btnStartDate(_ sender: UIButton) {
        showDatePicker(for: tfSrartDate)
    }
    
    @IBAction func btnEndDate(_ sender: UIButton) {
        showDatePicker(for: tfEndDate)
    }
    
    @IBAction func selectPhotos(_ sender: UIButton) {
        openCameraGallery()
       }
    
    @objc func imageViewTapped(_ sender:AnyObject){
        openCameraGallery()
    }
    
    @IBAction func PublishBtn(_ sender: UIButton){
            
            if tfTitle.text?.isEmpty == true {
                    showAlert(message: "Please Enter title")
                } else if tfSrartDate.text?.isEmpty == true {
                    showAlert(message: "Please select start date")
                } else if tfEndDate.text?.isEmpty == true {
                    showAlert(message: "Please select end date")
                } else if tfStartTime.text?.isEmpty == true {
                    showAlert(message: "Please select start time")
                } else if tfEndTime.text?.isEmpty == true {
                    showAlert(message: "Please select end time")
                } else if tvDesc.text?.isEmpty == true {
                    showAlert(message: "Please enter description")
                } else if tfAdd1.text?.isEmpty == true {
                    showAlert(message: "Please enter address line 1")
                } else if tfAdd2.text?.isEmpty == true {
                    showAlert(message: "Please enter address line 2")
                } else {
                    updateEvents()
                }
          
        }
    
    func showAlert(message: String) {
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let font = UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.darkGray
            ]
            
            let attributedTitle = NSAttributedString(string: title ?? "", attributes: titleAttributes)
            let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            okAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor")
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    
    func showDatePicker(for textField: UITextField) {
           let datePicker = UIDatePicker()
           datePicker.datePickerMode = .date
           datePicker.preferredDatePickerStyle = .wheels
            datePicker.minimumDate = Date()
           datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
           
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
           let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
           
           toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
           
           textField.inputAccessoryView = toolbar
           textField.inputView = datePicker
           textField.becomeFirstResponder()
       }

       @objc func dateChanged(_ sender: UIDatePicker) {
           // Convert date to string format
           let formatter = DateFormatter()
           formatter.dateFormat = "dd-MM-yyyy"
           
           if let textField = tfSrartDate.isFirstResponder ? tfSrartDate : tfEndDate {
               textField.text = formatter.string(from: sender.date)
           }
       }
    
    @objc func doneButtonTapped() {
           view.endEditing(true)
       }

       @objc func cancelButtonTapped() {
           view.endEditing(true)
       }
    
    @objc func donePicker() {
        
        timePickerContainer.removeFromSuperview()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm aa"
        let timeSelected = formatter.string(from: timePicker.date)
        
        if from==1
        {
            tfStartTime.text = timeSelected
        }
        else
        {
            tfEndTime.text = timeSelected
        }
        
    }
    
    @objc func dismissPicker() {
        timePickerContainer.removeFromSuperview()
    }
    
    func openTimePicker() {
        timePickerContainer.frame = CGRect(x: 0.0, y: (self.view.frame.height - 250), width: self.view.frame.width, height: 250.0)
        timePickerContainer.backgroundColor = UIColor.white

        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor(named:"primaryColor"), for: .normal)
        doneButton.addTarget(self, action: #selector(donePicker), for: UIControl.Event.touchUpInside)
        doneButton.frame = CGRect(x: (self.view.frame.width - 100), y: 5.0, width: 70.0, height: 40.0)
        timePickerContainer.addSubview(doneButton)

        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor(named:"primaryColor"), for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissPicker), for: UIControl.Event.touchUpInside)
        cancelButton.frame = CGRect(x: 20.0, y: 5.0, width: 70.0, height: 40.0)
        timePickerContainer.addSubview(cancelButton)

        timePicker.frame = CGRect(x: 0.0, y: 40.0, width: self.view.frame.width, height: 200.0)
        timePicker.datePickerMode = .time
        
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }

        timePicker.backgroundColor = UIColor.white
        timePicker.locale = Locale(identifier: "en_US")
        timePickerContainer.addSubview(timePicker)

        self.view.addSubview(timePickerContainer)
    }
    
    
    func callsendImageAPI(param:[String: Any],arrImage:UIImage,imageKey:String,URlName:String, withblock:@escaping ()->Void){
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
                guard let imgData = arrImage.jpegData(compressionQuality: 1) else { return }
            multipartFormData.append(imgData, withName: imageKey, fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
            guard let imgData2 = self.profileImgView.image?.jpegData(compressionQuality: 1) else { return }
            multipartFormData.append(imgData, withName: "aadharBack", fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
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
    
    func formatDate(_ dateStr: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateStr) {
            return outputFormatter.string(from: date)
        }
        return dateStr
    }
    
    func formatTime(_ timeStr: String) -> String {
        let inputFormatter1 = DateFormatter()
        inputFormatter1.dateFormat = "hh:mm a"
        let inputFormatter2 = DateFormatter()
        inputFormatter2.dateFormat = "HH:mm"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        if let date = inputFormatter1.date(from: timeStr) {
            return outputFormatter.string(from: date)
        } else if let date = inputFormatter2.date(from: timeStr) {
            return outputFormatter.string(from: date)
        }
        return timeStr
    }

    
    func isImageSizeValid(_ image: UIImage, maxSizeKB: Int = 5048) -> Bool {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let imageSizeKB = imageData.count / 1024
            let imageSizeMB = Double(imageSizeKB) / 1024.0
            print("Image size: \(imageSizeKB) KB (\(String(format: "%.2f", imageSizeMB)) MB)")
            return imageSizeKB <= maxSizeKB
        }
        print("❌ Could not convert image to data")
        return false
    }
    
    func isValidStartEnd(startDate: String, endDate: String, startTime: String, endTime: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let start = formatter.date(from: "\(startDate) \(startTime)"),
           let end = formatter.date(from: "\(endDate) \(endTime)") {
            return end > start
        }
        return false
    }

    
    func updateEvents() {
        let startDate = formatDate(tfSrartDate.text ?? "")
        let endDate = formatDate(tfEndDate.text ?? "")
        let startTime = formatTime(tfStartTime.text ?? "")
        let endTime = formatTime(tfEndTime.text ?? "")
        
        if !isValidStartEnd(startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime) {
            self.alertToast(Message: "End time must be after start time")
            return
        }

        let request = EventUpdate_Request(
            title: tfTitle.text ?? "",
            event_date: startDate,
            event_end_date: endDate,
            event_start_time: startTime,
            event_end_time: endTime,
            cover_image: "",
            event_detail: tvDesc.text ?? "",
            address_line_one: tfAdd1.text ?? "",
            address_line_two: tfAdd2.text ?? "",
            id: jEventId ?? 0
        )

        var uploadImages = imageArray
        if let profileImage = selectedImge {
            uploadImages.append(profileImage)
        }
        if uploadImages.isEmpty, let defaultImg = UIImage(named: "EventImage") {
            uploadImages.append(defaultImg)
        }
        for img in uploadImages {
            if !isImageSizeValid(img) {
                self.alertToast(Message: "Image size should be less than 5 MB")
                return
            }
        }

        let param: [String: Any] = [
            "title": request.title,
            "event_date": request.event_date,
            "event_end_date": request.event_end_date,
            "event_start_time": request.event_start_time,
            "event_end_time": request.event_end_time,
            "event_detail": request.event_detail,
            "address_line_one": request.address_line_one,
            "address_line_two": request.address_line_two
        ]
        
        if let croppedImage = profileImgView.image {
            callsendImageAPI(param: param, arrImage: croppedImage, imageKey: "cover_image", URlName: API.createEvents) {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

@available(iOS 16.0, *)
extension UpdateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true) {
            self.showCrop(image: image) // Open crop view
        }
    }

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

    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            self.profileImgView.image = image
            self.selectedImge = image
        }
    }

    func openCameraGallery() {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            print("User clicked Camera button")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker = UIImagePickerController()
                self.imagePicker?.sourceType = .camera
                self.imagePicker?.allowsEditing = false
                self.imagePicker?.delegate = self
                self.present(self.imagePicker!, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))

        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            print("User clicked Gallery button")
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker = UIImagePickerController()
                self.imagePicker?.sourceType = .photoLibrary
                self.imagePicker?.allowsEditing = false
                self.imagePicker?.delegate = self
                self.present(self.imagePicker!, animated: true, completion: nil)
            } else {
                print("Photo library not available")
            }
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            print("User clicked Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
