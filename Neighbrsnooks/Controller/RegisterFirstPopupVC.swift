//
//  RegisterFirstPopupVC.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 12/09/24.
//

import UIKit


protocol PopupSelectionDelegate: AnyObject {
    func didSelectItems(selectedItems: [String], forLabel tag: Int)
}


class RegisterFirstPopupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var crosspopup: UIButton!
    
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var okButton: UIButton!
    
    var allowMultipleSelection: Bool = true
    var data: [String] = []
    var selectedItems: [String] = []
    weak var delegate: PopupSelectionDelegate?
    var labelTag: Int = 0
    var hideOkButton: Bool = false 
    
    
    var IntrsetData : IntrestModel?
    var NeighbourData : NeighbourModel?
    var AddProjectData : ProffessionModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()
        tableView.delegate = self
        tableView.dataSource = self
        mainView.layer.cornerRadius = 10
        mainView.clipsToBounds = true
        crosspopup.layer.borderWidth = 2
        crosspopup.layer.borderColor = UIColor.white.cgColor
        crosspopup.layer.cornerRadius = crosspopup.height/2
        mainView.clipsToBounds = false
        self.view.bringSubviewToFront(crosspopup)

        tableView.separatorColor = UIColor.lightGray // Set the separator color
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) // Adjust the separator inset
        
        tableView.separatorStyle = .none
        
        
        self.headingLabel.font  = UIFont(name: "Montserrat-Regular", size: 16)
        self.headingLabel.tintColor = .darkGray
        if let headingLabel = headingLabel {
            switch labelTag {
            case 1:
                headingLabel.text = "Select your profession"
                okButton.isHidden = true
            case 2:
                headingLabel.text = "Select your interests"
            case 3:
                headingLabel.text = "I love my neighbourhood because"
            default:
                headingLabel.text = "Select Items"
            }
        } else {
            print("headingLabel is nil")
        }
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Semi-transparent black
        self.view.isOpaque = false
        
     }
    
    
    deinit {
           // Stop monitoring when the view controller is deallocated
           NetworkMonitor.shared.stopMonitoring()
       }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterFirstPopupTblViewCell", for: indexPath) as! RegisterFirstPopupTblViewCell
        let currentItem = data[indexPath.row]
        self.tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()

        // Set the label text
        cell.textLabel?.text = currentItem
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font  = UIFont(name: "Montserrat-Regular", size: 16)
        
        // Set the checkbox status and appearance based on selection
        cell.isChecked = selectedItems.contains(currentItem)
        cell.updateButtonAppearance()
        
        // Tag for identifying the row
        cell.checkboxButton.tag = indexPath.row
        cell.checkboxButton.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        
        
         
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = data[indexPath.row]

        if allowMultipleSelection {
            if selectedItems.contains(selectedItem) {
                selectedItems.removeAll { $0 == selectedItem }
            } else {
                selectedItems.append(selectedItem)
            }
        } else {
            selectedItems.removeAll()
            selectedItems.append(selectedItem)
        }

        if hideOkButton {
            // Directly pass the selection back to delegate and dismiss
            delegate?.didSelectItems(selectedItems: selectedItems, forLabel: labelTag)
            self.dismiss(animated: true, completion: nil)
        } else {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 // Adjust this value to control the row height
    }
    
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        delegate?.didSelectItems(selectedItems: selectedItems, forLabel: labelTag)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func crossAcction(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    
    
     
  
    
    @objc func checkboxTapped(_ sender: UIButton) {
            let index = sender.tag
            let selectedItem = data[index]
            
            // Toggle selection
            if selectedItems.contains(selectedItem) {
                selectedItems.removeAll { $0 == selectedItem }
            } else {
                selectedItems.append(selectedItem)
            }
            
            // Update the button appearance
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? RegisterFirstPopupTblViewCell {
                cell.isChecked = selectedItems.contains(selectedItem)
                cell.updateButtonAppearance()
            }
        }
    
    
    
}
