//
//  OtherProfilePostTableViewCell.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 10/07/24.
//

import UIKit

class OtherProfilePostTableViewCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionViewBanner: UICollectionView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGeneral: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var HeartImgView : UIImageView!
    @IBOutlet weak var LargeImgView : UIImageView!
    @IBOutlet weak var EmojiView : UIImageView!
    
    @IBOutlet weak var lblStLikes: UILabel!
    @IBOutlet weak var lblStComment: UIButton!
    
    @IBOutlet weak var lblNewEmoji: UILabel!
    @IBOutlet weak var viewToHide: UIView!
    
   // @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var btnLikes: UIButton!
    var LikesCallback : ((UIButton) -> Void)?
    var CommentCallback : ((UIButton) -> Void)?
    var FullImgCallback : ((UIButton) -> Void)?
    var LikeListCallback : ((UIButton) -> Void)?
    var imgData = [PostImage]()
    var imgEmojiData = [Emojilistdata]()
    var UserName = ""
    
    var newStoryBoard:  UIStoryboard!
    var newNavigationController:  UINavigationController!
    
    @IBOutlet weak var shareButton: UIButton!
    
    let reactionButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("🤍", for: .normal)
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
       
       let emojiContainerView: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           view.backgroundColor = UIColor.white
           view.layer.cornerRadius = 10
           view.layer.shadowColor = UIColor.black.cgColor
           view.layer.shadowOpacity = 0.3
           view.layer.shadowOffset = CGSize(width: 0, height: 5)
           view.layer.shadowRadius = 5
           view.isHidden = true
           return view
       }()
       
       let emojis: [String] = ["👍", "❤️", "😂", "😮", "😎", "🥳","♡"]
   
        
        var shareAction: (() -> Void)?
    var emojiAction: ((_ emoji : String?) ->())?
        
        

        @IBAction func shareButtonTapped(_ sender: UIButton) {
            shareAction?()
        }

    var thisWidth:CGFloat = 0
    var PostListData : PostListModel?
  //  var BusinessListData : BussinessListModel?
    
//    var BusinessListData : BussinessListModel?{
//        didSet{
//            collectionViewBanner.reloadData()
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewBanner.delegate = self
        collectionViewBanner.dataSource = self
     
        //viewPopup.isHidden = true
      //  self.HeartImgView.image = UIImage(systemName: "heart")
        // Initialization code
        setupEmojis()
        self.HeartImgView.image = UIImage(systemName: "heart")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                viewToHide.addGestureRecognizer(tapGesture)
        
        
        
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            // Reset the collection view's data to avoid displaying incorrect images
        collectionViewBanner.reloadData()
        }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupView()
        }
    
//       required init?(coder: NSCoder) {
//           fatalError("init(coder:) has not been implemented")
//       }
    
    @IBAction func btnLikes(_ sender: UIButton) {
        LikesCallback?(sender)
    }
    @IBAction func btnComment(_ sender: UIButton) {
        CommentCallback?(sender)
    }
    
    @IBAction func btnFullImg(_ sender: UIButton) {
        FullImgCallback?(sender)
    }
    
    
    @IBAction func btnLikeList(_ sender: UIButton) {
        LikeListCallback?(sender)
    }
    
    @IBAction func btnClose(_ : UIButton){
        
     //   viewPopup.isHidden = true
        
    }
    
   
    
    private func setupView() {
           contentView.addSubview(reactionButton)
           contentView.addSubview(emojiContainerView)
       
        
           
           NSLayoutConstraint.activate([
              reactionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,constant: 155),
              // reactionButton.centerYAnchor.constraint(equalTo: btnComment.centerYAnchor, constant: 40),
                   
             
               reactionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
               reactionButton.heightAnchor.constraint(equalToConstant: 60),
               reactionButton.widthAnchor.constraint(equalToConstant: 60),
               
               emojiContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,constant: 90),
               emojiContainerView.bottomAnchor.constraint(equalTo: reactionButton.topAnchor, constant: 50),
               emojiContainerView.heightAnchor.constraint(equalToConstant: 50),
               emojiContainerView.widthAnchor.constraint(equalToConstant: CGFloat(emojis.count * 50)),
            
           
           ])
           
           setupEmojis()
           
           let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showEmojiContainer))
           reactionButton.addGestureRecognizer(longPressGesture)
       }
    
    private func setupEmojis() {
           for (index, emoji) in emojis.enumerated() {
               let button = UIButton(type: .system)
               let fontSize: CGFloat = 30
               button.setTitle(emoji, for: .normal)
               button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
               button.tag = index
               button.frame = CGRect(x: index * 50, y: 5, width: 40, height: 40)
               button.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
               
               
               emojiContainerView.addSubview(button)
           }
       }
       
       @objc private func showEmojiContainer() {
           emojiContainerView.isHidden = false
           DispatchQueue.main.asyncAfter(deadline: .now() + 9) { [weak self] in
               self?.emojiContainerView.isHidden = true
           }
       }
    
    @objc func handleTap() {
        emojiContainerView.isHidden = true
       }
       
    @objc private func emojiTapped(sender: UIButton) {
        let selectedEmoji = emojis[sender.tag]
        reactionButton.setTitle(selectedEmoji, for: .normal)
        emojiAction?(selectedEmoji)
        emojiContainerView.isHidden = true
    }
 
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgData.count ?? 0
       
        
    }
    
    @IBAction func categoryTapped(sender: UITapGestureRecognizer) {
        
       // self.sectorLbl.text = neighbrhoodData?.nearestNeighbrhood[viewTag!].name

        let tappedView = sender.view
        let viewTag = tappedView?.tag
        
        let url = URL(string: (imgData[viewTag!].img ?? ""))
        self.LargeImgView.kf.indicatorType = .activity
        self.LargeImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewBusiness"))
        
       
        
     //   viewPopup.isHidden = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewPostCollectionViewCell", for: indexPath) as! NewPostCollectionViewCell
        
        let url = URL(string: (imgData[indexPath.row].img ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: ""))
        
        let totalNumberOfImages = imgData.count
        cell.totalImagesLabel.text =  "/ \(totalNumberOfImages)"
        cell.numberLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        cell.totalImagesLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        
        
       
       // cell.profileImgView.image = nil
//        let tapCategoryCardCell = UITapGestureRecognizer(target: self, action:  #selector(self.categoryTapped))
//        cell.viewCard.tag = indexPath.row
//        cell.viewCard.addGestureRecognizer(tapCategoryCardCell)
        
        
//        cell.DetailsCallback = { [self] value in
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let viewController = storyboard.instantiateViewController(withIdentifier: "PostEnlargeImageViewController") as? PostEnlargeImageViewController {
//                // Assuming you have a navigation controller, push the view controller
//                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
//                    viewController.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
//                //    viewController.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
//
//                    navigationController.pushViewController(viewController, animated: true)
//                }
//            }
//
//        }
        
       
//
    //    cell.profileImgView.image = UIImage(named: self.PostListData?.listdata[indexPath.row].postImages.first?.img ?? "")!
        
//        let url = PostListData?.listdata.first?.postImages[indexPath.row].img ?? ""
//        cell.profileImgView.kf.indicatorType = .activity
//        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewBusiness"))

//        let url = URL(string: (BusinessListData?.listdata[indexPath.row].userpic ?? ""))
//        cell.PublicImgView.kf.indicatorType = .activity
//        cell.PublicImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
        
        
        
//        let url = URL(string: (BusinessListData?.listdata[indexPath.row].userpic ?? ""))
//        cell.PublicImgView.kf.indicatorType = .activity
//        cell.PublicImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
//
        return cell
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                  thisWidth = CGFloat(self.collectionViewBanner.width) / 1
                  return CGSize(width: thisWidth, height: 214)
              }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
////        let vc = self.newStoryBoard?.instantiateViewController(withIdentifier: "PostPictureEnlarge")as! PostPictureEnlarge
////        vc.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
////        self.newNavigationController?.pushViewController(vc, animated: true)
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let vc = storyboard.instantiateViewController(withIdentifier: "PostEnlargeImageViewController") as? PostEnlargeImageViewController {
//            // Assuming you have a navigation controller, push the view controller
//            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
//              //  viewController.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
//                vc.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
//                vc.UserName = PostListData?.listdata?[indexPath.row].username ?? ""
//            //    viewController.imgData = PostListData?.listdata?[indexPath.row].postImages ?? []
//
//                navigationController.pushViewController(vc, animated: true)
//            }
//        }
//
//    }

}


