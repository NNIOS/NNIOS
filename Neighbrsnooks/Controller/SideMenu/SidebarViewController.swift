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
    let menuItems = ["My Profile", "My neighbourhood", "Business", "Event", "Group", "Poll", "Post", "Public Agency directory", "Share app", "Setting", "Contact us"]
    let menuItemImages = ["person", "location 1", "Market", "calendar", "person.2", "icons8-poll-24", "envelope", "bag", "arrowshape.turn.up.right", "gearshape", "phone"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblUserName.text = "\(self.profileData?.firstname ?? "") \(self.profileData?.lastname ?? "")"
        let url = URL(string: (self.profileData?.userpic ?? ""))
        self.userProfileImg.kf.indicatorType = .activity
        self.userProfileImg.kf.setImage(with:url ,placeholder: UIImage(named: "profile 1"))
        self.lblNeighbourhood.text = self.profileData?.neighborhood
        userProfileImg.layer.cornerRadius = userProfileImg.frame.size.width / 2
        userProfileImg.clipsToBounds = true
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
        // Tap outside to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            lblVersionApp.text = "V\(version) @Neighbrsnook"
        }
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
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController else {
                    print("❌ MyProfileViewController not found")
                    return
                }
                vc.sourceViewController = "HomeViewController"
                vc.headingTitle = "My Profile"
                self.pushTo(vc)
                
            case "My neighbourhood":
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
                vc.selectedNeighborhoodId = self.selectedNeighborhoodId
                vc.sourceViewController = "Neighbourhood"
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
                
            case "Public Agency directory":
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PublicAgencyViewController") as? PublicAgencyViewController else {
                    print("❌ PublicAgencyViewController not found")
                    return
                }
                self.pushTo(vc)
                
            case "Share app":
                let appName = "NeighboursNook"
                let appDescription = "NeighbrsNook is a hyperlocal social networking service. Connect with your neighborhood today!"
                let appLink = "https://testflight.apple.com/join/1G74jNEC"
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
                
            case "Contact us":
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
