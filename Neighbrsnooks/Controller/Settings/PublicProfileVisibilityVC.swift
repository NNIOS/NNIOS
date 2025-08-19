//
//  PublicProfileVisibilityVC.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 22/05/25.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class PublicProfileVisibilityVC: UIViewController {
    
    // MARK: -  outlets
    @IBOutlet var btnEmergencyConatct: [UIButton]!
    @IBOutlet var btnContact: [UIButton]!
    @IBOutlet var btnProfession: [UIButton]!
    @IBOutlet var btnAddressLine1: [UIButton]!
    @IBOutlet var btnAddressLine2: [UIButton]!
    
    // MARK: -  varibles
    var contactNo: String?
    var addresslineone: String?
    var addresslinetwo: String?
    var profession: String?
    var emergencyContactno: String?
    var updateNewNotificationsData : NewNotificationModel?
    let id = UserDefaults.standard.string(forKey: "userid")
    
    // MARK: -  life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callUpdateNewNotificationWebService { }
    }
    
    // MARK: -  Button's Action
    @IBAction func btnBackAction(_ sender: UIButton) { // Back Button
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveAction(_ sender: UIButton) { // Save Button
        callUpdateNewNotificationWebService {
            self.updateModelFromButtons()
            self.showToast(message: "Saved")
        }
    }
    
    @IBAction func btnEmergrncyHideShow(_ sender: UIButton) { // Emergency's Contact Button
        handleRadioSelection(for: sender, in: btnEmergencyConatct) { index in
            emergencyContactno = "\(index)"
            updateNewNotificationsData?.emergencyContactno = "\(index)"
        }
    }
    
    @IBAction func btnContactHideShow(_ sender: UIButton) { // Contact Button
        handleRadioSelection(for: sender, in: btnContact) { index in
            contactNo = "\(index)"
            updateNewNotificationsData?.contactNo = "\(index)"
        }
    }
    
    @IBAction func btnProfessionHideShow(_ sender: UIButton) { // Profession Button
        handleRadioSelection(for: sender, in: btnProfession) { index in
            profession = "\(index)"
            updateNewNotificationsData?.profession = "\(index)"
        }
    }
    
    @IBAction func btnAddressLine1HideShow(_ sender: UIButton) {  // Address line 1 Button
        handleRadioSelection(for: sender, in: btnAddressLine1) { index in
            addresslineone = "\(index)"
            updateNewNotificationsData?.address = "\(index)"
        }
    }
    
    @IBAction func btnAddressLine2HideShow(_ sender: UIButton) {  // Address line 2 Button (Currently not in use)
        handleRadioSelection(for: sender, in: btnAddressLine2) { index in
            addresslinetwo = "\(index)"
//            updateNewNotificationsData?.addresslinetwo = "\(index)"
        }
    }
}

// MARK: -  Extension for PublicProfileVisibilityVC
@available(iOS 16.0, *)
extension PublicProfileVisibilityVC {
    
    func callUpdateNewNotificationWebService(_ completionClosure: @escaping () -> ()) {  // main Api calling function(API)
        var dictParams: [String: Any] = ["userid": id ?? ""]
        if let model = updateNewNotificationsData {
            dictParams["contactNo"] = model.contactNo
            dictParams["emergencyContactno"] = model.emergencyContactno
            dictParams["address"] = model.address
            dictParams["profession"] = model.profession
        }
        WebService.sharedInstance.callNewNotificationWebService(withParams: dictParams) { responseData in
            self.updateNewNotificationsData = responseData
            print("Api data response is model is : \(String(describing: self.updateNewNotificationsData))")
            DispatchQueue.main.async {
                self.updateUIFromModel()
                completionClosure()
            }
        }
    }
    
    func callSaveNotificationVisibilitySettings(completion: @escaping () -> ()) { // save notification setting calling function (Save Data)
        guard let model = updateNewNotificationsData else { return }
        let params: [String: Any] = [
            "userid": id ?? "",
            "contactNo": model.contactNo,
            "emergencyContactno": model.emergencyContactno,
            "address": model.address,
            "profession": model.profession
        ]
        WebService.sharedInstance.callNewNotificationWebService(withParams: params) { _ in completion() }
    }
    
    func updateUIFromModel() { // updating values in model
        guard let model = updateNewNotificationsData else { return }
        updateButtonSelection(buttons: btnContact, selectedValue: model.contactNo)
        updateButtonSelection(buttons: btnEmergencyConatct, selectedValue: model.emergencyContactno)
        updateButtonSelection(buttons: btnAddressLine1, selectedValue: model.address)
        updateButtonSelection(buttons: btnProfession, selectedValue: model.profession)
    }
    
    func updateButtonSelection(buttons: [UIButton], selectedValue: String?) { // changes image on UIButton
        for (index, button) in buttons.enumerated() {
            let isSelected = selectedValue == "\(index)"
            button.setImage(UIImage(named: isSelected ? "icons8-radio-button-24" : "radio-blank"), for: .normal)
            button.tag = isSelected ? 1 : 0
        }
    }
    
    func updateModelFromButtons() { // Updating model from button click
        updateNewNotificationsData?.contactNo = getSelectedIndex(from: btnContact)
        updateNewNotificationsData?.emergencyContactno = getSelectedIndex(from: btnEmergencyConatct)
        updateNewNotificationsData?.address = getSelectedIndex(from: btnAddressLine1)
        updateNewNotificationsData?.profession = getSelectedIndex(from: btnProfession)
    }
    
    func getSelectedIndex(from buttons: [UIButton]) -> String { // geting index of UIButton
        return buttons.firstIndex { $0.tag == 1 }.map { "\($0)" } ?? "0"
    }
    
    func setupUI() {
        [btnEmergencyConatct, btnContact, btnProfession, btnAddressLine1].forEach {
            setInitialRadioState(for: $0)
        }
    }
    
    private func setInitialRadioState(for buttons: [UIButton]) { // set initial image for UIButton
        buttons.forEach {
            $0.setImage(UIImage(named: "radio-blank"), for: .normal)
            $0.tag = 0
        }
    }
    
    func showToast(message: String) { // show Toast Messages
        let toastLabel = UILabel(frame: CGRect(x: 0, y: view.frame.size.height - 100, width: view.frame.size.width, height: 40))
        let font = UIFont(name: "Montserrat-Regular", size: 13) ?? .systemFont(ofSize: 13)
        let messageSize = (message as NSString).size(withAttributes: [.font: font])
        let desiredWidth = messageSize.width + 30
        toastLabel.frame.origin.x = (view.frame.size.width - desiredWidth) / 2
        toastLabel.frame.size.width = desiredWidth
        toastLabel.backgroundColor = UIColor(red: 0, green: 0.56, blue: 0, alpha: 0.8)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = font
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.2, delay: 0.8, options: .curveEaseOut) {
            toastLabel.alpha = 0.0
        } completion: { _ in  toastLabel.removeFromSuperview() }
    }
    
    func handleRadioSelection(for sender: UIButton, in buttons: [UIButton], updateModel: (Int) -> Void) { // handle button's Action
        guard sender.tag != 1 else { return }
        buttons.enumerated().forEach { index, button in
            let isSelected = (button == sender)
            button.setImage(UIImage(named: isSelected ? "icons8-radio-button-24" : "radio-blank"), for: .normal)
            button.tag = isSelected ? 1 : 0
            if isSelected {
                updateModel(index)
            }
        }
    }
}
// MARK: -  Ends Here
