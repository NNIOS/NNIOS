//
//  EventsMyProfileViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 30/08/24.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class EventsMyProfileViewController:  BaseViewController , UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource  {
    
    
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


    
    var thisWidth:CGFloat = 0
    var EventListData : EventListModel?
    var selection = 1
    var isOffsetApplied = false
    var isOffsetAppliedPast = false
    var idCr = UserDefaults.standard.string(forKey: "usercr")

    override func viewDidLoad() {
        super.viewDidLoad()
       // setdata()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
      //  collectionViewEvent.contentInset = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)
      //  idCr = ""
        SVProgressHUD.show()
       
        callEventListWebService{
            SVProgressHUD.dismiss()
            self.collectionViewEvent.reloadData()
            
            self.SectorLbl.text = self.EventListData?.neighbrhood
           // self.PastLbl.text = self.EventListData?.eventPast.first?.iseventrunning
          //  self.CurrentLbl.text = self.EventListData?.first.eventcountCurrent
        //    self.UpcomingLbl.text = self.EventListData?.neighbrhood

        }

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnCreateEvent(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateEventViewController") as? CreateEventViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnCurrent(_ sender: UIButton) {
        selection = 1
       
        btnCurrent.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        btnPast.backgroundColor =  #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
        btnFuture.backgroundColor =   #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
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
        callEventListWebService{
            self.collectionViewEvent.reloadData()
        }
        
    }
    
    @IBAction func btnFuture(_ sender: UIButton) {
        selection = 2
       
       // EventsCollectionViewCell.isHidden = false
        btnCurrent.backgroundColor =   #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
        btnFuture.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        btnPast.backgroundColor =   #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
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
        callEventListWebService{
            self.collectionViewEvent.reloadData()
        }
    }
    
    @IBAction func btnPast(_ sender: UIButton) {
        selection = 3
       
        btnCurrent.backgroundColor =  #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
        btnFuture.backgroundColor =   #colorLiteral(red: 0.7725490196, green: 0.662745098, blue: 0.3333333333, alpha: 1)
        btnPast.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
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
        callEventListWebService{
            self.collectionViewEvent.reloadData()
        }
    }
    
    func callEventListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "neighbrhood":idNeighbour ?? "",
                                                    "eventuserlist":id ?? ""
                                                    
                                                   
                                                                        ]
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
        }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
              return 3
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0{
            if selection == 1{
                return EventListData?.eventCurrent.count ?? 0
            }else{
                return 0
            }

        } else if section == 1 {
            if selection == 2{
                return EventListData?.eventFuture.count ?? 0
            }else{
                return 0
            }
        }else{
            if selection == 3{
                return EventListData?.eventPast.count ?? 0
            }else{
                return 0
            }
        }
    }
    

//     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsCollectionViewCell", for: indexPath) as! EventsCollectionViewCell
//
//         cell.EventLbl.text = EventListData?.eventCurrent[indexPath.row].title
//         let url = URL(string: (EventListData?.eventCurrent[indexPath.row].coverImage ?? ""))
//         cell.profileImgView.kf.indicatorType = .activity
//         cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
//        // cell.FollowMemberLbl.text = neighbrhoodData?.nearestNeighbrhood[indexPath.row].member
//
//          return cell
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsCollectionViewCell", for: indexPath) as! EventsCollectionViewCell
         
                  cell.EventLbl.text = EventListData?.eventCurrent[indexPath.row].title
                  let url = URL(string: (EventListData?.eventCurrent[indexPath.row].coverImage ?? ""))
                  cell.profileImgView.kf.indicatorType = .activity
                  cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
            
            cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
            
            cell.DetailCallback = { [self] value in
//                
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController")as! EventsDetailViewController
//                vc.eventid = EventListData?.eventCurrent[indexPath.row].id ?? ""
//             
//                self.navigationController?.pushViewController(vc, animated: true)
//                
                
    
            }
            
                 
         
                   return cell
     } else if indexPath.section == 1 {
         
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCollectionViewCell", for: indexPath) as! UpcomingEventsCollectionViewCell
         
         cell.EventLbl.text = EventListData?.eventFuture[indexPath.row].title
                  let url = URL(string: (EventListData?.eventFuture[indexPath.row].coverImage ?? ""))
                  cell.profileImgView.kf.indicatorType = .activity
                  cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
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
//             
//             let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController")as! EventsDetailViewController
//             vc.eventid = EventListData?.eventFuture[indexPath.row].id ?? ""
//          
//             self.navigationController?.pushViewController(vc, animated: true)
//             
             
 
         }
      //   cell.frame = cell.frame.offsetBy(dx: 0, dy: -20)
                 // cell.FollowMemberLbl.text = neighbrhoodData?.nearestNeighbrhood[indexPath.row].member
         
                   
        
    return cell
         
     }
     
     else  {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PastCollectionViewCell", for: indexPath) as! PastCollectionViewCell
         
                  cell.EventLbl.text = EventListData?.eventPast[indexPath.row].title
                  let url = URL(string: (EventListData?.eventPast[indexPath.row].coverImage ?? ""))
                  cell.profileImgView.kf.indicatorType = .activity
                  cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
         cell.EventLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
       //  cell.frame = cell.frame.offsetBy(dx: 0, dy: -70)
         
         
         if !cell.isOffsetAppliedPast {
                 cell.frame = cell.frame.offsetBy(dx: 0, dy: -70)
                 cell.isOffsetAppliedPast = true
             }
         
         cell.DetailCallback = { [self] value in
             
//             let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController")as! EventsDetailViewController
//             vc.eventid = EventListData?.eventPast[indexPath.row].id ?? ""
//          
//             self.navigationController?.pushViewController(vc, animated: true)
             
             
 
         }
         
                   
        
    return cell
     }
}
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     let width = collectionViewEvent.frame.width / 3 - 15
        let height = width + 40
         return CGSize(width: width , height: height)
     
     }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailVC")as! CategoryDetailVC
//        vc.conID = getCategoryBucketData?.response?.data?.contents?[indexPath.row].podcastId ?? 0
//        self.navigationController?.pushViewController(vc, animated: true)
//
//    }

}


//return EventListData?.eventCurrent.count ?? 0

