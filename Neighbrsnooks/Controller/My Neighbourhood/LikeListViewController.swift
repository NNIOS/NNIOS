//
//  LikeListViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 18/06/24.
//

import UIKit
import SVProgressHUD
@available(iOS 16.0, *)
class LikeListViewController: BottomPopupViewController {
    
    @IBOutlet weak var tableviewMembers: UITableView!
    
    var LikeListData : LikeListModel?
    var Postid = ""
    var callback : ((_ range : String?) ->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      //  self.MembersLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        
        SVProgressHUD.show()
        
        
        callLikeListPostWebService{
            SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
            
            
            // Do any additional setup after loading the view.
        }
    }
    

    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?

    override var popupHeight: CGFloat { return height ?? CGFloat(SCREEN_HEIGHT - 10) }

    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(0) }

    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }

    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }

    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }

}

@available(iOS 16.0, *)
extension LikeListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return LikeListData?.listdata.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeListTableViewCell", for: indexPath) as! LikeListTableViewCell
        
        cell.lblName.text = LikeListData?.listdata[indexPath.row].username
      //  cell.EmojiImgView.text = LikeListData?.listdata[indexPath.row].emojiunicode
        
        
//        let emojiUnicode = LikeListData?.listdata[indexPath.row].emojiunicode
//        cell.lblEmoji?.text = unicodeToEmoji(unicode: emojiUnicode ?? "")

        
//        let url = URL(string: (LikeListData?.listdata[indexPath.row].emojiunicode ?? ""))
//        cell.EmojiImgView.kf.indicatorType = .activity
//        cell.EmojiImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewBusiness"))
       
        
        cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 17)
        
        let text = LikeListData?.listdata[indexPath.row].emojiunicode?.decodeEmojiNew
        if text == nil {
          //  cell.reactionButton.isSelected = true
            cell.reactionButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.reactionButton.setTitle("", for: .normal)
          //  cell.reactionButton.kf.setImage(with:url ,placeholder: UIImage(named: "NewBusiness"))
        }else{
        //    cell.reactionButton.isSelected = false
            cell.reactionButton.setImage(nil, for: .normal)
           // cell.reactionButton.setImage(UIImage(systemName: "heart"), for: .normal)
           // cell.reactionButton.kf.setImage(with:url ,placeholder: UIImage(named: "NewBusiness"))
            cell.reactionButton.setTitle(text, for: .normal)
        }
        
        if LikeListData?.listdata[indexPath.row].emojiunicode == "" {
           // cell.reactionButton.image = UIImage(systemName: "heart")
            cell.reactionButton.setImage(UIImage(systemName: "heart (1)"), for: .normal)
           
        } else if LikeListData?.listdata[indexPath.row].emojiunicode == "2" {
           
           // cell.HeartImgView.image = UIImage(systemName: "heart")
            cell.reactionButton.isHidden = true
         
        }
       
        
      //  cell.profileImgView.image = UIImage(named: [indexPath.row]
        
        
       // cell.btnOtherProfile.tag = indexPath.row
      //  cell.btnOtherProfile.addTarget(self, action: #selector(onProfileClick(_:)), for: .touchUpInside)
       
        return cell
    }
    
    func unicodeToEmoji(unicode: String) -> String? {
        guard let unicodeScalar = UnicodeScalar(Int(unicode, radix: 16) ?? 0) else {
               return nil
           }
           return String(Character(unicodeScalar))
       }

    
    func callLikeListPostWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
          let dictParams: Dictionary<String, Any> = [
            "postid":Postid,
                                                    
                                                                        ]
          WebService.sharedInstance.callLikeListPostWebService(withParams: dictParams) { data in
            self.LikeListData = data
            //  UserDefaults.standard.set(self.LikeListData?.LikeListData.first?.id, forKey: "id")
            //  UserDefaults.standard.set("\(self.MemberListData?.listdata.first?.id ?? 0)", forKey: "userid")
//              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")

            completionClosure()
          }
        }
}
@available(iOS 16.0, *)
extension String {
    var decodeEmojiNew: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}

