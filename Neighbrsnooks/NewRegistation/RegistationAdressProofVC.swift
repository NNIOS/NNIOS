//
//  RegistationAdressProofVC.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 05/08/25.
//

import UIKit
import TOCropViewController
import Vision
import FirebaseAnalytics


class RegistationAdressProofVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, TOCropViewControllerDelegate{
    
    @IBOutlet weak var viewNeighbrsnook: UIView!
    @IBOutlet weak var viewRentLease: UIView! // only one image
    @IBOutlet weak var viewDrivingLicense: UIView!
    @IBOutlet weak var viewVoterID: UIView!
    @IBOutlet weak var viewPassport: UIView!
    @IBOutlet weak var viewAadhaarCard: UIView!
    
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewDateOfBirth: UIView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var viewFrontImg: UIView!
    @IBOutlet weak var viewBackImg: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    
    @IBOutlet weak var lblNeighbrsnookHeading: UILabel!
    @IBOutlet weak var lblVoterId: UILabel!
    @IBOutlet weak var lblDriving: UILabel!
    @IBOutlet weak var lblRent: UILabel!
    @IBOutlet weak var lblPassport: UILabel!
    @IBOutlet weak var lblAadhar: UILabel!
    @IBOutlet weak var lblFront: UILabel!
    @IBOutlet weak var lblBack: UILabel!
    @IBOutlet weak var lblGenderHeading: UILabel!
    @IBOutlet weak var lblDateOfBirthheading: UILabel!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewImg: UIStackView!
    @IBOutlet weak var lblYourNeighbourhood: UILabel!
    @IBOutlet weak var lblSelectTheAdressProof: UILabel!
    @IBOutlet weak var btnFront: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var viewThankYou: UIView!
    
    var isSelectingFrontImage: Bool = true
    var frontImage: UIImage?
    var backImage: UIImage?
    private let genderPicker = UIPickerView()
    private let datePicker = UIDatePicker()
    var selectedView: UIView?
    var selectedDOB: Date?
    let genderOptions = ["Choose Your Gender","Male", "Female", "Other"]
    var documentViews: [UIView] = []
    var imageViewToUpdate: UIImageView? = nil
    var isComingFromImagePicker: Bool = false
    var selectedDocumentType: DocumentType?
    var RegistrationSec : RegistrationNewSecModel?
    var selectedLocation: String?
    var name = ""
    var secname = ""
    var profileData: ProfileModel?
    var uploadedDocuments: UploadedDocumentsModel?
    var sourceScreen: String?
    //    var sourceScreen: String?
    
    enum DocumentType: String {
        case aadhaar = "aadhar"
        case passport = "passport"
        case voterID = "voter"
        case drivingLicense = "dl"
        case rentdocs = "rentdocs"
        case none = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGenderPicker()
        setupDatePicker()
        UserDefaults.standard.set("step2", forKey: "registrationStep")
        
        let allViews = [
            viewRentLease,
            viewDrivingLicense,
            viewVoterID,
            viewPassport,
            viewAadhaarCard,
            viewGender,
            viewFrontImg,
            viewBackImg,
            viewNeighbrsnook,
            viewDateOfBirth,
            btnRegister
        ]
        
        for v in allViews {
            v?.layer.cornerRadius = 12
            v?.layer.masksToBounds = true
        }
        
        let views = [viewRentLease, viewDrivingLicense, viewVoterID, viewPassport, viewAadhaarCard, viewGender,
                     viewFrontImg,
                     viewBackImg,
                     viewNeighbrsnook,
                     viewDateOfBirth,
                     btnRegister]
        
        viewMain.layer.cornerRadius = 16
        viewMain.layer.shadowColor = UIColor.black.cgColor
        viewMain.layer.shadowOpacity = 0.30
        viewMain.layer.shadowOffset = CGSize(width: 0, height: 4)
        viewMain.layer.shadowRadius = 10
        viewMain.layer.masksToBounds = false
        
        
        documentViews = [viewRentLease, viewDrivingLicense, viewVoterID, viewPassport, viewAadhaarCard]
        documentViews.forEach { view in
            view.backgroundColor = .white
            let tap = UITapGestureRecognizer(target: self, action: #selector(documentViewTapped(_:)))
            view.addGestureRecognizer(tap)
        }
        stackViewImg.isHidden = true
        stackViewHeight.constant = -20
        viewFrontImg.isHidden = true
        viewBackImg.isHidden = true
        
        let labels = [lblVoterId, lblDriving, lblRent, lblPassport, lblAadhar, lblFront, lblBack, lblNeighbrsnookHeading]
        for label in labels {
            label?.font = UIFont(name: "Montserrat-Regular", size: 14)
        }
        lblYourNeighbourhood.font = UIFont(name: "Montserrat-Regular", size: 20)
        lblSelectTheAdressProof.font = UIFont(name: "Montserrat-Medium", size: 16)
        genderTextField.font = UIFont(name: "Montserrat-Regular", size: 16)
        dobTextField.font = UIFont(name: "Montserrat-Regular", size: 16)
        if let customFont = UIFont(name: "Montserrat-Regular", size: 20) {
            btnRegister.titleLabel?.font = customFont
        }
        let frontTapGesture = UITapGestureRecognizer(target: self, action: #selector(frontImageTapped))
        viewFrontImg.isUserInteractionEnabled = true
        viewFrontImg.addGestureRecognizer(frontTapGesture)
        let backTapGesture = UITapGestureRecognizer(target: self, action: #selector(backImageTapped))
        viewBackImg.isUserInteractionEnabled = true
        viewBackImg.addGestureRecognizer(backTapGesture)
        
        let neighbourhood = selectedLocation ?? ""
        lblYourNeighbourhood.text = "Id & Address for \(neighbourhood)"
        viewThankYou.layer.shadowColor = UIColor.black.cgColor
        viewThankYou.layer.shadowOpacity = 0.3
        viewThankYou.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewThankYou.layer.shadowRadius = 4
        viewThankYou.layer.cornerRadius = 12
        
        viewThankYou.isHidden = true
        viewThankYou.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewThankYou)
        
        NSLayoutConstraint.activate([
            viewThankYou.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            viewThankYou.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            viewThankYou.heightAnchor.constraint(equalToConstant: 130),
            viewThankYou.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewThankYou.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ✅ Prevent reloading data after image picker
        if isComingFromImagePicker {
            print("Skipping viewWillAppear code because returning from picker/cropper")
            return
        }

        print("Profile Data received:", profileData ?? "No Data")
        print("Uploaded Docs received:", uploadedDocuments ?? [])

        // Gender & DOB
        genderTextField.text = profileData?.gender ?? ""
        dobTextField.text = profileData?.dob ?? ""
        lblYourNeighbourhood.text = "Id & Address for \(profileData?.neighborhood ?? "")"

        // ✅ Document selection
        if let docType = profileData?.uploadedDoc?.lowercased() {
            if docType.contains("aadhaar") {
                selectDocument(viewAadhaarCard, type: .aadhaar)
            } else if docType.contains("passport") {
                selectDocument(viewPassport, type: .passport)
            } else if docType.contains("voter") {
                selectDocument(viewVoterID, type: .voterID)
            } else if docType.contains("driving") {
                selectDocument(viewDrivingLicense, type: .drivingLicense)
            } else if docType.contains("rent") {
                selectDocument(viewRentLease, type: .rentdocs)
            }
        }

        // ✅ Load Uploaded Images
        if let images = profileData?.uploadedDocImages as? [String] {
            if images.count > 0, let frontURL = URL(string: images[0]) {
                loadImage(from: frontURL) { [weak self] image in
                    DispatchQueue.main.async {
                        self?.frontImage = image
                        self?.viewFrontImg.backgroundColor = .white
                        self?.updateImageCountLabels()
                    }
                }
            }
            if images.count > 1, let backURL = URL(string: images[1]) {
                loadImage(from: backURL) { [weak self] image in
                    DispatchQueue.main.async {
                        self?.backImage = image
                        self?.viewBackImg.backgroundColor = .white
                        self?.updateImageCountLabels()
                    }
                }
            }
        }
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewThankYou.center = self.view.center
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }.resume()
    }

    private func selectDocument(_ view: UIView, type: DocumentType) {
        documentViews.forEach { $0.backgroundColor = .white }
        view.backgroundColor = UIColor(red: 0.85, green: 1.0, blue: 0.85, alpha: 1.0) // light green
        stackViewImg.isHidden = false
        stackViewHeight.constant = 50
        selectedDocumentType = type

        // Aadhaar → show both images, Rent → only front
        if type == .rentdocs {
            viewFrontImg.isHidden = false
            viewBackImg.isHidden = true
        } else {
            viewFrontImg.isHidden = false
            viewBackImg.isHidden = false
        }
    }

    
    // MARK: - Action
    
    
    
    
    @IBAction func actionVerifiedOK(_ sender: Any) {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.viewThankYou.alpha = 0
        }) { _ in
            self.viewThankYou.isHidden = true
            
            // Remove dimmed background view
            if let dimmedView = self.view.viewWithTag(999) {
                dimmedView.removeFromSuperview()
            }
            self.view.backgroundColor = .white
            
            // 1️⃣ Fire Analytics event
            Analytics.logEvent("registration_complete_iOS", parameters: [
                "method": "app_registration",
                "platform": "iOS"
            ])
            
            // 2️⃣ Save registration flags
            UserDefaults.standard.set("done", forKey: "registrationStep")

            
//            // 3️⃣ Navigate to next screen
//            if self.sourceScreen == "profile" {
//                
//                if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
//                    
//                    self.navigationController?.setViewControllers([homeVC], animated: true)
//                }
//            } else {
//                // Registration flow → NeigbrnookViewController जाना है
//                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController") as? NeigbrnookViewController {
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            }
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController") as? NeigbrnookViewController else { return }
            UserDefaults.standard.set("done", forKey: "registrationStep")
            UserDefaults.standard.set(true, forKey: "isRegistered")

            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    @IBAction func action_Back(_ sender: Any) {
        // Sirf jab profile pe jaana ho tab ye alert aaye
        if sourceScreen == "profile" {
            // Show confirmation alert
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            let titleText = "Confirmation"
            let messageText = "Are you sure you want to go back? Unsaved changes might be lost."
            let titleColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .label
            let messageColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .secondaryLabel
            
            let attributedTitle = NSAttributedString(string: titleText, attributes: [
                .foregroundColor: titleColor,
                .font: UIFont.boldSystemFont(ofSize: 17)
            ])
            
            let attributedMessage = NSAttributedString(string: messageText, attributes: [
                .foregroundColor: messageColor,
                .font: UIFont.systemFont(ofSize: 15)
            ])
            
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            
            // Confirm Back Action
            let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                // Profile pe wapas jao
                if let navigationController = self.navigationController {
                    for controller in navigationController.viewControllers {
                        if controller is MyProfileViewController {
                            navigationController.popToViewController(controller, animated: true)
                            return
                        }
                    }
                }
                // Agar stack me nahi mila toh push kar do
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let profileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController {
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
            
            // Cancel Action
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else if sourceScreen == "secondStep" {
            // SecondStep VC pe wapas jao
            if let step2VC = self.navigationController?.viewControllers.first(where: { $0 is NewRegistationSecondStepVC }) {
                self.navigationController?.popToViewController(step2VC, animated: true)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as! NewRegistationSecondStepVC
                 vc.profileData = self.profileData
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func action_Register(_ sender: Any) {
        
        
        // 1. Document selection required
        guard let docType = selectedDocumentType, docType != .none else {
            showAlert(message: "Please select a document type")
            return
        }
        
        // 2. Image Validation based on Document Type
        switch docType {
        case .aadhaar, .passport, .voterID, .drivingLicense:
            if frontImage == nil {
                showAlert(message: "Please upload the FRONT image")
                return
            }
            if backImage == nil {
                showAlert(message: "Please upload the BACK image")
                return
            }
        case .rentdocs:
            if frontImage == nil {
                showAlert(message: "Please upload the Rent/Lease document image")
                return
            }
        default:
            break
        }
        
        // 3. Gender Validation
        guard let genderText = genderTextField.text,
              genderOptions.contains(genderText),
              genderText != genderOptions[0] else {
            showAlert(message: "Please select your gender")
            return
        }
        
        // 4. DOB Validation
        guard let dob = dobTextField.text, !dob.isEmpty else {
            showAlert(message: "Please enter your Date of Birth")
            return
        }
        UIHelper.showLoader(on: sender as! UIButton, show: true)
        
        // --- API call only if ALL validations pass ----
        self.callRegSecWebService {
            DispatchQueue.main.async {
                UIHelper.showLoader(on: sender as! UIButton, show: false)
                let dimView = UIView(frame: self.view.bounds)
                dimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                dimView.tag = 999
                self.view.addSubview(dimView)
                self.viewThankYou.layer.cornerRadius = 12
                self.viewThankYou.center = self.view.center // Center horizontally + vertically
                UserDefaults.standard.set("completed", forKey: "registrationStep")

                self.viewThankYou.isHidden = false
                self.viewThankYou.alpha = 1
                
                // Bring thank you view above dim background
                self.view.bringSubviewToFront(self.viewThankYou)
                print("🎉 Registration Step III success")
            }
        }
    }
    
    // Show simple alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        // Custom attributed message: font & color
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributedMessage = NSAttributedString(
            string: message,
            attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.darkGray,
                .paragraphStyle: paragraph
            ]
        )
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    
    
    
    
    @IBAction func action_FrontImg(_ sender: Any) {
        isSelectingFrontImage = true
        selectedView = view
        self.isComingFromImagePicker = false
        presentImageSourceOptions()
    }
    @IBAction func action_BackImg(_ sender: Any) {
        isSelectingFrontImage = false
        self.isComingFromImagePicker = false
        selectedView = view
        presentImageSourceOptions()
    }
    
    
    // MARK: - Present Image Picker Options
    private func presentImageSourceOptions() {
        let alertController = UIAlertController()
         if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take photo", style: .default) { _ in
                checkCameraPermission { granted in // ✅ NO `self.`
                    if granted {
                        self.openImagePicker(sourceType: .camera)
                    }
                }
            }
            alertController.addAction(cameraAction)
        }
        
        let galleryAction = UIAlertAction(title: "Choose photo", style: .default) { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        }
        alertController.addAction(galleryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    
    // MARK: - Open Image Picker
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        isComingFromImagePicker = true
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            let cropViewController = TOCropViewController(croppingStyle: .default, image: originalImage)
            cropViewController.delegate = self
            cropViewController.aspectRatioLockEnabled = false
            cropViewController.resetAspectRatioEnabled = true
            cropViewController.aspectRatioPickerButtonHidden = false
            cropViewController.toolbar.clampButtonHidden = false
            cropViewController.toolbar.rotateClockwiseButtonHidden = false
            cropViewController.cropView.cropBoxResizeEnabled = true

            picker.dismiss(animated: true) {
                self.present(cropViewController, animated: true)
            }
        } else {
            picker.dismiss(animated: true) {
                self.isComingFromImagePicker = false
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.isComingFromImagePicker = false
        }
    }
    
    // MARK: - TOCropViewController Delegate
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            self.isComingFromImagePicker = false // ✅ Reset here safely

            if self.selectedDocumentType == .aadhaar {
                self.performAadhaarMasking(on: image) { success in
                    if success {
                        self.updateImageCountLabels()
                    }
                }
            } else {
                if self.isSelectingFrontImage {
                    self.frontImage = image
                    self.viewFrontImg.backgroundColor = .white
                } else {
                    self.backImage = image
                    self.viewBackImg.backgroundColor = .white
                }
                self.updateImageCountLabels()
            }
        }
    }


 
    
    func updateImageCountLabels() {
        self.isComingFromImagePicker = false
        let frontSelected: Bool = (frontImage != nil)
        let backSelected: Bool = (backImage != nil)
        
        // Stylish text
        lblFront.text = frontSelected ? "Front Preview " : "Front"
        lblBack.text  = backSelected  ? "Back Preview " : "Back"
        
        // Color
        lblFront.textColor = frontSelected ? .systemGreen : .darkGray
        lblBack.textColor  = backSelected  ? .systemGreen : .darkGray
        
        lblFront.font = UIFont.boldSystemFont(ofSize: 15)
        lblBack.font  = UIFont.boldSystemFont(ofSize: 15)
        
        btnFront.isHidden = frontSelected
        btnBack.isHidden  = backSelected
    }
    
    
    
    @objc func frontImageTapped() {
        if let frontImage = self.frontImage {
            showImagePopup(with: frontImage, isFront: true)
        }
    }
    @objc func backImageTapped() {
        if let backImage = self.backImage {
            showImagePopup(with: backImage, isFront: false)
        }
    }
    
    
    func showImagePopup(with image: UIImage, isFront: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "RegisterThirdImageShowPopupVC") as? RegisterThirdImageShowPopupVC {
            popupVC.imagePass = image
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            // Yeh callback setup karo:
            popupVC.onDeleteImage = { [weak self] in
                guard let self = self else { return }
                if isFront {
                    self.frontImage = nil
                    self.viewFrontImg.backgroundColor = .systemGray6 // or placeholder color
                } else {
                    self.backImage = nil
                    self.viewBackImg.backgroundColor = .systemGray6
                }
                self.updateImageCountLabels()
            }
            self.present(popupVC, animated: true, completion: nil)
        }
    }
    
    @objc func documentViewTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else { return }
        documentViews.forEach { $0.backgroundColor = .white }
        selectedView.backgroundColor = UIColor(red: 0.85, green: 1.0, blue: 0.85, alpha: 1.0) // light green
        
        stackViewImg.isHidden = false
        stackViewHeight.constant = 50
        
        frontImage = nil
        backImage = nil
        
        if let frontImageView = viewFrontImg as? UIImageView {
            frontImageView.image = nil
        }
        if let backImageView = viewBackImg as? UIImageView {
            backImageView.image = nil
        }
        
        if selectedView == viewRentLease {
            viewFrontImg.isHidden = false
            viewBackImg.isHidden  = true
        } else {
            viewFrontImg.isHidden = false
            viewBackImg.isHidden  = false
        }
        
        updateImageCountLabels()
        if selectedView == viewAadhaarCard {
            selectedDocumentType = .aadhaar
        } else if selectedView == viewPassport {
            selectedDocumentType = .passport
        } else if selectedView == viewVoterID {
            selectedDocumentType = .voterID
        } else if selectedView == viewDrivingLicense {
            selectedDocumentType = .drivingLicense
        } else if selectedView == viewRentLease {
            selectedDocumentType = .rentdocs
        } else {
            selectedDocumentType = .none
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func detectText(in image: UIImage, completion: @escaping ([VNRecognizedTextObservation]) -> Void) {
        guard let cgImage = image.cgImage else { return }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let observations = request.results as? [VNRecognizedTextObservation] {
                completion(observations)
            }
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-IN"]
        request.usesLanguageCorrection = true
        
        try? requestHandler.perform([request])
    }
    func performAadhaarMasking(on image: UIImage, completion: @escaping (Bool) -> Void) {
            let request = VNRecognizeTextRequest { [weak self] request, error in
                guard let self = self else { return }
                let observations = request.results as? [VNRecognizedTextObservation] ?? []
                let aadhaarObservations = self.findAadhaarNumbers(in: observations)
                if !aadhaarObservations.isEmpty,
                   let masked = self.maskDigits(in: image, from: observations) {
                    DispatchQueue.main.async {
                        if self.isSelectingFrontImage {
                            self.frontImage = masked
                            self.viewFrontImg.backgroundColor = .white
                        } else {
                            self.backImage = masked
                            self.viewBackImg.backgroundColor = .white
                        }
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        if self.isSelectingFrontImage {
                            self.frontImage = image
                            self.viewFrontImg.backgroundColor = .white
                        } else {
                            self.backImage = image
                            self.viewBackImg.backgroundColor = .white
                        }
                        completion(false)
                    }
                }
            }
            
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en-IN"]
            guard let cgImage = image.cgImage else { return }
            DispatchQueue.global(qos: .userInitiated).async {
                try? VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([request])
            }
        }
    
    
    
    
    func findAadhaarNumbers(in observations: [VNRecognizedTextObservation]) -> [(text: String, boundingBox: CGRect)] {
            var result: [(text: String, boundingBox: CGRect)] = []
            for observation in observations {
                guard let candidate = observation.topCandidates(1).first else { continue }
                let text = candidate.string.replacingOccurrences(of: " ", with: "")
                if text.range(of: #"^[0-9]{12}$"#, options: .regularExpression) != nil {
                    result.append((candidate.string, observation.boundingBox))
                    print("Musk text is : \(text)")
                }
            }
            if result.isEmpty {
                DispatchQueue.main.async {
                    let msgString = "Couldn’t read the Aadhaar card. Please take a clearer photo."
                    let alert = UIAlertController(title: nil, message: msgString, preferredStyle: .alert)
                    let attributedMessage = NSAttributedString(string: msgString,
                        attributes: [.font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: #colorLiteral(red: 0.3764705882, green: 0.3725490196, blue: 0.3725490196, alpha: 1)])
                    alert.setValue(attributedMessage, forKey: "attributedMessage")
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    okAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor")
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            return result
        }

        func maskDigits(in image: UIImage, from observations: [VNRecognizedTextObservation]) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
            image.draw(at: .zero)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            
            for obs in observations {
                guard let candidate = obs.topCandidates(1).first else { continue }
                let fullText = candidate.string.replacingOccurrences(of: " ", with: "")
                if fullText.range(of: #"^[0-9]{12}$"#, options: .regularExpression) != nil { //  Mask only Aadhaar number (12 digits)
                    let box = obs.boundingBox
                    let imageSize = image.size
                    let rect = CGRect(
                        x: box.origin.x * imageSize.width,
                        y: (1 - box.origin.y - box.size.height) * imageSize.height,
                        width: box.size.width * imageSize.width,
                        height: box.size.height * imageSize.height
                    )
                    let digitWidth = rect.width / 12.0 // Mask first 8 digits
                    let maskRect = CGRect(
                        x: rect.origin.x,
                        y: rect.origin.y,
                        width: digitWidth * 8,
                        height: rect.height
                    )
                    context.setFillColor(#colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1))
                    context.fill(maskRect)
                }
            }
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resultImage
        }
    
    
 
    
    func setupGenderPicker() {
        // Set delegate and data source for picker
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        // Set the picker as the input view for the text field
        genderTextField.inputView = genderPicker
        
        // Set placeholder for the text field
        genderTextField.placeholder = "Select Gender"
    }
    
    func setupDatePicker() {
        // Set the date picker mode to date only
        datePicker.datePickerMode = .date
        
        // Set the maximum date to today to prevent future dates selection
        datePicker.maximumDate = Date()
        
        // Set a minimum date (13 years ago from today)
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -13, to: Date())
        datePicker.maximumDate = minDate // Maximum date ko 13 saal pehle set kar rahe hain
        
        // Configure for iOS 14 and later
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels // Use wheel style for better UX
        }
        
        // Set the date picker as the input view for the text field
        dobTextField.inputView = datePicker
        
        // Add target for the date picker value change
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // Set placeholder for the text field
        dobTextField.placeholder = "Select Date"
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Calculate the difference between current date and selected date
        let ageComponents = calendar.dateComponents([.year], from: selectedDate, to: currentDate)
        if let age = ageComponents.year, age < 13 {
            showAlert(message: "Age should be above 13 years")
            dobTextField.text = "" // Clear the text field
        } else {
            // Format the selected date and set it in the text field
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dobTextField.text = dateFormatter.string(from: selectedDate)
        }
    }
    
    
    
    

    
    
    // Hide karte waqt aap ye function use kar sakte hain:
    func hideStackViewImage() {
        stackViewImg.isHidden = true
        stackViewHeight.constant = -20
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - api call
    
    func callRegSecWebService(_ completionClosure: @escaping () -> ()) {
        let userID = UserDefaults.standard.string(forKey: "userid") ?? ""
        
        // Gender mapping
        var genderValue = ""
        if let genderText = self.genderTextField.text?.lowercased() {
            switch genderText {
            case "male": genderValue = "1"
            case "female": genderValue = "2"
            case "other": genderValue = "3"
            default: genderValue = ""
       
            }
        }
        
        var formattedDOB = ""
        if let dobString = self.dobTextField.text, !dobString.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if let date = dateFormatter.date(from: dobString) {
                formattedDOB = dateFormatter.string(from: date)
            } else {
                formattedDOB = dobString // fallback: pass as is
            }
        }
        
        // Parameters
        let dictParams: [String: String] = [
            "userid": userID,
            "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
            "dob": formattedDOB,
            "gender": genderValue,
            "term": "1"
        ]
        
        
        print("Request Parameters: \(dictParams)")
        
        // Handle images
        var images: [(key: String, image: UIImage?)] = []
        
        switch selectedDocumentType {
        case .aadhaar:
            guard let front = frontImage else { print("Aadhaar Front image upload karein"); return }
            guard let back = backImage else { print("Aadhaar Back image upload karein"); return }
            images.append(("aadharFront", front))
            images.append(("aadharBack", back))
            
        case .passport:
            guard let front = frontImage else { print("Passport Front image upload karein"); return }
            guard let back = backImage else { print("Passport Back image upload karein"); return }
            images.append(("passportFront", front))
            images.append(("passportBack", back))
            
        case .voterID:
            guard let front = frontImage else { print("Voter ID Front image upload karein"); return }
            guard let back = backImage else { print("Voter ID Back image upload karein"); return }
            images.append(("voterFront", front))
            images.append(("voterBack", back))
            
        case .drivingLicense:
            guard let front = frontImage else { print("Driving License Front image upload karein"); return }
            guard let back = backImage else { print("Driving License Back image upload karein"); return }
            images.append(("dlFront", front))
            images.append(("dlBack", back))
            
        case .rentdocs:
            guard let front = frontImage else { print("Rent Document image upload karein"); return }
            images.append(("rentdocs", front))
            
        default:
            print("Koi document selected nahi hai")
            return
        }
        
        // API URL
        guard let url = URL(string: "https://dev.neighbrsnook.com/oldadmin/api/master?flag=reg-step-III") else {
            print("URL invalid hai")
            return
        }
        
        // Request setup
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createMultipartBody(with: dictParams, images: images, boundary: boundary)
        request.httpBody = body
        
        // Network call
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("Koi data nahi mila")
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response: \(jsonString)")
                }
                
                let decoder = JSONDecoder()
                self.RegistrationSec = try decoder.decode(RegistrationNewSecModel.self, from: data)
                
                if self.RegistrationSec?.status == "success" {
                    DispatchQueue.main.async {
                        completionClosure()
                    }
                } else {
                    DispatchQueue.main.async {
                        print(self.RegistrationSec?.message ?? "Unknown error")
                    }
                }
            } catch let decodeError {
                print("Decoding error: \(decodeError)")
            }
        }
        task.resume()
    }
    
    
    // Function to create multipart body
    func createMultipartBody(with parameters: [String: String], images: [(key: String, image: UIImage?)], boundary: String) -> Data {
        var body = Data()
        
        // Parameters ko body mein add karein
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Images ko body mein add karein
        for (key, image) in images {
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.7) else { continue }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
            
            // Debugging ke liye image key print karein
            print("Uploading image with key: \(key)")
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
  
    
}

extension RegistationAdressProofVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Single column for gender
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count // genderOptions is your array of gender strings
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row] // Display gender options in the picker
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Set the selected gender to the text field
        genderTextField.text = genderOptions[row]
        
        // Dismiss the picker after selection
        genderTextField.resignFirstResponder()
    }
}
