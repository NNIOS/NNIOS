//
//  BottomVC.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 03/06/25.
//

import UIKit
@available(iOS 16.0, *)

class BottomVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    
    
    var objBlockUserData : BlockUserModel?
    var is_blocked: Int?
    var blocker_userid: String?
    var blocked_userid: String?
    var onUpdateForBlock: (() -> Void)?
    var stringArray: [String]?
    var blockArray: [String]?
    var unBlockArray: [String]?
    let estimatedRowHeight: CGFloat = 45.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRegisterCell()
    }
    
    @IBAction func btnDismissAction(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}

@available(iOS 16.0, *)
extension BottomVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottomDataCell", for: indexPath) as! BottomDataCell
        if is_blocked == 0 {
            cell.lblBlock.text = "Block user"
            cell.lblBlockThisUser.text = "Block this user"
        } else if is_blocked == 1 {
            cell.lblBlock.text = "Unblock user"
            cell.lblBlockThisUser.text = "Unblock this user"
        }
        cell.selectionStyle = .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if is_blocked == 0 {
//            ConfirmAlert(titleText: "Block", messageText: "Are you sure you want to block this user ?")
//        } else if is_blocked == 1 {
//            self.ConfirmAlert(titleText: "Unblock", messageText: "Are you sure you want to unblock this user ?")
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

@available(iOS 16.0, *)
extension BottomVC {
    
    func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        blocker_userid = UserDefaults.standard.string(forKey: "userid")
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        if is_blocked == 0 {
            stringArray = ["Block User"]
        } else {
            stringArray = ["Unblock User"]
        }
    }
    
    @objc func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }

    
    func setupRegisterCell() {
        self.tableView.register(UINib(nibName: "BottomDataCell", bundle: nil), forCellReuseIdentifier: "BottomDataCell")
    }
     
//    func handleUnblockAPI(completion: @escaping () -> Void) {  // Un-Block APi dev.
//        let url = "https://neighbrsnook.com/admin/api/toggle-block-user"
//        guard let blockerId = blocker_userid else { print("Error: Missing blocker ID"); return }
//        guard let blockedId = blocked_userid else { print("Error: Missing blocked ID"); return }
//        
//        let dictParams: [String: Any] = [
//            "blocker_userid": blockerId,
//            "blocked_userid": blockedId,
//            "action": "unblock"
//        ]
//        print("Block dictParams :\(dictParams)")
//        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.POST,requestParameters: dictParams, withProgressHUD: true)
//        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
//            switch statusCode {
//            case .SUCCESS ,.CREATED:
//                do {
//                    let data = try JSONDecoder().decode(BlockUserModel.self, from: result!)
//                    self.objBlockUserData = data
//                    DispatchQueue.main.async {
//                        self.onUpdateForBlock!()
//                        self.dismiss(animated: false)
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
//                do {
//                    let data = try JSONDecoder().decode(BlockUserModel.self, from: result!)
//                    self.objBlockUserData = data
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .UNAUTHORIZED:
//                print(error?.localizedDescription ?? "")
//            default:
//                break
//            }
//        }
//    }
//     
//    func handleBlockAPI(completion: @escaping () -> Void) { // Block APi dev.
//        let url = "https://neighbrsnook.com/admin/api/toggle-block-user"
//        guard let blockerId = blocker_userid else {
//            print("Error: Missing blocker ID")
//            return
//        }
//        
//        guard let blockedId = blocked_userid else {
//            print("Error: Missing blocked ID")
//            return
//        }
//        let dictParams: [String: Any] = [
//            "blocker_userid": blockerId,
//            "blocked_userid": blockedId,
//            "action": "block"
//        ]
//        print("Block dictParams :\(dictParams)")
//        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.POST,requestParameters: dictParams, withProgressHUD: true)
//        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
//            switch statusCode {
//            case .SUCCESS ,.CREATED:
//                do {
//                    let data = try JSONDecoder().decode(BlockUserModel.self, from: result!)
//                    self.objBlockUserData = data
//                    DispatchQueue.main.async {
//                        self.onUpdateForBlock!()
//                        self.dismiss(animated: false)
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
//                do {
//                    let data = try JSONDecoder().decode(BlockUserModel.self, from: result!)
//                    self.objBlockUserData = data
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .UNAUTHORIZED:
//                print(error?.localizedDescription ?? "")
//            default:
//                break
//            }
//        }
//    }
//    
//    func ConfirmAlert(titleText: String, messageText: String) {
//        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
//        let titleColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .label
//        let messageColor: UIColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
//        let font = UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
//        let attributedTitle = NSAttributedString(string: titleText, attributes: [ .foregroundColor: titleColor, .font: font])
//        let attributedMessage = NSAttributedString(string: messageText, attributes: [.foregroundColor: messageColor, .font: font ])
//        alertController.setValue(attributedTitle, forKey: "attributedTitle")
//        alertController.setValue(attributedMessage, forKey: "attributedMessage")
//        let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
//            guard let self = self else { return }
//            if self.is_blocked == 0 {
//                self.handleBlockAPI(completion: {
//                    self.onUpdateForBlock?()
//                    self.dismiss(animated: false, completion: nil)
//                    
//                })
//            } else if self.is_blocked == 1 {
//                self.handleUnblockAPI(completion: {
//                    self.onUpdateForBlock?()
//                    self.dismiss(animated: false, completion: nil)
//                })
//            }
//        }
//        confirmAction.setValue(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), forKey: "titleTextColor")
//        let cancelAction = UIAlertAction(title: "No", style: .cancel) { [weak self] _ in
//            guard let self = self else { return }
//            self.onUpdateForBlock?()
//            self.dismiss(animated: false, completion: nil)
//        }
//        alertController.addAction(confirmAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: false, completion: nil)
//    }
}

@available(iOS 16.0, *)
extension BottomVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, touchedView.isDescendant(of: mainView) {
            return false
        }
        return true
    }
}
