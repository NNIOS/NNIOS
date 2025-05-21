//
//  NeighbourhoodViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 05/03/24.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class NeighbourhoodViewController: BaseViewController,UICollectionViewDelegate, UICollectionViewDataSource, ConfirmfollowDelegate, UICollectionViewDelegateFlowLayout {
   
    
   
    
    
    @IBOutlet weak var collectionViewDirectory: UICollectionView!
    @IBOutlet weak var wallImgView : UIImageView!
    
    @IBOutlet weak var EventsLbl: UILabel!
    @IBOutlet weak var PollLbl: UILabel!
    @IBOutlet weak var BusinessLbl: UILabel!
    @IBOutlet weak var GroupLbl: UILabel!
    @IBOutlet weak var MemberLbl: UILabel!
    @IBOutlet weak var PostLbl: UILabel!
    @IBOutlet weak var neighborhoodView: UIView!
    
    @IBOutlet weak var NeighrhoodLbl: UILabel!
    @IBOutlet weak var LblMyNeighbrhoods: UILabel!
    @IBOutlet weak var PrimaryNeighrhoodLbl: UILabel!
    @IBOutlet weak var TotalMemberLbl: UILabel!
    
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var sectorLbl: UILabel!
    
    @IBOutlet weak var MyNearByLbl: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var lblTotalMember: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var NeighbourhoddView: UIView!
    @IBOutlet weak var MembersView: UIView!
    @IBOutlet weak var NearNeighbourhoddView: UIView!
    @IBOutlet weak var MyNeighbourhoddView: UIView!
    
    @IBOutlet weak var LblMemberText: UILabel!
    @IBOutlet weak var LblGroupsText: UILabel!
    @IBOutlet weak var LblEventText: UILabel!
    @IBOutlet weak var LblPollText: UILabel!
    @IBOutlet weak var LblBussinessText: UILabel!
    @IBOutlet weak var LblPostText: UILabel!
    
    private let spacing:CGFloat = 5.0
    var neighbrhoodData : MyNeighbhoodModel?
    var thisWidth:CGFloat = 0
    var selectedNeighborhoodId: String?
    var idNeighbour: String?
    private var defaultTextColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
       
        self.EventsLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.lblTotalMember.font = UIFont(name: "Montserrat-Regular", size: 13)
        self.PollLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.BusinessLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.GroupLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.MemberLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.BusinessLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.NeighrhoodLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        
        self.PrimaryNeighrhoodLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
      //  self.TotalMemberLbl.font = UIFont(name: "Montserrat-Medium", size: 18)
        self.PostLbl.font = UIFont(name: "Montserrat-Regular", size: 18)
        
        self.MyNearByLbl.font  = UIFont(name: "Montserrat-Regular", size: 20)
        self.LblMyNeighbrhoods.font  = UIFont(name: "Montserrat-Regular", size: 20)
        defaultTextColor = lblMember.textColor
        
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionViewDirectory.delegate = self
        collectionViewDirectory.dataSource = self
        neighborhoodView.isHidden = true
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.lblMember.font = UIFont(name: "Montserrat-Regular", size: 17)
        SVProgressHUD.show()
       

//
        callMyNeighbrhoodWebService{
            SVProgressHUD.dismiss()
            self.collectionViewDirectory.reloadData()
            
            self.EventsLbl.text = self.neighbrhoodData?.events
            self.PollLbl.text = self.neighbrhoodData?.polls
            self.BusinessLbl.text = self.neighbrhoodData?.business
            self.GroupLbl.text = self.neighbrhoodData?.groups
            self.MemberLbl.text = self.neighbrhoodData?.members
            self.BusinessLbl.text = self.neighbrhoodData?.business
           self.NeighrhoodLbl.text = self.neighbrhoodData?.neighbrhood
            self.PostLbl.text = self.neighbrhoodData?.post
            if let totalMembers = self.neighbrhoodData?.totmember {
                self.lblTotalMember.text = "Total members \(totalMembers)"
            } else {
                self.lblTotalMember.text = "N/A"  // Or another default value if totmember is nil
            }


           
          
          //  self.TotalMemberLbl.text = self.neighbrhoodData?.members
            self.lblMember.text = self.neighbrhoodData?.ownerNeighbrhood.first?.name
            
            self.PrimaryNeighrhoodLbl.text = "\(self.neighbrhoodData?.ownerNeighbrhood.first?.member ?? "") Members"
            self.PostLbl.text = self.neighbrhoodData?.post
         //   self.lblMember.text = self.neighbrhoodData?.neighbrhood
            
           // self.lblTotalMember.text = self.neighbrhoodData?.totmember ?? "N/A"
           
            
            
          //  self.NeighrhoodLbl.text = self.neighbrhoodData?.nearestNeighbrhood.first?.name
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            NeighbourhoddView.backgroundColor = .black
            LblMemberText.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            LblGroupsText.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            LblEventText.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            LblPollText.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            LblBussinessText.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            LblEventText.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            LblPostText.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            LblMyNeighbrhoods.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            lblMember.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            PrimaryNeighrhoodLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            
            MyNearByLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            lblTotalMember.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
           
            MembersView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           
            MembersView.layer.borderWidth = 1.0
            
            neighborhoodView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           
            neighborhoodView.layer.borderWidth = 1.0
            
            NearNeighbourhoddView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           
            NearNeighbourhoddView.layer.borderWidth = 1.0
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
          //  questionView.textColor = UIColor.secondaryLabel
           
            MembersView.isUserInteractionEnabled = true
            MembersView.layer.borderWidth = 0
            
            neighborhoodView.isUserInteractionEnabled = true
            neighborhoodView.layer.borderWidth = 0
            
            NearNeighbourhoddView.isUserInteractionEnabled = true
            NearNeighbourhoddView.layer.borderWidth = 0
            NeighbourhoddView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            LblMemberText.textColor = UIColor.secondaryLabel
            LblGroupsText.textColor = UIColor.secondaryLabel
            LblEventText.textColor = UIColor.secondaryLabel
            LblPollText.textColor = UIColor.secondaryLabel
            LblBussinessText.textColor = UIColor.secondaryLabel
            LblEventText.textColor = UIColor.secondaryLabel
            LblPostText.textColor = UIColor.secondaryLabel
            LblMyNeighbrhoods.textColor = defaultTextColor
            lblMember.textColor = defaultTextColor
            PrimaryNeighrhoodLbl.textColor = UIColor.secondaryLabel
            MyNearByLbl.textColor = defaultTextColor
            lblTotalMember.textColor =  UIColor.secondaryLabel
            
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    @IBAction func btnClose(_ : UIButton){
        
      //  viewPopup.isHidden = true
        
    }
    
    @IBAction func btnMember(_ : UIButton) {

       
        
        if neighbrhoodData?.verfiedMsg == "User Verification is completed!" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MembersViewController")as! MembersViewController
            vc.selectedNeighborhoodId = self.selectedNeighborhoodId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            // Create the alert controller
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            
            // Define font and color attributes
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            
            // Create attributed strings
            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
            let attributedMessage = NSAttributedString(
                string: "You have limited access till verification is complete. We thank you for your patience.",
                attributes: messageAttributes
            )
            
            // Set the title and message of the alert
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            // Add an action to the alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }

       }
    
    @IBAction func btnGroups(_ : UIButton) {

   
        
        if neighbrhoodData?.verfiedMsg == "User Verification is completed!" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupsViewController")as! GroupsViewController
            vc.selectedNeighborhoodId = self.selectedNeighborhoodId
          //  vc.sourceViewController = "Neighbourhood"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else {
            // Create the alert controller
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            
            // Define font and color attributes
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            
            // Create attributed strings
            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
            let attributedMessage = NSAttributedString(
                string: "You have limited access till verification is complete. We thank you for your patience.",
                attributes: messageAttributes
            )
            
            // Set the title and message of the alert
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            // Add an action to the alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }


       }
    
    @IBAction func btnEvents(_ : UIButton){

   
        
        if neighbrhoodData?.verfiedMsg == "User Verification is completed!" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsViewController")as! EventsViewController
            vc.selectedNeighborhoodId = self.selectedNeighborhoodId
            vc.selectedNeighborhoodName = self.NeighrhoodLbl.text
            vc.sourceViewController = "Neighbourhood"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            
            // Define font and color attributes
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            
            // Create attributed strings
            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
            let attributedMessage = NSAttributedString(
                string: "You have limited access till verification is complete. We thank you for your patience.",
                attributes: messageAttributes
            )
            
            // Set the title and message of the alert
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            // Add an action to the alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }

       }
    
    @IBAction func btnBusiness(_ : UIButton){

   
        
        if neighbrhoodData?.verfiedMsg == "User Verification is completed!" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BussinesViewController")as! BussinesViewController
            vc.selectedNeighborhoodId = self.selectedNeighborhoodId
            vc.sourceViewController = "Neighbourhood"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            // Create the alert controller
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            
            // Define font and color attributes
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            
            // Create attributed strings
            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
            let attributedMessage = NSAttributedString(
                string: "You have limited access till verification is complete. We thank you for your patience.",
                attributes: messageAttributes
            )
            
            // Set the title and message of the alert
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            // Add an action to the alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }


       }
    
    @IBAction func btnPolls(_ : UIButton){

    
        
        if neighbrhoodData?.verfiedMsg == "User Verification is completed!" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PollsViewController")as! PollsViewController
            vc.selectedNeighborhoodId = self.selectedNeighborhoodId
            vc.sourceViewController = "Neighbourhood"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            // Create the alert controller
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            
            // Define font and color attributes
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            
            // Create attributed strings
            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
            let attributedMessage = NSAttributedString(
                string: "You have limited access till verification is complete. We thank you for your patience.",
                attributes: messageAttributes
            )
            
            // Set the title and message of the alert
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            // Add an action to the alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }

       }
    
    @IBAction func btnPost(_ : UIButton){

        
        if neighbrhoodData?.verfiedMsg == "User Verification is completed!" {
               
               // Save selectedNeighborhoodId to UserDefaults
               UserDefaults.standard.set(selectedNeighborhoodId, forKey: "neighbrshood")
               
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
               vc.selectedNeighborhoodId = self.selectedNeighborhoodId
               self.navigationController?.pushViewController(vc, animated: true)
               
           } else {
               let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)

               let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
               let messageAttributes: [NSAttributedString.Key: Any] = [
                   .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                   .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
               ]

               let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
               let attributedMessage = NSAttributedString(
                   string: "You have limited access till verification is complete. We thank you for your patience.",
                   attributes: messageAttributes
               )

               alert.setValue(attributedTitle, forKey: "attributedTitle")
               alert.setValue(attributedMessage, forKey: "attributedMessage")

               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                   alert.dismiss(animated: true, completion: nil)
               }))

               self.present(alert, animated: true, completion: nil)
           }
       }
    
    @IBAction func moreButton(_ sender: Any)
    
       {
           self.neighborhoodView.isHidden = true
           
           let selectedId =  self.neighbrhoodData?.ownerNeighbrhood.first?.name
         //  let OwnerId =  self.neighbrhoodData?.ownerNeighbrhood.first?.id
           if let ownerId = self.neighbrhoodData?.ownerNeighbrhood.first?.id {
                  // Save OwnerId to UserDefaults
              
               self.selectedNeighborhoodId = ownerId // Store the selected ID
                  UserDefaults.standard.set(ownerId, forKey: "neighbrhood")
                  
                  // Call the API
                  callMyNeighbrhoodWebService {
                      self.NeighrhoodLbl.text = self.neighbrhoodData?.neighbrhood
                      self.PollLbl.text = self.neighbrhoodData?.polls
                      self.BusinessLbl.text = self.neighbrhoodData?.business
                      self.GroupLbl.text = self.neighbrhoodData?.groups
                      self.MemberLbl.text = self.neighbrhoodData?.members
                      self.BusinessLbl.text = self.neighbrhoodData?.business
                      self.PostLbl.text = self.neighbrhoodData?.post
                      
                      self.EventsLbl.text = self.neighbrhoodData?.events
                      
                      print("API call completed")
                  }
              } else {
                  print("OwnerId is nil")
              }
        //   self.neighbrhoodData?.ownerNeighbrhood.first?.name
       }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

      //  return (neighbrhoodData?.nearestNeighbrhood.count)!
        return neighbrhoodData?.nearestNeighbrhood.count ?? 0
        //neighbrhoodData?.nearestNeighbrhood.count ?? 0
     //   return collectionViewDirectory?.count ?? 0
        
    }
   
   

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeighbourhoodCollectionViewCell", for: indexPath) as! NeighbourhoodCollectionViewCell
       
      //  cell.selectionStyle = .none
        
        let data = neighbrhoodData?.nearestNeighbrhood[indexPath.row]
       
        cell.SecLbl.text = neighbrhoodData?.nearestNeighbrhood[indexPath.row].name
        cell.FollowMemberLbl.text = "\(neighbrhoodData?.nearestNeighbrhood[indexPath.row].member ?? "") Members"

        if data?.status == "0" {
            cell.btnEdit.setTitle("Follow", for: .normal)
            cell.btnEdit.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
            cell.btnTransfer.isHidden = true
            
        } else {
            cell.btnEdit.setTitle("Unfollow", for: .normal)
            cell.btnEdit.backgroundColor = .red
            cell.btnTransfer.isHidden = false
        }


//        if neighbrhoodData?.nearestNeighbrhood[indexPath.row].status == "0" {
//            cell.btnEdit.setTitle("Follow", for: .normal)
//            cell.btnEdit.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
//           // cell.viewStatus.backgroundColor = UIColor(named:"red")
//        } else if neighbrhoodData?.nearestNeighbrhood[indexPath.row].status == "1" {
//            cell.btnEdit.setTitle("Unfollow", for: .normal)
//            cell.btnEdit.backgroundColor = .red
//          //  cell.btnEdit.backgroundColor = UIColor(named:"green")
//        }
        
       // self.addViewShadow(view: cell.viewCard)
        
//        let tapCategoryCardCell = UITapGestureRecognizer(target: self, action:  #selector(self.categoryTapped))
//        cell.viewCard.tag = indexPath.row
//        cell.viewCard.addGestureRecognizer(tapCategoryCardCell)
       

        cell.SecLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.FollowMemberLbl.font = UIFont(name: "Montserrat-Regular", size: 13)
                                  
        cell.transferCallback = { [self] value in
            if let selectedNeighborhood = self.neighbrhoodData?.nearestNeighbrhood[indexPath.row] {
                // Get the name and id from the selected neighborhood
                let selectedName = selectedNeighborhood.name
                let selectedId = selectedNeighborhood.id
                self.selectedNeighborhoodId = selectedId // Store the selected ID
                
                // Update the NeighrhoodLbl with the selected name
                self.NeighrhoodLbl.text = selectedName
                print("Selected Neighborhood Name: \(selectedName ?? "N/A")")
                print("Selected Neighborhood ID: \(selectedId ?? "N/A")")
                
                // Save the selected neighborhood ID to UserDefaults
                UserDefaults.standard.set(selectedId, forKey: "neighbrhood")

                // Update the main neighborhood property in the data model
                self.neighbrhoodData?.neighbrhood = selectedName
                callMyNeighbrhoodWebService{
                   
                    self.collectionViewDirectory.reloadData()
                    
                    self.EventsLbl.text = self.neighbrhoodData?.events
                    self.PollLbl.text = self.neighbrhoodData?.polls
                    self.BusinessLbl.text = self.neighbrhoodData?.business
                    self.GroupLbl.text = self.neighbrhoodData?.groups
                    self.MemberLbl.text = self.neighbrhoodData?.members
                    self.BusinessLbl.text = self.neighbrhoodData?.business
                   self.NeighrhoodLbl.text = self.neighbrhoodData?.neighbrhood
                  
                  //  self.TotalMemberLbl.text = self.neighbrhoodData?.members
                 //   self.PrimaryNeighrhoodLbl.text = self.neighbrhoodData?.neighbrhood
                    self.PostLbl.text = self.neighbrhoodData?.post
                  //  self.lblMember.text = self.neighbrhoodData?.neighbrhood
                    
                   
                }
            } else {
                print("Data not found for the selected index")
            }
            
            // Show the neighborhood view
            self.neighborhoodView.isHidden = false
        }

        cell.DetailsCallback = { [weak self] value in
            guard let self = self else { return }
            if self.neighbrhoodData?.verfiedMsg == "User Verification is completed!" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "followPopUpViewController") as! followPopUpViewController
                vc.FollowName = data?.name
                vc.Nid = data?.id
                vc.Nstats = (data?.status == "0") ? "1" : "0"
                vc.delegate = self
                
                // Avoid dimmed background by using custom presentation style
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve // Smooth transition effect
                
                self.present(vc, animated: true)
            } else {
                let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
                
                // Define font and color attributes
                let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
                let messageAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
                ]
                
                // Create attributed strings
                let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
                let attributedMessage = NSAttributedString(
                    string: "You have limited access till verification is complete. We thank you for your patience.",
                    attributes: messageAttributes
                )
                
                // Set the title and message of the alert
                alert.setValue(attributedTitle, forKey: "attributedTitle")
                alert.setValue(attributedMessage, forKey: "attributedMessage")
                
                // Add an action to the alert
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                // Present the alert
                self.present(alert, animated: true, completion: nil)
            }
        }

        
//        cell.followCallback = { value in
//
//
//
//            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "FollowViewController") as? FollowViewController)!
//        //    vc.suggestion = neighbrhoodData[indexPath.row]
//                vc.height = 300.0
//                vc.topCornerRadius = 10.0
//                vc.presentDuration = 0.5
//                vc.dismissDuration = 0.5
//                vc.neighbrhoodData = self.neighbrhoodData?.nearestNeighbrhood[indexPath.row].name
//                self.present(vc, animated: true, completion: nil)
//
//        }
        

    
        return cell
        
    }
    
   

   
    
//    @IBAction func categoryTapped(sender: UITapGestureRecognizer) {
//
//        let tappedView = sender.view
//        let viewTag = tappedView?.tag
//
//     //   let data = neighbrhoodData?.nearestNeighbrhood[indexPath.row]
//
//       // self.lblCategory.text = responseData[viewTag!]["name"].stringValue
//
//        self.sectorLbl.text = neighbrhoodData?.nearestNeighbrhood[viewTag!].name
//
//       // self.categoryId = responseData[viewTag!]["_id"].stringValue
//
//       // viewPopup.isHidden = false
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//      let Size  = (collectionView.frame.width )/4
//          return CGSize(width:Size , height:40)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 8
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        if let collection = self.collectionViewDirectory{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 105)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    func tapConfirm() {
        // Update the neighborhood data and UI
        self.callMyNeighbrhoodWebService {
            DispatchQueue.main.async {
                self.collectionViewDirectory.reloadData()
                self.lblMember.text = self.neighbrhoodData?.ownerNeighbrhood.first?.name
                self.PrimaryNeighrhoodLbl.text = "\(self.neighbrhoodData?.ownerNeighbrhood.first?.member ?? "") Members"
            }
        }
    }
    
   
    
//    @objc func onEditClick(_ sender:UIButton ){
//
//        print(sender.tag)
//      //  let data = neighbrhoodData[sender.tag]
//
//
//
//
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowViewController") as? FollowViewController{
//            vc.height = 300.0
//            vc.topCornerRadius = 10.0
//            vc.presentDuration = 0.5
//            vc.dismissDuration = 0.5
//            vc.neighbrhoodData = self.neighbrhoodData
//          //  vc.name = self.FollowMemberLbl.text ?? ""
//        //    vc.otherid = MemberListData?.listdata[indexPath.row].id ?? ""
//
//            self.present(vc, animated: true, completion: nil)
//        }
//
//
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//                  thisWidth = (CGFloat(self.collectionViewDirectory.width) / 3 ) - 3
//                  return CGSize(width: thisWidth, height: 110)
//              }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
//    {
//        let screenSize: CGRect = UIScreen.main.bounds
//        var screenWidth = CGFloat()
//        screenWidth = (screenSize.width / 5 ) - 30
//
//        if UIDevice.current.userInterfaceIdiom == .pad
//        {
//            return CGSize(width: screenWidth, height: screenWidth + 50)
//        }
//
//        return CGSize(width: screenWidth, height: screenWidth + 30)
//    }
    
    func callMyNeighbrhoodWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        
        // Retrieve the updated neighborhood ID from UserDefaults
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrhood")
        
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "neighbrhood": idNeighbour ?? ""
        ]
        
        WebService.sharedInstance.callMyNeighbrhoodWebService(withParams: dictParams) { data in
            self.neighbrhoodData = data
            UserDefaults.standard.set(self.neighbrhoodData?.nearestNeighbrhood.first?.name, forKey: "name")
            UserDefaults.standard.set(self.neighbrhoodData?.nearestNeighbrhood.first?.status, forKey: "status")
            
            completionClosure()
        }
    }

    func updateFollowButtonStatus(_ status: Int) {
        let followButton = UIButton()
        followButton.setTitle(status == 1 ? "Unfollow" : "Follow", for: .normal)
    }

    
   
}
//9958981387
//Malik@123
//1  hga  to wishlist kr payga
//0 inactive
//, 2 sold
