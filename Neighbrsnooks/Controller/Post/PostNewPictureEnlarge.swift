//
//  PostNewPictureEnlarge.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 01/07/24.
//

import UIKit

class PostNewPictureEnlarge: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
       var selectedImge: UIImage?
       
    
    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = selectedImge

        // Do any additional setup after loading the view.
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
