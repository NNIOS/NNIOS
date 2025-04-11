//
//  Terms&ConditionViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 08/03/24.
//

import UIKit

@available(iOS 16.0, *)
class Terms_ConditionViewController: BaseViewController {

    @IBOutlet weak var lblHeading: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
