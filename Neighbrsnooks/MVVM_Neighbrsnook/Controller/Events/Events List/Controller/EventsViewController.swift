//
//  EventsViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 05/04/24.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class EventsViewController: BaseViewController  {
    
    @IBOutlet weak var collectionViewEvent: UICollectionView!
    @IBOutlet weak var SectorLbl: UILabel!
    @IBOutlet weak var PastLbl: UILabel!
    @IBOutlet weak var CurrentLbl: UILabel!
    @IBOutlet weak var UpcomingLbl: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    
    @IBOutlet weak var btnPast: UIButton!
    @IBOutlet weak var btnCurrent: UIButton!
    @IBOutlet weak var btnFuture: UIButton!
    
    @IBOutlet weak var ViewPast: UIView!
    @IBOutlet weak var ViewCurrent: UIView!
    @IBOutlet weak var ViewFuture: UIView!
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var EventView: UIView!
    
    var currentPage: Int = 1
    var lastPage: Int = 1
    var isLoading: Bool = false
    var thisWidth:CGFloat = 0
    var EventListData : EventListModel?
    var selection = 1
    var isOffsetApplied = false
    var isOffsetAppliedPast = false
    var idCr = UserDefaults.standard.string(forKey: "usercr")
    var selectedNeighborhoodId: String?
    var searchWorkItem: DispatchWorkItem?
    var sourceViewController: String?
    var Newid: String? // Set this when navigating from MessageViewController
    var Oid: String?
    var profileData : ProfileModel?
    var savedProfileData: ProfileModel?
    var selectedNeighborhoodName: String?
    
    var jneighbr_id:Int?
    var other_user_id:Int?
    var objEventList:EventsListResponse?
    var objDecryptEventList:EventListDecryptModel?
    var filteredEventData: EventListDecryptModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tfSearch.delegate = self
        if Reach().isInternet() {
            currentPage = 1
            eventListApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reach().isInternet() {
            currentPage = 1
            eventListApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearch(_ : UIButton){
        self.searchView.isHidden = false
    }
    
    @IBAction func btncancelSearch(_ : UIButton){
        self.searchView.isHidden = true
        self.tfSearch.text = ""
        if Reach().isInternet() {
            currentPage = 1
            eventListApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    @IBAction func btnCreateEvent(_ : UIButton) {
        if Reach().isInternet() {
            if objDecryptEventList?.data.data.verified_status == true {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateEventViewController") as? CreateEventViewController else {return}
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                alertToast(Message:  "You have limited access till verification is complete. We thank you for your patience.")
            }
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    @IBAction func btnCurrent(_ sender: UIButton) {
        handleCurrentButton()
    }
    
    @IBAction func btnFuture(_ sender: UIButton) {
        handleFutureButton()
    }
    
    @IBAction func btnPast(_ sender: UIButton) {
        handlePastButton()
    }
}

extension EventsViewController {
    
    func setupUI() {
        tfSearch.tintColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
        self.PastLbl.font = UIFont(name: "Montserrat-Regular", size: 22)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.CurrentLbl.font = UIFont(name: "Montserrat-Regular", size: 22)
        self.UpcomingLbl.font = UIFont(name: "Montserrat-Regular", size: 22)
        self.searchView.isHidden = true
    }
    
    func eventListApi() {
        let id = UserDefaults.standard.string(forKey: "userId") ?? ""
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood") ?? ""
        
        var request: EventList_Request
        var param: [String: Any] = [:]
        
        if sourceViewController == "MyProfile" {
            request = EventList_Request(type: "user", neighbr_id: 0, other_user_id: nil, page: currentPage)
            param = [
                "type": request.type,
                "page": request.page
            ]
        } else if sourceViewController == "Neighbourhood" {
            request = EventList_Request(type: "neighbourhood", neighbr_id: 43, other_user_id: nil, page: currentPage)
            param = [
                "type": request.type,
                "page": request.page,
                "neighbr_id": request.neighbr_id
            ]
        } else if sourceViewController == "Menu" {
            request = EventList_Request(type: "neighbourhood", neighbr_id: 0, other_user_id: nil, page: currentPage)
            param = [
                "type": request.type,
                "page": request.page
            ]
        } else if sourceViewController == "OtherProfile" {
            request = EventList_Request(type: "other", neighbr_id: 0, other_user_id: Int(Newid ?? "") ?? 0, page: currentPage)
            param = [
                "type": request.type,
                "page": request.page,
                "other_user_id": request.other_user_id ?? 0
            ]
        } else {
            request = EventList_Request(type: "user", neighbr_id: 0, other_user_id: nil, page: currentPage)
            param = [
                "type": request.type,
                "page": request.page
            ]
        }
        print("param is :\(param)")
        let viewModel = EventList_VM()
        viewModel.fetchEventListData(parameter: param, request: request) { [weak self] pollListResponse in
            guard let self = self else { return }
            if let pollData = pollListResponse {
                let encryptedString = pollData.data
                if self.currentPage == 1 {
                    self.objEventList?.data = encryptedString
                }
                DispatchQueue.main.async {
                    self.collectionViewEvent.reloadData()
                    self.decryptEventListApi(encryptedString: encryptedString)
                }
            }
        }
    }
    private func decryptEventListApi(encryptedString: String) {
        let viewModel = EventList_VM()
        viewModel.decryptEventListData(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    self.lastPage = decryptedData.data.data.last_page
                    
                    if self.currentPage == 1 {
                        self.objDecryptEventList = decryptedData
                    } else {
                        self.objDecryptEventList?.data.data.event_Current += decryptedData.data.data.event_Current
                        self.objDecryptEventList?.data.data.event_Future += decryptedData.data.data.event_Future
                        self.objDecryptEventList?.data.data.event_Past += decryptedData.data.data.event_Past
                    }
                    
                    // Update labels
                    self.CurrentLbl.text = String(self.objDecryptEventList?.data.data.event_Current.count ?? 0)
                    self.UpcomingLbl.text = String(self.objDecryptEventList?.data.data.event_Future.count ?? 0)
                    self.PastLbl.text = String(self.objDecryptEventList?.data.data.event_Past.count ?? 0)
                    
                    // Reload once
                    self.collectionViewEvent.reloadData()
                    self.collectionViewEvent.setContentOffset(.zero, animated: false)
                    
                    self.isLoading = false
                }
            } else {
                print("❌ Failed to decrypt poll list data")
                self.isLoading = false
            }
        }
    }


    func handlePastButton() {
        selection = 3
        currentPage = 1
        lastPage = 1
        filteredEventData = nil
        isLoading = false
        eventListApi()
        self.collectionViewEvent.setContentOffset(.zero, animated: false)
        ViewCurrent.backgroundColor =  #colorLiteral(red: 0.7725, green: 0.6627, blue: 0.3333, alpha: 1)
        ViewFuture.backgroundColor =   #colorLiteral(red: 0.7725, green: 0.6627, blue: 0.3333, alpha: 1)
        ViewPast.backgroundColor = #colorLiteral(red: 0, green: 0.5019, blue: 0, alpha: 1)
        lblPost.textColor = .white
        btnCurrent.setTitleColor(.white, for: .normal)
        btnFuture.setTitleColor(.white, for: .normal)
        btnPast.setTitleColor(.white, for: .normal)
        
        ViewPast.layer.cornerRadius = 10
        ViewFuture.layer.cornerRadius = 10
        ViewCurrent.layer.cornerRadius = 10
        btnCurrent.layer.cornerRadius = 10
        btnPast.layer.cornerRadius = 10
        btnFuture.layer.cornerRadius = 10
    }

    func handleFutureButton() {
        selection = 2
        currentPage = 1
        lastPage = 1
        filteredEventData = nil
        isLoading = false
        eventListApi()
        self.collectionViewEvent.setContentOffset(.zero, animated: false)
        lblPost.textColor = .white
        ViewPast.backgroundColor = #colorLiteral(red: 0.7725, green: 0.6627, blue: 0.3333, alpha: 1)
        ViewFuture.backgroundColor = #colorLiteral(red: 0, green: 0.5019, blue: 0, alpha: 1)
        ViewCurrent.backgroundColor = #colorLiteral(red: 0.7725, green: 0.6627, blue: 0.3333, alpha: 1)
        
        btnPast.layer.cornerRadius = 10
        ViewPast.layer.cornerRadius = 10
        btnFuture.layer.cornerRadius = 10
        btnCurrent.layer.cornerRadius = 10
        ViewFuture.layer.cornerRadius = 10
        ViewCurrent.layer.cornerRadius = 10
        btnPast.setTitleColor(.white, for: .normal)
        btnFuture.setTitleColor(.white, for: .normal)
        btnCurrent.setTitleColor(.white, for: .normal)
    }

    func handleCurrentButton() {
        selection = 1
        currentPage = 1
        lastPage = 1
        filteredEventData = nil
        isLoading = false
        eventListApi()
        self.collectionViewEvent.setContentOffset(.zero, animated: false)
        lblPost.textColor = .white
        ViewPast.backgroundColor =  #colorLiteral(red: 0.7725, green: 0.6627, blue: 0.3333, alpha: 1)
        btnPast.layer.cornerRadius = 10
        ViewPast.layer.cornerRadius = 10
        ViewCurrent.backgroundColor = #colorLiteral(red: 0, green: 0.5019, blue: 0, alpha: 1)
        ViewFuture.backgroundColor =   #colorLiteral(red: 0.7725, green: 0.6627, blue: 0.3333, alpha: 1)
        btnFuture.layer.cornerRadius = 10
        ViewFuture.layer.cornerRadius = 10
        btnCurrent.layer.cornerRadius = 10
        ViewCurrent.layer.cornerRadius = 10
        btnPast.setTitleColor(.white, for: .normal)
        btnFuture.setTitleColor(.white, for: .normal)
        btnCurrent.setTitleColor(.white, for: .normal)
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            //            updateColors()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            collectionViewEvent.backgroundColor = .black
            EventView.backgroundColor = .black
        } else {
            collectionViewEvent.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            EventView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        }
    }
}

extension EventsViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selection == 1 {
            return filteredEventData?.data.data.event_Current.count ?? objDecryptEventList?.data.data.event_Current.count ?? 0
        } else if selection == 2 {
            return filteredEventData?.data.data.event_Future.count ?? objDecryptEventList?.data.data.event_Future.count ?? 0
        } else {
            return filteredEventData?.data.data.event_Past.count ?? objDecryptEventList?.data.data.event_Past.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selection == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsCollectionViewCell", for: indexPath) as! EventsCollectionViewCell
            let currentEventItem = filteredEventData?.data.data.event_Current[indexPath.row] ?? objDecryptEventList?.data.data.event_Current[indexPath.row]
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
            cell.EventLbl.text = currentEventItem?.title
            ImageLoader.shared.setImage(on: cell.profileImgView, urlString: URL(string: currentEventItem?.cover_image ?? "")?.absoluteString, placeholder: "EventImage")
            cell.DetailCallback = { [self] value in
                if Reach().isInternet() {
                    if objDecryptEventList?.data.data.verified_status == true {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC")as! EventDetailVC
                        vc.jEventId = currentEventItem?.id ?? 0
                        vc.objEventData = objDecryptEventList?.data.data.event_Current[indexPath.row]
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        alertToast(Message: "You have limited access till verification is complete. We thank you for your patience.")
                    }
                } else {
                    AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
                }
            }
            return cell
        } else if selection == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCollectionViewCell", for: indexPath) as! UpcomingEventsCollectionViewCell
            let currentEventItem = filteredEventData?.data.data.event_Future[indexPath.row] ?? objDecryptEventList?.data.data.event_Future[indexPath.row]
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
            cell.EventLbl.text = currentEventItem?.title
            ImageLoader.shared.setImage(on: cell.profileImgView, urlString: URL(string: currentEventItem?.cover_image ?? "")?.absoluteString, placeholder: "EventImage")
            cell.DetailCallback = { [self] value in
                if Reach().isInternet() {
                    if objDecryptEventList?.data.data.verified_status == true {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC")as! EventDetailVC
                        vc.jEventId = currentEventItem?.id
                        vc.objEventData = objDecryptEventList?.data.data.event_Future[indexPath.row]
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        alertToast(Message: "You have limited access till verification is complete. We thank you for your patience.")
                    }
                } else {
                    AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
                }
            }
            return cell
        } else if selection ==  3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PastCollectionViewCell", for: indexPath) as! PastCollectionViewCell
            let currentEventItem = filteredEventData?.data.data.event_Past[indexPath.row] ?? objDecryptEventList?.data.data.event_Past[indexPath.row]
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
            cell.EventLbl.text = currentEventItem?.title
            ImageLoader.shared.setImage(on: cell.profileImgView, urlString: URL(string: currentEventItem?.cover_image ?? "")?.absoluteString, placeholder: "EventImage")
            cell.DetailCallback = { [self] value in
                if Reach().isInternet() {
                    if objDecryptEventList?.data.data.verified_status == true {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC")as! EventDetailVC
                        vc.jEventId = currentEventItem?.id
                        vc.objEventData = objDecryptEventList?.data.data.event_Past[indexPath.row]
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        alertToast(Message: "You have limited access till verification is complete. We thank you for your patience.")
                    }
                } else {
                    AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
                }
            }
            return cell
        } else {
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsCollectionViewCell", for: indexPath) as! EventsCollectionViewCell
                 cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
                 cell.EventLbl.text = "No Event"
                 cell.profileImgView.image = UIImage(named: "EventImage")
                 return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionViewEvent.frame.width / 3 - 15
        return CGSize(width: width, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        var totalCount = 0
        if selection == 1 {
            totalCount = filteredEventData?.data.data.event_Current.count ?? objDecryptEventList?.data.data.event_Current.count ?? 0
        } else if selection == 2 {
            totalCount = filteredEventData?.data.data.event_Future.count ?? objDecryptEventList?.data.data.event_Future.count ?? 0
        } else if selection == 3 {
            totalCount = filteredEventData?.data.data.event_Past.count ?? objDecryptEventList?.data.data.event_Past.count ?? 0
        }
    }

}

extension EventsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        searchWorkItem?.cancel()
        searchWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            if updatedText.isEmpty {
                self.filteredEventData = nil
            } else {
                if let originalData = self.objDecryptEventList {
                    do {
                        let encoded = try JSONEncoder().encode(originalData)
                        self.filteredEventData = try JSONDecoder().decode(EventListDecryptModel.self, from: encoded)
                    } catch {
                        print("Copy failed:", error)
                    }
                }
                if self.selection == 1 {
                    self.filteredEventData?.data.data.event_Current =
                    self.objDecryptEventList?.data.data.event_Current.filter { $0.title.lowercased().contains(updatedText.lowercased()) } ?? []
                } else if self.selection == 2 {
                    self.filteredEventData?.data.data.event_Future =
                    self.objDecryptEventList?.data.data.event_Future.filter { $0.title.lowercased().contains(updatedText.lowercased()) } ?? []
                } else if self.selection == 3 {
                    self.filteredEventData?.data.data.event_Past =
                    self.objDecryptEventList?.data.data.event_Past.filter { $0.title.lowercased().contains(updatedText.lowercased()) } ?? []
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchWorkItem!)
        return true
    }
}
