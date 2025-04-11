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
    
    @IBOutlet weak var profileImgView : UIImageView!
    var eventid = ""
    
    var EventDetauilData : EventDetailModel?
    var EventUpdatesData : UpdateEventModel?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        
        SVProgressHUD.show()
       
       
        callEventDetailWebService{ [self] in
            SVProgressHUD.dismiss()
            self.tfTitle.text = self.EventDetauilData?.title
            self.tfSrartDate.text = self.EventDetauilData?.eventStartDate
            self.tfEndDate.text = self.EventDetauilData?.eventEndDate
            self.tfStartTime.text = self.EventDetauilData?.eventStarttime
            self.tfEndTime.text = self.EventDetauilData?.eventEndtime
            self.tvDesc.text = self.EventDetauilData?.eventDetail
            
            self.tfAdd1.text = self.EventDetauilData?.addlineone
            self.tfAdd2.text = self.EventDetauilData?.addlinetwo
         
            let url = URL(string: (self.EventDetauilData?.coverImage ?? ""))
            self.profileImgView.kf.indicatorType = .activity
           self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "EventImage"))
            
            
            self.imagePicker = UIImagePickerController()
            self.imagePicker?.delegate = self
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
//            profileImgView.isUserInteractionEnabled = true
//            profileImgView.addGestureRecognizer(tapGestureRecognizer)
//            profileImgView.layer.masksToBounds = true
//            profileImgView.layer.cornerRadius = profileImgView.frame.height / 2
           
            
            
            // Do any additional setup after loading the view.
        }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

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
     //   selectPictureThroughPhotoGallery()
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
                callUpdateEventWebService { success in
                    DispatchQueue.main.async {
                        if success {
                            if let eventsVC = self.navigationController?.viewControllers.first(where: { $0 is EventsViewController }) {
                                self.navigationController?.popToViewController(eventsVC, animated: true)
                            } else {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        } else {
                            self.showAlert(message: "Failed to update event. Please try again.")
                        }
                    }
                }
            }
      
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let attributedMessage = NSAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        )
        
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDatePicker(for textField: UITextField) {
           let datePicker = UIDatePicker()
           datePicker.datePickerMode = .date
           datePicker.preferredDatePickerStyle = .wheels
        
        // Disable past dates
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
        timePicker.locale = Locale(identifier: "en_US") // Ensure 12-hour format with AM/PM
        timePickerContainer.addSubview(timePicker)

        self.view.addSubview(timePickerContainer)
    }
    
    func callEventDetailWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "usercr")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "eventid": eventid ?? "",
                                                   
                                                                        ]
          WebService.sharedInstance.callEventDetailWebService(withParams: dictParams) { data in
            self.EventDetauilData = data
              UserDefaults.standard.set(self.EventDetauilData?.id, forKey: "eventid")
              UserDefaults.standard.set(self.EventDetauilData?.userid, forKey: "usercr")
              
              

            completionClosure()
          }
        }
    
    func callsendImageAPI(param:[String: Any],arrImage:UIImage,imageKey:String,URlName:String, withblock:@escaping ()->Void){

        let headers: HTTPHeaders
        headers = ["Content-type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            
        //    for img in arrImage {
                guard let imgData = arrImage.jpegData(compressionQuality: 1) else { return }
            multipartFormData.append(imgData, withName: imageKey, fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
            guard let imgData2 = self.profileImgView.image?.jpegData(compressionQuality: 1) else { return }
            multipartFormData.append(imgData, withName: "aadharBack", fileName: "\(NSDate().timeIntervalSince1970.rounded())" + ".jpeg", mimeType: "image/jpeg")
            
           // }
            
            
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
    
    func callUpdateEventWebService(_ completionClosure: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: [String: Any] = [
            "userid": id ?? "",
            "title": self.tfTitle.text ?? "",
            "eventdate": self.tfSrartDate.text ?? "",
            "e_id": eventid ?? "",
            "eventenddate": self.tfEndDate.text ?? "",
            "eventstarttime": self.tfStartTime.text ?? "",
            "eventendtime": self.tfEndTime.text ?? "",
            "eventdetails": self.tvDesc.text ?? "",
            "addlineone": self.tfAdd1.text ?? "",
            "addlinetwo": self.tfAdd2.text ?? "",
            "datelong": "5"
        ]
        WebService.sharedInstance.callUpdateEventWebService(withParams: dictParams) { [self] data in
            self.EventUpdatesData = data
            
            callsendImageAPI(param: dictParams, arrImage: profileImgView.image!, imageKey: "eventpic", URlName: kBASEURL + WebServiceName.kUpdateEvent) {
                DispatchQueue.main.async {
                    completionClosure(true)  // Call completion closure with success
                }
            }
        }
    }

}

@available(iOS 16.0, *)
extension UpdateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        // volunteerProfileVM.profileImg = image
        picker.dismiss(animated: true, completion: nil)
      //   imageview.image = image
    //   showCrop(image: image) for crop visible
        self.profileImgView.image = image
        self.selectedImge = image
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
        //rajuuuuu
        
//            let imageView = UIImageView(frame: view.frame)
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = image
//            view.addSubview(imageView)
    }
//


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


}
