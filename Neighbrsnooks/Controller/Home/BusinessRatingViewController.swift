//
//  BusinessRatingViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 08/08/24.
//
protocol ConfirmRatingDelegate {
  func tapConfirm() -> Void
}
import UIKit

@available(iOS 16.0, *)
class BusinessRatingViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblRate: UILabel!
    var delegate: ConfirmRatingDelegate?
    var BusinessRatingtData : BusinessRatingModel?
    var business_id : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()

        self.lblRate.font = UIFont(name: "Montserrat-Regular", size: 15)
        
        setupButtons()
        // Do any additional setup after loading the view.
    }
    deinit {
          // Stop monitoring when the view controller is deallocated
          NetworkMonitor.shared.stopMonitoring()
      }
    var rating = 0 {
           didSet {
               updateButtonSelectionStates()
           }
       }
    
    @IBAction func tapDismiss(_ sender: UIButton) {
          self.dismiss(animated: true)
    }
    
    @IBAction func ExitYesBtn(_ sender: UIButton) {
        print("⭐ ExitYesBtn tapped")
        
        sender.isUserInteractionEnabled = false // 👈 prevent double tap
        // Optionally show loader here
        callRatingBusinessWebService {
            print("✅ API completed")
            
            DispatchQueue.main.async {
                self.delegate?.tapConfirm()
                self.dismiss(animated: true)
            }
        }
    }
 
    private func setupButtons() {
           for _ in 0..<5 {
               let button = UIButton()
               
               // Set empty star image for normal state
               button.setImage(UIImage(systemName: "star"), for: .normal)
               // Set filled star image for selected state
               button.setImage(UIImage(systemName: "star.fill"), for: .selected)
               
               // Add action to button
               button.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
               button.translatesAutoresizingMaskIntoConstraints = false
                          button.widthAnchor.constraint(equalToConstant: 40).isActive = true
                          button.heightAnchor.constraint(equalToConstant: 40).isActive = true
               
               // Add button to stack view
               stackView.addArrangedSubview(button)
           }
           
           updateButtonSelectionStates()
       }
       
       @objc func ratingButtonTapped(_ button: UIButton) {
           guard let index = stackView.arrangedSubviews.firstIndex(of: button) else {
               return
           }
           // Calculate the rating based on button tapped
                  let selectedRating = index + 1
                  
                  if selectedRating == rating {
                      // Reset to 0 if the same star is tapped twice
                      rating = 0
                  } else {
                      rating = selectedRating
                  }
              }
              
              private func updateButtonSelectionStates() {
                  for (index, button) in stackView.arrangedSubviews.enumerated() {
                      if let button = button as? UIButton {
                          // Update the button's selected state
                          button.isSelected = index < rating
                      }
                  }
              }
    
    func callRatingBusinessWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let Busid = UserDefaults.standard.string(forKey: "Businessid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "neighbrhood":idNeighbour ?? "",
            "business_id":Busid ?? "",
            "rateno":  rating
            
        ]
        WebService.sharedInstance.callRatingBusinessWebService(withParams: dictParams) { data in
            self.BusinessRatingtData = data
            completionClosure()
        }
    }
}
