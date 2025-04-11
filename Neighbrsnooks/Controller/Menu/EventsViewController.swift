//
//  EventsViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 05/04/24.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class EventsViewController: BaseViewController , UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, UITextFieldDelegate  {
    
    
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
    
    var thisWidth:CGFloat = 0
    var EventListData : EventListModel?
    var selection = 1
    var isOffsetApplied = false
    var isOffsetAppliedPast = false
    var idCr = UserDefaults.standard.string(forKey: "usercr")
    var selectedNeighborhoodId: String? // Property to receive the selected ID
    
    var filteredEventData: EventListModel?
    var searchWorkItem: DispatchWorkItem?
    var sourceViewController: String?
    var Newid: String? // Set this when navigating from MessageViewController
    var profileData : ProfileModel?
    var savedProfileData: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // setdata()
        self.searchView.isHidden = true
        tfSearch.delegate = self
        NetworkMonitor.shared.startMonitoring()
        callUserProfileWebService{ [self] in
            
            SVProgressHUD.dismiss()
            
            
            
            
            self.SectorLbl.text = self.profileData?.neighborhood
            // self.MobileLbl.text = self.profileData?.phoneno
            
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
       // self.lblPost.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.PastLbl.font = UIFont(name: "Montserrat-Regular", size: 22)
        self.CurrentLbl.font = UIFont(name: "Montserrat-Regular", size: 22)
        self.UpcomingLbl.font = UIFont(name: "Montserrat-Regular", size: 22)
        
        callUserProfileWebService{ [self] in
            
            SVProgressHUD.dismiss()
            
            
            
            
            self.SectorLbl.text = self.profileData?.neighborhood
            // self.MobileLbl.text = self.profileData?.phoneno
            
            
        }
       
      //  collectionViewEvent.contentInset = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)
      //  idCr = ""
      //  SVProgressHUD.show()
       
        callEventListWebService(searchQuery: "") {
          //  SVProgressHUD.dismiss()
            self.collectionViewEvent.reloadData()
            
           // self.SectorLbl.text = self.EventListData?.neighbrhood
            self.PastLbl.text = "\(self.EventListData?.evencountPast ?? 0)"
            self.CurrentLbl.text = "\(self.EventListData?.eventcountCurrent ?? 0)"
            self.UpcomingLbl.text = "\(self.EventListData?.eventcountFuture ?? 0)"
          //  self.PastLbl.text = self.EventListData?.evencountPast
          //  self.CurrentLbl.text = self.EventListData?.first.eventcountCurrent
        //    self.UpcomingLbl.text = self.EventListData?.neighbrhood

        }
        
        callEventListWebService(searchQuery: "") {
                   SVProgressHUD.dismiss()
                   self.collectionViewEvent.reloadData()
               }

        // Do any additional setup after loading the view.
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            collectionViewEvent.backgroundColor = .black
            EventView.backgroundColor = .black
        } else {
            // Light mode mein storyboard ke original colors preserve karna
           

            // Light mode mein PollsView ka background red karna
            collectionViewEvent.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            EventView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
           // tableviewMembers.separatorStyle = .none
        }
    }
    
    @IBAction func btnSearch(_ : UIButton){

        self.searchView.isHidden = false

       }
    
    @IBAction func btncancelSearch(_ : UIButton){

        self.searchView.isHidden = true
               self.tfSearch.text = ""
        callEventListWebService(searchQuery: "") {
                   self.collectionViewEvent.reloadData()
               }

       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           let currentText = textField.text ?? ""
           let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

           // Cancel the previous work item to avoid multiple API calls
           searchWorkItem?.cancel()

           // Create a new work item for the search
           searchWorkItem = DispatchWorkItem {
               // Call the API with the updated search text
               self.callEventListWebService(searchQuery: updatedText) {
                   self.collectionViewEvent.reloadData()
               }
           }

           // Execute the work item after a delay of 0.5 seconds
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchWorkItem!)

           return true
       }
    
    @IBAction func btnCreateEvent(_ : UIButton){

        
        if profileData?.verfiedMsg == "User Verification is completed!" {
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateEventViewController") as? CreateEventViewController else {return}
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Create the alert controller
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            
            // Define font and color attributes
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            
            // Create attributed strings
            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
            let attributedMessage = NSAttributedString(
                string: "You have limited access till verification is complete. We thank you for your patience.",
                attributes: messageAttributes
            )
            
            // Set the title and message of the alert
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            // Add an action to the alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }

       }
    
    @IBAction func btnCurrent(_ sender: UIButton) {
        selection = 1
       
        ViewCurrent.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        ViewPast.backgroundColor =  #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
        ViewFuture.backgroundColor =   #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
        lblPost.textColor =  .white
        btnCurrent.setTitleColor(.white, for: .normal)
        btnPast.setTitleColor(.white, for: .normal)
        btnFuture.setTitleColor(.white, for: .normal)
        ViewPast.layer.cornerRadius = 10
        ViewFuture.layer.cornerRadius = 10
        ViewCurrent.layer.cornerRadius = 10
        
        btnCurrent.layer.cornerRadius = 10
        btnPast.layer.cornerRadius = 10
        btnFuture.layer.cornerRadius = 10
        callEventListWebService(searchQuery: "") {
            self.collectionViewEvent.reloadData()
            self.PastLbl.text = "\(self.EventListData?.evencountPast ?? 0)"
            self.CurrentLbl.text = "\(self.EventListData?.eventcountCurrent ?? 0)"
            self.UpcomingLbl.text = "\(self.EventListData?.eventcountFuture ?? 0)"
        }
        
    }
    
    @IBAction func btnFuture(_ sender: UIButton) {
        selection = 2
       
       // EventsCollectionViewCell.isHidden = false
        ViewCurrent.backgroundColor =   #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
        ViewFuture.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        ViewPast.backgroundColor =   #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
        lblPost.textColor =  .white
        btnCurrent.setTitleColor(.white, for: .normal)
        btnFuture.setTitleColor(.white, for: .normal)
        btnPast.setTitleColor(.white, for: .normal)
        ViewPast.layer.cornerRadius = 10
        ViewFuture.layer.cornerRadius = 10
        ViewCurrent.layer.cornerRadius = 10
        btnCurrent.layer.cornerRadius = 10
        btnPast.layer.cornerRadius = 10
        btnFuture.layer.cornerRadius = 10
        callEventListWebService(searchQuery: "") {
            self.collectionViewEvent.reloadData()
            self.PastLbl.text = "\(self.EventListData?.evencountPast ?? 0)"
            self.CurrentLbl.text = "\(self.EventListData?.eventcountCurrent ?? 0)"
            self.UpcomingLbl.text = "\(self.EventListData?.eventcountFuture ?? 0)"
        }
    }
    
    @IBAction func btnPast(_ sender: UIButton) {
        selection = 3
       
        ViewCurrent.backgroundColor =  #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
        ViewFuture.backgroundColor =   #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
        ViewPast.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblPost.textColor =  .white
        btnCurrent.setTitleColor(.white, for: .normal)
        btnFuture.setTitleColor(.white, for: .normal)
        btnPast.setTitleColor(.white, for: .normal)
        ViewPast.layer.cornerRadius = 10
        ViewFuture.layer.cornerRadius = 10
        ViewCurrent.layer.cornerRadius = 10
        btnCurrent.layer.cornerRadius = 10
        btnPast.layer.cornerRadius = 10
        btnFuture.layer.cornerRadius = 10
        callEventListWebService(searchQuery: "") {
            self.collectionViewEvent.reloadData()
            self.PastLbl.text = "\(self.EventListData?.evencountPast ?? 0)"
            self.CurrentLbl.text = "\(self.EventListData?.eventcountCurrent ?? 0)"
            self.UpcomingLbl.text = "\(self.EventListData?.eventcountFuture ?? 0)"
        }
    }
    
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""
        let loggedUser = UserDefaults.standard.string(forKey: "loggeduser") ?? ""
        
        let dictParams: [String: Any] = [
            "userid": id,
            "loggeduser": id // Use loggedUser instead of id
        ]
        print(dictParams)
        
        // Call the web service
        WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { (data: ProfileModel?) in
            // Check if data is nil (i.e., the API response was unsuccessful)
            guard let data = data else {
                print("Error: API response is nil")
                completionClosure()
                return
            }
            
            // Now, 'data' is a ProfileModel, and we can safely assign it
            self.profileData = data
            self.savedProfileData = data
            print("Profile Data Saved: \(String(describing: self.savedProfileData))")
            
            // Save required fields to UserDefaults
            if let emerPhone = self.profileData?.emerPhone {
                UserDefaults.standard.set(emerPhone, forKey: "emer_phone")
            }
            if let userPic = self.profileData?.userpic {
                UserDefaults.standard.set(userPic, forKey: "profileImage")
            }
            if let lastName = self.profileData?.lastname {
                UserDefaults.standard.set(lastName, forKey: "lastName")
            }
            if let neighborhood = self.profileData?.neighborhood {
                UserDefaults.standard.set(neighborhood, forKey: "myNeighbhrhhod")
            }
            
            // Save address details
            let addressLineOne = self.profileData?.addlineone ?? ""
            let addressLineTwo = self.profileData?.addlinetwo ?? ""

            
            // Final completion callback
            completionClosure()
        }
    }
    
//    func callEventListWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
//          let dictParams: Dictionary<String, Any> = [
//                                                    "userid":id ?? "",
//                                                    "neighbrhood":selectedNeighborhoodId ?? ""
//                                                   // "eventuserlist":id ?? ""
//
//
//                                                                        ]
//          WebService.sharedInstance.callEventListWebService(withParams: dictParams) { data in
//            self.EventListData = data
//         //     UserDefaults.standard.set(self.EventListData?.nearestNeighbrhood.first?.name, forKey: "name")
////              UserDefaults.standard.set(self.neighbrhoodData?.nearestNeighbrhood.first?.status, forKey: "status")
//          //    UserDefaults.standard.set(self.EventListData?.eventFuture.id, forKey: "accessToken")
//             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
//             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")
//
//            completionClosure()
//          }
//        }
    
    func callEventListWebService(searchQuery: String, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")

        
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let neighborhoodId = selectedNeighborhoodId ?? idNeighbour // Use default if selectedNeighborhoodId is nil
        
//        let dictParams: [String: Any] = [
//            "userid": id ?? "",
//            "neighbrhood": neighborhoodId ?? "", // Use the resolved neighborhoodId
//
//        ]
        
        
        var dictParams: [String: Any] = [:]
        
        if sourceViewController == "MyProfile" {
            dictParams = [
                "userid": id ?? "",
                "eventuserlist": id ?? "", // Use the
            ]
        } else if sourceViewController == "Neighbourhood" {
            dictParams = [
                "userid": id ?? "",
                "neighbrhood": neighborhoodId ?? "", // Use the
            ]
        }
        else if sourceViewController == "Menu" {
            dictParams = [
                "userid": id ?? "",
                "searchQuery": searchQuery
            ]
        }
        else  {
            dictParams = [
                "userid": Newid ?? "",
               // "searchQuery": searchQuery
            ]
        }

        WebService.sharedInstance.callEventListWebService(withParams: dictParams) { data in
            self.EventListData = data
       //     UserDefaults.standard.set(self.EventListData?.neighbrhood, forKey: "NeighbourhoodName")

            if searchQuery.isEmpty {
                // No filtering, retain original data
                self.filteredEventData = data
            } else {
                // Filter all three event categories
                let filteredPast = data.eventPast.filter { $0.title.lowercased().contains(searchQuery.lowercased()) }
                let filteredCurrent = data.eventCurrent.filter { $0.title.lowercased().contains(searchQuery.lowercased()) }
                let filteredFuture = data.eventFuture.filter { $0.title.lowercased().contains(searchQuery.lowercased()) }

                // Update the filteredEventData with filtered results
                self.filteredEventData = EventListModel(
                    status: data.status,
                    message: data.message,
                    neighbrhood: data.neighbrhood,
                    verfiedMsg: data.verfiedMsg,
                    eventPast: filteredPast,
                    eventCurrent: filteredCurrent,
                    eventFuture: filteredFuture,
                    evencountPast: filteredPast.count,
                    eventcountCurrent: filteredCurrent.count,
                    eventcountFuture: filteredFuture.count
                )
            }

            // Reload the collection view
            completionClosure()
            self.collectionViewEvent.reloadData()
        }
    }


    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
              return 3
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0{
            if selection == 1{
                return filteredEventData?.eventCurrent.count ?? 0
            }else{
                return 0
            }

        } else if section == 1 {
            if selection == 2{
                return filteredEventData?.eventFuture.count ?? 0
            }else{
                return 0
            }
        }else{
            if selection == 3{
                return filteredEventData?.eventPast.count ?? 0
            }else{
                return 0
            }
        }
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsCollectionViewCell", for: indexPath) as! EventsCollectionViewCell
         
                  cell.EventLbl.text = filteredEventData?.eventCurrent[indexPath.row].title
                  let url = URL(string: (filteredEventData?.eventCurrent[indexPath.row].coverImage ?? ""))
                  cell.profileImgView.kf.indicatorType = .activity
                  cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "EventImage"))
            
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
            
            cell.DetailCallback = { [self] value in
                if EventListData?.verfiedMsg == "User Verification is completed!" {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController")as! EventsDetailViewController
                    vc.eventid = filteredEventData?.eventCurrent[indexPath.row].id ?? ""
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
                else {
                    // Create the alert controller
                    let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
                    
                    // Define font and color attributes
                    let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
                    let messageAttributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                        .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                    ]
                    
                    // Create attributed strings
                    let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
                    let attributedMessage = NSAttributedString(
                        string: "You have limited access till verification is complete. We thank you for your patience.",
                        attributes: messageAttributes
                    )
                    
                    // Set the title and message of the alert
                    alert.setValue(attributedTitle, forKey: "attributedTitle")
                    alert.setValue(attributedMessage, forKey: "attributedMessage")
                    
                    // Add an action to the alert
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    // Present the alert
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
                 
         
                   return cell
     } else if indexPath.section == 1 {
         
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCollectionViewCell", for: indexPath) as! UpcomingEventsCollectionViewCell
         
         cell.EventLbl.text = filteredEventData?.eventFuture[indexPath.row].title
                  let url = URL(string: (filteredEventData?.eventFuture[indexPath.row].coverImage ?? ""))
                  cell.profileImgView.kf.indicatorType = .activity
                  cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "EventImage"))
         cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
         
        // cell.frame = cell.frame.offsetBy(dx: 0, dy: -20)
         
//         let originalFrame = cell.frame
//         cell.frame = originalFrame.offsetBy(dx: 0, dy: -20)
         
//         if !isOffsetApplied {
//             cell.frame = cell.frame.offsetBy(dx: 0, dy: -40)
//            // isOffsetApplied = true
//             cell.isOffsetApplied = true
//         }
         
         if !cell.isOffsetApplied {
                 cell.frame = cell.frame.offsetBy(dx: 0, dy: -40)
                 cell.isOffsetApplied = true
             }
         
         cell.DetailCallback = { [self] value in
             if EventListData?.verfiedMsg == "User Verification is completed!" {
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController")as! EventsDetailViewController
             vc.eventid = filteredEventData?.eventFuture[indexPath.row].id ?? ""
          
             self.navigationController?.pushViewController(vc, animated: true)
             }
             else {
                 // Create the alert controller
                 let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
                 
                 // Define font and color attributes
                 let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
                 let messageAttributes: [NSAttributedString.Key: Any] = [
                     .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                     .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                 ]
                 
                 // Create attributed strings
                 let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
                 let attributedMessage = NSAttributedString(
                     string: "You have limited access till verification is complete. We thank you for your patience.",
                     attributes: messageAttributes
                 )
                 
                 // Set the title and message of the alert
                 alert.setValue(attributedTitle, forKey: "attributedTitle")
                 alert.setValue(attributedMessage, forKey: "attributedMessage")
                 
                 // Add an action to the alert
                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                     alert.dismiss(animated: true, completion: nil)
                 }))
                 
                 // Present the alert
                 self.present(alert, animated: true, completion: nil)
             }
 
         }
      //   cell.frame = cell.frame.offsetBy(dx: 0, dy: -20)
                 // cell.FollowMemberLbl.text = neighbrhoodData?.nearestNeighbrhood[indexPath.row].member
         
                   
        
    return cell
         
     }
     
     else  {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PastCollectionViewCell", for: indexPath) as! PastCollectionViewCell
         
                  cell.EventLbl.text = filteredEventData?.eventPast[indexPath.row].title
                  let url = URL(string: (filteredEventData?.eventPast[indexPath.row].coverImage ?? ""))
                  cell.profileImgView.kf.indicatorType = .activity
                  cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "EventImage"))
         cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
       //  cell.frame = cell.frame.offsetBy(dx: 0, dy: -70)
         
         
         if !cell.isOffsetAppliedPast {
                 cell.frame = cell.frame.offsetBy(dx: 0, dy: -70)
                 cell.isOffsetAppliedPast = true
             }
         
         cell.DetailCallback = { [self] value in
             if EventListData?.verfiedMsg == "User Verification is completed!" {
             
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController")as! EventsDetailViewController
             vc.eventid = filteredEventData?.eventPast[indexPath.row].id ?? ""
          
             self.navigationController?.pushViewController(vc, animated: true)
             
             }
             else {
                 // Create the alert controller
                 let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
                 
                 // Define font and color attributes
                 let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
                 let messageAttributes: [NSAttributedString.Key: Any] = [
                     .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                     .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                 ]
                 
                 // Create attributed strings
                 let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
                 let attributedMessage = NSAttributedString(
                     string: "You have limited access till verification is complete. We thank you for your patience.",
                     attributes: messageAttributes
                 )
                 
                 // Set the title and message of the alert
                 alert.setValue(attributedTitle, forKey: "attributedTitle")
                 alert.setValue(attributedMessage, forKey: "attributedMessage")
                 
                 // Add an action to the alert
                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                     alert.dismiss(animated: true, completion: nil)
                 }))
                 
                 // Present the alert
                 self.present(alert, animated: true, completion: nil)
             }
 
         }
         
                   
        
    return cell
     }
}
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     let width = collectionViewEvent.frame.width / 3 - 15
        let height = width + 40
         return CGSize(width: width , height: height)
     
     }
  
}
