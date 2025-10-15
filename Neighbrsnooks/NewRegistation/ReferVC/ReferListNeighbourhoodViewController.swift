//
//  ReferListNeighbourhoodViewController.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 13/10/25.
//

import UIKit

protocol ReferListNeighbourhoodDelegate: AnyObject {
    func didSelectNeighbourhood(name: String)
}


class ReferListNeighbourhoodViewController: UIViewController {
    
    
    @IBOutlet weak var viewDataList: UIView!
    @IBOutlet weak var selectNeighbReferTblView: UITableView!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnCross: UIButton!
    var selectedItems: [String] = []


    var lblData = ["Sector 15","Sector 15","Sector 15","Sector 15","Sector 15"]
    weak var delegate: ReferListNeighbourhoodDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        selectNeighbReferTblView.delegate = self
        selectNeighbReferTblView.dataSource = self
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.isOpaque = false
        viewDataList.layer.cornerRadius = 12
        viewDataList.clipsToBounds = true
        btnCross.layer.cornerRadius = 12
        btnCross.clipsToBounds = true
    }
    
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)

    }
    

}



extension ReferListNeighbourhoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lblData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReferListNeighbourhoodTableViewCell", for: indexPath) as! ReferListNeighbourhoodTableViewCell
        let currentItem = lblData[indexPath.row]
        cell.selectListDataLbl.text = currentItem
        cell.isChecked = selectedItems.contains(currentItem)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = lblData[indexPath.row]
        selectedItems = [selectedItem] // Single selection
        tableView.reloadData()

        delegate?.didSelectNeighbourhood(name: selectedItem)
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
