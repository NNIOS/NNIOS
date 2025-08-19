//
//  AttendeesVC.swift
//  EventDeatilDemo
//
//  Created by Abdul Aleem on 16/07/25.
//

import UIKit
import Kingfisher

class AttendeesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAttendees: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    
    var isComingFrom: String?
    var animals: [String] = [String]()
    let cellReuseIdentifier = "AttendeesCell"
    var getData : EventDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        print("Getting data is : \(String(describing: getData))")
    }
    
    @IBAction func actionOK(_ sender: UIButton) {
        print("Ok is tapped")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: false)
        }
    }
}

extension AttendeesVC {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupUI() {
        self.tableView.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        if isComingFrom == "Attendees" {
            self.lblAttendees.text = "Attendees List"
        } else if isComingFrom == "NonAttendees" {
            self.lblAttendees.text = "Non-Attendees List"
        }
        mainView.layer.cornerRadius = 8
        btnOk.layer.cornerRadius = btnOk.frame.height / 2
        btnOk.layer.cornerRadius = btnOk.frame.width / 2
        self.lblAttendees.font  = UIFont(name: "Montserrat-SemiBold", size: 15)
        tableView.reloadData()
        DispatchQueue.main.async {
            self.adjustMainViewHeight()
        }
    }
    func adjustMainViewHeight() {
        tableView.layoutIfNeeded()
        if self.isComingFrom == "Attendees" || self.isComingFrom == "NonAttendees" {
            if self.getData?.userjoinmemberlist?.count ?? 0 >= 10 {
                self.mainViewHeight.constant = 594
                self.tableView.isScrollEnabled = true
            } else {
                let tableHeight = self.tableView.contentSize.height
                let extraPadding: CGFloat = self.animals.count > 1 ? 55 : 55
                self.mainViewHeight.constant = tableHeight + extraPadding
            }
            
            if self.getData?.userjoinmemberlist?.count ?? 0 >= 2  || self.getData?.userunjoinmemberlist?.count ?? 0 >= 2 {
                self.tableView.isScrollEnabled = false
            } else {
                self.tableView.isScrollEnabled = true
            }
        }
        print("Updated mainViewHeight: \(self.mainViewHeight.constant)")
    }
    
    
}

extension AttendeesVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComingFrom == "Attendees" {
            return getData?.userjoinmemberlist?.count ?? 0
        } else if isComingFrom == "NonAttendees" {
            return getData?.userunjoinmemberlist?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AttendeesCell
        if isComingFrom == "Attendees" {
            cell.lblPerson.font  = UIFont(name: "Montserrat-Regular", size: 15)
            cell.lblPerson.text = getData?.userjoinmemberlist?[indexPath.row].username
            cell.lblSector.font  = UIFont(name: "Montserrat-Regular", size: 11)
            cell.lblSector.text = getData?.userjoinmemberlist?[indexPath.row].neighbrhood
            let url = URL(string: (getData?.userjoinmemberlist?[indexPath.row].userphoto ?? ""))
            cell.imgPerson.kf.indicatorType = .activity
            cell.imgPerson.layer.cornerRadius = cell.imgPerson.frame.height / 2
            cell.imgPerson.layer.cornerRadius = cell.imgPerson.frame.width / 2
            cell.imgPerson.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
        } else if isComingFrom == "NonAttendees" {
            cell.lblPerson.font  = UIFont(name: "Montserrat-Regular", size: 15)
            cell.lblPerson.text = getData?.userunjoinmemberlist?[indexPath.row].username
            cell.lblSector.font  = UIFont(name: "Montserrat-Regular", size: 11)
            cell.lblSector.text = getData?.userjoinmemberlist?[indexPath.row].neighbrhood
            let url = URL(string: (getData?.userunjoinmemberlist?[indexPath.row].userphoto ?? ""))
            cell.imgPerson.kf.indicatorType = .activity
            cell.imgPerson.layer.cornerRadius = cell.imgPerson.frame.height / 2
            cell.imgPerson.layer.cornerRadius = cell.imgPerson.frame.width / 2
            cell.imgPerson.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        if isComingFrom == "Attendees" {
            vc.Oid = getData?.userjoinmemberlist?[indexPath.row].userid
        } else if isComingFrom == "NonAttendees" {
            vc.Oid = getData?.userunjoinmemberlist?[indexPath.row].userid
        }
        vc.sourceViewController = "OtherProfile"
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
