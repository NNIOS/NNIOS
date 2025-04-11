//
//  DeactivateViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 28/05/24.
//

import UIKit

class DeactivateViewController: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btn30: UIButton!
    @IBOutlet weak var btn60: UIButton!
    @IBOutlet weak var btn90: UIButton!
    
    var account = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func Days30BtnAction(_ sender: UIButton) {
        btn30.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btn60.setImage(UIImage(named: "radio-blank"), for: .normal)
        btn90.setImage(UIImage(named: "radio-blank"), for: .normal)
        account = "1"
//        btnPrivate.setImage(UIImage(named: "radio-blank"), for: .normal)
//        whoCanSeeList = "EveryOne"
   }
   
   @IBAction func Days60BtnAction(_ sender: UIButton) {
       btn60.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
       btn90.setImage(UIImage(named: "radio-blank"), for: .normal)
       btn30.setImage(UIImage(named: "radio-blank"), for: .normal)
       account = "0"
      
   }
    
    @IBAction func Days90BtnAction(_ sender: UIButton) {
        btn90.setImage(UIImage(named: "icons8-radio-button-24"), for: .normal)
        btn60.setImage(UIImage(named: "radio-blank"), for: .normal)
        btn30.setImage(UIImage(named: "radio-blank"), for: .normal)
        account = "0"
       
    }
}
