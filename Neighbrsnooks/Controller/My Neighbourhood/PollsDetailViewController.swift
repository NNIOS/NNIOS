import UIKit
import SVProgressHUD
@available(iOS 16.0, *)

class PollsDetailViewController: UIViewController, ConfirmPollDelDelegate, DeletePollViewControllerDelegate {
    
    func tapConfirm() {
        
    }
    
    @IBOutlet weak var mainViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tablViewHeightConst: NSLayoutConstraint!
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
    var pollid : String?
    var id : String?
    var selectedPollOption: String?
    var selectedIndex: IndexPath?
    var previousSelectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        updateColors()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.SectLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.NameLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        self.StartLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.EnddateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.StateLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.DateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.VoteLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.StateLbl.numberOfLines = 0
        NetworkMonitor.shared.startMonitoring()
        PollsBgView.backgroundColor = UIColor.systemBackground
        callPollDetailWebService{
            self.NameLbl.textColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 0.8)
            self.tableviewMembers.reloadData()
            self.NameLbl.text = self.PollDetailData?.createdBy
            self.SectLbl.text = self.PollDetailData?.neighborhood
            self.StartLbl.text = "Start date: " + (self.PollDetailData?.startDate ?? "")
            self.DateLbl.text = self.PollDetailData?.createdDate
            self.StateLbl.text = self.PollDetailData?.pollQues
            self.EnddateLbl.text =  "End date  : " + (self.PollDetailData?.endDate ?? "")
            self.VoteLbl.text = self.PollDetailData?.total
            let url = URL(string: (self.PollDetailData?.userpic ?? ""))
            self.profileImgView.kf.indicatorType = .activity
            self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
            
            self.NameLbl.textColor = UIColor.secondaryLabel
            self.SectLbl.textColor = UIColor.secondaryLabel
            self.StartLbl.textColor = UIColor.secondaryLabel
            self.EnddateLbl.textColor = UIColor.secondaryLabel
            self.StateLbl.textColor = UIColor.secondaryLabel
            self.DateLbl.textColor = UIColor.secondaryLabel
            self.VoteLbl.textColor = UIColor.secondaryLabel
            self.PollsBgView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        updateColors()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        updateMainViewHeight()
    }
    
 
    
    func updateMainViewHeight() {
            tableviewMembers.layoutIfNeeded()
            let tableContentHeight = tableviewMembers.contentSize.height
            tablViewHeightConst.constant = tableContentHeight
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callPollDetailWebService{ [self] in
            self.tableviewMembers.reloadData()
           
            if self.PollDetailData?.pollRunningStatus == "\(2)" {
                self.VoteBtn.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
                self.VoteBtn.setTitle("Voted", for: .normal)
                self.VoteBtn.isUserInteractionEnabled = false
            } else if self.PollDetailData?.pollRunningStatus == "\(1)" {
                self.VoteBtn.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                self.VoteBtn.setTitle("Vote", for: .normal)
                self.VoteBtn.isUserInteractionEnabled = true
            }
            self.NameLbl.text = self.PollDetailData?.createdBy
            self.SectLbl.text = self.PollDetailData?.neighborhood
            self.StartLbl.text = "Start date : " + (self.PollDetailData?.startDate ?? "")
            self.DateLbl.text = self.PollDetailData?.createdDate
            self.StateLbl.text = self.PollDetailData?.pollQues
            self.EnddateLbl.text =  "End date  : " + (self.PollDetailData?.endDate ?? "")
            self.VoteLbl.text = self.PollDetailData?.total
            
            if let id = UserDefaults.standard.string(forKey: "userid"),
               let idCr = UserDefaults.standard.string(forKey: "usercr") {
                print("id: \(id), idCr: \(idCr)")
                
                if id == idCr {
                    btnedit.isHidden = false
                    btnDel.isHidden = false
                } else {
                    btnedit.isHidden = true
                    btnDel.isHidden = true
                }
            } else {
                print("UserDefaults values are nil")
            }
            let url = URL(string: (self.PollDetailData?.userpic ?? ""))
            self.profileImgView.kf.indicatorType = .activity
            self.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
            if PollDetailData?.isvoted == "1" {
                self.VoteBtn.isEnabled = false
                self.VoteBtn.backgroundColor =   #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.VoteBtn.setTitleColor(UIColor.white, for: .normal)
                VoteBtn.setTitle("Voted", for: .normal)
            } else if PollDetailData?.isvoted == "0"  {
                self.VoteBtn.isHidden = false
            }
        }
    }
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            NameLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            SectLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            StartLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            EnddateLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            StateLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            DateLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            VoteLbl.textColor = #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            PollsBgView.backgroundColor = .black
        } else {
            NameLbl.textColor = UIColor.secondaryLabel
            SectLbl.textColor = UIColor.secondaryLabel
            StartLbl.textColor = UIColor.secondaryLabel
            EnddateLbl.textColor = UIColor.secondaryLabel
            StateLbl.textColor = UIColor.secondaryLabel
            DateLbl.textColor = UIColor.secondaryLabel
            VoteLbl.textColor = UIColor.secondaryLabel
            PollsBgView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            //            updateColors()
        }
    }
    
    @IBAction func submitVoteButtonTapped(_ sender: UIButton) {
        guard let pollOption = selectedPollOption else {
            print("No option selected")
            return
        }
        SVProgressHUD.show()
        callPollVotedWebService(pollOption: pollOption) { [weak self] in
            SVProgressHUD.dismiss()
            
            self?.callPollDetailWebService{
                self?.tableviewMembers.reloadData()
                self?.NameLbl.text = self?.PollDetailData?.createdBy
                self?.SectLbl.text = self?.PollDetailData?.neighborhood
                self?.StartLbl.text = "Start date: " + (self?.PollDetailData?.startDate ?? "")
                self?.DateLbl.text = self?.PollDetailData?.createdDate
                self?.StateLbl.text = self?.PollDetailData?.pollQues
                self?.EnddateLbl.text =  "End date  : " + (self?.PollDetailData?.endDate ?? "")
                self?.VoteLbl.text = self?.PollDetailData?.total
                let url = URL(string: (self?.PollDetailData?.userpic ?? ""))
                self?.profileImgView.kf.indicatorType = .activity
                self?.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "NewEvents"))
                
                if self?.PollDetailData?.isvoted == "1" {
                    self?.VoteBtn.isEnabled = false
                    self?.VoteBtn.backgroundColor =   #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                    self?.VoteBtn.setTitleColor(UIColor.white, for: .normal)
                    self?.VoteBtn.setTitle("Voted", for: .normal)
                } else if self?.PollDetailData?.isvoted == "0"  {
                    self?.VoteBtn.isHidden = false
                    
                }
            }
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
        let messageText = "Are you sure you want to remove this poll?"
        let attributedMessage = NSAttributedString(string: messageText, attributes: [
            .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        ])
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)
        let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.callPollDeleteWebService {
                self.navigationController?.popViewController(animated: true)
            }
        }
        yesAction.setValue(yesColor, forKey: "titleTextColor")
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(noColor, forKey: "titleTextColor")
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnEditPoll(_ : UIButton) {
        if PollDetailData?.editPollStatus == 1 {
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            ]
            let attributedTitle = NSAttributedString(string: "", attributes: titleFont)
            let attributedMessage = NSAttributedString(
                string: "Poll cannot be edited as voting has already started. You can delete the poll.",
                attributes: messageAttributes
            )
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else if PollDetailData?.editPollStatus == 0 {
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
        let id = UserDefaults.standard.string(forKey: "userid")
        let idName = UserDefaults.standard.string(forKey: "name")
        let Pollid = UserDefaults.standard.string(forKey: "Pollid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "pollid": Pollid ?? "",
        ]
        WebService.sharedInstance.callPollDeleteWebService(withParams: dictParams) { data in
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PollTableViewCell", for: indexPath) as? PollTableViewCell else {
                return UITableViewCell()
            }

            let option = PollDetailData?.options?[indexPath.row]

            // Set option text
            cell.lblPrcntg.text = "\(option?.percentage ?? "") %"
            cell.lblTitle.text = option?.option ?? ""
            cell.lblTitle.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            cell.lblPrcntg.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            cell.lblTitle.font =  UIFont(name: "Montserrat-Regular", size: 15)
            cell.lblPrcntg.font =  UIFont(name: "Montserrat-Regular", size: 15)
            
            cell.customBackgroundView.layer.sublayers?.removeAll(where: { $0.name == "progressLayer" })

            // Set default background
            cell.customBackgroundView.backgroundColor = UIColor.systemGray5

            if PollDetailData?.isvoted == "1" {
                // Show progress layer
                let height = cell.customBackgroundView.bounds.height
                let percentage = CGFloat(Double(option?.percentage ?? "0") ?? 0)
                let progressWidth = cell.customBackgroundView.bounds.width * percentage / 100

                let progressLayer = CALayer()
                progressLayer.name = "progressLayer"
                progressLayer.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                progressLayer.frame = CGRect(x: 0, y: 0, width: progressWidth, height: height)
                progressLayer.cornerRadius = height / 2
                cell.customBackgroundView.layer.insertSublayer(progressLayer, at: 0)
                if option?.option == PollDetailData?.userget {
                    cell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }
            }
        if PollDetailData?.pollRunningStatus == "2" {
                    cell.isUserInteractionEnabled = false
                }
            cell.selectionStyle = .none
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if PollDetailData?.isvoted == "0",
               let userCount = PollDetailData?.options?[indexPath.row].userCount,
               userCount == 0 || userCount == 1 {
                
                // Reset previously selected cell background
                if let previousIndex = selectedIndex {
                    if let previousCell = tableView.cellForRow(at: previousIndex) as? PollTableViewCell {
                        previousCell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                        previousCell.customBackgroundView.layer.cornerRadius = previousCell.customBackgroundView.frame.height / 2
                    }
                }

                // Set new selected cell background
                if let cell = tableView.cellForRow(at: indexPath) as? PollTableViewCell {
                    cell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    cell.customBackgroundView.layer.cornerRadius = cell.customBackgroundView.frame.height / 2
                }

                selectedIndex = indexPath
                selectedPollOption = PollDetailData?.options?[indexPath.row].option
                print("Selected poll option: \(selectedPollOption ?? "")")

                // ❌ Don't reload the row here
                // tableView.reloadRows(at: [indexPath], with: .none)
            }
        }



    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
    //        spacer.backgroundColor = .clear
        return spacer
    }

    
 }





