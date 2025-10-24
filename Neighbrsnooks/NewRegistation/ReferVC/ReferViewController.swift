//
//  ReferViewController.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 13/10/25.
//

import UIKit

class ReferViewController: BaseViewController {

    @IBOutlet weak var lblNeighborhood: UILabel!
    @IBOutlet weak var viewNeighborhood: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var txtReferName: UITextField!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var btnRefer: UIButton!
    @IBOutlet weak var lblYouCan: UILabel!
   
    
    var referralModel = [ReferralResponse]()
    var referralModelList = [ReferralResponseList]()
    var selectedNeighbourhoodId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        btnRefer.layer.cornerRadius = 12
        btnRefer.clipsToBounds = true
        viewName.layer.cornerRadius = 12
        viewName.clipsToBounds = true
        viewPhone.layer.cornerRadius = 12
        viewPhone.clipsToBounds = true
        viewNeighborhood.layer.cornerRadius = 12
        viewNeighborhood.clipsToBounds = true
        // Add tap gesture to viewNeighborhood
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(neighborhoodTapped))
        viewNeighborhood.isUserInteractionEnabled = true
        viewNeighborhood.addGestureRecognizer(tapGesture)
        lblYouCan.font = UIFont(name: "Montserrat-Regular", size: 16)
        lblNeighborhood.font = UIFont(name: "Montserrat-Regular", size: 16)
        callReferralAPI()
        
     }
    
    @objc func neighborhoodTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ReferListNeighbourhoodViewController") as? ReferListNeighbourhoodViewController {
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }

    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
     

    // MARK: - Button Action
    @IBAction func actionRefer(_ sender: Any) {
        guard let referredName = txtReferName.text,
              !referredName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(message: "Please enter full name")
            return
        }

        guard let referredPhone = txtPhone.text,
              !referredPhone.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(message: "Please enter phone number")
            return
        }

        if !isValidPhoneNumber(referredPhone) {
            showAlert(message: "Please enter a valid phone number")
            return
        }

        // ✅ Direct API call on button click
        createReferral(sender: sender)
    }

    // MARK: - Create Referral API
    func createReferral(sender: Any) {
        guard let referrerUserId = Int(UserDefaults.standard.string(forKey: "userid") ?? ""),
              let referredName = txtReferName.text, !referredName.isEmpty,
              let referredPhone = txtPhone.text, !referredPhone.isEmpty else {
            showAlert(message: "Please fill all details")
            return
        }

        guard let neighborhoodIdString = selectedNeighbourhoodId,
              let neighborhoodIdInt = Int(neighborhoodIdString) else {
            showAlert(message: "Please select a neighbourhood")
            return
        }

        let params: [String: Any] = [
            "referrer_user_id": referrerUserId,
            "referred_name": referredName,
            "referred_phone": referredPhone,
            "neighbourhood_id": neighborhoodIdInt,
            "api": "DEV-3a9f1d2e7b8c4d6f1234abcd5678ef90"
        ]

        guard let url = URL(string: "https://dev.neighbrsnook.com/admin/api/referrals/create") else {
            showAlert(message: "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            showAlert(message: "Failed to serialize request data")
            return
        }

        print("📤 Sending referral API request with params: \(params)")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(message: "Request error: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(message: "No response data")
                }
                return
            }

            // ✅ Print the full response to verify instantly
            if let jsonString = String(data: data, encoding: .utf8) {
                print("✅ API Response: \(jsonString)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(ReferralResponse.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.success {
                        // ✅ API success message
                        self.showAlert(message: "Referral created successfully!") {
                            // After OK, open share screen
                            let appLink = "https://neighbrsnook.com/open-app"
                            let referralMessage = """
                            Hi! I am referring you to join me on Neighbrsnook - it's a safe, real-neighbour app to stay connected and strengthen our community.

                            You have been invited by: \(decodedResponse.data?.referredName ?? "")
                            Neighbourhood ID: \(decodedResponse.data?.neighbourhoodId ?? 0)
                            Referral Code: \(decodedResponse.data?.referralCode ?? "")

                            Download here: \(appLink)
                            """

                            let activityVC = UIActivityViewController(activityItems: [referralMessage], applicationActivities: nil)
                            if let popover = activityVC.popoverPresentationController {
                                popover.sourceView = self.view
                                if let button = sender as? UIView {
                                    popover.sourceRect = button.frame
                                }
                            }
                            self.present(activityVC, animated: true)
                        }
                    } else {
                        // ❌ API returned failure
                        self.showAlert(message: decodedResponse.message)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(message: "Failed to parse response: \(error.localizedDescription)")
                }
            }
        }

        // ✅ Hit the API instantly on button click
        task.resume()
    }

    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Neighbrsnook", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }


    
    
    func callReferralAPI() {
        let userID = UserDefaults.standard.string(forKey: "userid") ?? ""
        let page = 1
        let perPage = 10
        let apiKey = "DEV-3a9f1d2e7b8c4d6f1234abcd5678ef90"

        
        let urlString = "https://dev.neighbrsnook.com/admin/api/referrals/user-referrals?user_id=\(userID)&page=\(page)&per_page=\(perPage)&api=\(apiKey)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let decoder = JSONDecoder()
                let referralResponse = try decoder.decode(ReferralResponseList.self, from: data)
                print("Referral API Response: \(referralResponse)")

                DispatchQueue.main.async {
                    
                }
            } catch {
                print("Error decoding response: \(error)")
            }
        }
        task.resume()
    }

    
}


extension ReferViewController: ReferListNeighbourhoodDelegate {
    func didSelectNeighbourhood(name: String, id: String) {
        lblNeighborhood.text = name
        selectedNeighbourhoodId = id
    }
}
