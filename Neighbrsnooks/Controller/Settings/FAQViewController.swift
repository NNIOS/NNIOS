//
//  FAQViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 01/10/24.
//

import UIKit
@available(iOS 16.0, *)
class FAQViewController: UIViewController {

    @IBOutlet weak var tableviewMembers: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var FAQView: UIView!
    
    var FAQData : FAQModel?
    var expandedIndexPaths = Set<IndexPath>() // Track which rows are expanded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        callFAQWebService{
           
            self.tableviewMembers.reloadData()
            
           
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        
        
        callFAQWebService{
           
            self.tableviewMembers.reloadData()
            
           
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
           
            tableviewMembers.backgroundColor = .black
            FAQView.backgroundColor = .black
        } else {
            // Light mode mein storyboard ke original colors preserve karna
           

            // Light mode mein PollsView ka background red karna
            tableviewMembers.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            FAQView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
           // tableviewMembers.separatorStyle = .none
        }
    }

}

@available(iOS 16.0, *)
extension FAQViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FAQData?.faqdata?.count ?? 0
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell", for: indexPath) as! FAQTableViewCell
        
        let faqItem = FAQData?.faqdata?[indexPath.row]
        cell.lblQuestion.text = FAQData?.faqdata?[indexPath.row].question
        cell.lblAnswer.text = FAQData?.faqdata?[indexPath.row].answer
      
        
        cell.lblQuestion.font = UIFont(name: "Montserrat-Regular", size: 16)
        cell.lblAnswer.font = UIFont(name: "Montserrat-Regular", size: 15)
        
        cell.lblAnswer.isHidden = !expandedIndexPaths.contains(indexPath)
        
        let isExpanded = expandedIndexPaths.contains(indexPath)
               let arrowImageName = isExpanded ? "upward-arrow" : "downward-arrow" // Use your image names
               cell.arrowImageView.image = UIImage(named: arrowImageName)
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Toggle the expanded/collapsed state
           if expandedIndexPaths.contains(indexPath) {
               expandedIndexPaths.remove(indexPath) // Collapse (hide the answer)
           } else {
               expandedIndexPaths.insert(indexPath) // Expand (show the answer)
           }
           
           // Reload the clicked row with animation to reflect the changes
           tableView.reloadRows(at: [indexPath], with: .automatic)
       }
       
       // Optional: Dynamic row height based on content when expanded or collapsed
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           if expandedIndexPaths.contains(indexPath) {
               return UITableView.automaticDimension // Dynamic height when answer is shown
           } else {
               return 65.0 // Default height when only the question is shown
           }
       }
    
   
    func callFAQWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let dictParams: Dictionary<String, Any> = [:
                                                    
                                                                        ]
          WebService.sharedInstance.callFAQWebService(withParams: dictParams) { data in
            self.FAQData = data
             
            completionClosure()
          }
        }
    
    
}
//tfMobile.text = UserDefaults.standard.object(forKey: "phoneNo") as? String
