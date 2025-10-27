import UIKit
import SVProgressHUD
@available(iOS 16.0, *)

class PollsDetailViewController: BaseViewController, ConfirmPollDelDelegate, DeletePollViewControllerDelegate {
    
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
    var jPollId: Int?
    var id : String?
    var selectedPollOption: Int?
    var selectedIndex: IndexPath?
    var previousSelectedIndex: IndexPath?
    
    var viewModel = PollDetail_VM()
    
    var objPollDeleteData:PollDeleteResponse?
    var objPollDetailData:PollDetailsResponse?
    var objDecryptPollDetailData:PollDetailsDecryptModel?
    var objDecryptPollVoteData:PollVoteResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.SectLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.NameLbl.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        self.StartLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.EnddateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.StateLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.DateLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.VoteLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.StateLbl.numberOfLines = 0
        PollsBgView.backgroundColor = UIColor.systemBackground
        if Reach().isInternet() {
            pollDetailApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reach().isInternet() {
            pollDetailApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    func pollDetailApi() {
        let request = PollDetails_Request(poll_id: jPollId ?? 0)
        let param: [String: Any] = ["poll_id": request.poll_id]
        viewModel.fetchPollDetailData(parameter: param, request: request) { [weak self] pollListResponse in
            guard let self = self else { return }
            if let pollData = pollListResponse {
                let encryptedString = pollData.data
                self.objPollDetailData?.data = encryptedString
                DispatchQueue.main.async {
                    self.tableviewMembers.reloadData()
                    self.decryptPollDetailApi(encryptedString: encryptedString)
                }
            }
        }
    }
    
    private func decryptPollDetailApi(encryptedString: String) {
        viewModel.decryptPollDetailsData(encryptedString: encryptedString) { [weak self] decryptedResponse in
            guard let self = self else { return }
            if let decryptedData = decryptedResponse {
                DispatchQueue.main.async {
                    self.objDecryptPollDetailData = decryptedData
                    self.tableviewMembers.reloadData()
                    let item = self.objDecryptPollDetailData?.data.data
                    if item?.auth_voted == false {
                        self.VoteBtn.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
                        self.VoteBtn.setTitle("Vote", for: .normal)
                        self.VoteBtn.isUserInteractionEnabled = true
                    } else if item?.auth_voted == true {
                        self.VoteBtn.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
                        self.VoteBtn.setTitle("Voted", for: .normal)
                        self.VoteBtn.isUserInteractionEnabled = false
                    }
                    self.NameLbl.text = item?.created_by
                    self.SectLbl.text = item?.neighborhood
                    self.StartLbl.text = "Start date : " + (item?.start_date ?? "")
                    self.DateLbl.text = item?.created_date
                    self.StateLbl.text = item?.poll_ques
                    self.EnddateLbl.text = "End date  : " + (item?.end_date ?? "")
                    if let totalVotes = item?.total_vote {
                        self.VoteLbl.text = "\(totalVotes)"
                    }
                    let userID = UserDefaults.standard.string(forKey: "userId")
                    let pollUserId = item?.userid
                    if Int(userID ?? "") == pollUserId {
                        self.btnedit.isHidden = false
                        self.btnDel.isHidden = false
                    } else {
                        self.btnedit.isHidden = true
                        self.btnDel.isHidden = true
                    }
                    let url = URL(string: (item?.userpic ?? ""))
                    ImageLoader.shared.setImage(on: self.profileImgView, urlString: url?.absoluteString, placeholder: "check")
                }
            } else {
                self.alertToast(Message: "Something went wrong")
            }
        }
    }
    
    func pollDeleteApi() {
        let request = PollDetails_Request(poll_id: jPollId ?? 0)
        let param: [String: Any] = ["poll_id": request.poll_id]
        print("Param is:\(param)")
        viewModel.fetchPollDelete(parameter: param, request: request) { [weak self] pollDeleteResponse in
            self?.objPollDeleteData = pollDeleteResponse
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                print("Delete group data is: \(String(describing: self?.objPollDeleteData))")
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func pollVoteApi() {
        let request = pollVote_Request(poll_id: jPollId,option_id: selectedPollOption)
        let param: [String: Any] = ["poll_id": request.poll_id ?? 0,"option_id":request.option_id ?? 0]
        print("Param is:\(param)")
        viewModel.fetchPollVote(parameter: param, request: request) { [weak self] pollDeleteResponse in
            self?.objDecryptPollVoteData = pollDeleteResponse
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                print("poll Vote data is: \(String(describing: self?.objPollDeleteData))")
                self?.pollDetailApi()
            }
        }
    }
    
    func updateMainViewHeight() {
        tableviewMembers.layoutIfNeeded()
        let tableContentHeight = tableviewMembers.contentSize.height
        tablViewHeightConst.constant = tableContentHeight
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
        if Reach().isInternet() {
            pollVoteApi()
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    @IBAction func DeletePopUpBtnAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeletePollViewController") as! DeletePollViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
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
            self.pollDeleteApi()
        }
        yesAction.setValue(yesColor, forKey: "titleTextColor")
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(noColor, forKey: "titleTextColor")
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnEditPoll(_ : UIButton) {
        if self.objDecryptPollDetailData?.data.data.edit_poll_status == true {
            alertToast(Message: "Poll cannot be edited as voting has already started. You can delete the poll.")
        } else  {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditPollViewController") as? EditPollViewController else { return }
            vc.jPollId = objDecryptPollDetailData?.data.data.p_id ?? 0
            vc.objDecryptPollDetailData = objDecryptPollDetailData
            print("Sending poll id is: \(objDecryptPollDetailData?.data.data.p_id ?? 0)")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnProfile(_ : UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        vc.Oid = PollDetailData?.userid ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

@available(iOS 16.0, *)
extension PollsDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objDecryptPollDetailData?.data.data.options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PollTableViewCell", for: indexPath) as? PollTableViewCell else {
            return UITableViewCell()
        }
        let option = objDecryptPollDetailData?.data.data.options[indexPath.row]
        if let rawOption = option?.option {
            let cleanedOption = rawOption
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
                .replacingOccurrences(of: "\"", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            cell.lblTitle.text = cleanedOption
        } else {
            cell.lblTitle.text = ""
        }
        
        cell.lblPrcntg.text = "\(option?.percentage ?? "") %"
        
        cell.lblTitle.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        cell.lblPrcntg.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        cell.lblTitle.font =  UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblPrcntg.font =  UIFont(name: "Montserrat-Regular", size: 15)
        
        cell.customBackgroundView.layer.sublayers?.removeAll(where: { $0.name == "progressLayer" })
        cell.customBackgroundView.backgroundColor = UIColor.systemGray5
        
        if self.objDecryptPollDetailData?.data.data.auth_voted == true {
            cell.lblPrcntg.text = "\(option?.percentage ?? "") %"
        } else {
            cell.lblPrcntg.text = "0 %"
        }
        
        cell.lblTitle.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        cell.lblPrcntg.textColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        cell.lblTitle.font =  UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblPrcntg.font =  UIFont(name: "Montserrat-Regular", size: 15)
        
        cell.customBackgroundView.layer.sublayers?.removeAll(where: { $0.name == "progressLayer" })
        cell.customBackgroundView.backgroundColor = UIColor.systemGray5
        
        if self.objDecryptPollDetailData?.data.data.auth_voted == true {
            let height = cell.customBackgroundView.bounds.height
            let percentage = CGFloat(Double(option?.percentage ?? "0") ?? 0)
            let progressWidth = cell.customBackgroundView.bounds.width * percentage / 100
            let progressLayer = CALayer()
            progressLayer.name = "progressLayer"
            progressLayer.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            progressLayer.frame = CGRect(x: 0, y: 0, width: progressWidth, height: height)
            progressLayer.cornerRadius = height / 2
            cell.customBackgroundView.layer.insertSublayer(progressLayer, at: 0)
            
            //            if option?.option == PollDetailData?.userget {
            //                cell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            //            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if objDecryptPollDetailData?.data.data.auth_voted == false,
           let userCount = objDecryptPollDetailData?.data.data.options[indexPath.row].user_count,
           userCount == 0 || userCount == 1 {
            if let previousIndex = selectedIndex {
                if let previousCell = tableView.cellForRow(at: previousIndex) as? PollTableViewCell {
                    previousCell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    previousCell.customBackgroundView.layer.cornerRadius = previousCell.customBackgroundView.frame.height / 2
                }
            }
            
            if let cell = tableView.cellForRow(at: indexPath) as? PollTableViewCell {
                cell.customBackgroundView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.customBackgroundView.layer.cornerRadius = cell.customBackgroundView.frame.height / 2
            }
            
            selectedIndex = indexPath
            selectedPollOption = objDecryptPollDetailData?.data.data.options[indexPath.row].id
            print("Selected poll option: \(selectedPollOption ?? 0)")
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





