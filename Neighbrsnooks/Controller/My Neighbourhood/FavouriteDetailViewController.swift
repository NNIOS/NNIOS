//
//  FavouriteDetailViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 01/08/24.
//

import UIKit
import SVProgressHUD
@available(iOS 16.0, *)
class FavouriteDetailViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate {

    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var tableviewPost: UITableView!
    @IBOutlet weak var MembersLbl: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    @IBOutlet weak var lblGeneral: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblmonth: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var UserPicImgView : UIImageView!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tvmessage: UITextView!
    
    var thisWidth:CGFloat = 0
    var CommentPostListData : CommentPostModel?
    var PostCommentData : PostCommentModel?
    var UserName = ""
    var sectorName = ""
    var MonthName = ""
    var GeneralName = ""
    var DescriptionlName = ""
    var CommentName = ""
    var likeName = ""
    var postid = ""
    var timer: Timer?
        var counter = 0
    var imgData = [PostImage]()
    var imgDataF = [PostImageF]()
    var PostidDe = [Postlistdatum]()
    var PostListData : PostListModel?
  //  var UserimgData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewBanner.delegate = self
       
        collectionViewBanner.dataSource = self
    //   collectionViewBanner.register(UINib(nibName: "PostBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostBannerCollectionViewCell")
        self.lblSector.font = UIFont(name: "Montserrat-Regular", size: 11)
        self.lblmonth.font = UIFont(name: "Montserrat-Regular", size: 11)
        collectionViewBanner.reloadData()
//        let shinyView = ShinyBackgroundView(frame: self.view.bounds)
//                shinyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                self.view.addSubview(shinyView)
//
        placeholderLabel.text = "Type a message..."
               placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvmessage.text.isEmpty
        tvmessage.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshTableView), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.MembersLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        lblName.text = UserName
        lblSector.text = sectorName
        lblGeneral.text = GeneralName
        lblDescription.text = DescriptionlName
        lblmonth.text = MonthName
        lblComment.text = CommentName
        lblLike.text = likeName
        
        let urlString = UserDefaults.standard.object(forKey: "userphoto") as? String
        let url = URL(string: (urlString ?? ""))
        self.UserPicImgView.kf.indicatorType = .activity
        self.UserPicImgView.kf.setImage(with:url,placeholder:UIImage(named: "My-profile"))

        
        SVProgressHUD.show()
        
        
        callPostCommenteWebService{
            SVProgressHUD.dismiss()
            self.tableviewPost.reloadData()
            
            
            // Do any additional setup after loading the view.
        }
        
//        callCommentePostWebService{
//         //   SVProgressHUD.dismiss()
//            self.tableviewPost.reloadData()
//
//
//            // Do any additional setup after loading the view.
//        }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @objc func refreshTableView() {
            // Call reloadData to refresh the table view
        tableviewPost.reloadData()
     //   scrollToBottom()
        }
    
    func textViewDidChange(_ textView: UITextView) {
            // Show or hide placeholder label based on text view content
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    
    @IBAction func SendBtn(_ sender: UIButton){
        
//        tfSubject.text = ""
       
        
        if tvmessage.text == "" {
        let alert = UIAlertController(title: "", message: "Please Enter Your Message", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
                         
        }

        else{
            
            callCommentePostWebService{ [self] in
                tvmessage.text = ""
                //tfSubject.text = ""
            }
            callPostCommenteWebService{ [self] in
                
//
            }
        }
      
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteDetailsImageEnlargementViewController")as! FavouriteDetailsImageEnlargementViewController
//        vc.imgDataF = self.imgDataF.self
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgDataF.count ?? 0
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostBannerCollectionViewCell", for: indexPath) as! PostBannerCollectionViewCell
        
        let url = URL(string: (imgDataF[indexPath.row].img ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: ""))
        
        cell.FullImgCallback = { [self] value in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteDetailsImageEnlargementViewController")as! FavouriteDetailsImageEnlargementViewController
          //  vc.UserName = listdata[indexPath.row].username ?? ""
            vc.imgDataF = self.imgDataF.self
         //   vc.UserName = self.UserName.self
          //  vc.imgDataF = imgDataF
          //  vc.UserimgData = (PostListData?.listdata?[indexPath.row].userpic ?? [])
            self.navigationController?.pushViewController(vc, animated: true)
            
//            guard let vc = storyboard?.instantiateViewController(withIdentifier: "PostEnlargeImageViewController") as? PostEnlargeImageViewController else {
//                return
//            }
//            vc.modalPresentationStyle = .overFullScreen
//            vc.UserName = PostListData?.listdata?[indexPath.row].username ?? ""
//
//            vc.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
//                present(vc, animated: true, completion: nil)
            
        }
        
//        let urlB = URL(string: (imgDataF[indexPath.row].img ?? ""))
//        cell.profileImgView.kf.indicatorType = .activity
//        cell.profileImgView.kf.setImage(with:urlB ,placeholder: UIImage(named: ""))
        
//        cell.FullImgCallback = { [self] value in
//            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostEnlargeImageViewController")as! PostEnlargeImageViewController
////            vc.UserName = PostListData?.listdata?[indexPath.row].username ?? ""
////
////            vc.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
//            vc.UserName = self.UserName.self
//            vc.imgDataF = self.imgDataF.self
//          //  vc.UserimgData = (PostListData?.listdata?[indexPath.row].userpic ?? [])
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//        }
        

//
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteDetailsImageEnlargementViewController")as! FavouriteDetailsImageEnlargementViewController
//        vc.imgDataF = self.imgDataF.self
//        self.navigationController?.pushViewController(vc, animated: true)
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use the correct storyboard name
        let favouriteDetailsVC = storyboard.instantiateViewController(withIdentifier: "FavouriteDetailsImageEnlargementViewController") as! FavouriteDetailsImageEnlargementViewController
        favouriteDetailsVC.imgDataF = self.imgDataF.self
        // Pass data to the new view controller if needed
        // favouriteDetailsVC.someProperty = someValue
        
        // Navigate to the new view controller
        self.navigationController?.pushViewController(favouriteDetailsVC, animated: true)
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                  thisWidth = CGFloat(self.collectionViewBanner.width) / 1
                  return CGSize(width: thisWidth, height: 214)
              }
    
    func callPostCommenteWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "postid": postid ?? "",
                                                    
                                                                        ]
//          WebService.sharedInstance.callPostCommenteWebService(withParams: dictParams) { data in
//            self.CommentPostListData = data
//            //  UserDefaults.standard.set(self.CommentPostListData?.postlistdata.first?.postid, forKey: "postid")
//            //  UserDefaults.standard.set("\(self.MemberListData?.listdata.first?.id ?? 0)", forKey: "userid")
////              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
//             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
//            //  UserDefaults.standard.set(self.CommentPostListData?.postlistdata.first?.postid, forKey: "profileImage")
//
//            completionClosure()
//          }
        }
    
    func callCommentePostWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
       // let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let idPost = UserDefaults.standard.string(forKey: "postid")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "postid":postid ?? "",
                                                    
                                                    "commenttext":self.tvmessage.text ?? "",
                                                                        ]
//          WebService.sharedInstance.callCommentePostWebService(withParams: dictParams) { data in
//            self.PostCommentData = data
//            
//              if self.PostCommentData?.status == "success"{
//                  completionClosure()
//              }else{
//                  self.showAlert(Message: self.PostCommentData?.message ?? "")
//              }
//          }
        }


}
@available(iOS 16.0, *)
extension FavouriteDetailViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CommentPostListData?.postlistdata.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailsTableViewCell", for: indexPath) as! PostDetailsTableViewCell
        
        cell.lblName.text = CommentPostListData?.postlistdata[indexPath.row].username
//        cell.lblSec.text = CommentPostListData?.postlistdata[indexPath.row].neighbrhood
        cell.lblComment.text = CommentPostListData?.postlistdata[indexPath.row].commenttext
        cell.lblTime.text = CommentPostListData?.postlistdata[indexPath.row].createon
        
        cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 17)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
        cell.lblTime.font = UIFont(name: "Montserrat-Regular", size: 13)
        
      //  cell.profileImgView.image = UIImage(named: [indexPath.row]
        
        let url = URL(string: (CommentPostListData?.postlistdata[indexPath.row].userpic ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
        
       // cell.btnOtherProfile.tag = indexPath.row
      //  cell.btnOtherProfile.addTarget(self, action: #selector(onProfileClick(_:)), for: .touchUpInside)
       
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
//        vc.otherid = MemberListData?.listdata[indexPath.row].id ?? ""
//
//
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
//    @objc func onProfileClick(_ sender:UIButton){
//
//        print(sender.tag)
//      //  let data = neighbrhoodData[sender.tag]
//
//
//
//
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController") as? OtherProfileViewController{
//            vc.MemberListData = self.MemberListData
//            self.navigationController?.pushViewController(vc, animated: false)
//        }
//
//
//    }
    
    
}
