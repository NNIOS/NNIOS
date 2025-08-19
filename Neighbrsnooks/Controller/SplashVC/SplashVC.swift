//
//  SplashVC.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 12/08/25.
//

import UIKit

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              if let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                  self.navigationController?.pushViewController(vc, animated: true)
              }
          }
      }
    }
