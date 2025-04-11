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
import TOCropViewController


class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCollectionViewControllerDelegate, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,CropViewControllerDelegate {
   
    
    
    func didTapDeleteButton(at index: Int) {
        
    }
    
    
    func didDeleteImage(at index: Int) {
        images.remove(at: index)
    }
    var allImages: [UIImage] {
        return images + imageArray
    }

    
    @IBOutlet weak var tfStartTime: UITextField!
    @IBOutlet weak var tfEndTime: UITextField!
    
    @IBOutlet weak var tfStartDatee: UITextField!
    @IBOutlet weak var tfEndDate: UITextField!
    @IBOutlet weak var tfTitle: UITextField!
    
    @IBOutlet weak var tfadd1: UITextField!
    @IBOutlet weak var tfAdd2: UITextField!
    @IBOutlet weak var tfDesc: UITextView!
    @IBOutlet weak var tfDescHeightConstraint: NSLayoutConstraint!
   // @IBOutlet weak var tfDesc: UITextView!
   // @IBOutlet weak var placeholderLabel: UILabel!
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
    
    var from = 1
    var fromDate = 1
    var timePickerContainer = UIView()
    var thisWidth:CGFloat = 0
    
    let timePicker = UIDatePicker()
    let datePicker = UIDatePicker()
    var imagePicker:UIImagePickerController?
    var imageArray = [UIImage]()
    var CamimageArray = [UIImage]()
    var selectedImages: [UIImage] = []
    var images: [UIImage] = []
    var selectedImge: UIImage? = nil
    var createEventData : CreateEventModel?
    
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openTimePicker()
        timePickerContainer.removeFromSuperview()
        
        TitleeView.backgroundColor = UIColor.systemBackground
        startDateView.backgroundColor = UIColor.systemBackground
        EndDateView.backgroundColor = UIColor.systemBackground
        startTimeView.backgroundColor = UIColor.systemBackground
        EndTimeView.backgroundColor = UIColor.systemBackground
        updateColors()
        
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        tfTitle.autocapitalizationType = .sentences
        tfadd1.autocapitalizationType = .sentences
        tfAdd2.autocapitalizationType = .sentences
        NetworkMonitor.shared.startMonitoring()
        self.tfStartTime.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfEndTime.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfStartDatee.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfEndDate.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfDesc.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfTitle.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblEventAddress.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblUploadEvent.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfadd1.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfAdd2.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.imagePicker?.delegate = self
        self.imagePicker = UIImagePickerController()
        tfDesc.isScrollEnabled = false // Scroll disable karein
               tfDesc.delegate = self
        updateCollectionView()
        
        tfDesc.delegate = self
        tfDesc.text = "Description"
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            TitleeView.layer.borderColor = UIColor.lightGray.cgColor
            EndDateView.layer.borderColor = UIColor.lightGray.cgColor
            startDateView.layer.borderColor = UIColor.lightGray.cgColor
            
            EndTimeView.layer.borderColor = UIColor.lightGray.cgColor
            tfEndTime.layer.borderColor = UIColor.lightGray.cgColor
            Description.layer.borderColor = UIColor.lightGray.cgColor
            UploadImageView.layer.borderColor = UIColor.lightGray.cgColor
            startTimeView.layer.borderColor = UIColor.lightGray.cgColor
            AddressEventView.layer.borderColor = UIColor.lightGray.cgColor
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
            Add1View.backgroundColor = .black
            Add2.backgroundColor = .black
            tfadd1.backgroundColor = .black
            tfAdd2.backgroundColor = .black
            UploadImageView.backgroundColor = .black
            UploadImageView.layer.borderColor = UIColor.lightGray.cgColor
            UploadImageView.layer.borderWidth = 1.0
           
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
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
    
    func updateCollectionView() {
        WicketRangeCollectionView.reloadData()
        collectionviewWicketRangeHeight.constant = allImages.isEmpty ? 0 : 150

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
   
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
           let size = CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)
           let estimatedSize = textView.sizeThatFits(size)
           
           tfDescHeightConstraint.constant = estimatedSize.height // Height adjust karein
           
           UIView.animate(withDuration: 0.2) {
               self.view.layoutIfNeeded() // Animation ke saath update karein
           }
       }
    
//    func textViewDidChange(_ textView: UITextView) {
//            // Show or hide placeholder label based on text view content
//            placeholderLabel.isHidden = !textView.text.isEmpty
//        }
    
    @IBAction func btnStartTime(_ sender: UIButton) {
        from = 1
        openTimePicker()
    }
    
    @IBAction func btnEndTime(_ sender: UIButton) {
        from = 2
        openTimePicker()
    }
    
    @IBAction func btnStartDate(_ sender: UIButton) {
        showDatePicker(for: tfStartDatee)
    }
    
    @IBAction func btnEndDate(_ sender: UIButton) {
        showDatePicker(for: tfEndDate)
    }
    
    @IBAction func selectPhotos(_ sender: UIButton) {
    
        selectImages()
    
       }
    
    @IBAction func PublishBtn(_ sender: UIButton){
        
        if tfTitle.text == "" {
                showAlert(message: "Please enter title")
            } else if tfStartDatee.text == "" {
                showAlert(message: "Please select start date")
            } else if tfEndDate.text == "" {
                showAlert(message: "Please select end date")
            } else if tfStartTime.text == "" {
                showAlert(message: "Please select start time")
            } else if tfEndTime.text == "" {
                showAlert(message: "Please select end time")
            } else if tfDesc.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || tfDesc.text == "Description" {
                showAlert(message: "Please enter description")
            }
 else if tfadd1.text == "" {
                showAlert(message: "Please enter flat/ houseno. appartment name ")
            } else if tfAdd2.text == "" {
                showAlert(message: "Please enter road/ street name")
        }
        else{
            callCreateEventWebService{

            }
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
    
    
    @objc func selectImages(){
        //  let alert = UIAlertController(title:  "", message: "", preferredStyle: .actionSheet)
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

    
    func openCameraGallery()
    {
      //  let alert = UIAlertController(title:  "", message: "", preferredStyle: .actionSheet)
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
    
//    func presentCropViewController(image: UIImage) {
//        let cropViewController = TOCropViewController(image: image)
//        cropViewController.delegate = self
//        self.present(cropViewController, animated: true, completion: nil)
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                DispatchQueue.main.async {
//                    self.presentCropViewController(image: image)
//                    self.images.append(image)
//                   // self.selectedImge = image
//                    //  self.presentCropViewController(image: image)
//                    self.WicketRangeCollectionView.reloadData()
//                    self.updateCollectionView()
//                }
//            }
//            picker.dismiss(animated: true, completion: nil)
//        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        picker.dismiss(animated: true, completion: nil)
        showCrop(image: image)
        
     //   self.presentCropViewController(image: image)
        self.images.append(image)
       // self.selectedImge = image
        //  self.presentCropViewController(image: image)
        self.WicketRangeCollectionView.reloadData()
        updateCollectionView()
    }


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
    
    
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        print("Did crop")
        
        // Assign the cropped image to profilePic
        self.imageArray.append(image)
         self.images.append(image)
        self.WicketRangeCollectionView.reloadData()
        updateCollectionView()
     //   updateProfileImageView() // ✅ Yeh line zaroori hai
    }
    
   


    

    
    func showDatePicker(for textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        // Set the selectedDate to current date if nil
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

        // Use selectedDate or fallback to the current date
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell

        // Ensure correct array is used
        cell.LargeImgView.image = allImages[indexPath.row]

        cell.FullImgCallback = { [self] value in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeforePostEnlargeViewController") as! BeforePostEnlargeViewController
            vc.imageArray = self.allImages  // Correct array pass karein
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                  thisWidth = CGFloat(self.WicketRangeCollectionView.width) / 1
                  return CGSize(width: thisWidth, height: 214)
 
              }
    
    
//    @objc func doneButtonTapped() {
//           view.endEditing(true)
//       }
//
//       @objc func cancelButtonTapped() {
//           view.endEditing(true)
//       }
    
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

        let buttonHeight: CGFloat = 50.0
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0), for: .normal)
        doneButton.addTarget(self, action: #selector(donePicker), for: .touchUpInside)
        doneButton.frame = CGRect(x: (self.view.frame.width - 100), y: 5.0, width: 70.0, height: 40.0)
        timePickerContainer.addSubview(doneButton)

        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0), for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)
        cancelButton.frame = CGRect(x: 20.0, y: 5.0, width: 70.0, height: 40.0)
        timePickerContainer.addSubview(cancelButton)

        // Separator Line
        let separatorLine = UIView()
        separatorLine.frame = CGRect(x: 0, y: buttonHeight, width: self.view.frame.width, height: 0.5)
        separatorLine.backgroundColor = UIColor.lightGray
        timePickerContainer.addSubview(separatorLine)

        timePicker.frame = CGRect(x: 0.0, y: buttonHeight + 0.5, width: self.view.frame.width, height: 200.0)
        timePicker.datePickerMode = .time
        
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }

        timePicker.backgroundColor = UIColor.white
        timePicker.locale = Locale(identifier: "en_US") // Ensure 12-hour format with AM/PM
        timePickerContainer.addSubview(timePicker)

        self.view.addSubview(timePickerContainer)
    }

    
    func callCreateEventWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
      //  let idcategory = UserDefaults.standard.string(forKey: "idCategory")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "eventstarttime":self.tfStartTime.text ?? "",
                                                    "eventendtime":self.tfEndTime.text ?? "",
                                                   
                                                    "eventdate": self.tfStartDatee.text ?? "",
                                                    
                                                    "eventenddate":  self.tfEndDate.text ?? "",
                                                    "title":self.tfTitle.text ?? "",
                                                    "eventdetails": self.tfDesc.text ?? "",
                                                    
                                                    "addlineone":self.tfadd1.text ?? "",
                                                    "addlinetwo":self.tfAdd2.text ?? "",
                                                    "datelong": "5",
                                                    "eventpic": "",
                                                                        ]
        if self.from == 1
        {
            
            callsendImageAPI(param: dictParams, arrImage: imageArray, imageKey: "eventpic", URlName: kBASEURL + WebServiceName.kCreateEvent, withblock: {
                
                self.navigationController?.popViewController(animated: true)
            })
//            callsendImageAPI(param: dictParams, arrImage: imageArray, imageKey: "document[]", URlName: kBASEURL + WebServiceName.kCreateBussines, withblock: {
//
//                self.navigationController?.popViewController(animated: true)
//            })
        }
        else if self.from == 2
        {
            callsendImageAPI(param: dictParams, arrImage: images, imageKey: "eventpic", URlName: kBASEURL + WebServiceName.kCreateEvent, withblock: {
                
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
    
}

//extension CreateEventViewController: TOCropViewControllerDelegate {
////    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, withRect cropRect: CGRect, angle: Int)
////
////    {
////        self.imageArray.append(image)
////         self.images.append(image)
////        self.WicketRangeCollectionView.reloadData()
////        cropViewController.dismiss(animated: true, completion: nil)
////    }
////
////
////
////    @nonobjc func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
////        cropViewController.dismiss(animated: true, completion: nil)
////    }
//
//
//    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
//        cropViewController.dismiss(animated: true)
//    }
//
//    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        cropViewController.dismiss(animated: true)
//        print("Did crop")
//
//        // Assign the cropped image to profilePic
//        self.imageArray.append(image)
//         self.images.append(image)
//        self.WicketRangeCollectionView.reloadData()
//
//     //   updateProfileImageView() // ✅ Yeh line zaroori hai
//    }
//
//}


extension CreateEventViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1) // Actual text color (Dark Gray)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Description"
           // textView.textColor = #colorLiteral(red: 0.5647058824, green: 0.9333333333, blue: 0.5647058824, alpha: 1) // Light Green Placeholder
        }
    }
}
