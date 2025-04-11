import UIKit

class ShowFullImageViewController: UIViewController {
    
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    
    var userPicURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setdata()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        // Load the image using Kingfisher
               if let userPicURL = userPicURL, let url = URL(string: userPicURL) {
                   profileImgView.kf.indicatorType = .activity
                   profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "letter-b"))
               } else {
                   profileImgView.image = UIImage(named: "letter-b") // Fallback image
               }
        
       
        // Do any additional setup after loading the view.
    }
    
    
    
    func setdata(){
        
       
        let urlString = UserDefaults.standard.object(forKey: "profileImage") as? String
        let url = URL(string: (urlString ?? ""))
        self.profileImgView.kf.indicatorType = .activity
        self.profileImgView.kf.setImage(with:url,placeholder:UIImage(named: "My-profile"))

    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    

}
