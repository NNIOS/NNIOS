//
//  GroupListVC.swift
//  MarketVC
//
//  Created by Abdul Aleem on 11/09/25.
//

import UIKit
import Kingfisher

class GroupListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var btnAllGroupType: [UIButton]!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    var groupid : String?
    var userName : String?
    var groupName : String?
    var refreshTimer: Timer?
    var userId:String = "2725"
    var currentPage: Int = 1
    var lastPage: Int = 1
    var isLoading: Bool = false
    var sourceViewController:String?
    var objGrpListData:  GropsListModel?
    var filtered: [GroupItem] = []
    var getGoin :String?
    var groupType:String?
    var objGroupList: [GroupItem]?
    var selectedGroupTypeTag: Int = 0
    var objDeleteGroup: DeleteGroupResponse?
    var selectedRowIndex: Int?
    var objGroupJoin:GroupJoinResponse?
    var objGroupExit:GroupExitResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtonUI()
        registerTableCell()
        setupRefreshControl()
        if Reach().isInternet() {
            currentPage = 1
            groupListAPI(page: currentPage)
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
        searchTF.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reach().isInternet() {
            currentPage = 1
            isLoading = false
            groupListAPI(page: currentPage)
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        searchView.isHidden = false
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        searchView.isHidden = true
        searchTF.text = ""
        filterContent()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCreateGroupAction(_ sender: UIButton) {
        if Reach().isInternet() {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController") as? CreateGroupViewController else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    @IBAction func btnAllGroupTypeAction(_ sender: UIButton) {
        selectedGroupTypeTag = sender.tag
        btnAllGroupType.forEach {
            $0.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
            $0.setTitleColor(#colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1), for: .normal)
        }
        sender.backgroundColor = #colorLiteral(red: 0, green: 0.6, blue: 0.2, alpha: 1)
        sender.setTitleColor(.white, for: .normal)
        filterContent()
    }
    
    @objc func buttonSelected(sender: UIButton) {
        let index = sender.tag
        guard index >= 0 && index < filtered.count else { return }
        let item = filtered[index]
        let groupId = item.groupid ?? 0
        guard Reach().isInternet() else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
            return
        }
        if item.getjoin == "join" && sender.titleLabel?.text == "join" {
            groupJoinApi(groupId: groupId, index: index)
            print("seelcted groupid is :\(self.groupid ?? "")")
        } else if item.getjoin == "joined" && sender.titleLabel?.text == "Exit" {
            print("Tapped Exit for groupId: \(groupId)")
            confirmAlert(title: "", msg: "Are you sure you want to exit from this group?", groupId: groupId, index: index)
        }
    }
}

extension GroupListVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Table will display \(filtered.count) rows")
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        cell.selectionStyle = .none
        let item = filtered[indexPath.row]
        cell.configure(with: item)
        cell.btnRequest.tag = indexPath.row
        cell.btnRequest.addTarget(self, action: #selector(buttonSelected(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GroupCell else { return }
        let item = filtered[indexPath.row]
        if item.getjoin == "joined" || item.getjoin == "owner" {
            if Reach().isInternet() {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsViewController") as? GroupDetailsViewController else { return }
                vc.jGroupId = item.groupid
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
            }
        } else if item.getjoin == "join" &&  item.getjoin == "owner"{
            if cell.btnRequest.titleLabel?.text == "Approval Pending" {
                alertToast(Message: "Please wait for Approval")
            } else {
                alertToast(Message: "It's private group please send request to join")
            }
        } else if item.getjoin == "pending" {
            alertToast(Message: "You can not tap on this")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension GroupListVC {
    
    func setupUI() {
        searchTF.delegate = self
        searchView.isHidden = true
    }
    
    func registerTableCell() {
        tableView.showsVerticalScrollIndicator = false
        self.tableView.register(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
    }
    
    func setupButtonUI() {
        for button in btnAllGroupType {
            button.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1), for: .normal)
        }
        if let firstButton = btnAllGroupType.first {
            firstButton.backgroundColor = #colorLiteral(red: 0.0, green: 0.6, blue: 0.2, alpha: 1)
            firstButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func getGroupId(at index: Int) -> Int? {
        guard index >= 0 && index < filtered.count else { return nil }
        return filtered[index].groupid
    }
    
    
    func groupListAPI(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        var request: GroupListing_Request!
        var param: [String: Any] = [:]
        if sourceViewController == "Menu" {
            request = GroupListing_Request(type: "neighbourhood", page: page)
            param = ["type": "neighbourhood", "page": page] as [String : Any]
        }
        print("param is :\(param)")
        let viewModel = GroupList_VM()
        viewModel.fetchGroupListData(parameter: param, request: request) { response in
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.isLoading = false
                if let encryptedData = response?.data {
                    let httpUtility = HttpUtility()
                    httpUtility.decryptGroupListData(encryptedData: encryptedData) { decryptedResponse in
                        if let groupList = decryptedResponse, let groupData = groupList.data {
                            self.lastPage = groupData.last_page ?? 1
                            if page == 1 {
                                self.objGroupList = groupData.groups
                            } else {
                                self.objGroupList? += groupData.groups ?? []
                            }
                            self.applyFilter()
                        }
                    }
                }
            }
        }
    }
    
    func groupJoinApi(groupId: Int, index: Int) {
        let request = GroupJoin_Request(group_id: groupId)
        let param: [String: Any] = ["group_id": request.group_id]
        print("param is :\(param)")
        let viewModel = GroupJoin_VM()
        viewModel.groupJoin(parameter: param, request: request) { joinResponse in
            self.objGroupJoin = joinResponse
            print("Join group response: \(String(describing: self.objGroupJoin))")
            self.filtered[index].getjoin = (index < self.filtered.count && self.filtered[index].group_type?.lowercased() == "public") ? "joined" : "pending"
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }

    
    func groupExitAPi(groupId: Int, index: Int) {
        let request = GroupExit_Request(group_id: groupId)
        let param: [String: Any] = [ "group_id": request.group_id ]
        print("param is :\(param)")
        let viewModel = GroupExit_VM()
        viewModel.groupExit(parameter: param, request: request) { exitResponse in
            self.objGroupExit = exitResponse
            print("Exit group data is: \(String(describing: self.objGroupExit))")
            self.filtered[index].getjoin = "join"
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }
    
    func applyFilter() {
        filterContent()
    }
    
    func filterContent() {
        guard let fullList = objGroupList else { return }
        let groupTypeFiltered: [GroupItem] = {
            switch selectedGroupTypeTag {
            case 0: return fullList
            case 1: return fullList.filter { $0.getjoin == "owner" }
            case 2: return fullList.filter { $0.getjoin == "joined" }
            case 3: return fullList.filter { $0.group_type == "Private" }
            case 4: return fullList.filter { $0.group_type == "Public" }
            default: return []
            }
        }()
        DispatchQueue.main.async {
            if let searchText = self.searchTF.text, !searchText.isEmpty {
                self.filtered = groupTypeFiltered.filter {
                    ($0.group_name?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                    ($0.group_type?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                    ($0.username?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                    ($0.neighborhood?.localizedCaseInsensitiveContains(searchText) ?? false)
                }
            } else {
                self.filtered = groupTypeFiltered
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshGroupList), for: .valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0, green: 0.6, blue: 0.2, alpha: 1)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshGroupList() {
        if Reach().isInternet() {
            currentPage = 1
            isLoading = false
            groupListAPI(page: currentPage)
        } else {
            tableView.refreshControl?.endRefreshing()
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    func confirmAlert(title:String, msg:String, groupId: Int, index: Int) {
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let attributedMessage = NSAttributedString(string: msg, attributes: [
            .font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17),.foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)])
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        let yesColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)
        let noColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in self.groupExitAPi(groupId: groupId, index: index) }
        yesAction.setValue(yesColor, forKey: "titleTextColor")
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(noColor, forKey: "titleTextColor")
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension GroupListVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoading else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height
        if offsetY > contentHeight - tableViewHeight - 100 {
            if currentPage < lastPage {
                currentPage += 1
                groupListAPI(page: currentPage)
            }
        }
    }
}
extension GroupListVC :UITextFieldDelegate {
    @objc func searchTextChanged(_ textField: UITextField) {
        filterContent()
    }
}
