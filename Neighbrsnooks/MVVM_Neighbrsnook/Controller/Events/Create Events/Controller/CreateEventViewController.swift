//
//  CreateEventViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 15/04/24.
//

import UIKit
import Alamofire
import Photos
import PhotosUI
import SVProgressHUD
import TOCropViewController
import CropViewController

@available(iOS 16.0, *)
class CreateEventViewController: UIViewController{
    
    func didDeleteImage(at index: Int) {
        images.remove(at: index)
        updateCollectionView()
    }
    
    var allImages: [UIImage] {
        return images + imageArray
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tfStartTime: UITextField!
    @IBOutlet weak var tfEndTime: UITextField!
    @IBOutlet weak var tfStartDatee: UITextField!
    @IBOutlet weak var tfEndDate: UITextField!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfadd1: UITextField!
    @IBOutlet weak var tfAdd2: UITextField!
    @IBOutlet weak var tfDesc: UITextView!
    @IBOutlet weak var tfDescHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblEventAddress: UILabel!
    @IBOutlet weak var lblUploadEvent: UILabel!
    @IBOutlet weak var lblmaxImg: UILabel!
    @IBOutlet weak var WicketRangeCollectionView: UICollectionView!
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
    @IBOutlet weak var collectionviewWicketRangeHeight: NSLayoutConstraint!
    
    // MARK: - Variable
    var from = 1
    var fromDate = 1
    var timePickerContainer = UIView()
    var thisWidth:CGFloat = 0
    let timePicker = UIDatePicker()
    let datePicker = UIDatePicker()
    var imagePicker:UIImagePickerController?

    var CamimageArray = [UIImage]()
    var imageArray = [UIImage]()
    var selectedImages: [UIImage] = []
    
    var images: [UIImage] = []
    var selectedImge: UIImage? = nil
    var createEventData : CreateEventModel?
    var objEventData:CreateEventsResponse?
    var selectedDate: Date?
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reach().isInternet() {
            setupUI()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Buton's Action
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStartTime(_ sender: UIButton) {
        from = 1
        openTimePicker(defaultHour: 10, defaultMinute: 0)
    }
    
    @IBAction func btnEndTime(_ sender: UIButton) {
        from = 2
        openTimePicker(defaultHour: 19, defaultMinute: 0)
    }
    
    @IBAction func btnStartDate(_ sender: UIButton) {
        showDatePicker(for: tfStartDatee)
    }
    
    @IBAction func btnEndDate(_ sender: UIButton) {
        showDatePicker(for: tfEndDate)
    }
    
    @IBAction func selectPhotos(_ sender: UIButton) {
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.openCameraGalleryForSingleImage()
            }
        }
    }
    
    @IBAction func PublishBtn(_ sender: UIButton) {
        let validations: [(Bool, String)] = [
            (tfTitle.text?.isEmpty ?? true, "Please enter title"),
            (tfStartDatee.text?.isEmpty ?? true, "Please select start date"),
            (tfEndDate.text?.isEmpty ?? true, "Please select end date"),
            (tfStartTime.text?.isEmpty ?? true, "Please select start time"),
            (tfEndTime.text?.isEmpty ?? true, "Please select end time"),
            (tfDesc.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || tfDesc.text == "Description", "Please enter description"),
            (tfadd1.text?.isEmpty ?? true, "Please enter flat/houseno. apartment name "),
            (tfAdd2.text?.isEmpty ?? true, "Please enter road/ street name"),
            (containsBadWords(tfTitle.text ?? ""), "Please remove inappropriate words from Title"),
            (containsBadWords(tfDesc.text ?? ""), "Please remove inappropriate words from Description"),
            (containsBadWords(tfadd1.text ?? ""), "Please remove inappropriate words from Address Line 1"),
            (containsBadWords(tfAdd2.text ?? ""), "Please remove inappropriate words from Address Line 2")
        ]
        for (condition, message) in validations {
            if condition {
                alertToast(Message: message)
                return
            }
        }
        if Reach().isInternet() {
            createEvents()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }

}

// MARK: - Exteniosn for UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource
extension CreateEventViewController: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell
        cell.LargeImgView.image = allImages[indexPath.row]
        cell.LargeImgView.contentMode = .scaleAspectFill
        cell.FullImgCallback = { [self] value in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforePostEnlargeViewController") as! BeforePostEnlargeViewController
            vc.imageArray = self.allImages
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.WicketRangeCollectionView.width) / 1
        return CGSize(width: thisWidth, height: 214)
    }
}

// MARK: - Extension for ImageCollectionViewControllerDelegate
extension CreateEventViewController: ImageCollectionViewControllerDelegate {
    func didTapDeleteButton(at index: Int) {
    }
}

// MARK: - Extension for UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate   {
    
    // MARK - function for open camra or gallery
    @objc func openCameraGalleryForSingleImage() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            print("User clicked Camera button")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = false
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            print("User clicked Gallery button")
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = false
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
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
    
    // MARK - function for handle slect iamge
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        picker.dismiss(animated: true, completion: nil)
        showCrop(image: image)
    }
    
    // MARK - function for handle crop image
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioLockEnabled = false
        vc.resetAspectRatioEnabled = true
        vc.rotateButtonsHidden = false
        vc.rotateClockwiseButtonHidden = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "continue"
        vc.cancelButtonTitle = "Quit"
        vc.cropView.cropBoxResizeEnabled = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    // MARK - function for handle dimiss controller
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    // MARK - function for handle image crop delegate
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        print("Did crop and received image")
        self.images.append(image)
        self.imageArray.append(image)
        self.WicketRangeCollectionView.reloadData()
        updateCollectionView()
    }
}

// MARK: - Extension for ViewController
extension CreateEventViewController {
    
    func setupUI() {
        tfDesc.delegate = self
        tfTitle.delegate = self
        updateCollectionView()
        tfDesc.delegate = self
        tfDesc.text = "Description"
        tfDesc.isScrollEnabled = false
        self.imagePicker?.delegate = self
        tfTitle.autocapitalizationType = .words
        timePickerContainer.removeFromSuperview()
        self.imagePicker = UIImagePickerController()
        TitleeView.backgroundColor = UIColor.systemBackground
        EndDateView.backgroundColor = UIColor.systemBackground
        EndTimeView.backgroundColor = UIColor.systemBackground
        startDateView.backgroundColor = UIColor.systemBackground
        startTimeView.backgroundColor = UIColor.systemBackground
        self.tfadd1.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfAdd2.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfDesc.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfTitle.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfEndDate.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfEndTime.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.tfStartTime.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfStartDatee.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblUploadEvent.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblEventAddress.font = UIFont(name: "Montserrat-Regular", size: 17)
        tfDesc.textColor = UIColor(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
    }
    
    
    func createEvents() {
        let request = CreateEvent_Request(
            title: tfTitle.text ?? "",
            event_date: formatDate(tfStartDatee.text ?? ""),
            event_end_date: formatDate(tfEndDate.text ?? ""),
            event_start_time: formatTime(tfStartTime.text ?? ""),
            event_end_time: formatTime(tfEndTime.text ?? ""),
            cover_image: "",
            event_detail: tfDesc.text ?? "",
            address_line_one: tfadd1.text ?? "",
            address_line_two: tfAdd2.text ?? ""
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

        // Combine parameters and images in one multipart request
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

        callsendMediaAPI(param: param, arrImage: uploadImages, mediaKey: "cover_image", URlName: API.createEvents) { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK - function for handle to send multipart iamge
    func callsendMediaAPI(param: [String: Any], arrImage: [UIImage], mediaKey: String, URlName: String, withblock: @escaping () -> Void) {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                if let valueString = value as? String, !valueString.isEmpty {
                    if let data = valueString.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }
            for img in arrImage {
                if let imgData = img.jpegData(compressionQuality: 0.3) {
                    multipartFormData.append(imgData, withName: mediaKey, fileName: "image\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
                }
            }
        }, to: URlName, method: .post, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                if let data = data, let rawStr = String(data: data, encoding: .utf8) {
                    print("📸 Uploaded Image + Event Params Response:", rawStr)
                }
                withblock()
            case .failure(let error):
                print("❌ Upload failed:", error.localizedDescription)
                self.retryUpload(param: param, images: arrImage, mediaKey: mediaKey, URlName: URlName, withblock: withblock)
            }
        }
    }
    
    // MARK - function for handle retry multipart iamge
    func retryUpload(param: [String: Any], images: [UIImage],  mediaKey: String, URlName: String, withblock: @escaping () -> Void) {
        self.callsendMediaAPI(param: param, arrImage: images,mediaKey: mediaKey,URlName: URlName,withblock: withblock)
    }
    
    // MARK - function for handle image size
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
    
    func updateCollectionView() {
        WicketRangeCollectionView.reloadData()
        collectionviewWicketRangeHeight.constant = allImages.isEmpty ? 0 : 150
        UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showDatePicker(for textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        if selectedDate == nil {
            selectedDate = Date()
        }
        datePicker.date = selectedDate!
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
        selectedDate = sender.date
    }
    
    @objc func doneButtonTapped() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateToSet = selectedDate ?? Date()
        let dateString = formatter.string(from: dateToSet)
        
        if tfStartDatee.isFirstResponder {
            tfStartDatee.text = dateString
        } else if tfEndDate.isFirstResponder {
            tfEndDate.text = dateString
        }
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
        
        if from==1 {
            tfStartTime.text = timeSelected
        } else {
            tfEndTime.text = timeSelected
        }
    }
    
    @objc func dismissPicker() {
        timePickerContainer.removeFromSuperview()
    }
    
    
    func openTimePicker(defaultHour: Int, defaultMinute: Int) {
        timePickerContainer.frame = CGRect( x: 0.0, y: (self.view.frame.height - 250), width: self.view.frame.width, height: 250.0  )
        
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        timePickerContainer.backgroundColor = isDarkMode ? .black : .white
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.width - 100), y: 5.0, width: 70.0, height: 40.0))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        doneButton.addTarget(self, action: #selector(donePicker), for: .touchUpInside)
        timePickerContainer.addSubview(doneButton)
        
        let cancelButton = UIButton(frame: CGRect(x: 20.0, y: 5.0, width: 70.0, height: 40.0))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)
        timePickerContainer.addSubview(cancelButton)
        
        let buttonHeight: CGFloat = 50.0
        let separatorLine = UIView(frame: CGRect(x: 0, y: buttonHeight, width: self.view.frame.width, height: 0.5))
        separatorLine.backgroundColor = isDarkMode ? UIColor.lightGray.withAlphaComponent(0.3) : UIColor.lightGray
        timePickerContainer.addSubview(separatorLine)
        
        timePicker.frame = CGRect(x: 0.0, y: buttonHeight + 0.5, width: self.view.frame.width, height: 200.0)
        timePicker.datePickerMode = .time
        
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        
        timePicker.backgroundColor = isDarkMode ? .black : .white
        timePicker.setValue(UIColor.label, forKey: "textColor")
        timePicker.locale = Locale(identifier: "en_US")
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.hour = defaultHour
        components.minute = defaultMinute
        if let defaultDate = calendar.date(from: components) {
            timePicker.date = defaultDate
        }
        
        timePickerContainer.addSubview(timePicker)
        self.view.addSubview(timePickerContainer)
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            TitleeView.layer.borderColor = UIColor(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1).cgColor
            EndDateView.layer.borderColor = UIColor(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1).cgColor
            startDateView.layer.borderColor = UIColor(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1).cgColor
            
            EndTimeView.layer.borderColor = UIColor(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1).cgColor
            tfEndTime.layer.borderColor = UIColor(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1).cgColor
            Description.layer.borderColor = UIColor(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1).cgColor
            UploadImageView.layer.borderColor = UIColor(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1).cgColor
            startTimeView.layer.borderColor = UIColor(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1).cgColor
            AddressEventView.layer.borderColor = UIColor(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1).cgColor
            
            TitleeView.layer.borderWidth = 1.0
            EndDateView.layer.borderWidth = 1.0
            startDateView.layer.borderWidth = 1.0
            startTimeView.layer.borderWidth = 1.0
            EndTimeView.layer.borderWidth = 1.0
            
            Description.layer.borderWidth = 1.0
            Add1View.layer.borderWidth = 1.0
            Add2.layer.borderWidth = 1.0
            AddressEventView.layer.borderWidth = 1.0
            createEventView.backgroundColor = .black
            Add1View.backgroundColor = .black
            Add2.backgroundColor = .black
            tfadd1.backgroundColor = .black
            tfAdd2.backgroundColor = .black
            UploadImageView.backgroundColor = .black
            UploadImageView.layer.borderColor = UIColor(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1).cgColor
            UploadImageView.layer.borderWidth = 1.0
            tfTitle.textColor = UIColor(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            tfStartTime.textColor = UIColor(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            tfEndTime.textColor = UIColor(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            tfStartDatee.textColor = UIColor(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            tfEndDate.textColor = UIColor(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            tfDesc.textColor = .white
            
            tfadd1.textColor = UIColor(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            tfAdd2.textColor = UIColor(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            
            
        } else {
            TitleeView.isUserInteractionEnabled = true
            EndDateView.isUserInteractionEnabled = true
            startDateView.isUserInteractionEnabled = true
            
            EndTimeView.isUserInteractionEnabled = true
            tfEndTime.isUserInteractionEnabled = true
            Description.isUserInteractionEnabled = true
            UploadImageView.isUserInteractionEnabled = true
            
            Add1View.isUserInteractionEnabled = true
            Add2.isUserInteractionEnabled = true
            startTimeView.isUserInteractionEnabled = true
            
            TitleeView.layer.borderWidth = 0
            tfStartDatee.layer.borderWidth = 0
            startDateView.layer.borderWidth = 0
            startTimeView.layer.borderWidth = 0
            EndDateView.layer.borderWidth = 0
            AddressEventView.layer.borderWidth = 0
            tfadd1.backgroundColor = .white
            tfAdd2.backgroundColor = .white
            
            Add1View.backgroundColor = .white
            Add2.backgroundColor = .white
            UploadImageView.backgroundColor = .white
            
            EndTimeView.layer.borderWidth = 0
            tfEndTime.layer.borderWidth = 0
            Description.layer.borderWidth = 0
            Add1View.layer.borderWidth = 0
            Add2.layer.borderWidth = 0
            UploadImageView.layer.borderWidth = 0
            createEventView.backgroundColor = UIColor(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
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
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "hh:mm a"   // incoming like "07:00 PM"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"    // backend expects "19:00"
        
        if let date = inputFormatter.date(from: timeStr) {
            return outputFormatter.string(from: date)
        }
        return timeStr
    }


}

// MARK: - Extension for UITextFieldDelegate
extension CreateEventViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let maxAllowedLines = 5
        guard let font = textField.font else { return true }
        let singleLineHeight = "A".height(withConstrainedWidth: textField.frame.width, font: font)
        if singleLineHeight == 0 { return true }
        let updatedTextHeight = updatedText.height(withConstrainedWidth: textField.frame.width, font: font)
        let estimatedLines = Int(ceil(updatedTextHeight / singleLineHeight))
        return estimatedLines <= maxAllowedLines
    }
}


@available(iOS 16.0, *)
extension CreateEventViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
            textView.text = ""
            textView.textColor = UIColor(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Description"
        }
    }
    
    func adjustTextViewScrollingIfNeeded() {
        guard let font = tfDesc.font else { return }
        let lineHeight = font.lineHeight
        let maxLines: CGFloat = 5
        let maxHeight = lineHeight * maxLines + tfDesc.textContainerInset.top + tfDesc.textContainerInset.bottom
        let size = CGSize(width: tfDesc.frame.width, height: .greatestFiniteMagnitude)
        let estimatedSize = tfDesc.sizeThatFits(size)
        if estimatedSize.height > maxHeight {
            tfDesc.isScrollEnabled = true
            tfDescHeightConstraint.constant = maxHeight
        } else {
            tfDesc.isScrollEnabled = false
        }
        tfDesc.setNeedsLayout()
        tfDesc.layoutIfNeeded()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewScrollingIfNeeded()
    }
}

// MARK: - Extension for String
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
