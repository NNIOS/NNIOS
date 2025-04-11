//
//  FirstViewController.swift
//  HathMe
//
//  Created by Mama on 17/02/23.
//  Copyright © 2023 Qanvus Technologies Private Limited. All rights reserved.
//

import UIKit

@available(iOS 16.0, *)
class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnLogin(_ sender: UIButton) {
     
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
   

}
