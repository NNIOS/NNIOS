//
//  SidebarViewController.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 12/05/25.
//

import UIKit
@available(iOS 16.0, *)

class SidebarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lblNeighbourhood: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var sideMenuTblView: UITableView!
    @IBOutlet weak var sideMenuContainer: UIView! // This is the view with Tag 100 in storyboard
    @IBOutlet weak var lblVersionApp: UILabel!
    
    var homeData: HomeAllModel?
    var profileData : ProfileModel?
    var selectedNeighborhoodId: String?
    
    let menuItems = ["My Profile", "My Neighbourhood", "Business", "Event", "Group", "Poll", "Post", "Public Agency Directory", "Refer", "Share App", "Setting", "Contact Us"]

    let menuItemImages = ["person", "location 1", "Market", "calendar", "person.2", "icons8-poll-24", "envelope", "bag", "arrowshape.turn.up.right", "arrowshape.turn.up.right", "gearshape", "phone"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(profileData)
        userProfileImg.layer.cornerRadius = userProfileImg.frame.height/2
        userProfileImg.clipsToBounds = true
        self.view.layoutIfNeeded()
        self.lblUserName.text = self.profileData?.username
            let userName = self.profileData?.username ?? ""
            let firstLetter = String(userName.prefix(1)).uppercased()
            
            if let imageUrlString = self.profileData?.userpic,
               let url = URL(string: imageUrlString),
               !imageUrlString.trimmingCharacters(in: .whitespaces).isEmpty {
                
                self.userProfileImg.kf.indicatorType = .activity
                self.userProfileImg.kf.setImage(with: url, placeholder: UIImage(named: "profile 1")) { result in
                    switch result {
                    case .success(_):
                        self.userProfileImg.backgroundColor = .clear // Image load ho gaya toh color reset
                    case .failure(_):
                        self.setInitialLetterProfile(firstLetter)
                    }
                }
            } else {
                self.setInitialLetterProfile(firstLetter)
            }
       
        self.lblNeighbourhood.text = self.profileData?.neighborhood ?? ""
        // Label ke text ko set kar rahe hain
        self.lblNeighbourhood.text = self.profileData?.neighborhood ?? ""

        if let neighborhood = self.profileData?.neighborhood {
            UserDefaults.standard.set(neighborhood, forKey: "savedNeighborhood")
        }

        if let nbdId = self.profileData?.nbdId {
            UserDefaults.standard.set(nbdId, forKey: "savedNbdId")
        }

        UserDefaults.standard.synchronize()


        
        let desiredWidth: CGFloat = 280
        
        if sideMenuContainer.frame.width != desiredWidth {
            var frame = sideMenuContainer.frame
            frame.size.width = desiredWidth
            sideMenuContainer.frame = frame
        }
        sideMenuTblView.delegate = self
        sideMenuTblView.dataSource = self
        // Ensure sideMenuContainer starts off-screen
        sideMenuContainer.transform = CGAffineTransform(translationX: -sideMenuContainer.frame.width, y: 0)
        // Animate it into place
        UIView.animate(withDuration: 0.3) {
            self.sideMenuContainer.transform = .identity
        }
        
        let professionLabelTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
        lblUserName.isUserInteractionEnabled = true
        lblUserName.addGestureRecognizer(professionLabelTap)
        // Tap outside to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            lblVersionApp.text = "V\(version) @Neighbrsnook"
        }
    }
    
    
    
    func setInitialLetterProfile(_ letter: String) {
        // 1️⃣ First letter label ya imageView ke andar set karo
        self.userProfileImg.image = nil // Purana image clear karo
        
        // 2️⃣ Background color set karo based on letter
        self.userProfileImg.backgroundColor = UIColor.colorForAlphabet(letter)
        
        // 3️⃣ Initial letter ko show karne ke liye ek UILabel lagao
        let initialLabel = UILabel(frame: self.userProfileImg.bounds)
        initialLabel.text = letter
        initialLabel.textColor = .white
        initialLabel.textAlignment = .center
        initialLabel.font = UIFont.boldSystemFont(ofSize: self.userProfileImg.bounds.width / 2)
        self.userProfileImg.layer.cornerRadius = self.userProfileImg.bounds.width / 2
        self.userProfileImg.clipsToBounds = true
        // Pehle se added subviews remove karo
        self.userProfileImg.subviews.forEach { $0.removeFromSuperview() }
        
        self.userProfileImg.addSubview(initialLabel)
    }
    
    
    @objc func professionLabelTapped() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else { return }
        vc.sourceViewController = "HomeViewController"
        vc.headingTitle = "My Profile"
        self.pushTo(vc)
        print("Abdul Aleem Usmani")
    }
    @IBAction func actionSidemenuHide(_ sender: Any) {
        dismissMenu()
    }
    
    // Add your updated method here 👇
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenuContainer.transform = CGAffineTransform(translationX: -self.sideMenuContainer.frame.width, y: 0)
            self.view.backgroundColor = UIColor.clear
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let desiredWidth: CGFloat = 280
        var frame = sideMenuContainer.frame
        frame.size.width = desiredWidth
        sideMenuContainer.frame = frame
        UIView.animate(withDuration: 0.3) {
            self.sideMenuContainer.transform = .identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SidebarTableViewCell", for: indexPath) as! SidebarTableViewCell
        // Set title
        cell.lblItmeName.text = menuItems[indexPath.row]
        // Get image name
        let imageName = menuItemImages[indexPath.row]
        // Try to use SF Symbol first, if it fails, use image from Assets
        if let systemImage = UIImage(systemName: imageName) {
            cell.imgItme.image = systemImage
        } else {
            cell.imgItme.image = UIImage(named: imageName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissMenu()
        let selectedItem = menuItems[indexPath.row]
        // Dispatch to give time for menu dismiss animation
        DispatchQueue.main.async{
            switch selectedItem {
            case "My Profile":
                let id = UserDefaults.standard.string(forKey: "userid")
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {
                    print("❌ MyProfileViewController not found")
                    return
                }
                vc.sourceViewController = "MyProfile"
                vc.headingTitle = "My Profile"
                vc.Oid = id
                self.pushTo(vc)
                
            case "My Neighbourhood":
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NeighbourhoodViewController") as? NeighbourhoodViewController else {
                    print("❌ NeighbourhoodViewController not found")
                    return
                }
                let selectedNeighbourId = self.profileData?.nbdId ?? ""
                vc.idNeighbour = selectedNeighbourId
                // Save to UserDefaults
                UserDefaults.standard.set(selectedNeighbourId, forKey: "neighbrhood")
                self.pushTo(vc)
                
            case "Business":
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BussinesViewController") as? BussinesViewController else {
                    print("❌ BussinesViewController not found")
                    return
                }
//                vc.selectedNeighborhoodId = self.selectedNeighborhoodId
//                vc.sourceViewController = "Neighbourhood"
//                vc.sourceViewController = "MyProfile"
                vc.selectedNeighborhoodId = self.selectedNeighborhoodId
                vc.sourceViewController = "Neighbourhood"
                vc.backAction = "homeBack"
                
                self.pushTo(vc)
                
            case "Event":
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventsViewController") as? EventsViewController else {
                    print("❌ EventsViewController not found")
                    return
                }
                vc.sourceViewController = "Menu"
                self.pushTo(vc)
                
            case "Group":
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GroupsViewController") as? GroupsViewController else {
                    print("❌ GroupsViewController not found")
                    return
                }
                vc.sourceViewController = "Menu"
                self.pushTo(vc)
            case "Poll":
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PollsViewController") as? PollsViewController else {
                    print("❌ PollsViewController not found")
                    return
                }
                vc.sourceViewController = "Menu"
                self.pushTo(vc)
                
                
            case "Post":
                let vc = MennuPostViewController()
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MennuPostViewController") as? MennuPostViewController else {
                    print("❌ MennuPostViewController not found")
                    return
                }
                self.pushTo(vc)
                
            case "Public Agency Directory":
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PublicAgencyViewController") as? PublicAgencyViewController else {
                    print("❌ PublicAgencyViewController not found")
                    return
                }
                self.pushTo(vc)
                
            case "Refer":
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReferViewController") as? ReferViewController else {
                    print("❌ ReferViewController not found")
                    return
                }
                self.pushTo(vc)

                
            case "Share App":
                let appName = "NeighboursNook"
                let appDescription = "NeighbrsNook is a hyperlocal social networking service. Connect with your neighborhood today!"
                let appLink = "https://apps.apple.com/in/app/neighbrsnook/id6746369263"
                let shareText = "\(appDescription) \nDownload now: \(appLink)"
                let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
                
            case "Setting":
                let vc = SettingNewViewController()
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingNewViewController") as? SettingNewViewController else {
                    print("❌ SettingNewViewController not found")
                    return
                }
                self.pushTo(vc)
                
            case "Contact Us":
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController else {
                    print("❌ ContactUsViewController not found")
                    return
                }
                self.pushTo(vc)
                
            default:
                break
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // ya jo bhi constant height aapko chahiye
    }
    
    
    
    //MARK: - Helper method to push view controller safely
    
    func pushTo(_ vc: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootNav = window.rootViewController as? UINavigationController else {
            print("❌ NavigationController not found")
            return
        }
        print("✅ Found rootNav: \(rootNav)")
        self.dismiss(animated: false) {
            rootNav.pushViewController(vc, animated: true)
        }
    }
    
}

// Gesture to detect taps outside menu
@available(iOS 16.0, *)
// Gesture to detect taps outside menu
extension SidebarViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: view)
        // Only dismiss if the tap is outside the sideMenuContainer
        return !sideMenuContainer.frame.contains(touchPoint)
    }
}
