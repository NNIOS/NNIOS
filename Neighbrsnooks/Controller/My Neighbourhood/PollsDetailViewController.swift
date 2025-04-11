import UIKit
import SVProgressHUD
@available(iOS 16.0, *)

class PollsDetailViewController: UIViewController, ConfirmPollDelDelegate, DeletePollViewControllerDelegate {
    
    func tapConfirm() {
        
    }
    
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var SectLbl: UILabel!
    @IBOutlet weak var StartLbl: UILabel!
    @IBOutlet weak var EnddateLbl: UILabel!
    @IBOutlet weak var StateLbl: UILabel!
    @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var VoteLbl: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var VoteBtn: UIButton!
    
    @IBOutlet weak var btnedit: UIButton!
    @IBOutlet weak var btnDel: UIButton!
    @IBOutlet weak var PollsBgView: UIView!
    
    var PollDetailData : PollDetailModel?
    var PollVotedData : PollVotedModel?
  //  var PollsData : PollsModel?
    var pollid : String?
    var id : String?
    var selectedPollOption: String?
    var selectedIndex: IndexPath? // To store the selected index
    var previousSelectedIndex: IndexPath?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.SectLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.NameLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        self.StartLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.EnddateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.StateLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
       
        self.DateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.VoteLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        NetworkMonitor.shared.startMonitoring()
       // updateColors()
        PollsBgView.backgroundColor = UIColor.systemBackground
        
        callPollDetailWebService{
          //  SVProgressHUD.dismiss()
            self.tableviewMembers.reloadData()
            self.NameLbl.text = self.PollDetailData?.createdBy
            self.SectLbl.text = self.PollDetailData?.neighborhood
            self.StartLbl.text = "Start date: " + (self.PollDetailData?.startDate ?? "")
            self.DateLbl.text = self.PollDetailData?.createdDate
            self.StateLbl.text = self.PollDetailData?.pollQues
            self.EnddateLbl.text =  "End date  : " + (self.PollDetailData?.endDate ?? "")
            self.VoteLbl.text = self.PollDetailData?.isvoted
            
           // "Rs." + (self.MarketWDetailData?.productdetail?.first?.salePrice ?? "")
            let url = URL(string: (self.PollDetailData?.userpic ?? ""))
            self.profileImgView.kf.indicatorType = .activity
           self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
        }
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
       
        callPollDetailWebService{ [self] in
            
            self.tableviewMembers.reloadData()
            self.NameLbl.text = self.PollDetailData?.createdBy
            self.SectLbl.text = self.PollDetailData?.neighborhood
            self.StartLbl.text = "Start date : " + (self.PollDetailData?.startDate ?? "")
            self.DateLbl.text = self.PollDetailData?.createdDate
            self.StateLbl.text = self.PollDetailData?.pollQues
            self.EnddateLbl.text =  "End date  : " + (self.PollDetailData?.endDate ?? "")
            self.VoteLbl.text = self.PollDetailData?.isvoted
            
            if let id = UserDefaults.standard.string(forKey: "userid"),
               let idCr = UserDefaults.standard.string(forKey: "usercr") {
                print("id: \(id), idCr: \(idCr)") // Debugging output
                
                if id == idCr {
                    btnedit.isHidden = false
                    btnDel.isHidden = false
                    
                } else {
                    btnedit.isHidden = true
                    btnDel.isHidden = true
                   
                }
            } else {
                print("UserDefaults values are nil") // Handle nil case
            }
            
           // "Rs." + (self.MarketWDetailData?.productdetail?.first?.salePrice ?? "")
            let url = URL(string: (self.PollDetailData?.userpic ?? ""))
            self.profileImgView.kf.indicatorType = .activity
           self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
         
            if PollDetailData?.isvoted == "1" {
                self.VoteBtn.isEnabled = false // Disable the button click
                self.VoteBtn.backgroundColor =   #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1) // Default color
                self.VoteBtn.setTitleColor(UIColor.white, for: .normal)
                VoteBtn.setTitle("Voted", for: .normal)
                    // btnedit.isHidden = true
               // self.isUserInteractionEnabled = false // Disable cell interaction when the vote is already cast
            } else if PollDetailData?.isvoted == "0"  {
                self.VoteBtn.isHidden = false
                
            }

        }

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            NameLbl.textColor = .white
            SectLbl.textColor = .white
            StartLbl.textColor = .white
            EnddateLbl.textColor = .white
            StateLbl.textColor = .white
            DateLbl.textColor = .white
            VoteLbl.textColor = .white
            PollsBgView.backgroundColor = .black
        } else {
            // Light mode mein storyboard ke original colors preserve karna
            NameLbl.textColor = UIColor.secondaryLabel
            SectLbl.textColor = UIColor.secondaryLabel
            StartLbl.textColor = UIColor.secondaryLabel
            EnddateLbl.textColor = UIColor.secondaryLabel
            StateLbl.textColor = UIColor.secondaryLabel
            DateLbl.textColor = UIColor.secondaryLabel
            VoteLbl.textColor = UIColor.secondaryLabel

            // Light mode mein PollsView ka background red karna
            PollsBgView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors() // Re-apply colors on theme change
        }
    }
    
    @IBAction func submitVoteButtonTapped(_ sender: UIButton) {
        // Ensure an option has been selected
        guard let pollOption = selectedPollOption else {
               print("No option selected")
               return
           }

           // Show SVProgressHUD before calling the API
           SVProgressHUD.show()

           // Call the API with the selected option
           callPollVotedWebService(pollOption: pollOption) { [weak self] in
               // Hide SVProgressHUD once the API call is completed
               SVProgressHUD.dismiss()
               
               self?.callPollDetailWebService{
                 //  SVProgressHUD.dismiss()
                   self?.tableviewMembers.reloadData()
                   self?.NameLbl.text = self?.PollDetailData?.createdBy
                   self?.SectLbl.text = self?.PollDetailData?.neighborhood
                   self?.StartLbl.text = "Start date: " + (self?.PollDetailData?.startDate ?? "")
                   self?.DateLbl.text = self?.PollDetailData?.createdDate
                   self?.StateLbl.text = self?.PollDetailData?.pollQues
                   self?.EnddateLbl.text =  "End date  : " + (self?.PollDetailData?.endDate ?? "")
                   self?.VoteLbl.text = self?.PollDetailData?.isvoted
                   
                  // "Rs." + (self.MarketWDetailData?.productdetail?.first?.salePrice ?? "")
                   let url = URL(string: (self?.PollDetailData?.userpic ?? ""))
                   self?.profileImgView.kf.indicatorType = .activity
                   self?.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
                   
                   if self?.PollDetailData?.isvoted == "1" {
                       self?.VoteBtn.isEnabled = false // Disable the button click
                       self?.VoteBtn.backgroundColor =   #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1) // Default color
                       self?.VoteBtn.setTitleColor(UIColor.white, for: .normal)
                       self?.VoteBtn.setTitle("Voted", for: .normal)
                      // self.isUserInteractionEnabled = false // Disable cell interaction when the vote is already cast
                   } else if self?.PollDetailData?.isvoted == "0"  {
                       self?.VoteBtn.isHidden = false
                       
                   }
               }
               
               // Optionally handle any completion logic here, like a success message
               // You can use a UIAlertController for success/failure feedback
//               let alertController = UIAlertController(title: "Success", message: "Your vote has been submitted!", preferredStyle: .alert)
//               alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//               self?.present(alertController, animated: true, completion: nil)
           }
       
    }
    
    @IBAction func DeletePopUpBtnAction(_ sender: UIButton) {
      
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeletePollViewController") as! DeletePollViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self // Set the delegate
            self.present(vc, animated: true)
        

   }
    
    
    @IBAction func DeletePopUpNewBtnAction(_ sender: UIButton) {
      
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)

            // Customizing the message font and size
            let messageText = "Are you sure you want to remove this poll?"
            let attributedMessage = NSAttributedString(string: messageText, attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
                .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            ])
            alertController.setValue(attributedMessage, forKey: "attributedMessage")

            // Define RGB Colors
            let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)  // Green
            let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)   // Red

            // Yes Action
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.callPollDeleteWebService {
                    // Pop one screen back after the API call is successful
                    self.navigationController?.popViewController(animated: true)
                }
            }
            yesAction.setValue(yesColor, forKey: "titleTextColor") // Set Yes button color

            // No Action
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            noAction.setValue(noColor, forKey: "titleTextColor") // Set No button color

            alertController.addAction(yesAction)
            alertController.addAction(noAction)

            // Present the alert
            self.present(alertController, animated: true, completion: nil)
   }
    
//   "Poll cannot be edited as voting has already started You can delete the poll."
    
    @IBAction func btnEditPoll(_ : UIButton){
        
        if PollDetailData?.editPollStatus == 1 {
               // Show popup alert
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
                string: "Poll cannot be edited as voting has already started. You can delete the poll.",
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
           } else if PollDetailData?.editPollStatus == 0 {
               // Navigate to EditPollViewController
               guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditPollViewController") as? EditPollViewController else { return }
               vc.pollid = PollDetailData?.pID ?? ""
               self.navigationController?.pushViewController(vc, animated: true)
           }
        
    }
    
    @IBAction func btnProfile(_ : UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        vc.Oid = PollDetailData?.userid ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func callPollDeleteWebService(_ completionClosure: @escaping () -> ()) {
       // let id = UserDefaults.standard.string(forKey: "userid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let Pollid = UserDefaults.standard.string(forKey: "Pollid")
          let dictParams: Dictionary<String, Any> = [
                                                     "userid":id ?? "",
                                                    "pollid": Pollid ?? "",
                                                   
                                                                        ]
          WebService.sharedInstance.callPollDeleteWebService(withParams: dictParams) { data in
         //   self.GrouDeleteData = data
         

            completionClosure()
          }
        }
   
    func callPollDetailWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let Pollid = UserDefaults.standard.string(forKey: "Pollid")
        let idCr = UserDefaults.standard.string(forKey: "usercr")
        var dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "poll_id":pollid ?? ""
        ]

        

        WebService.sharedInstance.callPollDetailWebService(withParams: dictParams) { responseData in
            // Handle the response
            if let PollDetailData = responseData as? PollDetailModel {
                self.PollDetailData = PollDetailData
                UserDefaults.standard.set(self.PollDetailData?.pID, forKey: "Pollid")
                UserDefaults.standard.set(self.PollDetailData?.userid, forKey: "usercr")
                print("Decoded data: \(self.PollDetailData)")
                completionClosure()
            } else {
                print("Error: Could not cast responseData to NewNotificationModel")
            }
        }
    }
    
//    func callPollVotedWebService(pollOption: String, _ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
//
//        // Ensure required parameters are present
//        guard let pollid = pollid else {
//            print("Poll ID is missing")
//            return
//        }
//
//        let dictParams: Dictionary<String, Any> = [
//            "userid": id ?? "",
//            "poll_id": pollid,
//            "polloption": pollOption
//        ]
//
//        // Log request parameters
//        print("Request Parameters: \(dictParams)")
//
//        WebService.sharedInstance.callPollVotedWebService(withParams: dictParams) { data in
//            // Assign the response data directly
//            print("Response Data: \(data)")
//
//            self.PollVotedData = data
//            completionClosure()
//        }
//    }

    func callPollVotedWebService(pollOption: String, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        
        guard let pollid = pollid else {
            print("Poll ID is missing")
            return
        }

        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "pollid": pollid,
            "polloption": pollOption
        ]
        
        print("Request Parameters: \(dictParams)")

        WebService.sharedInstance.callPollVotedWebService(withParams: dictParams) { data in
            // Directly assign the PollVotedModel object to self.PollVotedData
            self.PollVotedData = data  // Assuming data is already of type PollVotedModel
            
            // Log response data
            print("Response Data: \(self.PollVotedData)")
            
            completionClosure()
        }
    }
}


@available(iOS 16.0, *)
extension PollsDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PollDetailData?.options?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PollTableViewCell", for: indexPath) as! PollTableViewCell

        cell.lblTitle.text = PollDetailData?.options?[indexPath.row].option
        cell.lblPrcntg.text = ((PollDetailData?.options?[indexPath.row].percentage)!) + "%"


        if let isVoted = PollDetailData?.isvoted, isVoted == "0" {
            // Set default background color and enable selection
            cell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) // Gray color
            cell.lblTitle.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1) // Default text color
            cell.lblPrcntg.isHidden = true
            cell.isUserInteractionEnabled = true // Allow selection

            // If this is the selected cell, change background color
            if selectedIndex == indexPath {
                cell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) // Greenish-yellow color
            }
        } else {
            cell.isUserInteractionEnabled = true
            cell.lblPrcntg.isHidden = false

            if let userCount = PollDetailData?.options?[indexPath.row].userCount {
                if userCount == 0 {
                    cell.customBackgroundView.backgroundColor = (selectedIndex == indexPath) ?
                        #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) :
                        #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                } else if userCount == 1 {
                    cell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }
            } else {
                cell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }



        cell.lblTitle.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        cell.lblPrcntg.font = UIFont(name: "Montserrat-Regular", size: 13)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Only allow selection if voting is allowed (isvoted == "0")
        if PollDetailData?.isvoted == "0",
           let userCount = PollDetailData?.options?[indexPath.row].userCount,
           userCount == 0 || userCount == 1 { // Allow selection for userCount == 1 as well

            // If there's a previously selected index, reset its background color to default
            if let previousIndex = selectedIndex {
                if let previousCell = tableView.cellForRow(at: previousIndex) as? PollTableViewCell {
                    previousCell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) // Default color
                }
            }

            // Update the selected cell's background color
            let cell = tableView.cellForRow(at: indexPath) as! PollTableViewCell
            cell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) // Greenish-yellow color
            
            // Update the selected index
            selectedIndex = indexPath
            selectedPollOption = PollDetailData?.options?[indexPath.row].option // Store the selected option

            print("Selected poll option: \(selectedPollOption ?? "")")

            // Reload the previous and newly selected rows to reflect the change
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

}
