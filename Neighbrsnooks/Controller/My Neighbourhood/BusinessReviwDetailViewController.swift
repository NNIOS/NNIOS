//
//  BusinessReviwDetailViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 06/08/24.
//

import UIKit


@available(iOS 16.0, *)
class BusinessReviwDetailViewController: BottomPopupViewController {
    @IBOutlet weak var tableviewMembers: UITableView!
    
    var BusinessReviewData : BusinessReviewModel?
    var BusinesReviewDelete : DeleteBusinessReviewModel?
    var business_id : String?
//    var callback : ((_ range : String?) ->())?
    var callback: (() -> Void)?

    var reviewID: String?  // ID store karne ke liye variable
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 2.0 // 2 seconds hold
        tableviewMembers.addGestureRecognizer(longPressGesture)
        callBussinesReviewDetailPostWebService{
            self.tableviewMembers.reloadData()
            self.updatePopupHeight()
            // Do any additional setup after loading the view.
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkMonitor.shared.startMonitoring()
        callBussinesReviewDetailPostWebService{
            self.tableviewMembers.reloadData()
            self.updatePopupHeight()
            // Do any additional setup after loading the view.
        }
    }
    
    deinit {
        // Stop monitoring when the view controller is deallocated
        NetworkMonitor.shared.stopMonitoring()
    }
    
    
    
    override var popupHeight: CGFloat { return height ?? CGFloat(SCREEN_HEIGHT - 10) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(0) }
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: tableviewMembers) // TableView ke andar ka touch point
        guard let indexPath = tableviewMembers.indexPathForRow(at: point) else { return }
        
        if gesture.state == .began {
            showDeleteConfirmation(for: indexPath)
        }
    }
    
    func showDeleteConfirmation(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Review", message: "Are you sure you want to delete this review?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // ✅ API Call to Delete Review
            self.callBussinesReviewDeleteWebService { message in
                DispatchQueue.main.async {
                    self.deleteReview(at: indexPath)
                    
                    // ✅ If last review is deleted, dismiss VC
                    if self.BusinessReviewData?.listdata?.isEmpty == true {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteReview(at indexPath: IndexPath) {
        BusinessReviewData?.listdata?.remove(at: indexPath.row)
        tableviewMembers.deleteRows(at: [indexPath], with: .fade)

        if BusinessReviewData?.listdata?.isEmpty == true {
            print("✅ All reviews deleted, dismissing popup...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func updatePopupHeight() {
        let tableHeight = tableviewMembers.contentSize.height
        let maxHeight = UIScreen.main.bounds.height - 100 // ✅ Maximum allowed height
        let calculatedHeight = min(tableHeight + 50, maxHeight) // ✅ Adjust with padding
        
        self.height = calculatedHeight
        self.view.layoutIfNeeded() // ✅ Update UI
    }
    
    
}
@available(iOS 16.0, *)
extension BusinessReviwDetailViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BusinessReviewData?.listdata?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessReviwDetailTableViewCell", for: indexPath) as! BusinessReviwDetailTableViewCell
        cell.lblName.text = BusinessReviewData?.listdata?[indexPath.row].username
        cell.lblDSec.text = BusinessReviewData?.listdata?[indexPath.row].review
        cell.lblSec.text = BusinessReviewData?.listdata?[indexPath.row].neighbrhood
        let url = URL(string: (BusinessReviewData?.listdata?[indexPath.row].userpic ?? ""))
        cell.profileImgView.kf.indicatorType = .activity
        cell.profileImgView.kf.setImage(with:url ,placeholder: UIImage(named: "defaultImage"))
        cell.lblDSec.font = UIFont(name: "Montserrat-Regular", size: 15)
        cell.lblSec.font = UIFont(name: "Montserrat-Regular", size: 14)
        cell.lblName.font = UIFont(name: "Montserrat-Regular", size: 15)
        return cell
    }
    
    func callBussinesReviewDetailPostWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "business_id": business_id ?? ""
        ]
        WebService.sharedInstance.callBussinesReviewDetailPostWebService(withParams: dictParams) { data in
            self.BusinessReviewData = data
            if let firstReview = data.listdata?.first {
                self.reviewID = firstReview.id  // ID store karna
                print("✅ Review ID Stored: \(self.reviewID ?? "No ID")")
            }
            completionClosure()
        }
    }
    
    func callBussinesReviewDeleteWebService(_ completionClosure: @escaping (String) -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: [String: Any] = [
            "userid": id ?? "",
            "review_id": reviewID ?? ""
        ]
        print("📡 Sending API Request with Params: \(dictParams)")
        
        WebService.sharedInstance.callBussinesReviewDeleteWebService(withParams: dictParams) { response in
            print("✅ API Response: \(response)")
            
            if response.status.lowercased() == "failed" {
                DispatchQueue.main.async {
                    self.showAutoDismissAlert(message: "Error: \(response.message)")
                    completionClosure(response.message)
                }
                return
            }

            self.BusinesReviewDelete = response
            
            DispatchQueue.main.async {
                self.showAutoDismissAlert(message: response.message)
                completionClosure(response.message)
            }

            self.callBussinesReviewDetailPostWebService {
                DispatchQueue.main.async {
                    self.tableviewMembers.reloadData()
                    self.updatePopupHeight()

                    /// ✅ Always call callback so main screen updates
                    self.callback?()
                    
                    // ✅ Dismiss only if all reviews deleted
                    if self.BusinessReviewData?.listdata?.isEmpty == true {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }

    
    
    
    
//
//    func callBussinesReviewDeleteWebService(_ completionClosure: @escaping (String) -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let dictParams: [String: Any] = [
//            "userid": id ?? "",
//            "review_id": reviewID ?? ""
//        ]
//        print("📡 Sending API Request with Params: \(dictParams)")
//        WebService.sharedInstance.callBussinesReviewDeleteWebService(withParams: dictParams) { response in
//            print("✅ API Response: \(response)")
//            if response.status.lowercased() == "failed" {
//                print("🚨 Error: \(response.message)")
//                DispatchQueue.main.async {
//                    self.showAutoDismissAlert(message: "Error: \(response.message)")
//                    completionClosure(response.message)
//                }
//                return
//            }
//            self.BusinesReviewDelete = response
//            DispatchQueue.main.async {
//                self.showAutoDismissAlert(message: response.message)
//                completionClosure(response.message)
//            }
//            self.callBussinesReviewDetailPostWebService {
//                DispatchQueue.main.async {
//                    self.tableviewMembers.reloadData()
//                    self.updatePopupHeight()
//                    // ✅ Agar sare reviews delete ho gaye, to popup dismiss ho jaye
//                    if self.BusinessReviewData?.listdata?.isEmpty == true {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
}
