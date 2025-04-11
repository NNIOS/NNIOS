//
//  NewMenuViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 25/07/24.
//

import UIKit

let online = ["Our GYRE","Subscribe Our YouTube Channel","Join Our Telegram Community","Let’s Expand Our Friend circle ","Share your view with us","Follow us on instagram","Let’s Connect to create future","Privacy Policy","Term & conditions","Frequently Asked Questions","Help & Support\nContact Us on support@gyrenetwork.io","Twitter Support\nhttps://twitter.com/GyreNetworkcare","App Feedback"]

let pic = ["closed-mail-envelope","closed-mail-envelope","closed-mail-envelope","closed-mail-envelope","twitter","instagram","linkedin","privacy","termsCondition","frequently","help","help","frequently"]


@available(iOS 16.0, *)
class NewMenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()

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

@available(iOS 16.0, *)
extension NewMenuViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("online.count",online.count)
        return online.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        debugPrint("indexPath.row",indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMenuTableViewCell", for: indexPath) as! NewMenuTableViewCell
        
        //cell.selectionStyle = .none
        cell.lblSubscribe.text = online[indexPath.row]
        cell.imgSubs.image =  UIImage(named: pic[indexPath.row])
               
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 1 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeighbourhoodViewController") as! NeighbourhoodViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 2 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        if indexPath.row == 3 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        if indexPath.row == 4 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 5 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
        if indexPath.row == 6 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 7 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        if indexPath.row == 8 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
           
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        if indexPath.row == 9 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 9 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 10 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 11 {
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
