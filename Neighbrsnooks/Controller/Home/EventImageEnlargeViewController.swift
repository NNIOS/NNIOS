//
//  EventImageEnlargeViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 02/09/24.
//

import UIKit

class EventImageEnlargeViewController: UIViewController {
    
    @IBOutlet weak var enlargedImageView: UIImageView!
       var imageUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = imageUrl {
                   enlargedImageView.kf.indicatorType = .activity
                   enlargedImageView.kf.setImage(with: url, placeholder: UIImage(named: "NewEvents"))
               }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }

}
