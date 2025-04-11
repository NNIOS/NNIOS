

import UIKit
import CoreMedia
import MobileCoreServices
import SVProgressHUD
import PhotosUI
import Alamofire
@available(iOS 16.0, *)
class MyProfileViewController: BaseViewController {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var SecLbl: UILabel!
    @IBOutlet weak var SectorLbl: UILabel!
    @IBOutlet weak var EmailLbl: UILabel!
    @IBOutlet weak var MobileLbl: UILabel!
    @IBOutlet weak var EmergencyLbl: UILabel!
    @IBOutlet weak var DobLbl: UILabel!
    @IBOutlet weak var GenderLbl: UILabel!
    @IBOutlet weak var ProfessioLbl: UILabel!
    @IBOutlet weak var IntrstLbl: UILabel!
    @IBOutlet weak var MemberLbl: UILabel!
    @IBOutlet weak var AddressCityLbl: UILabel!
    @IBOutlet weak var ReasonLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var AddOneLbl: UILabel!
    @IBOutlet weak var AddTwoLbl: UILabel!
    @IBOutlet weak var AddProofLbl: UILabel!
    
    @IBOutlet weak var EventsLbl: UILabel!
    @IBOutlet weak var PollLbl: UILabel!
    @IBOutlet weak var BusinessLbl: UILabel!
    @IBOutlet weak var GroupLbl: UILabel!
    @IBOutlet weak var PostLbl: UILabel!
    @IBOutlet weak var FavoriteLbl: UILabel!
    
    @IBOutlet weak var btnAdress: UIButton!
    @IBOutlet weak var btnEmergency: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    // @IBOutlet weak var btnNeighbourhood: UIButton!
    
    @IBOutlet weak var TotalEventLbl: UILabel!
    @IBOutlet weak var TotalPollsLbl: UILabel!
    @IBOutlet weak var TotalBusinessLbl: UILabel!
    @IBOutlet weak var TotalGroupsLbl: UILabel!
    @IBOutlet weak var TotalPostLbl: UILabel!
    @IBOutlet weak var EventprcntgLbl: UILabel!
    @IBOutlet weak var EventPollsPrcntggLbl: UILabel!
    @IBOutlet weak var EventBusinessPrncntgLbl: UILabel!
    @IBOutlet weak var EventGropsPrcntgLbl: UILabel!
    @IBOutlet weak var EventPostPrcntgLbl: UILabel!
    
    @IBOutlet weak var viewintrest: UIView!
    @IBOutlet weak var viewNS: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var Eventprcntg: UILabel!
    @IBOutlet weak var EventPollsPrcntg: UILabel!
    @IBOutlet weak var EventBusinessPrncntg: UILabel!
    @IBOutlet weak var EventGropsPrcntg: UILabel!
    @IBOutlet weak var EventPostPrcntg: UILabel!
    
    @IBOutlet weak var MarketPrcntg: UILabel!
    @IBOutlet weak var TotMarket: UILabel!
    
    @IBOutlet weak var vieweevent: UIView!
    @IBOutlet weak var viewpost: UIView!
    
    @IBOutlet weak var viewePolls: UIView!
    @IBOutlet weak var viewBussines: UIView!
    
    @IBOutlet weak var vieweGroup: UIView!
    @IBOutlet weak var viewMarket: UIView!
    
    @IBOutlet weak var viewefillEvent: UIView!
    @IBOutlet weak var viewefillPolls: UIView!
    @IBOutlet weak var viewefillBusiness: UIView!
    
    @IBOutlet weak var viewefillGroup: UIView!
    @IBOutlet weak var viewefillPost: UIView!
    @IBOutlet weak var viewefillMarket: UIView!
    
    @IBOutlet weak var vieweMainProfile: UIView!
    
    var profileData : ProfileModel?
    var profileUploadData : UploadProfileModel?
    // var selectedImge: UIImage? = nil
    var isCircularWithStroke: Bool = false
    private let bottomPanel = BottomPanelView()
    
    var imageArray = [UIImage]()
    var from = 0 // 1 for gallery, 2 for camera
    var sourceViewController: String? // Set this when navigating to MyProfileViewController
    var Newid: String? // Set this when navigating from MessageViewController
    var Oid: String?
    
    //  private var profileViewModel: ProfileViewModel = ProfileViewModel()
    //  var picker = UIImagePickerController()
    
    var picker = UIImagePickerController()
    //  private weak var delegate: UIImagePickerControllerDelegate?
    var imagePicker:UIImagePickerController?
    private weak var delegate: UIImagePickerControllerDelegate?
    var selectedImge: UIImage? = nil
    
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    open var isAscending: Bool = true {
        didSet {
            rotateSlider()
        }
    }
    
    let phoneNumber = UserDefaults.standard.object(forKey: "emer_phone") as? String
    //   NameLbl.text = UserDefaults.standard.object(forKey: "username") as? String
    
    @IBAction func dialNumber(_ sender: Any) {
        if let url = URL(string: "tel://\(EmergencyLbl.text!)"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEventFill()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.EventprcntgLbl.text =  self.profileData?.eventper
        viewMarket.layer.cornerRadius = 15 // Adjust the radius as needed
        // viewMarket.layer.masksToBounds = true // Ensures t
        view.backgroundColor = .white
        imagePicker = UIImagePickerController()
        
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        //        self.NameLbl.font = UIFont(name: "Montserrat-SemiBold", size: 22)
        //        self.SecLbl.font = UIFont(name: "Montserrat-SemiBold", size: 22)
        self.EventsLbl.font = UIFont(name: "Montserrat-Regular", size: 35)
        self.PollLbl.font = UIFont(name: "Montserrat-Regular", size: 35)
        self.BusinessLbl.font = UIFont(name: "Montserrat-Regular", size: 35)
        self.GroupLbl.font = UIFont(name: "Montserrat-Regular", size: 35)
        self.PostLbl.font = UIFont(name: "Montserrat-Regular", size: 35)
        self.FavoriteLbl.font = UIFont(name: "Montserrat-Regular", size: 35)
        self.SectorLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.TotalEventLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.TotalPollsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.TotalBusinessLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.TotalGroupsLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.TotalPostLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        
        self.TotMarket.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.MarketPrcntg.font = UIFont(name: "Montserrat-Regular", size: 12)
        
        self.EventPollsPrcntggLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.EventprcntgLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.EventBusinessPrncntgLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.EventGropsPrcntgLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.EventPostPrcntgLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        
        self.Eventprcntg.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.EventPollsPrcntg.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.EventBusinessPrncntg.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.EventGropsPrcntg.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.EventPostPrcntg.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.IntrstLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.ReasonLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.AddressCityLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        
        
        setGradientBackground(for: vieweevent, colors: [
            #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.4862745098, alpha: 1),
            #colorLiteral(red: 0.7450980392, green: 0.8078431373, blue: 0.6117647059, alpha: 1),
            #colorLiteral(red: 0.8196078431, green: 0.8784313725, blue: 0.6862745098, alpha: 1)
            
        ])
        
        // Set gradient colors for viewpost
        setGradientBackground(for: viewpost, colors: [
            #colorLiteral(red: 0.5960784314, green: 0.337254902, blue: 0.2745098039, alpha: 1),
            #colorLiteral(red: 0.7843137255, green: 0.4901960784, blue: 0.4196078431, alpha: 1),
            #colorLiteral(red: 0.8862745098, green: 0.6039215686, blue: 0.5333333333, alpha: 1)
        ])
        setGradientBackground(for: viewePolls, colors: [
            #colorLiteral(red: 0.6862745098, green: 0.6156862745, blue: 0.4, alpha: 1),
            #colorLiteral(red: 0.8431372549, green: 0.768627451, blue: 0.5411764706, alpha: 1),
            #colorLiteral(red: 0.9215686275, green: 0.8549019608, blue: 0.6588235294, alpha: 1)
        ])
        setGradientBackground(for: viewBussines, colors: [
            #colorLiteral(red: 0.5098039216, green: 0.5843137255, blue: 0.568627451, alpha: 1),
            #colorLiteral(red: 0.6588235294, green: 0.7294117647, blue: 0.7137254902, alpha: 1),
            #colorLiteral(red: 0.7921568627, green: 0.8274509804, blue: 0.8235294118, alpha: 1)
        ])
        setGradientBackground(for: vieweGroup, colors: [
            #colorLiteral(red: 0.3098039216, green: 0.4745098039, blue: 0.3490196078, alpha: 1),
            #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.4862745098, alpha: 1),
            #colorLiteral(red: 0.6470588235, green: 0.8156862745, blue: 0.6901960784, alpha: 1)
        ])
        setGradientBackground(for: viewMarket, colors: [
            #colorLiteral(red: 0.5568627451, green: 0.5137254902, blue: 0.4352941176, alpha: 1),
            #colorLiteral(red: 0.6941176471, green: 0.6470588235, blue: 0.5647058824, alpha: 1),
            #colorLiteral(red: 0.8352941176, green: 0.7921568627, blue: 0.7176470588, alpha: 1)
        ])
        
        
    }
    
    // self.EmergencyLbl.text = self.profileData?.emer_phone
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        // viewNS.constant = self.viewintrest.intrinsicContentSize.height
        
        //  getCustomImage(imageDisplayName: NameLbl.text, imageView: profileImgView)
        
        //   self.NameLbl.font = UIFont(name: "Montserrat-SemiBold", size: 30)
        
        if let id = UserDefaults.standard.string(forKey: "userid"),
           let idCr = UserDefaults.standard.string(forKey: "idOther") {
            print("id: \(id), idCr: \(idCr)") // Debugging output
            
            if id == idCr {
                self.btnInfo.isHidden = false
                self.btnAdress.isHidden = false
                self.btnEmergency.isHidden = false
                
            } else {
                self.btnInfo.isHidden = true
                self.btnAdress.isHidden = true
                self.btnEmergency.isHidden = true
                
                
            }
        } else {
            print("UserDefaults values are nil") // Handle nil case
        }
        
        SVProgressHUD.show()
        callUserProfileWebService{ [self] in
            self.updateEventFill()
            SVProgressHUD.dismiss()
            
            self.NameLbl.text = "\(self.profileData?.firstname ?? "") \(self.profileData?.lastname ?? "")"
            
            
            //            self.NameLbl.text = self.profileData?.firstname
            //            self.SecLbl.text = self.profileData?.lastname
            self.SectorLbl.text = self.profileData?.neighborhood
            if let interests = self.profileData?.intersttype {
                // Split the string by comma and trim whitespace
                let interestArray = interests.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                
                // Create a bullet list
                let bulletList = interestArray.map { "• \($0)" }.joined(separator: "\n")
                
                // Set the label text
                self.IntrstLbl.text = bulletList
            } else {
                self.IntrstLbl.text = "No interests available."
            }
            
            
            self.MemberLbl.text = self.profileData?.createddate
            self.EmailLbl.text = self.profileData?.emailid
            self.MobileLbl.text = self.profileData?.phoneno
            self.EmergencyLbl.text = self.profileData?.emerPhone
            self.DobLbl.text = self.profileData?.dob
            self.GenderLbl.text = self.profileData?.gender
            self.ProfessioLbl.text = self.profileData?.nbrsType
            self.AddProofLbl.text = self.profileData?.uploadedDoc
            
            if let addLineOne = self.profileData?.addlineone,
               let addLineTwo = self.profileData?.addlinetwo,
               let address = self.profileData?.address,
               let neighborhood = self.profileData?.neighborhood {
                
                // Combine the keys into a single formatted string
                let combinedAddress = """
                \(addLineOne)
                \(addLineTwo)
                \(address)
                \(neighborhood)
                """
                
                // Update the label on the main thread
                DispatchQueue.main.async {
                    self.AddressCityLbl.numberOfLines = 0
                    self.AddressCityLbl.lineBreakMode = .byWordWrapping
                    // self.AddressCityLbl.textColor = .black
                    self.AddressCityLbl.backgroundColor = .clear
                    self.AddressCityLbl.text = combinedAddress
                    
                    // Debugging
                    print("Combined Address: \(combinedAddress)")
                    print("Label Frame: \(self.AddressCityLbl.frame)")
                }
            } else {
                DispatchQueue.main.async {
                    self.AddressCityLbl.text = "Address information is unavailable."
                }
            }
            
            
            
            
            if let interests = self.profileData?.reason {
                // Split the string by comma and trim whitespace
                let interestArray = interests.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                
                // Create a bullet list
                let bulletList = interestArray.map { "• \($0)" }.joined(separator: "\n")
                
                // Set the label text
                self.ReasonLbl.text = bulletList
            } else {
                self.ReasonLbl.text = "No interests available."
            }
            
            self.EventsLbl.text = self.profileData?.events
            self.PollLbl.text = self.profileData?.polls
            self.BusinessLbl.text = self.profileData?.business
            self.GroupLbl.text = self.profileData?.groups
            self.PostLbl.text = self.profileData?.posts
            self.FavoriteLbl.text = self.profileData?.market
            
            self.TotMarket.text = self.profileData?.totmarket
            self.MarketPrcntg.text = self.profileData?.marketper
            
            self.TotalEventLbl.text = self.profileData?.totevents
            self.TotalPollsLbl.text = self.profileData?.totpolls
            self.TotalBusinessLbl.text = self.profileData?.totbusiness
            self.TotalGroupsLbl.text = self.profileData?.totgroups
            self.TotalPostLbl.text = self.profileData?.totposts
            
            self.EventprcntgLbl.text =  self.profileData?.eventper
            self.EventPollsPrcntggLbl.text =  self.profileData?.pollper
            self.EventBusinessPrncntgLbl.text =  self.profileData?.businessper
            self.EventGropsPrcntgLbl.text =  self.profileData?.groupper
            self.EventPostPrcntgLbl.text =  self.profileData?.postper
            
            //  self.EventprcntgLbl.text =  "\(self.profileData?.eventper ?? 0 )%"
            
            let url = URL(string: (self.profileData?.userpic ?? ""))
            self.profileImgView.kf.indicatorType = .activity
            self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: ""))
            
            
            
        }
        
    }
    
    func updateEventFill() {
        // Update the event percentage view
        if let eventperString = profileData?.eventper,
           let eventPerDouble = Double(eventperString) {
            updateFill(for: viewefillEvent, withPercentage: CGFloat(eventPerDouble))
            EventprcntgLbl.text = "\(Int(eventPerDouble))%"
        } else {
            print("Invalid or missing eventper value. Using default value of 0%")
            updateFill(for: viewefillEvent, withPercentage: 0.0)
            EventprcntgLbl.text = "0%"
        }
        
        // Update the poll percentage view
        if let pollperString = profileData?.pollper,
           let pollPerDouble = Double(pollperString) {
            updateFill(for: viewefillPolls, withPercentage: CGFloat(pollPerDouble))
        } else {
            print("Invalid or missing pollper value. Using default value of 0%")
            updateFill(for: viewefillPolls, withPercentage: 0.0)
        }
        
        // Update the business percentage view
        if let businessperString = profileData?.businessper,
           let businessPerDouble = Double(businessperString) {
            updateFill(for: viewefillBusiness, withPercentage: CGFloat(businessPerDouble))
        } else {
            print("Invalid or missing businessper value. Using default value of 0%")
            updateFill(for: viewefillBusiness, withPercentage: 0.0)
        }
        
        if let groupsperString = profileData?.groupper,
           let groupPerDouble = Double(groupsperString) {
            updateFill(for: viewefillGroup, withPercentage: CGFloat(groupPerDouble))
        } else {
            print("Invalid or missing businessper value. Using default value of 0%")
            updateFill(for: viewefillGroup, withPercentage: 0.0)
        }
        
        if let postperString = profileData?.postper,
           let postPerDouble = Double(postperString) {
            updateFill(for: viewefillPost, withPercentage: CGFloat(postPerDouble))
        } else {
            print("Invalid or missing businessper value. Using default value of 0%")
            updateFill(for: viewefillPost, withPercentage: 0.0)
        }
        
        if let MarketperString = profileData?.marketper,
           let MarketPerDouble = Double(MarketperString) {
            updateFill(for: viewefillMarket, withPercentage: CGFloat(MarketPerDouble))
        } else {
            print("Invalid or missing businessper value. Using default value of 0%")
            updateFill(for: viewefillMarket, withPercentage: 0.0)
        }
    }
    
    // Helper function to update the fill view based on a given percentage
    private func updateFill(for view: UIView, withPercentage percentage: CGFloat) {
        // Calculate the height for the fill view based on the percentage
        let fillHeight = view.frame.height * (percentage / 100.0)
        
        // Create the fill view for the filled portion (white)
        let fillView = UIView(frame: CGRect(x: 0, y: view.frame.height - fillHeight, width: view.frame.width, height: fillHeight))
        fillView.backgroundColor = .gray  // Filled area color
        
        // Set the background color of the unfilled portion to gray
        view.backgroundColor = .white
        
        // Remove any existing subviews in the view and add the new fill view
        view.subviews.forEach { $0.removeFromSuperview() }
        view.addSubview(fillView)
    }
    
    
    fileprivate func rotateSlider() {
        if isAscending {
            progressView.transform = CGAffineTransform(rotationAngle: .pi * -0.5)
        } else {
            progressView.transform = CGAffineTransform(rotationAngle: .pi * 0.5)
        }
    }
    
    func getCustomImage(imageDisplayName: String?, imageView: UIImageView!){
        if let name = imageDisplayName, !name.isEmpty {
            imageView.setImage(string:name, color: UIColor.colorHash(name: name), circular: isCircularWithStroke, stroke: isCircularWithStroke)
        }else{
            imageView.setImage(string:"Display Picture", color: UIColor.colorHash(name: "Display Picture"), circular: isCircularWithStroke, stroke: isCircularWithStroke)
        }
    }
    
    private func setGradientBackground(for view: UIView, colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Start from top left
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)   // End at bottom right
        gradientLayer.frame = view.bounds // Fill the view's bounds
        
        // Make sure to resize the gradient layer when the view's bounds change
        //   gradientLayer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add the gradient layer as a sublayer
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func btnPost(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfilePostViewController") as? MyProfilePostViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func btnGroup(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController") as? GroupsViewController else {return}
                vc.sourceViewController = "MyProfile"
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnBusiness(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BussinesViewController") as? BussinesViewController else {return}
        vc.sourceViewController = "MyProfile"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnPolls(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PollsViewController") as? PollsViewController else {return}
        vc.sourceViewController = "MyProfile"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func btnOpenGallery(_ : UIButton){
        
        openCameraGallery()
        
    }
    
    @IBAction func btnDetails(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileEditViewController") as? MyProfileEditViewController else {return}
        // ✅ Data pass karein
        vc.profileData = self.profileData
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnEditProfile(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else {return}
        //     vc.imgProfile = self.profileData?.userpic
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnEvent(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsViewController") as? EventsViewController else {return}
        vc.sourceViewController = "MyProfile"
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnMarket(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyitemsMarketViewController") as? MyitemsMarketViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnFullImage(_ : UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowFullImageViewController") as? ShowFullImageViewController else {return}
        vc.userPicURL = self.profileData?.userpic
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "idOther")
        var dictParams: [String: Any] = [:]
        
        // Determine parameters based on the source view controller
        if sourceViewController == "MessageViewController" {
            dictParams = [
                "userid": Newid ?? "",
                "loggeduser": id ?? ""
            ]
        } else if sourceViewController == "HomeViewController" {
            dictParams = [
                "userid": id ?? "",
                "loggeduser": id ?? ""
            ]
        } else {
            // Default behavior for other sources
            dictParams = [
                "userid": Oid ?? "",
                "loggeduser": id ?? ""
            ]
        }
        
        // Call the web service
        WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { data in
            self.profileData = data
            
            // Save data to UserDefaults based on source
            if self.sourceViewController == "MessageViewController" {
                UserDefaults.standard.set(self.profileData?.id, forKey: "idOther")
            } else {
                UserDefaults.standard.set(self.profileData?.emerPhone, forKey: "emer_phone")
                UserDefaults.standard.set(self.profileData?.userpic, forKey: "profileImage")
            }
            
            completionClosure()
        }
    }
    
    
}




enum MediaType:Int{
    case image = 0, video = 1, none = 2
    init(rawValue: Int){
        switch rawValue{
        case 0: self = .image
        case 1: self = .video
        default: self = .none
        }
    }
    
    var CameraMediaType:[String]{
        switch rawValue{
        case 0: return [(kUTTypeImage as String)]
        case 1: return [(kUTTypeMovie as String)]
        default: return [(kUTTypeImage as String),(kUTTypeMovie as String)]
            
        }
    }
}

@available(iOS 16.0, *)
extension MyProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        picker.dismiss(animated: true, completion: nil)
        showCrop(image: image)
    }
    
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Continue"
        vc.cancelButtonTitle = "Quit"
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func deletePhoto() {
        // Get the user's name from UserDefaults or a placeholder
        let userName = UserDefaults.standard.string(forKey: "username") ?? "User"
        let firstLetter = String(userName.prefix(1)).uppercased()
        
        // Create a UILabel to show the first letter
        let label = UILabel()
        label.frame = profileImgView.bounds
        label.text = firstLetter
        label.textColor = .white
        label.backgroundColor = .gray // Set a default background color
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: profileImgView.bounds.height / 2)
        label.clipsToBounds = true
        label.layer.cornerRadius = profileImgView.bounds.height / 2
        
        // Remove any existing subviews and add the label
        profileImgView.subviews.forEach { $0.removeFromSuperview() }
        profileImgView.addSubview(label)
        
        // Call the API to update the server with a deleted photo
        deletePhotoAndUpdateServer {
            print("Profile updated with the first letter of the name.")
        }
    }
    
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        handleSelectedImage(image)
    }
    
    func openCameraGallery() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                print("Camera not available")
                return
            }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                print("Photo library not available")
                return
            }
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }))
        
        // Add the "Delete Photo" action
        alert.addAction(UIAlertAction(title: "Delete Photo", style: .destructive, handler: { _ in
            self.deletePhoto() // Call deletePhoto function to update profileImgView
            
            // Send the API call to upload the change with a nil image
            self.callProfileUploadWebService {
                print("Profile photo deleted and updated on server.")
                self.callUserProfileWebService{ [self] in
                    let url = URL(string: (self.profileData?.userpic ?? ""))
                    self.profileImgView.kf.indicatorType = .activity
                    self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: ""))
                }
            }
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func handleSelectedImage(_ image: UIImage) {
        // Compress the image
        guard let compressedImage = image.jpegData(compressionQuality: 0.5).flatMap(UIImage.init(data:)) else {
            print("Failed to compress image")
            return
        }
        
        // Set the profile image view
        profileImgView.image = compressedImage
        
        // Prepare image for API upload
        imageArray = [compressedImage]
        
        // Call API to upload the image
        callProfileUploadWebService {
            print("Profile photo updated successfully.")
            self.callUserProfileWebService{ [self] in
                let url = URL(string: (self.profileData?.userpic ?? ""))
                self.profileImgView.kf.indicatorType = .activity
                self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: ""))
            }
            
        }
        
    }
    
    func callProfileUploadWebService(_ completionClosure: @escaping () -> ()) {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        
        // Base parameters
        var params: [String: Any] = ["userid": userId]
        
        if imageArray.isEmpty {
            // If no image, send a predefined value for the "userpic" parameter
            params["userpic"] = "deleted" // Use the server-defined value for deletion
            AF.request(kBASEURL + WebServiceName.kUploadPhoto, method: .post, parameters: params, encoding: URLEncoding.default).response { response in
                if let error = response.error {
                    print("Error in upload: \(error.localizedDescription)")
                } else {
                    do {
                        if let jsonData = response.data {
                            let parsedData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                            print("Response: \(String(describing: parsedData))")
                            if let status = parsedData?["status"] as? String, status == "success" {
                                print("Profile photo successfully deleted on server.")
                            } else {
                                print("Failed to delete profile photo: \(parsedData?["message"] ?? "Unknown error")")
                            }
                            completionClosure()
                        }
                    } catch {
                        print("Error parsing response: \(error.localizedDescription)")
                    }
                }
            }
        }
        else {
            // If there's an image, call the upload function with the image array
            callsendImageAPI(param: params, arrImage: imageArray, imageKey: "userpic", URlName: kBASEURL + WebServiceName.kUploadPhoto) {
                completionClosure()
            }
        }
    }
    
    func deletePhotoAndUpdateServer(completion: @escaping () -> Void) {
        // Clear the image array to indicate deletion
        imageArray.removeAll()
        
        // Call the upload service with the "deleted" userpic parameter
        callProfileUploadWebService {
            print("Photo deletion handled successfully.")
            completion()
        }
    }
    
    
    func callsendImageAPI(param: [String: Any], arrImage: [UIImage], imageKey: String, URlName: String, withblock: @escaping () -> Void) {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            // Append all parameters
            for (key, value) in param {
                if let value = value as? String {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
            }
            
            // Append images
            for img in arrImage {
                if let imgData = img.jpegData(compressionQuality: 0.1) {
                    let fileName = "\(NSDate().timeIntervalSince1970.rounded()).jpeg"
                    multipartFormData.append(imgData, withName: imageKey, fileName: fileName, mimeType: "image/jpeg")
                }
            }
        }, to: URlName, method: .post, headers: headers).response { response in
            if let error = response.error {
                print("Error in upload: \(error.localizedDescription)")
            } else {
                do {
                    if let jsonData = response.data {
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                        print("Response: \(String(describing: parsedData))")
                        withblock()
                    }
                } catch {
                    print("Error parsing response: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
