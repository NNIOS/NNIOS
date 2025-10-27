//
//  ChatOtherProfileViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 03/05/24.
//

import UIKit
@available(iOS 16.0, *)
class ChatOtherProfileViewController: BaseViewController {

    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var SecLbl: UILabel!
    @IBOutlet weak var SectorLbl: UILabel!
   
   
    @IBOutlet weak var EmergencyLbl: UILabel!
    
    @IBOutlet weak var GenderLbl: UILabel!
    @IBOutlet weak var ProfessioLbl: UILabel!
    @IBOutlet weak var IntrstLbl: UILabel!
    @IBOutlet weak var MemberLbl: UILabel!
    @IBOutlet weak var AddressCityLbl: UILabel!
    @IBOutlet weak var ReasonLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var AddOneLbl: UILabel!
    @IBOutlet weak var AddTwoLbl: UILabel!
    
    @IBOutlet weak var EventsLbl: UILabel!
    @IBOutlet weak var PollLbl: UILabel!
    @IBOutlet weak var BusinessLbl: UILabel!
    @IBOutlet weak var GroupLbl: UILabel!
    @IBOutlet weak var PostLbl: UILabel!
    @IBOutlet weak var FavoriteLbl: UILabel!
    
    @IBOutlet weak var dynamicView: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    
    var profileData : ProfileModel?
    var MemberListData : MembersModel?
    
    var Newid : String?
    var idOther : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.NameLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.SecLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        callUserProfileWebService{ [self] in
            
            self.NameLbl.text = self.profileData?.firstname
            self.SecLbl.text = self.profileData?.lastname
            self.SectorLbl.text = self.profileData?.neighborhood
            self.IntrstLbl.text = self.profileData?.intersttype
            self.MemberLbl.text = self.profileData?.createddate
            
           
            self.EmergencyLbl.text = self.profileData?.emerPhone
            
            self.GenderLbl.text = self.profileData?.gender
            self.ProfessioLbl.text = self.profileData?.nbrsType
            self.AddressCityLbl.text = self.profileData?.addressone
            self.ReasonLbl.text = self.profileData?.reason
            self.AddOneLbl.text = self.profileData?.addlineone
            self.AddTwoLbl.text = self.profileData?.addlinetwo
            
            
            self.EventsLbl.text = self.profileData?.events
            self.PollLbl.text = self.profileData?.polls
            self.BusinessLbl.text = self.profileData?.business
            self.GroupLbl.text = self.profileData?.groups
            self.PostLbl.text = self.profileData?.posts
            self.FavoriteLbl.text = self.profileData?.favourites
            
            let url = URL(string: (self.profileData?.userpic ?? ""))
            self.profileImgView.kf.indicatorType = .activity
            self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
            
            
           
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnPost(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfilePostViewController") as? OtherProfilePostViewController else {return}
        
        vc.idOther = idOther

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    @IBAction func btnGroup(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileGroupViewController") as? OtherProfileGroupViewController else {return}
        
     //   vc.idOther = idOther

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
     //   let idOther = UserDefaults.standard.string(forKey: "id")
        
          let dictParams: Dictionary<String, Any> = [
                                                    
                                                    "userid": Newid ?? "",
                                                    "loggeduser":id ?? "",
                                                   
                                                                        ]
//          WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { data in
//            self.profileData = data
////              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
//              UserDefaults.standard.set(self.profileData?.id, forKey: "idOther")
//              UserDefaults.standard.set(self.profileData?.id, forKey: "idOther")
//            //  UserDefaults.standard.set(self.profileData?.id, forKey: "idOther")
//             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")
//
//            completionClosure()
//          }
        }
    

}
