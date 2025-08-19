//
//  ViewDocumentVC.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 24/06/25.
//

import UIKit

class ViewDocumentVC: UIViewController {
 
    @IBOutlet weak var viewDocumentImg: UIImageView!
    
    var imageURLString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageURLString = imageURLString,
              let url = URL(string: imageURLString) {
               viewDocumentImg.kf.setImage(with: url)
           }
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

    @IBAction func action_Cross(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
}
