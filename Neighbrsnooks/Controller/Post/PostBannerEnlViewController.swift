//
//  PostBannerEnlViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 02/07/24.
//

import UIKit

class PostBannerEnlViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    //   var imgData: [String] = [] // Assuming imgData is an array of image URLs or names
       var userName: String = ""
    
    var PostListData : PostListModel?
    var imgData = [PostImage]()
   // var imgData: [UIImage] = []
    var thisWidth:CGFloat = 0
    var UserName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let firstImage = imgData.first {
//                   downloadImage(from: firstImage.url)
//               }

        // Do any additional setup after loading the view.
    }
    
    func downloadImage(from url: String) {
           guard let url = URL(string: url) else { return }
           
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   print("Failed to download image")
                   return
               }
               
               DispatchQueue.main.async {
                   self.imageView.image = UIImage(data: data)
               }
           }
           task.resume()
       }
    

   
}
