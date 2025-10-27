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
    var getData:decryptEvent?
    
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
        tableView.backgroundColor = .clear
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
            if self.getData?.data?.data.event_attender.count ?? 0 >= 10 {
                self.mainViewHeight.constant = 594
                self.tableView.isScrollEnabled = true
            } else {
                let tableHeight = self.tableView.contentSize.height
                let extraPadding: CGFloat = self.animals.count > 1 ? 55 : 55
                self.mainViewHeight.constant = tableHeight + extraPadding
            }
            if self.getData?.data?.data.event_attender.count ?? 0 >= 2  || self.getData?.data?.data.event_attender.count ?? 0 >= 2 {
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
            return getData?.data?.data.event_attender.count ?? 0
        } else if isComingFrom == "NonAttendees" {
            return getData?.data?.data.event_unattender.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AttendeesCell
        if isComingFrom == "Attendees" {
            cell.lblPerson.font  = UIFont(name: "Montserrat-Regular", size: 15)
            cell.lblPerson.text = getData?.data?.data.event_attender[indexPath.row].name
            cell.lblSector.font  = UIFont(name: "Montserrat-Regular", size: 11)
            cell.lblSector.text = getData?.data?.data.event_attender[indexPath.row].neighborhood
            let url = URL(string: (getData?.data?.data.event_attender[indexPath.row].userpic ?? ""))
            cell.imgPerson.kf.indicatorType = .activity
            cell.imgPerson.layer.cornerRadius = cell.imgPerson.frame.height / 2
            cell.imgPerson.layer.cornerRadius = cell.imgPerson.frame.width / 2
            cell.imgPerson.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
        } else if isComingFrom == "NonAttendees" {
            cell.lblPerson.font  = UIFont(name: "Montserrat-Regular", size: 15)
            cell.lblPerson.text = getData?.data?.data.event_unattender[indexPath.row].name
            cell.lblSector.font  = UIFont(name: "Montserrat-Regular", size: 11)
            cell.lblSector.text = getData?.data?.data.event_unattender[indexPath.row].neighborhood
            let url = URL(string: (getData?.data?.data.event_unattender[indexPath.row].userpic ?? ""))
            cell.imgPerson.kf.indicatorType = .activity
            cell.imgPerson.layer.cornerRadius = cell.imgPerson.frame.height / 2
            cell.imgPerson.layer.cornerRadius = cell.imgPerson.frame.width / 2
            cell.imgPerson.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print("You tapped cell number \(indexPath.row).")
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        //        if isComingFrom == "Attendees" {
        //            vc.Oid = "\(getData?.data?.data.event_attender[indexPath.row].user_id ?? 0)"
        //        } else if isComingFrom == "NonAttendees" {
        //            vc.Oid = "\(getData?.data?.data.event_unattender[indexPath.row].user_id ?? 0)"
        //        }
        //        vc.sourceViewController = "OtherProfile"
        //        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
