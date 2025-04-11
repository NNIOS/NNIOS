//
//  SelectWeekDaysPopupVC.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 06/02/25.
//

import UIKit

protocol SelectWeekDaysDelegate: AnyObject {
    func didSelectWeekDays(_ selectedDays: [String])
}

class SelectWeekDaysPopupVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tblSelectWeekDay: UITableView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    var weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    weak var delegate: SelectWeekDaysDelegate?
    var selectedDays: [String] = []  // ✅ Selected items store karne ke liye
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.tblSelectWeekDay.dataSource = self
        self.tblSelectWeekDay.delegate = self
         
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
         
        tblSelectWeekDay.separatorStyle = .none
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Semi-transparent black
        self.view.isOpaque = false
        tblSelectWeekDay.showsVerticalScrollIndicator = false  // ✅ Scroll indicator hide karein
      
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectWeekDaysPopuptblViewCell", for: indexPath) as! SelectWeekDaysPopuptblViewCell
        let day = weekDays[indexPath.row]
        let isSelected = selectedDays.contains(day)
        cell.configure(with: day, isSelected: isSelected)
        cell.toggleSelection = { [weak self] in
            self?.toggleSelection(for: indexPath)
        }
        
        return cell
    }
    
    
    
    // ✅ Row Select hote hi radio button bhi select ho
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleSelection(for: indexPath)
    }
    
    private func toggleSelection(for indexPath: IndexPath) {
        let day = weekDays[indexPath.row]
        
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
        
        tblSelectWeekDay.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    @IBAction func actionOk(_ sender: Any) {
        delegate?.didSelectWeekDays(selectedDays)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
        
    }
    
    
    
}


