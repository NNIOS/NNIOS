//
//  ChatMemberViewController.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 01/05/24.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class ChatMemberViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var MembersLbl: UILabel!
    @IBOutlet weak var DMView: UIView!
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    var ChatMemberData : ChatMemberModel?
    var filteredChatData: ChatMemberModel? // Holds filtered poll data for search results
      var searchWorkItem: DispatchWorkItem?
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchView.isHidden = true
        tfSearch.delegate = self
        self.tableviewMembers.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    func setRefreshController() {
        refreshControl.addTarget(self, action: #selector(refreshPageAction), for: .valueChanged)
        tableviewMembers.refreshControl = refreshControl
    }
    
    @objc func refreshPageAction() {
        refreshPage()
    }
    
    func refreshPage() {
        callChatMemberListWebService(searchQuery: "") {
            self.tableviewMembers.reloadData()
            self.tableviewMembers.refreshControl?.endRefreshing()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.MembersLbl.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        
        self.searchView.isHidden = true
        SVProgressHUD.show()
        
     //   callHomeWebService()
        callChatMemberListWebService(searchQuery: "") {
                   SVProgressHUD.dismiss()
                   self.tableviewMembers.reloadData()
               }

    }
    
    @IBAction func btnSearch(_ : UIButton){

        self.searchView.isHidden = false

       }
    
    @IBAction func btncancelSearch(_ : UIButton){

        self.searchView.isHidden = true
               self.tfSearch.text = ""
        callChatMemberListWebService(searchQuery: "") {
                   self.tableviewMembers.reloadData()
               }

       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           let currentText = textField.text ?? ""
           let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

           // Cancel the previous work item to avoid multiple API calls
           searchWorkItem?.cancel()

           // Create a new work item for the search
           searchWorkItem = DispatchWorkItem {
               // Call the API with the updated search text
               self.callChatMemberListWebService(searchQuery: updatedText) {
                   self.tableviewMembers.reloadData()
               }
           }

           // Execute the work item after a delay of 0.5 seconds
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchWorkItem!)

           return true
       }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           super.traitCollectionDidChange(previousTraitCollection)
           
           // Check if interface style has changed
           if #available(iOS 13.0, *) {
               if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                   updateColors()
               }
           }
       }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColors()
    }
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
           
            DMView.backgroundColor = .black
        } else {
            // Light mode mein storyboard ke original colors preserve karna
           

            // Light mode mein PollsView ka background red karna
            DMView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            tableviewMembers.separatorStyle = .none
        }
    }
}

@available(iOS 16.0, *)
extension ChatMemberViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredChatData?.listdata.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMemberTableViewCell", for: indexPath) as! ChatMemberTableViewCell
        
        cell.lblName.text = filteredChatData?.listdata[indexPath.row].fullname
        cell.lblSec.text = filteredChatData?.listdata[indexPath.row].neighbrhood
        
        cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 13)
        
      //  cell.profileImgView.image = UIImage(named: [indexPath.row]
        
        let url = URL(string: (filteredChatData?.listdata[indexPath.row].userpic ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
        
       // cell.btnOtherProfile.tag = indexPath.row
      //  cell.btnOtherProfile.addTarget(self, action: #selector(onProfileClick(_:)), for: .touchUpInside)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController")as! MessageViewController
        vc.otherid = ChatMemberData?.listdata[indexPath.row].id ?? ""

        vc.userImage = ChatMemberData?.listdata[indexPath.row].userpic

        vc.userName = self.ChatMemberData?.listdata[indexPath.row].fullname
       /// vc.otherid = self.ChatMemberData?.listdata[indexPath.row].id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
//        vc.otherid = MemberListData?.listdata[indexPath.row].id ?? ""
//
//
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    

    
    func callChatMemberListWebService(searchQuery: String, _ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
          let dictParams: Dictionary<String, Any> = [
                                                    "userid":id ?? "",
                                                    "nbd_id":idNeighbour ?? "",
                                                    "searchQuery": searchQuery
                                                    
                                                                        ]
        WebService.sharedInstance.callChatMemberListWebService(withParams: dictParams) { data in
            self.ChatMemberData = data

            // Filter the PollsData based on search query
            if searchQuery.isEmpty {
                self.filteredChatData = self.ChatMemberData // No filtering if search is empty
            } else {
                self.filteredChatData = ChatMemberModel(
                    status: data.status,
                    message: data.message,
                  //  verfiedMsg: data.message,
                    listdata: data.listdata.filter { $0.fullname.lowercased().contains(searchQuery.lowercased()) }
                )
            }

            // Reload the table view after filtering the data
            completionClosure()
            self.tableviewMembers.reloadData()
        }
        }
}
