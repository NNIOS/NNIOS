//
//  OtherProfilePostViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 10/07/24.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class OtherProfilePostViewController: UIViewController {

    @IBOutlet weak var tableviewPost: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
   // emojiLabel.text = "😊🚀🌟"
    var selectedIndexPath: IndexPath?
    var PostListData : PostListModel?
    var PostLikeData : LikePostModel?
    var imgEmojiData = [Emojilistdata]()
    var imgData = [PostImage]()
    var UserName = ""
    var sectorName = ""
    var MonthName = ""
    var GeneralName = ""
    var DescriptionlName = ""
    var Newid : String?
    var otheridO : String?
    var idOther : String?
    
    
    let items = [
            (id: "1", name: "Item 1"),
            (id: "2", name: "Item 2"),
            (id: "3", name: "Item 3")
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
//        DispatchQueue.main.async {
//                    if let indexPath = self.selectedIndexPath {
//                        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
//                    }
//                }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // SVProgressHUD.show()
        
        
        callPostListWebService{
            SVProgressHUD.dismiss()
            self.tableviewPost.reloadData()
            
            
            // Do any additional setup after loading the view.
        }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnCreatePost(_ : UIButton){

    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController else {return}

    self.navigationController?.pushViewController(vc, animated: true)

       }
    
    

    
    func shareContent(for item: (id: String, name: String)) {
           let shareText = "Check out this item: \(item.name)"
           let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
           
           // For iPad, set the source view.
           if let popoverController = activityViewController.popoverPresentationController {
               popoverController.sourceView = self.view
               popoverController.sourceRect = self.view.bounds
           }
           
           self.present(activityViewController, animated: true, completion: nil)
       }
   

}

@available(iOS 16.0, *)
extension OtherProfilePostViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PostListData?.listdata?.count ?? 0

        //BusinessListData?.listdata.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherProfilePostTableViewCell", for: indexPath) as! OtherProfilePostTableViewCell
      
        cell.lblName.text = PostListData?.listdata?[indexPath.row].username
      //  cell.lblGeneral.text = PostListData?.listdata[indexPath.row].postType
        cell.lblGeneral.text = PostListData?.listdata?[indexPath.row].postType
        cell.lblDescription.text = PostListData?.listdata?[indexPath.row].postMessage
      //  cell.lblSec.text = PostListData?.listdata[indexPath.row].neighborhood
        cell.lblSec.text = PostListData?.listdata?[indexPath.row].neighborhood
        cell.lblMonth.text = PostListData?.listdata?[indexPath.row].createdOn
        cell.lblLikes.text = PostListData?.listdata?[indexPath.row].totallike
        cell.lblComments.text = PostListData?.listdata?[indexPath.row].totcomment
        
        cell.lblComments.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblLikes.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblStLikes.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblDescription.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 11)
        cell.lblMonth.font = UIFont(name: "Montserrat-Regular", size: 11)
        cell.lblGeneral.font = UIFont(name: "Montserrat-Medium", size: 15)
        cell.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
        cell.UserName = PostListData?.listdata?[indexPath.row].username ?? ""
        cell.reactionButton.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
        
        let text = PostListData?.listdata?[indexPath.row].postemojiunicode?.decodeEmojiOther
        if text == nil {
          //  cell.reactionButton.isSelected = true
            cell.reactionButton.setImage(UIImage(systemName: ""), for: .normal)
            cell.reactionButton.setTitle("", for: .normal)
        }else{
        //    cell.reactionButton.isSelected = false
            cell.reactionButton.setImage(nil, for: .normal)
            cell.reactionButton.setTitle(text, for: .normal)
        }
        
       
        
//        cell.UnlikeCallback = { [self] value in
//            
//           
//            callPostUnLikeWebService{
//                self.tableviewPost.reloadData()
//            }
//        }
        
        
        cell.emojiAction = { emoji in
            print(emoji ?? "")
            let emo = emoji ?? ""
            self.callPostLikeWebService(postId: self.PostListData?.listdata?[indexPath.row].postid, emoji: emoji, { [self] in
                
                callPostListWebService{
                    SVProgressHUD.dismiss()
                    self.tableviewPost.reloadData()
                    
                    
                    // Do any additional setup after loading the view.
                }
            })
            
               }
        
        
       // cell.lblComments.text = imgEmojiData[indexPath.row].emojiunicode
       // cell.imgEmojiData = PostListData?.listdata?[indexPath.row]. ?? []
        
//        let urlNN = URL(string: (imgEmojiData[indexPath.row].emojiunicode ?? "").rawValue)
//        cell.HeartImgView.kf.indicatorType = .activity
//        cell.HeartImgView.kf.setImage(with:urlNN ,placeholder: UIImage(named: ""))
//
      //  cell.imgEmojiData = imgEmojiData[indexPath.row].emojiunicode?.rawValue ?? ""
     //   profileImgView.image = UIImage(named: #imageLiteral(resourceName: "default_UserImage"))
        
     //   cell.lblNewEmoji.text = self.imgEmojiData[indexPath.row].emojiunicode
        
//        if indexPath.row < imgEmojiData.count {
//            if let emojiunicode = imgEmojiData[indexPath.row].emojiunicode?.rawValue,
//               let urlNN = URL(string: emojiunicode) {
//                cell.EmojiView.kf.indicatorType = .activity
//                cell.EmojiView.kf.setImage(with: urlNN, placeholder: UIImage(named: ""))
//            } else {
//                // Handle the case where the URL could not be created
//                cell.EmojiView.image = UIImage(named: "")
//            }
//        } else {
//            // Handle the case where indexPath.row is out of bounds
//            cell.EmojiView.image = UIImage(named: "")
//        }

        
//        if let emojiString = imgEmojiData[indexPath.row].emojiunicode?.rawValue, // Safely unwrap rawValue
//           let urlNN = URL(string: emojiString) { // Create URL from the String
//            cell.EmojiView.kf.indicatorType = .activity
//            cell.EmojiView.kf.setImage(with: urlNN, placeholder: UIImage(named: "placeholderImage")) // Use a proper placeholder
//        } else {
//            // Handle the case where emojiString or URL creation fails
//            cell.EmojiView.image = UIImage(named: "placeholderImage")
//        }
        
//        if let emojiString = imgEmojiData[indexPath.row].emojiunicode, // Directly unwrap the String
//           let urlNN = URL(string: emojiString.rawValue) {
//            cell.HeartImgView.kf.indicatorType = .activity
//            cell.HeartImgView.kf.setImage(with: urlNN, placeholder: UIImage(named: "placeholderImage"))
//        } else {
//            // Handle the case where emojiString or URL creation fails
//            cell.HeartImgView.image = UIImage(named: "placeholderImage")
//        }
        
        // Ensure indexPath.row is within the bounds of imgEmojiData array
        
//        func unicodeToEmoji(_ unicodeString: String) -> String {
//            // Replace the Unicode escape sequences
//            let processedString = unicodeString
//                .replacingOccurrences(of: "\\U", with: "\\u")
//                .replacingOccurrences(of: "\\u", with: "\\u{")
//                .replacingOccurrences(of: " ", with: " ")
//
//            // Decode the Unicode string
//            let emojiString = processedString
//                .components(separatedBy: " ")
//                .map { (component) -> String in
//                    if component.hasPrefix("\\u{"), component.hasSuffix("}") {
//                        let hexString = component.dropFirst(3).dropLast()
//                        if let codePoint = UInt32(hexString, radix: 16),
//                           let scalar = UnicodeScalar(codePoint) {
//                            return String(scalar)
//                        }
//                    }
//                    return component
//                }
//                .joined()
//
//            return emojiString
//        }
//
//        // Example usage
//        let unicodeString = "\\U0001F602" // Laughing emoji
//        let emoji = unicodeToEmoji(unicodeString)
//        print(emoji) // Prints 😂
        
        
        
       
        
//        if indexPath.row < imgEmojiData.count {
//            if let emojiString = imgEmojiData[indexPath.row].emojiunicode, // Directly unwrap the String
//               let urlNN = URL(string: emojiString.rawValue) {
//                cell.EmojiView.kf.indicatorType = .activity
//                cell.EmojiView.kf.setImage(with: urlNN, placeholder: UIImage(named: "placeholderImage"))
//            } else {
//                // Handle the case where emojiString or URL creation fails
//                cell.EmojiView.image = UIImage(named: "placeholderImage")
//            }
//        } else {
//            // Handle the case where indexPath.row is out of bounds
//            cell.EmojiView.image = UIImage(named: "placeholderImage")
//        }
//        let url = URL(string: (imgData[indexPath.row].img ?? ""))
//        cell.profileImgView.kf.indicatorType = .activity
//        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: ""))
//
//        let urlN = URL(string: (imgData[indexPath.row].img ?? ""))
//        cell.HeartImgView.kf.indicatorType = .activity
//        cell.HeartImgView.kf.setImage(with:urlN ,placeholder: UIImage(named: "NewBusiness"))
        
        
        
        
        cell.shareAction = { [weak self] in
           //        self?.shareContent(for: item)
               }
        
//        if cell.PostListData?.listdata[indexPath.row].postlike == "1" {
//
//            cell.HeartImgView.image = UIImage(systemName: "heart.fill")
//
//
//        } else if cell.PostListData?.listdata[indexPath.row].postlike == "0" {
//            cell.HeartImgView.image = UIImage(systemName: "heart")
//
//        }
        
        cell.CommentCallback = { [self] value in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailsNewViewController")as! PostDetailsNewViewController
            vc.UserName = PostListData?.listdata?[indexPath.row].username ?? ""
          //  vc.sectorName =  PostListData?.listdata![indexPath.row].neighborhood ?? ""
            vc.sectorName = PostListData?.listdata?[indexPath.row].neighborhood ?? ""
            vc.MonthName = PostListData?.listdata?[indexPath.row].createdOn ?? ""
            vc.GeneralName = PostListData?.listdata?[indexPath.row].postType ?? ""
         //   vc.GeneralName =  PostListData?.listdata?[indexPath.row].postType ??
            vc.DescriptionlName = PostListData?.listdata?[indexPath.row].postMessage ?? ""
            vc.CommentName =  PostListData?.listdata?[indexPath.row].totcomment ?? ""
            vc.likeName = PostListData?.listdata?[indexPath.row].totallike ?? ""
            vc.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
          //  vc.UserimgData = (PostListData?.listdata?[indexPath.row].userpic ?? [])
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        cell.FullImgCallback = { [self] value in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostEnlargeImageViewController")as! PostEnlargeImageViewController
            vc.UserName = PostListData?.listdata?[indexPath.row].username ?? ""
          
            vc.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
          //  vc.UserimgData = (PostListData?.listdata?[indexPath.row].userpic ?? [])
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        cell.LikeListCallback = { [self] value in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LikeListViewController") as! LikeListViewController
            vc.Postid = PostListData?.listdata?[indexPath.row].postid ?? ""
            vc.height = 300
            vc.topCornerRadius = 10.0
            vc.presentDuration = 0.5
            vc.dismissDuration = 0.5
            vc.view.backgroundColor = .white
           
            vc.callback = { range in
               
            }
           
            self.present(vc, animated: true, completion: nil)
            
        }
        
        if PostListData?.listdata?[indexPath.row].postlike == "0" {
            cell.HeartImgView.image = UIImage(systemName: "heart")
           
        } else if PostListData?.listdata?[indexPath.row].postlike == "1" {
           
           // cell.HeartImgView.image = UIImage(systemName: "heart")
            cell.HeartImgView.isHidden = true
         
        }
        
//        if PostListData?.listdata?[indexPath.row].postlike == "1" {
//            cell.HeartImgView.image = UIImage(systemName: "heart.fill")
//
//        } else if PostListData?.listdata?[indexPath.row].postlike == "0" {
//
//            cell.HeartImgView.image = UIImage(systemName: "heart")
//
//        }
//
//        if imgEmojiData[indexPath.row].emojiunicode == "👍" {
//            cell.HeartImgView.image = UIImage(systemName: "check")
//
//        }
        
//        if imgEmojiData[indexPath.row].emojiunicode == "👍" {
//            cell.HeartImgView.image = UIImage(systemName: "check")
//
//        } else if imgEmojiData[indexPath.row].emojiunicode?.rawValue ?? "" == "👍" {
//            cell.HeartImgView.image = UIImage(systemName: "close")
//
//        }
        
        
        
      //  cell.profileImgView.image = UIImage(named: [indexPath.row]
        
        let url = URL(string: (PostListData?.listdata?[indexPath.row].userpic ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewBusiness"))
        
        let emoji = PostListData?.listdata?[indexPath.row].postemojiunicode
        

        
        cell.LikesCallback = { [self] value in
            
            if cell.HeartImgView.image == UIImage(systemName: "heart"){
                cell.HeartImgView.image = UIImage(systemName: "heart.fill")

            }else{
                cell.HeartImgView.image = UIImage(systemName: "heart")
            }
            
        }
        
        return cell
    }
    
    func callPostListWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "idOther")
        let dictParams: Dictionary<String, Any> = [
                                                  "userid":idPost ?? "",
                                                  ]
//          WebService.sharedInstance.callPostListWebService(withParams: dictParams) { data in
//            self.PostListData = data
//            //  UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
//              UserDefaults.standard.set(self.PostListData?.listdata?.first?.postid, forKey: "postid")
////              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
//             // UserDefaults.standard.set(self.PostListData?.em.id, forKey: "id")
//             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")
//
//            completionClosure()
//          }
        }
    
    @objc private func emojiTapped(sender: UIButton) {
        callPostUnLikeWebService{
            self.tableviewPost.reloadData()
        }
    }
    
    func callPostUnLikeWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
        let dictParams: Dictionary<String, Any> = [
                                                  "userid":id ?? "" ,
                                                  "postid":idPost ?? "",
                                                  "likestatus": "0",
                                                  "emojiunicode":  "",
                                                   ]
        
//          WebService.sharedInstance.callPostUnLikeWebService(withParams: dictParams) { data in
//          //  self.LikePostModel = data
//            //  UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
//            //  UserDefaults.standard.set(self.PostListData?.listdata?.first?.postid, forKey: "postid")
//            //  UserDefaults.standard.set(self.PostListData?.listdata.u, forKey: "accessToken")
//           //   UserDefaults.standard.set(self.PostUnlikeLikeData?..id, forKey: "id")
//             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")
//
//            completionClosure()
//          }
        }
    
    func callPostLikeWebService(postId : String?,emoji : String?, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
    //    let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
   //     let idPost = UserDefaults.standard.string(forKey: "postid")
        let dictParams: Dictionary<String, Any> = [
                                                  "userid":id ?? "" ,
                                                  "postid":postId ?? "",
                                                  "likestatus": "1",
                                                  "emojiunicode": emoji ?? "",
                                                   ]
        
//          WebService.sharedInstance.callPostLikeWebService(withParams: dictParams) { data in
//            self.PostLikeData = data
//             // UserDefaults.standard.setValue(nil, forKey: "postid")
//            //  UserDefaults.standard.set(self.MemberListData?.listdata.first?.id, forKey: "id")
//            //  UserDefaults.standard.set("\(self.MemberListData?.listdata.first?.id ?? 0)", forKey: "userid")
////              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
//             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
//             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")
//
//            completionClosure()
//          }
        }
    
}

extension String {
    var decodeEmojiOther: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}

