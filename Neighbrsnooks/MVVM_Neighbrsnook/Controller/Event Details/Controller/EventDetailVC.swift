//
//  NewEventVC.swift
//  EventDeatilDemo
//
//  Created by Abdul Aleem on 27/09/25.
//

import UIKit
import Photos
import PhotosUI
import Alamofire
import CropViewController
import TOCropViewController

class EventDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblEventName: UILabel!
    
    var jEventId:Int?
    var images: [UIImage] = []
    var imageArray = [UIImage]()
    var selectedImge: UIImage? = nil
    var objEventData: EventItem?
    let viewModel = EventDeatilsVM()
    var objEventDetailData: EventDetailsResponse?
    var objDecryptEventData:decryptEvent?
    var objEventAttend:EventAttendResponse?
    var objEventUnAttend:EventUnattendRespnse?
    var objEventDelete:EventDeleteResponse?
    var objEventImageDeleteImage:EventImageDeleteResponse?
    var objEventLikeData:EventLikeResponse?
    private var showAttendingSection = false
    private var showOwnerSection = false
    private var showAttendeeSection = false
    private var isPostButtonVisible: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reach().isInternet() {
            registerCell()
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 200
            eventDetailsAPI()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reach().isInternet() {
            registerCell()
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 200
            eventDetailsAPI()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    func registerCell() {
        tableView.showsVerticalScrollIndicator = false
        self.tableView.register(UINib(nibName: "EventImageCell", bundle: nil), forCellReuseIdentifier: "EventImageCell")
        self.tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        self.tableView.register(UINib(nibName: "AttendingtCell", bundle: nil), forCellReuseIdentifier: "AttendingtCell")
        self.tableView.register(UINib(nibName: "UploadImageCell", bundle: nil), forCellReuseIdentifier: "UploadImageCell")
        self.tableView.register(UINib(nibName: "OwnerTableCell", bundle: nil), forCellReuseIdentifier: "OwnerTableCell")
        self.tableView.register(UINib(nibName: "AttendeeCell", bundle: nil), forCellReuseIdentifier: "AttendeeCell")
    }
    
    @objc private func handleYesTapped(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPosition),
           let cell = tableView.cellForRow(at: indexPath) as? AttendingtCell {
            self.objDecryptEventData?.data?.data.auth_join = 1
            self.showOwnerSection = true
            self.showAttendeeSection = true
            cell.btnYes.backgroundColor = #colorLiteral(red: 0, green: 0.56, blue: 0, alpha: 1)
            cell.btnYes.setTitleColor(.white, for: .normal)
            cell.btnNo.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
            cell.btnNo.setTitleColor(.black, for: .normal)
            callEventAttendApi()
            tableView.reloadSections(IndexSet([2,3,4,1]), with: .none)
        }
    }
    
    @objc private func handleNoTapped(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPosition),
           let cell = tableView.cellForRow(at: indexPath) as? AttendingtCell {
            self.objDecryptEventData?.data?.data.auth_join = 0
            self.showOwnerSection = false
            self.showAttendeeSection = false
            cell.btnNo.backgroundColor = #colorLiteral(red: 0.749, green: 0.212, blue: 0.047, alpha: 1)
            cell.btnNo.setTitleColor(.white, for: .normal)
            cell.btnYes.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
            cell.btnYes.setTitleColor(.black, for: .normal)
            callEventUnAttendApi()
            tableView.reloadSections(IndexSet([2,3,4,1]), with: .none)
        }
    }
    
    @objc private func HandleLike(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPosition),
           let cell = tableView.cellForRow(at: indexPath) as? EventCell {
            let item = self.objDecryptEventData?.data?.data
            if item?.auth_like == false {
                self.eventLikeAPI()
            } else {
                if item?.total_likes != 0 {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttendeesVC") as! AttendeesVC
                    vc.getData = objDecryptEventData
                    vc.isComingFrom = "TotalLikes"
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .overFullScreen
                    nav.modalTransitionStyle = .crossDissolve
                    self.present(nav, animated: true)
                }
            }
        }
    }

    @objc private func handleUploadImage(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPosition),
           let eventData = objDecryptEventData?.data?.data {
            let userID = UserDefaults.standard.string(forKey: "userId")
            let eventUserId = eventData.userid
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? UploadImageCell {
                if Int(userID ?? "") == eventUserId {
                    let ownerImages = eventData.images.filter { $0.type.lowercased() == "owner" }
                    if ownerImages.count < eventData.event_img_limit {
                        isPostButtonVisible.toggle()
                        cell.btnPostImage.isHidden = !isPostButtonVisible
                        cell.btnPostHeightConst.constant = isPostButtonVisible ? 35 : 0
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    } else {
                        alertToast(Message: "You have reached the maximum image limit.")
                    }
                } else {
                    let joineeImages = eventData.images.filter { $0.type.lowercased() == "joinee" }
                    if joineeImages.count < eventData.event_img_limit {
                        isPostButtonVisible.toggle()
                        cell.btnPostImage.isHidden = !isPostButtonVisible
                        cell.btnPostHeightConst.constant = isPostButtonVisible ? 35 : 0
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    } else {
                        alertToast(Message: "You have reached the maximum image limit.")
                    }
                }
            } else {
                print("⚠️ UploadImageCell not found at section 2")
            }
        }
    }

    @objc private func HandleJoin(sender: UIButton) {
        if objDecryptEventData?.data?.data.total_joins != 0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttendeesVC") as! AttendeesVC
            vc.getData = objDecryptEventData
            vc.isComingFrom = "Attendees"
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true)
        }
    }
    
    @objc private func HandleUnJoin(sender: UIButton) {
        if objDecryptEventData?.data?.data.total_likes != 0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttendeesVC") as! AttendeesVC
            vc.getData = objDecryptEventData
            vc.isComingFrom = "Attendees"
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true)
        }
    }

    @objc private func handlePostImage(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPosition),
           let cell = tableView.cellForRow(at: indexPath) as? UploadImageCell {
            openCameraGalleryForSingleImage()
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let messageText = "Are you sure you want to delete this event?"
        let attributedMessage = NSAttributedString(string: messageText, attributes: [
            .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        ])
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)
        let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.deleteEventApi()
        }
        yesAction.setValue(yesColor, forKey: "titleTextColor")
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(noColor, forKey: "titleTextColor")
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnEditAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateEventViewController")as! UpdateEventViewController
        vc.jEventId = jEventId
        vc.objDecryptEventData = objDecryptEventData
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showAttendingSectionAction() {
        showAttendingSection = true
        tableView.reloadSections(IndexSet([1]), with: .none)
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
    
    func eventDetailsAPI() {
        let request = EventDeatils_Request(id: jEventId ?? 0)
        let param:[String:Any] = ["id":request.id]
        viewModel.eventDetails(parameter: param, request: request) { [weak self] eventDetailsResponse in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UtilityMethods.showIndicator()
            }
            if let eventDetail = eventDetailsResponse {
                let encryptedString = eventDetail.data
                self.objEventDetailData?.data = encryptedString
                DispatchQueue.main.async {
                    UtilityMethods.hideIndicator()
                    print("Event encrypted string is :\(encryptedString)")
                    self.decryptEventDetailsData(encryptedString: encryptedString)
                }
            } else {
                alertToast(Message: objEventDetailData?.message ?? "")
            }
        }
    }
    
    private func decryptEventDetailsData(encryptedString: String) {
        viewModel.decryptEventDetailsData(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UtilityMethods.showIndicator()
            }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    self.objDecryptEventData = decryptedData
                    let item = self.objDecryptEventData?.data?.data
                    UtilityMethods.hideIndicator()
                    self.tableView.reloadData()
                    self.lblEventName.text = item?.title
                    let userID = UserDefaults.standard.string(forKey: "userId")
                    let eventUserId = item?.userid
                    if Int(userID ?? "") == eventUserId {
                        self.btnEdit.isHidden = false
                        self.btnDelete.isHidden = false
                    } else {
                        self.btnEdit.isHidden = true
                        self.btnDelete.isHidden = true
                    }
                    
                    if item?.auth_join == 1 {
                        print("yes joinEvent")
                        self.showOwnerSection = true
                        self.showAttendeeSection = true
                    } else if item?.auth_join == 0 {
                        print("no joinEvent")
                        self.showOwnerSection = false
                        self.showAttendeeSection = false
                    } else {
                        print("auth_join = 2 (not joined yet)")
                        self.showOwnerSection = false
                        self.showAttendeeSection = false
                    }
                }
            } else {
                alertToast(Message: objDecryptEventData?.data?.message ?? "")
            }
        }
    }

    
    func callEventAttendApi() {
        let request = EventAttend_Request(event_id: jEventId ?? 0, flag: "Attend")
        let param:[String:Any] = ["event_id":request.event_id, "flag":request.flag]
        print("Attend Event api param is :\(param)")
        viewModel.eventAttendApi(parameter: param, request: request) { [weak self] eventAttendResponse in
            guard let self = self else { return }
            if let eventAttend = eventAttendResponse {
                self.objEventAttend = eventAttendResponse
                DispatchQueue.main.async {
                    self.eventDetailsAPI()
                }
            } else {
//                alertToast(Message: objEventAttend?.message ?? "")
            }
        }
    }
    
    func callEventUnAttendApi() {
        let request = EventUnAttend_Request(event_id: jEventId ?? 0, flag: "Unattend")
        let param:[String:Any] = ["event_id":request.event_id, "flag":request.flag]
        print("Unattend Event api param is :\(param)")
        viewModel.eventUnAttendApi(parameter: param, request: request) { [weak self] eventUnAttendResponse in
            guard let self = self else { return }
            if let eventAttend = eventUnAttendResponse {
                self.objEventUnAttend = eventUnAttendResponse
                DispatchQueue.main.async {
                    self.eventDetailsAPI()
                }
            } else {
            }
        }
    }
    
    func deleteEventApi() {
        let request = EventDelete_Request(event_id: jEventId ?? 0)
        let param: [String: Any] = ["event_id":request.event_id]
        print("Param is: \(param)")
        let viewModel = CreateEvent_VM()
        viewModel.eventDelete(parameter: param, request: request) { [weak self] eventDeleteResponse in
            guard let self = self else { return }
            if let response = eventDeleteResponse {
                print("Delete Event Response is: \(response)")
            } else {
                alertToast(Message: objEventDelete?.message ?? "")
            }
            DispatchQueue.main.async {
                self.objEventDelete = eventDeleteResponse
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func callEventUploadImgWebService() {
        
        let request = EventImage_Request(image: "", event_id: jEventId ?? 0)
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
        
        if let item = self.objDecryptEventData?.data?.data {
            let currentCount = item.images.count + (uploadImages.isEmpty ? 0 : 1)
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? UploadImageCell {
                cell.lblPreviewImage.isHidden = currentCount == 0
                let title = currentCount == 1 ? "Preview 1 Image" : "Preview \(currentCount) Images"
                cell.lblPreviewImage.setTitle(title, for: .normal)
            }
        }
        let param:[String:Any] = [
            "event_id":request.event_id
        ]
        
        callsendMediaAPI(param: param, arrImage: uploadImages, mediaKey: "image", URlName: API.eventsImage) { [weak self] in
            guard let self = self else { return }
            self.eventDetailsAPI()
        }
    }
    
    func eventLikeAPI() {
        let request = EventLike_Request(event_id: jEventId ?? 0)
        let param:[String:Any] = ["event_id":request.event_id]
        print("Event Like param is :\(param)")
        viewModel.eventLikeApi(parameter: param, request: request) { [weak self] eventLikeResponse in
            guard let self = self else { return }
            self.objEventLikeData = eventLikeResponse
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet([0]), with: .automatic)
            }
                print("Like response is :\(String(describing: eventLikeResponse))")
        }
    }
    
    func calleventDeleteImageAPI() {
        let request = EventImageDelete_Request(image_id: objDecryptEventData?.data?.data.images.first?.id ?? 0)
        let param:[String:Any] = ["image_id":request.image_id]
        viewModel.eventImageDeleteApi(parameter: param, request: request) { [weak self] eventImageDeleteResponse in
            guard let self = self else { return }
            if let eventImageDelete = eventImageDeleteResponse {
                self.objEventImageDeleteImage = eventImageDeleteResponse
                DispatchQueue.main.async {
                    self.eventDetailsAPI()
                    self.tableView.reloadData()
                }
            } else {
                alertToast(Message: objEventDetailData?.message ?? "")
            }
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
                let valueString = "\(value)"   // convert anything (Int, Double, etc.) to String
                if !valueString.isEmpty {
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
}

extension EventDetailVC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6 // Added 1 more section for EventImageCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { // EventImageCell
            return 1
        } else if section == 1 { // EventCell (was section 0)
            let userID = UserDefaults.standard.string(forKey: "userId")
            let eventUserId = objDecryptEventData?.data?.data.userid
            return 1
        } else if section == 2 { // AttendingtCell (was section 1)
            let userID = UserDefaults.standard.string(forKey: "userId")
            let eventUserId = objDecryptEventData?.data?.data.userid
            return (Int(userID ?? "") == eventUserId) ? 0 : 1
        } else if section == 3 { // UploadImageCell (was section 2)
            let userID = UserDefaults.standard.string(forKey: "userId")
            let eventUserId = objDecryptEventData?.data?.data.userid
            if Int(userID ?? "") == eventUserId {
                return 1
            } else {
                return (objDecryptEventData?.data?.data.auth_join == 1) ? 1 : 0
            }
        } else if section == 4 { // OwnerTableCell (was section 3)
            if !showOwnerSection { return 0 }
            let ownerImages = objDecryptEventData?.data?.data.images.filter { $0.type == "owner" } ?? []
            return ownerImages.isEmpty ? 0 : 1
        } else if section == 5 { // AttendeeCell (was section 4)
            if !showAttendeeSection { return 0 }
            let joineeImages = objDecryptEventData?.data?.data.images.filter { $0.type == "joinee" } ?? []
            return joineeImages.isEmpty ? 0 : 1
        }
        return 0
    }


    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.objDecryptEventData?.data?.data
        
        if indexPath.section == 0 { // New EventImageCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventImageCell", for: indexPath) as! EventImageCell
            let imageURL = item?.cover_image ?? ""
            ImageLoader.shared.setImage(on: cell.eventImage, urlString: imageURL.isEmpty ? nil : imageURL, placeholder: "groupImg")
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
            cell.onTapViewAtIndex = { index in
                switch index {
                case 0:
                    print("Username tapped")
                case 1:
                    print("Neighborhood tapped")
                case 2:
                    print("User image tapped")
                default:
                    break
                }
            }
            cell.btnJoin.setTitle("\(item?.attender_count ?? 0)", for: .normal)
            cell.btnUnjoin.setTitle("\(item?.unattender_count ?? 0)", for: .normal)
            
            
            if item?.auth_like == false {
                cell.btnLike.tintColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
            } else {
                cell.btnLike.tintColor = #colorLiteral(red: 0, green: 0.56, blue: 0, alpha: 1)
            }
            cell.btnLike.setTitle("\(item?.total_likes ?? 0)", for: .normal)
            cell.lblEventTitle.text = item?.title
            cell.lblEventDetails.text = item?.event_detail
            cell.lblNeighrHood.text = item?.neighborhood_name_date_time
            cell.lblUsername.text = item?.username
            let url = URL(string: (item?.userpic ?? ""))
            ImageLoader.shared.setImage(on: cell.userImage, urlString: url?.absoluteString, placeholder: "check")
            cell.lblStartDate.setAttributedText(prefix: "Start Date:", value: item?.event_date ?? "", prefixColor: .black, valueColor: .gray)
            cell.lblEndDate.setAttributedText(prefix: "End Date:", value: item?.event_end_date ?? "", prefixColor: .black, valueColor: .gray)
            cell.lblStartTime.setAttributedText(prefix: "Start Time:", value: item?.event_start_time ?? "", prefixColor: .black, valueColor: .gray)
            cell.lblEndTime.setAttributedText(prefix: "End Time:", value: item?.event_end_time ?? "", prefixColor: .black, valueColor: .gray)
            cell.btnLike.tag = indexPath.row
            cell.btnLike.addTarget(self, action: #selector(HandleLike(sender:)), for: .touchUpInside)
            
            cell.btnJoin.tag = indexPath.row
            cell.btnJoin.addTarget(self, action: #selector(HandleJoin(sender:)), for: .touchUpInside)
            
            
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 2 { // AttendingtCell (was section 1)
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttendingtCell", for: indexPath) as! AttendingtCell
            cell.btnYes.tag = indexPath.row
            cell.btnNo.tag = indexPath.row
            cell.btnYes.addTarget(self, action: #selector(handleYesTapped(sender:)), for: .touchUpInside)
            cell.btnNo.addTarget(self, action: #selector(handleNoTapped(sender:)), for: .touchUpInside)
            let authJoin = objDecryptEventData?.data?.data.auth_join
            if authJoin == 1 {
                cell.btnYes.backgroundColor = #colorLiteral(red: 0, green: 0.56, blue: 0, alpha: 1)
                cell.btnYes.setTitleColor(.white, for: .normal)
                cell.btnNo.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                cell.btnNo.setTitleColor(.black, for: .normal)
            } else if authJoin == 0 {
                cell.btnNo.backgroundColor = #colorLiteral(red: 0.749, green: 0.212, blue: 0.047, alpha: 1)
                cell.btnNo.setTitleColor(.white, for: .normal)
                cell.btnYes.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                cell.btnYes.setTitleColor(.black, for: .normal)
            } else {
                cell.btnYes.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                cell.btnYes.setTitleColor(.black, for: .normal)
                cell.btnNo.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                cell.btnNo.setTitleColor(.black, for: .normal)
            }
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 3 { // UploadImageCell (was section 2)
            let cell = tableView.dequeueReusableCell(withIdentifier: "UploadImageCell", for: indexPath) as! UploadImageCell
            cell.btnPostImage.layer.cornerRadius = 8
            cell.btnPostImage.isHidden = true
            cell.btnPostHeightConst.constant = 0
            cell.btnUplaodImage.tag = indexPath.row
            cell.btnPostImage.tag = indexPath.row
            cell.btnUplaodImage.addTarget(self, action: #selector(handleUploadImage(sender:)), for: .touchUpInside)
            cell.btnPostImage.addTarget(self, action: #selector(handlePostImage(sender:)), for: .touchUpInside)
            cell.lblMaxLimit.text = "Max image limit :\(item?.event_img_limit ?? 0)"
            cell.lblPreviewImage.isHidden = true
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerTableCell", for: indexPath) as! OwnerTableCell
            cell.selectionStyle = .none
            cell.ownerCollectionView.showsHorizontalScrollIndicator = false
            if let eventData = self.objDecryptEventData?.data?.data {
                cell.setImages(eventData.images)
            }
            cell.onDeleteImageTapped = { [weak self] in
                guard let self = self else { return }
                self.calleventDeleteImageAPI()
                
            }
            
            cell.onImageTapped = { [weak self] selectedImage, allImages in
                guard let self = self else { return }
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventEnlargementViewController") as! EventEnlargementViewController
                if let selectedUrl = URL(string: selectedImage.image_path) {
                    vc.url = selectedUrl
                }
                vc.otherImages = allImages.map { $0.image_path }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        else if indexPath.section == 4 { // OwnerTableCell (was section 3)
            let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerTableCell", for: indexPath) as! OwnerTableCell
            cell.selectionStyle = .none
            cell.ownerCollectionView.showsHorizontalScrollIndicator = false
            if let eventData = self.objDecryptEventData?.data?.data {
                cell.setImages(eventData.images)
            }
            cell.onDeleteImageTapped = { [weak self] in
                guard let self = self else { return }
                self.calleventDeleteImageAPI()
                
            }
            
            cell.onImageTapped = { [weak self] selectedImage, allImages in
                guard let self = self else { return }
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventEnlargementViewController") as! EventEnlargementViewController
                if let selectedUrl = URL(string: selectedImage.image_path) {
                    vc.url = selectedUrl
                }
                vc.otherImages = allImages.map { $0.image_path }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        else if indexPath.section == 5 { // AttendeeCell (was section 4)
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttendeeCell", for: indexPath) as! AttendeeCell
            cell.selectionStyle = .none
            cell.AttendeesCollectionView.showsHorizontalScrollIndicator = false
            if let eventData = self.objDecryptEventData?.data?.data {
                cell.setImages(eventData.images)
            }
            cell.onDeleteImageTapped = { [weak self] in
                guard let self = self else { return }
                self.calleventDeleteImageAPI()
            }
            
            cell.onImageTapped = { [weak self] selectedImage, allImages in
                guard let self = self else { return }
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventEnlargementViewController") as! EventEnlargementViewController
                if let selectedUrl = URL(string: selectedImage.image_path) {
                    vc.url = selectedUrl
                }
                vc.otherImages = allImages.map { $0.image_path }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        else {
            return UITableViewCell()
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - Extension for UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EventDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate   {
    
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
        callEventUploadImgWebService()
    }
}
