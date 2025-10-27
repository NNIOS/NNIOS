//
//  InternetConnectionVC.swift
//  Manish
//
//  Created by Manish Mishra on 09/10/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class InternetConnectionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

     @IBAction func tapTryAgainButton(_ sender: Any) {
//        if CommonMethods.isInternetAvailable() {
        if Reach().isInternet() == true {
            self.navigationController?.popViewController(animated: false)
        }
     }

}
