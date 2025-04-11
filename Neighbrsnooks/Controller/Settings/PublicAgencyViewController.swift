//
//  PublicAgencyViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 03/10/24.
//

import UIKit
import GoogleMaps
@available(iOS 16.0, *)
class PublicAgencyViewController: BaseViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tableviewMembers: UITableView!
    
    @IBOutlet weak var btnHospital: UIButton!
    @IBOutlet weak var btnAmbu: UIButton!
    @IBOutlet weak var btnPolice: UIButton!
    @IBOutlet weak var btnFire: UIButton!
    @IBOutlet weak var lblHospital: UILabel!
    @IBOutlet weak var lblAmbu: UILabel!
    @IBOutlet weak var lblPolice: UILabel!
    @IBOutlet weak var lblFire: UILabel!
    
    @IBOutlet weak var ViewHospital: UIView!
    @IBOutlet weak var ViewAmbu: UIView!
    @IBOutlet weak var ViewPolice: UIView!
    @IBOutlet weak var ViewFire: UIView!
    @IBOutlet weak var SectorLbl: UILabel!
    
    @IBOutlet weak var AmbuImgView : UIImageView!
    @IBOutlet weak var HospiImgView : UIImageView!
    @IBOutlet weak var PoliceImgView : UIImageView!
    @IBOutlet weak var FireImgView : UIImageView!
    var selection = 1
    var PublicDirecData : PublicDirectoryModel?
    var profileData : ProfileModel?
    var expandedIndexPath: IndexPath? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.lblHospital.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.lblAmbu.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.lblPolice.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.lblFire.font = UIFont(name: "Montserrat-Regular", size: 12)
    //    SectorLbl.text = UserDefaults.standard.object(forKey: "MyNeighbourhood") as? String
        
        if let savedNeighborhood = UserDefaults.standard.string(forKey: "myNeighbhrhhod") {
                   // Set the label's text to the saved neighborhood
            SectorLbl.text = savedNeighborhood
               } else {
                   // If nothing is saved, set a default text
                   SectorLbl.text = "No neighborhood saved"
               }
        ViewHospital.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblHospital.textColor =  .white
        ViewAmbu.backgroundColor = .white
        ViewPolice.backgroundColor = .white
        ViewFire.backgroundColor = .white
        lblAmbu.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblPolice.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblFire.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        
        HospiImgView.image = HospiImgView.image?.withRenderingMode(.alwaysTemplate)
        HospiImgView.tintColor = .white
        if let savedNeighborhood = UserDefaults.standard.string(forKey: "myNeighbhrhhod") {
                   // Set the label's text to the saved neighborhood
            SectorLbl.text = savedNeighborhood
               } else {
                   // If nothing is saved, set a default text
                   SectorLbl.text = "No neighborhood saved"
               }
        calldirectoryWebService{
           
            self.tableviewMembers.reloadData()
         
        }
        // Do any additional setup after loading the view.
    }
    
    func configureMapButtonAction(_ button: UIButton, lat: Double, long: Double) {
           button.addTarget(self, action: #selector(openInGoogleMaps(_:)), for: .touchUpInside)
           button.accessibilityValue = "\(lat),\(long)"
       }

       // Open location in Google Maps
       @objc func openInGoogleMaps(_ sender: UIButton) {
           guard let latLong = sender.accessibilityValue else { return }
           let urlString = "https://www.google.com/maps?q=\(latLong)"
           if let url = URL(string: urlString) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
       }
    
   
    
    
    func setdata(){
        
       
        SectorLbl.text = UserDefaults.standard.object(forKey: "neighbrshood") as? String
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // SVProgressHUD.show()
        lblHospital.text = "Hospital"
        lblAmbu.text = "Ambulance"
        setdata()
        calldirectoryWebService{
           
            self.tableviewMembers.reloadData()
            
            
            // Do any additional setup after loading the view.
        }
        
        callUserProfileWebService{ [self] in
           
           
            self.SectorLbl.text = self.profileData?.neighborhood
           
           
        }
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnHospi(_ sender: UIButton) {
        selection = 1
       
        ViewHospital.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblHospital.textColor =  .white
        ViewAmbu.backgroundColor = .white
        ViewPolice.backgroundColor = .white
        ViewFire.backgroundColor = .white
        lblAmbu.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblPolice.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblFire.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        HospiImgView.image = HospiImgView.image?.withRenderingMode(.alwaysTemplate)
        HospiImgView.tintColor = .white
        
        AmbuImgView.image = AmbuImgView.image?.withRenderingMode(.alwaysTemplate)
        AmbuImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        FireImgView.image = FireImgView.image?.withRenderingMode(.alwaysTemplate)
        FireImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        PoliceImgView.image = PoliceImgView.image?.withRenderingMode(.alwaysTemplate)
        PoliceImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)

        calldirectoryWebService{
            self.tableviewMembers.reloadData()
            
        }
        
    }
    
    @IBAction func btnAmbu(_ sender: UIButton) {
        selection = 2
       
        ViewHospital.backgroundColor = .white
        lblHospital.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        ViewAmbu.backgroundColor =  #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        ViewPolice.backgroundColor = .white
        ViewFire.backgroundColor = .white
        lblAmbu.textColor =   .white
        lblPolice.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblFire.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        AmbuImgView.image = AmbuImgView.image?.withRenderingMode(.alwaysTemplate)
           AmbuImgView.tintColor = .white
        
        HospiImgView.image = HospiImgView.image?.withRenderingMode(.alwaysTemplate)
        HospiImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        FireImgView.image = FireImgView.image?.withRenderingMode(.alwaysTemplate)
        FireImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        PoliceImgView.image = PoliceImgView.image?.withRenderingMode(.alwaysTemplate)
        PoliceImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        
        calldirectoryWebService{
            self.tableviewMembers.reloadData()
            
        }
        
    }
    
    @IBAction func btnPolice(_ sender: UIButton) {
        selection = 3
       
        ViewHospital.backgroundColor = .white
        lblHospital.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        ViewAmbu.backgroundColor =  .white
        ViewPolice.backgroundColor =  #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        ViewFire.backgroundColor = .white
        lblAmbu.textColor =    #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblPolice.textColor =   .white
        lblFire.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        
        PoliceImgView.image = PoliceImgView.image?.withRenderingMode(.alwaysTemplate)
        PoliceImgView.tintColor = .white
        
        
        AmbuImgView.image = AmbuImgView.image?.withRenderingMode(.alwaysTemplate)
        AmbuImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        FireImgView.image = FireImgView.image?.withRenderingMode(.alwaysTemplate)
        FireImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        HospiImgView.image = HospiImgView.image?.withRenderingMode(.alwaysTemplate)
        HospiImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)

        calldirectoryWebService{
            self.tableviewMembers.reloadData()
            
        }
        
    }
    
    @IBAction func btnFiore(_ sender: UIButton) {
        selection = 4
       
        ViewHospital.backgroundColor = .white
        lblHospital.textColor =   #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        ViewAmbu.backgroundColor =  .white
        ViewPolice.backgroundColor = .white
        ViewFire.backgroundColor =  #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblAmbu.textColor =    #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblPolice.textColor =  #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        lblFire.textColor =   .white
        
        FireImgView.image = FireImgView.image?.withRenderingMode(.alwaysTemplate)
        FireImgView.tintColor = .white
        
        
        AmbuImgView.image = AmbuImgView.image?.withRenderingMode(.alwaysTemplate)
        AmbuImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        PoliceImgView.image = PoliceImgView.image?.withRenderingMode(.alwaysTemplate)
        PoliceImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
        HospiImgView.image = HospiImgView.image?.withRenderingMode(.alwaysTemplate)
        HospiImgView.tintColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)

        
        calldirectoryWebService{
            self.tableviewMembers.reloadData()
            
        }
        
    }
    
    func callUserProfileWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
          let dictParams: Dictionary<String, Any> = [
                                                    
                                                    "userid":id ?? "",
                                                   
                                                   
                                                                        ]
          WebService.sharedInstance.callUserProfileWebService(withParams: dictParams) { data in
            self.profileData = data
              UserDefaults.standard.set(self.profileData?.emerPhone, forKey: "emer_phone")
              UserDefaults.standard.set(self.profileData?.userpic, forKey: "profileImage")
            //  UserDefaults.standard.set(self.profileData?.UserName, forKey: "userName")
//              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
             // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
             // UserDefaults.standard.set(self.MoreData?.data.profile, forKey: "profileImage")

            completionClosure()
          }
        }

}
@available(iOS 16.0, *)
extension PublicAgencyViewController: UITableViewDataSource, UITableViewDelegate {
    
    @objc func dialNumber(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text, !number.isEmpty else { return }

        if let phoneCallURL = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(phoneCallURL) {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
        } else {
            // Handle the case where the device cannot make a call
            print("Unable to make a call on this device.")
        }
    }

   

    
    // Add the selection variable to track which type to display
    var filteredData: [PublicDirecData] {
        switch selection {
        case 1:
            return PublicDirecData?.listdata?.filter({ $0.type == "Hospital" }) ?? []
        case 2:
            return PublicDirecData?.listdata?.filter({ $0.type == "Ambulance" }) ?? []
        case 3:
            return PublicDirecData?.listdata?.filter({ $0.type == "Police Station" }) ?? []
        case 4:
            return PublicDirecData?.listdata?.filter({ $0.type == "Fire Brigade" }) ?? []
        default:
            return []
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // We only need one section based on selection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = filteredData[indexPath.row]
        let cellHeight: CGFloat = (expandedIndexPath == indexPath) ? 290 : 70
        let configureButtonAction: (UIButton, String) -> Void = { button, number in
               button.setTitle(number, for: .normal)
               button.addTarget(self, action: #selector(self.dialNumber(_:)), for: .touchUpInside)
               button.tag = Int(number) ?? 0 // Optionally store the number as a tag or use another method to store it
           }
        
        func dialNumber(_ sender: UIButton) {
            guard let number = sender.titleLabel?.text, !number.isEmpty else { return }

            if let phoneCallURL = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(phoneCallURL) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                // Handle the case where the device cannot make a call
                print("Unable to make a call on this device.")
            }
        }
        
       


        switch selection {
        case 1: // Hospital section
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicDirectoryTableViewCell", for: indexPath) as! PublicDirectoryTableViewCell
            cell.EventLbl.text = data.name
            cell.AddLbl.text = data.address
            cell.Number1Lbl.text = data.number1
            cell.viewLine.isHidden = expandedIndexPath != indexPath
            if let number2 = data.number2, !number2.isEmpty {
                   cell.Number2View.isHidden = false
               } else {
                   cell.Number2View.isHidden = true
                   cell.Number2Lbl.isHidden = true
               }
            cell.WebLbl.text = data.website
            configureButtonAction(cell.Number1Btn, data.number1 ?? "")
            configureButtonAction(cell.Number2Btn, data.number2 ?? "")
            cell.EventLbl.font = UIFont(name: "Montserrat-SemiBold", size: 16)
            
            // Safely unwrap and convert lat and long to Double
            if let latString = data.lat, let longString = data.long,
               let latitude = Double(latString), let longitude = Double(longString) {
                configureMapButtonAction(cell.MapButton, lat: latitude, long: longitude)
            } else {
                print("Invalid latitude or longitude for data: \(data)")
            }
            
           
            
            // Add tap gesture to WebLbl to open the website
//                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite(_:)))
//                cell.WebLbl.isUserInteractionEnabled = true // Enable user interaction for the label
//                cell.WebLbl.addGestureRecognizer(tapGesture)
//                cell.WebLbl.tag = indexPath.row // Set tag
            
            // Add tap gesture to WebLbl to open the website
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite(_:)))
            cell.WebLbl.isUserInteractionEnabled = true // Enable user interaction for the label
            cell.WebLbl.addGestureRecognizer(tapGesture)

            // Store the website URL in gesture recognizer's `accessibilityLabel`
            cell.WebLbl.accessibilityLabel = data.website

            
            let tapNewGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
                cell.addGestureRecognizer(tapNewGesture)
                cell.tag = indexPath.row // Store indexPath in the cell's tag
            
            if expandedIndexPath == indexPath {
                  cell.arrowImageView.image = UIImage(named: "upward-arrow") // Show expanded arrow
              } else {
                  cell.arrowImageView.image = UIImage(named: "downward-arrow") // Show collapsed arrow
              }

            return cell
           


        case 2: // Ambulance section
            let cell = tableView.dequeueReusableCell(withIdentifier: "AmbulanceTableViewCell", for: indexPath) as! AmbulanceTableViewCell
            cell.EventLbl.text = data.name
            cell.AddLbl.text = data.address
            cell.Number1Lbl.text = data.number1
            cell.Number2Lbl.text = data.number2
            cell.viewLine.isHidden = expandedIndexPath != indexPath
            
            if let number2 = data.number2, !number2.isEmpty {
                   cell.Number2View.isHidden = false
               } else {
                   cell.Number2View.isHidden = true
                   cell.Number2Lbl.isHidden = true
               }
            
            cell.WebLbl.text = data.website
            configureButtonAction(cell.Number1Btn, data.number1 ?? "")
            configureButtonAction(cell.Number2Btn, data.number2 ?? "")
            cell.EventLbl.font = UIFont(name: "Montserrat-SemiBold", size: 16)
            if let latString = data.lat, let longString = data.long,
               let latitude = Double(latString), let longitude = Double(longString) {
                configureMapButtonAction(cell.MapButton, lat: latitude, long: longitude)
            } else {
                print("Invalid latitude or longitude for data: \(data)")
            }
            
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite(_:)))
//            cell.WebLbl.isUserInteractionEnabled = true // Enable user interaction for the label
//            cell.WebLbl.addGestureRecognizer(tapGesture)
//            cell.WebLbl.tag = indexPath.row // Set tag
            
            // Add tap gesture to WebLbl to open the website
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite(_:)))
            cell.WebLbl.isUserInteractionEnabled = true // Enable user interaction for the label
            cell.WebLbl.addGestureRecognizer(tapGesture)

            // Store the website URL in gesture recognizer's `accessibilityLabel`
            cell.WebLbl.accessibilityLabel = data.website

            
            let tapNewGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
                cell.addGestureRecognizer(tapNewGesture)
                cell.tag = indexPath.row // Store indexPath in the cell's tag
            
            // Set arrow image based on expansion state
               if expandedIndexPath == indexPath {
                   cell.arrowImageView.image = UIImage(named: "upward-arrow") // Show expanded arrow
               } else {
                   cell.arrowImageView.image = UIImage(named: "downward-arrow") // Show collapsed arrow
               }
            
            return cell
        case 3: // Police Station section
            let cell = tableView.dequeueReusableCell(withIdentifier: "PoliceTableViewCell", for: indexPath) as! PoliceTableViewCell
            cell.EventLbl.text = data.name
            cell.AddLbl.text = data.address
            cell.Number1Lbl.text = data.number1
            cell.Number2Lbl.text = data.number2
            cell.viewLine.isHidden = expandedIndexPath != indexPath
            
            if let number2 = data.number2, !number2.isEmpty {
                   cell.Number2View.isHidden = false
               } else {
                   cell.Number2View.isHidden = true
                   cell.Number2Lbl.isHidden = true
               }
            
            cell.WebLbl.text = data.website
            configureButtonAction(cell.Number1Btn, data.number1 ?? "")
            configureButtonAction(cell.Number2Btn, data.number2 ?? "")
            cell.EventLbl.font = UIFont(name: "Montserrat-SemiBold", size: 16)
            if let latString = data.lat, let longString = data.long,
               let latitude = Double(latString), let longitude = Double(longString) {
                configureMapButtonAction(cell.MapButton, lat: latitude, long: longitude)
            } else {
                print("Invalid latitude or longitude for data: \(data)")
            }
            
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite(_:)))
//            cell.WebLbl.isUserInteractionEnabled = true // Enable user interaction for the label
//            cell.WebLbl.addGestureRecognizer(tapGesture)
//            cell.WebLbl.tag = indexPath.row // Set tag
            
            // Add tap gesture to WebLbl to open the website
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite(_:)))
            cell.WebLbl.isUserInteractionEnabled = true // Enable user interaction for the label
            cell.WebLbl.addGestureRecognizer(tapGesture)

            // Store the website URL in gesture recognizer's `accessibilityLabel`
            cell.WebLbl.accessibilityLabel = data.website

            
            let tapNewGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
                cell.addGestureRecognizer(tapNewGesture)
                cell.tag = indexPath.row // Store indexPath in the cell's tag
            
            // Set arrow image based on expansion state
               if expandedIndexPath == indexPath {
                   cell.arrowImageView.image = UIImage(named: "upward-arrow") // Show expanded arrow
               } else {
                   cell.arrowImageView.image = UIImage(named: "downward-arrow") // Show collapsed arrow
               }
            
            return cell
        case 4: // Fire Brigade section
            let cell = tableView.dequeueReusableCell(withIdentifier: "FireTableViewCell", for: indexPath) as! FireTableViewCell
            cell.EventLbl.text = data.name
            cell.AddLbl.text = data.address
            cell.Number1Lbl.text = data.number1
            cell.Number2Lbl.text = data.number2
            cell.viewLine.isHidden = expandedIndexPath != indexPath
            
            if let number2 = data.number2, !number2.isEmpty {
                   cell.Number2View.isHidden = false
               } else {
                   cell.Number2View.isHidden = true
                   cell.Number2Lbl.isHidden = true
               }
            
            cell.WebLbl.text = data.website
            configureButtonAction(cell.Number1Btn, data.number1 ?? "")
            configureButtonAction(cell.Number2Btn, data.number2 ?? "")
            cell.EventLbl.font = UIFont(name: "Montserrat-SemiBold", size: 16)
            if let latString = data.lat, let longString = data.long,
               let latitude = Double(latString), let longitude = Double(longString) {
                configureMapButtonAction(cell.MapButton, lat: latitude, long: longitude)
            } else {
                print("Invalid latitude or longitude for data: \(data)")
            }
            
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite(_:)))
//            cell.WebLbl.isUserInteractionEnabled = true // Enable user interaction for the label
//            cell.WebLbl.addGestureRecognizer(tapGesture)
//            cell.WebLbl.tag = indexPath.row // Set tag
            
            // Add tap gesture to WebLbl to open the website
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite(_:)))
            cell.WebLbl.isUserInteractionEnabled = true // Enable user interaction for the label
            cell.WebLbl.addGestureRecognizer(tapGesture)

            // Store the website URL in gesture recognizer's `accessibilityLabel`
            cell.WebLbl.accessibilityLabel = data.website

            
            // Set arrow image based on expansion state
               if expandedIndexPath == indexPath {
                   cell.arrowImageView.image = UIImage(named: "upward-arrow") // Show expanded arrow
               } else {
                   cell.arrowImageView.image = UIImage(named: "downward-arrow") // Show collapsed arrow
               }
            
            let tapNewGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
                cell.addGestureRecognizer(tapNewGesture)
                cell.tag = indexPath.row // Store indexPath in the cell's tag
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? UITableViewCell else { return } // Handle all cell types
        
        let indexPath = IndexPath(row: cell.tag, section: 0)
        
        if expandedIndexPath == indexPath {
            expandedIndexPath = nil // Collapse the row
        } else {
            expandedIndexPath = indexPath // Expand the row
        }
        
        // Reload the row to apply the height change
        tableviewMembers.reloadRows(at: [indexPath], with: .automatic)
    }



    
    @objc func openWebsite(_ sender: UITapGestureRecognizer) {
        if let webLabel = sender.view as? UILabel,
           let website = webLabel.accessibilityLabel,
           let url = URL(string: website), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Invalid website URL or cannot open URL")
        }
    }

   

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (expandedIndexPath == indexPath) ? 230 : 60
    }

    
    // Web service call to load data
    func calldirectoryWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? ""
        ]
        WebService.sharedInstance.calldirectoryWebService(withParams: dictParams) { data in
            self.PublicDirecData = data
            if self.PublicDirecData?.status == "success"{
                completionClosure()
            }else{
                self.showAlert(Message: self.PublicDirecData?.message ?? "")
            }
        }
    }
    
   

}
