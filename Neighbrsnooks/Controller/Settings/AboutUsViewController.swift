//
//  AboutUsViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 06/02/25.
//

import UIKit
@available(iOS 16.0, *)
class AboutUsViewController: UIViewController {
    
    var AbouusData : AboutusModel?
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var AboutLbl: UILabel!
    @IBOutlet weak var AboutusLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.AboutusLbl.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.AboutLbl.font = UIFont(name: "Montserrat-Regular", size: 15)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callAboutUsWebService{
            self.AboutLbl.text = self.AbouusData?.nbdata?.first?.aboutus
        }
       

    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    func callAboutUsWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        
        // Retrieve the updated neighborhood ID from UserDefaults
       
        
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "appkey":  "abc1239",
           
        ]
        
        WebService.sharedInstance.callAboutUsWebService(withParams: dictParams) { data in
            self.AbouusData = data
           
            
            completionClosure()
        }
    }

}
