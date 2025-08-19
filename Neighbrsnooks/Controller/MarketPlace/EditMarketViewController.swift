import UIKit
import Alamofire
import Photos
import PhotosUI
import TOCropViewController


@available(iOS 16.0, *)
class EditMarketViewController: BaseViewController, UIPickerViewDelegate,UITextFieldDelegate , PHPickerViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TOCropViewControllerDelegate, UITextViewDelegate, MediaCountUpdateDelegate  {
   
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var collectionViewEvent: UICollectionView!
    @IBOutlet weak var tfItemName: UITextField!
    @IBOutlet weak var tfItemPrice: UITextField!
 
    @IBOutlet weak var tfDesc: UITextView!
    @IBOutlet weak var btnSell: UIButton!
    @IBOutlet weak var btnDonate: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet var checkBox: UIImageView!
    @IBOutlet var ActiatecheckBox: UIImageView!
    @IBOutlet var deactivatecheckBox: UIImageView!
   
    @IBOutlet weak var lblActivate: UILabel!
    @IBOutlet weak var lblDeActivate: UILabel!
    @IBOutlet weak var lblPerviewImgVidCount: UILabel!
    
    @IBOutlet weak var FullMarketView: UIView!
    @IBOutlet weak var ItemNameView: UIView!
    
    @IBOutlet weak var CategoryView: UIView!
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var DonateView: UIView!
    @IBOutlet weak var PriceView: UIView!
    
    @IBOutlet weak var UploadImageView: UIView!
    @IBOutlet weak var DescriptionView: UIView!
   
    var onUpdateForBlock: (() -> Void)?
    var selectedCategoryId: Int?
    var selectedCategoryName: String?
    var MarketCatDataNew : MarketCategoryModel?
    var MarketEditDataNew : MarketUpdateModel?
    var SoldDataNew : InactivemarketModel?
    var ActiveData : ActiveStatusModel?
    var soldData : SoldModel?
    var MarketWDetailData : ProductResponse?
     var imagePicker:UIImagePickerController?
    var imageArray = [UIImage]()
    var CamimageArray = [UIImage]()
    var selectedImages: [UIImage] = []
    var images: [UIImage] = []
    var selectedImge: UIImage? = nil
    var from = 1
    var thisWidth:CGFloat = 0
    var docType = ""
    var idD = ""
    var loaderView: UIView?
    
    // Variables to track checkbox selection
    var selectedCheckbox: CheckboxType = .none
    
    enum CheckboxType {
        case none
        case sold
        case active
        case deactivate
    }
    // var serviceName = [String]()
    
    var serviceName: [String] = []
    var pickerView = UIPickerView()
    
    let placeholderText = "Describe your item ..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 17)
        
        self.tfItemName.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.tfItemPrice.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.tfCategory.font = UIFont(name: "Montserrat-Regular", size: 16)
        self.tfDesc.font = UIFont(name: "Montserrat-Regular", size: 16)
        tfCategory.inputView = pickerView
        tfCategory.delegate = self
        tfDesc.delegate = self
        // Set initial placeholder
        tfDesc.text = placeholderText
        tfDesc.textColor = UIColor.lightGray // Make t
        tfItemName.autocapitalizationType = .sentences
      //  tfBrand.autocapitalizationType = .sentences
        tfDesc.autocapitalizationType = .sentences
        self.checkBox.image = UIImage(systemName: "square")
        self.ActiatecheckBox.image = UIImage(systemName: "square")
        self.deactivatecheckBox.image = UIImage(systemName: "square")
        self.serviceName.append("Market Categories")
        // Do any additional setup after loading the view.
        
        
        // ✅ Label ko tappable banane ke liye gesture recognizer add karo
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
            lblPerviewImgVidCount.isUserInteractionEnabled = true
            lblPerviewImgVidCount.addGestureRecognizer(tapGesture)
        
       
            
            // ✅ Label me image/video count dikhana
        callMarketDetailWebService{ [self] in
            updatePreviewLabel()
        }
        
        
        let professionLabelTap = UITapGestureRecognizer(target: self, action: #selector(professionLabelTapped))
                tfCategory.isUserInteractionEnabled = true
                tfCategory.addGestureRecognizer(professionLabelTap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //callProductListWebService{}
        callMarketCatWebService{
            
        }
        
        callMarketDetailWebService{ [self] in
            self.tfItemName.text = self.MarketWDetailData?.productdetail?.first?.pTitle
          
            // cell.rsLbl.text = "Rs." + (MarketWallData?.yourItems![indexPath.row].salePrice ?? "")
//            self.tfItemPrice.text = self.MarketWDetailData?.productdetail?.first?.salePrice ?? ""
            if let priceString = MarketWDetailData?.productdetail?.first?.salePrice,
               let price = Double(priceString) {
                tfItemPrice.text = "Rs. \(Int(price))"
            } else {
                tfItemPrice.text = "Rs. 0"
            }
            self.tfDesc.text = self.MarketWDetailData?.productdetail?.first?.pDescription
            //   self.timeLbl.text = self.MarketWDetailData?.productdetail?.first?.createdTime
            self.tfCategory.text = self.MarketWDetailData?.productdetail?.first?.catName
          //  self.tfBrand.text = self.MarketWDetailData?.productdetail?.first?.brandName
            //   self.secLbl.text = self.MarketWDetailData?.productdetail?.first?.neighborhoodName
            let url = URL(string: (MarketWDetailData?.productdetail?.first?.pImages?.first?.img ?? ""))
            if MarketWDetailData?.productdetail?.first?.pStatus == 1 {
                lblActivate.isHidden = true
                lblDeActivate.isHidden = false
                ActiatecheckBox.isHidden = true
                //  AddWishList.isHidden = true
            } else if MarketWDetailData?.productdetail?.first?.pStatus == 0 {
                
                lblActivate.isHidden = false
                lblDeActivate.isHidden = true
                deactivatecheckBox.isHidden = true
                //  AddWishList.isHidden = false
                
            }
            
            else if MarketWDetailData?.productdetail?.first?.pStatus == 2 {
                
                lblActivate.isHidden = true
                lblDeActivate.isHidden = true
                deactivatecheckBox.isHidden = true
                ActiatecheckBox.isHidden = true
                
            }
            
            if MarketWDetailData?.productdetail?.first?.pStatus == 2 {
                    self.checkBox.image = UIImage(systemName: "checkmark.square.fill")
                    selectedCheckbox = .sold
                } else {
                    self.checkBox.image = UIImage(systemName: "square")
                    selectedCheckbox = .none
                }
            
            if MarketWDetailData?.productdetail?.first?.saleType == "Sell" {
                self.btnSell.backgroundColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
                btnSell.setTitleColor(UIColor.white, for: .normal)
                //  self.lblName.textColor = #colorLiteral(red: 0.3843137255, green: 0.2, blue: 0.8392156863, alpha: 1)
                
            } else if MarketWDetailData?.productdetail?.first?.saleType == "Donate" {
                
                self.btnDonate.backgroundColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
                btnDonate.setTitleColor(UIColor.white, for: .normal)
                //  self.lblName.textColor = #colorLiteral(red: 0.9843137255, green: 0.5490196078, blue: 0, alpha: 1)
                
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        updateColors()
    }
    
    
    @objc func professionLabelTapped() {
            showPopup(for: 3, allowMultipleSelection: false) // Single selection for profession
        }
        
    func showPopup(for labelTag: Int, allowMultipleSelection: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "SelectMarketCatViewController") as? SelectMarketCatViewController {
            
            popupVC.allowMultipleSelection = allowMultipleSelection
            popupVC.labelTag = 3
            
            popupVC.callback = { [weak self] catId, catName in
                self?.selectedCategoryName = catName
                self?.selectedCategoryId = catId
                self?.tfCategory.text = catName
                print("Selected ID: \(catId), Name: \(catName)")
            }
            
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            self.present(popupVC, animated: true, completion: nil)
        }
    }
        
        
    
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            ItemNameView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            CategoryView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
//            sellView.layer.borderColor = UIColor.lightGray.cgColor
//
//            DonateView.layer.borderColor = UIColor.lightGray.cgColor
            PriceView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            DescriptionView.layer.borderColor =  #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            UploadImageView.layer.borderColor =  #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            UploadImageView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            btnSell.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            btnDonate.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
           
//            Add1View.layer.borderColor = UIColor.lightGray.cgColor
//            Add2.layer.borderColor = UIColor.lightGray.cgColor
            
            ItemNameView.layer.borderWidth = 1.0 // Enable border in dark mode
            CategoryView.layer.borderWidth = 1.0
            btnSell.layer.borderWidth = 1.0 // Enable border in dark mode
            btnDonate.layer.borderWidth = 1.0
//            sellView.layer.borderWidth = 1.0
//            DonateView.layer.borderWidth = 1.0
            PriceView.layer.borderWidth = 1.0 // Enable border in dark mode
            
            DescriptionView.layer.borderWidth = 1.0
            UploadImageView.layer.borderWidth = 1.0
                        FullMarketView.backgroundColor = .black
            
            UploadImageView.backgroundColor = .black
            UploadImageView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            UploadImageView.layer.borderWidth = 1.0
            ItemNameView.backgroundColor = .black
            CategoryView.backgroundColor = .black
            PriceView.backgroundColor = .black
            collectionViewEvent.backgroundColor = .black
            btnSell.backgroundColor = .black
            btnDonate.backgroundColor = .black
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
          //  questionView.textColor = UIColor.secondaryLabel
            ItemNameView.backgroundColor = .white
            ItemNameView.isUserInteractionEnabled = true // Disable in light mode
            CategoryView.isUserInteractionEnabled = true
//            sellView.isUserInteractionEnabled = true
//
//            DonateView.isUserInteractionEnabled = true // Disable in light mode
            PriceView.isUserInteractionEnabled = true
            DescriptionView.isUserInteractionEnabled = true
            UploadImageView.isUserInteractionEnabled = true
            
            UploadImageView.isUserInteractionEnabled = true
            
            
            ItemNameView.layer.borderWidth = 0 // Remove border in light mode
//            DonateView.layer.borderWidth = 0
//            sellView.layer.borderWidth = 0
            PriceView.layer.borderWidth = 0
            CategoryView.layer.borderWidth = 0
            DescriptionView.layer.borderWidth = 0
            btnSell.layer.borderWidth = 0
            btnDonate.layer.borderWidth = 0
           
            UploadImageView.backgroundColor = .white
            CategoryView.backgroundColor = .white
            PriceView.backgroundColor = .white
            collectionViewEvent.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            
            UploadImageView.layer.borderWidth = 0 // Remove border in light mode
            
           // option4.layer.borderWidth = 0
            UploadImageView.layer.borderWidth = 0
            FullMarketView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            
            btnSell.backgroundColor = .white
            btnDonate.backgroundColor = .white
            
        }
      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            updateColors()
        }
    }
    
    
    // ✅ Delegate method ko implement karein
    func didUpdateMedia(imageArray: [UIImage], videoArray: [URL]) {
        let totalCount = imageArray.count + videoArray.count
        lblPerviewImgVidCount.text = "Preview (\(totalCount))"
    }


       func updatePreviewLabel() {
           let imageCount = MarketWDetailData?.productdetail?.first?.pImages?.count ?? 0
           lblPerviewImgVidCount.text = "Preview (\(imageCount))"
       }

       @objc func labelTapped() {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           if let enlargeVC = storyboard.instantiateViewController(withIdentifier: "BeforePostEnlargeViewController") as? BeforePostEnlargeViewController {
               
               var imageArray = [UIImage]()
               var videoArray = [URL]()
               
               if let mediaArray = MarketWDetailData?.productdetail?.first?.pImages {
                   for media in mediaArray {
                       if let videoURL = media.video, !videoURL.isEmpty, let url = URL(string: videoURL) {
                           videoArray.append(url)
                       } else if let imageURL = media.img, !imageURL.isEmpty, let url = URL(string: imageURL),
                                 let imageData = try? Data(contentsOf: url),
                                 let image = UIImage(data: imageData) {
                           imageArray.append(image)
                       }
                   }
               }

               enlargeVC.imageArray = imageArray
               enlargeVC.videoArray = videoArray
               
               // ✅ Set the delegate here
               enlargeVC.countDelegate = self
               
               self.navigationController?.pushViewController(enlargeVC, animated: true)
           }
       }
    
    
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func onTapCheckbox(_ sender: UITapGestureRecognizer) {
        if self.checkBox.image == UIImage(systemName: "square") {
            self.checkBox.image = UIImage(systemName: "checkmark.square.fill")
            selectedCheckbox = .sold
        } else {
            self.checkBox.image = UIImage(systemName: "square")
            selectedCheckbox = .none
        }
        
        
    }
    
    @IBAction func ActivateonTapCheckbox(_ sender: UITapGestureRecognizer) {
        if self.ActiatecheckBox.image == UIImage(systemName: "square") {
            self.ActiatecheckBox.image = UIImage(systemName: "checkmark.square.fill")
            selectedCheckbox = .active
        } else {
            self.ActiatecheckBox.image = UIImage(systemName: "square")
            selectedCheckbox = .none
        }
        
    }
    
    @IBAction func DeActivateonTapCheckbox(_ sender: UITapGestureRecognizer) {
        if self.deactivatecheckBox.image == UIImage(systemName: "square") {
            self.deactivatecheckBox.image = UIImage(systemName: "checkmark.square.fill")
            selectedCheckbox = .deactivate
        } else {
            self.deactivatecheckBox.image = UIImage(systemName: "square")
            selectedCheckbox = .none
        }
        
    }
    
    @IBAction func SellBtnAction(_ sender: UIButton) {
        
        
        btnSell.backgroundColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
        btnDonate.backgroundColor = UIColor.white
        btnSell.setTitleColor(UIColor.white, for: .normal)
        btnDonate.setTitleColor(UIColor.gray, for: .normal)
        docType = "Sell"
        
    }
    
    @IBAction func DonateBtnAction(_ sender: UIButton) {
        btnSell.backgroundColor = UIColor.white
        btnDonate.backgroundColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
        btnDonate.setTitleColor(UIColor.white, for: .normal)
        btnSell.setTitleColor(UIColor.gray, for: .normal)
        docType = "Donate"
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = "" // Remove the placeholder text
            textView.textColor = UIColor.black // Change the text color to black for user input
        }
    }
    
    // UITextViewDelegate method to handle when the user finishes editing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText // Add the placeholder text back if the text view is empty
            textView.textColor = UIColor.lightGray // Set the placeholder text color to light gray
        }
    }
    
    @IBAction func selectPhotos(_ sender: UIButton) {
        
        selectImages()
        
    }
    
    @IBAction func PublishBtn(_ sender: UIButton){
        
        
        // Show loader
        showLoader()
        self.hideLoader()
        
        switch selectedCheckbox {
        case .sold:
            callMarketSoldWebService {
                self.callMarketCreateWebService {
                    
                }
            }
        case .active:
            callMarketActiveWebService {
                self.callMarketCreateWebService {
                    
                }
            }
        case .deactivate, .none:
            callMarketDeactiveWebService {
                self.callMarketCreateWebService {
                    
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
       
    }
    
    func showLoader() {
        // Check if the loaderView already exists
        if loaderView == nil {
            // Create a full-screen semi-transparent background view
            let backgroundView = UIView(frame: self.view.bounds)
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            
            // Add an activity indicator
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            // Add a label for a loading message (optional)
            let loadingLabel = UILabel()
            loadingLabel.text = "Loading..."
            loadingLabel.textColor = .white
            loadingLabel.font = UIFont.boldSystemFont(ofSize: 18)
            loadingLabel.textAlignment = .center
            loadingLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Add subviews to the background view
            backgroundView.addSubview(activityIndicator)
            backgroundView.addSubview(loadingLabel)
            
            // Add constraints to center the activity indicator and label
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
                
                loadingLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20)
            ])
            
            // Add the background view to the main view
            self.view.addSubview(backgroundView)
            
            // Add constraints for the background view
            NSLayoutConstraint.activate([
                backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            
            // Start animating the activity indicator
            activityIndicator.startAnimating()
            
            // Save a reference to the loaderView
            loaderView = backgroundView
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.0, animations: {
                self.loaderView?.alpha = 0
            }) { _ in
                self.loaderView?.removeFromSuperview()
                self.loaderView = nil
            }
        }
    }
    
    
    
    
    @objc func selectImages() {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
        from = 2
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        from = 1
        var config = PHPickerConfiguration()
        config.selectionLimit = 0 // 0 means no limit
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func presentCropViewController(image: UIImage) {
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.presentCropViewController(image: image)
                self.images.append(image)
                // self.selectedImge = image
                //  self.presentCropViewController(image: image)
               
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let imageNew = object as? UIImage {
                    // self.showCrop(image: imageNew)
                    self.imageArray.append(imageNew)
                    
                    self.selectedImge = imageNew
                    
                    DispatchQueue.main.async {
                        self.presentCropViewController(image: imageNew)
                        self.collectionViewEvent.reloadData()
                        // Handle the selected image (e.g., add to an array or display in the UI)
                        print(imageNew)
                    }
                }
            }
        }
    }
    
   
    // dev.
    func callMarketDeactiveWebService(completion: @escaping () -> Void) {
        let url = "https://dev.neighbrsnook.com/admin/api/product_inactive_status?"
        
        // let dictParams: Dictionary<String, Any> = ["":""]
        
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        let idPr = UserDefaults.standard.string(forKey: "producttId")
        let dictParams: Dictionary<String, Any> = [
            "user_id":id ?? "",
            "product_id":idD ?? "",
            
            
        ]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.PUT,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                
                do {
                    let data = try JSONDecoder().decode(InactivemarketModel.self, from: result!)
                    self.SoldDataNew = data
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "CreatorId")
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.id, forKey: "producttId")
                    self.collectionViewEvent.reloadData()
                    
                    
                    DispatchQueue.global().async {
                        // Simulate network delay
                        sleep(2)
                        
                        // Update MarketWDetailData with fetched data
                        // Example data assignment
                        self.SoldDataNew = data // Your actual data fetching logic
                        
                        DispatchQueue.main.async {
                            completion() // Call completion handler
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(InactivemarketModel.self, from: result!)
                    //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
                } catch {
                    print(error.localizedDescription)
                }
            case .UNAUTHORIZED:
                print(error?.localizedDescription)
                //   self.showLogoutAlert()
            default:
                break
            }
        }
    }
    //dev.
    
    func callMarketActiveWebService(completion: @escaping () -> Void) {
        let url = "https://dev.neighbrsnook.com/admin/api/product_active_status"
        
        // let dictParams: Dictionary<String, Any> = ["":""]
        
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        let idPr = UserDefaults.standard.string(forKey: "producttId")
        let dictParams: Dictionary<String, Any> = [
            "user_id":id ?? "",
            "product_id":idD ?? "",
            
            
        ]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.PUT,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                
                do {
                    let data = try JSONDecoder().decode(ActiveStatusModel.self, from: result!)
                    self.ActiveData = data
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "CreatorId")
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.id, forKey: "producttId")
                    self.collectionViewEvent.reloadData()
                    
                    
                    DispatchQueue.global().async {
                        // Simulate network delay
                        sleep(2)
                        
                        // Update MarketWDetailData with fetched data
                        // Example data assignment
                        self.ActiveData = data // Your actual data fetching logic
                        
                        DispatchQueue.main.async {
                            completion() // Call completion handler
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(ActiveStatusModel.self, from: result!)
                    //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
                } catch {
                    print(error.localizedDescription)
                }
            case .UNAUTHORIZED:
                print(error?.localizedDescription)
                //   self.showLogoutAlert()
            default:
                break
            }
        }
    }
    
    //dev.
    
    func callMarketSoldWebService(completion: @escaping () -> Void) {
        let url = "https://dev.neighbrsnook.com/admin/api/product_sold_status"
        
        // let dictParams: Dictionary<String, Any> = ["":""]
        
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        let idPr = UserDefaults.standard.string(forKey: "producttId")
        let dictParams: Dictionary<String, Any> = [
            "user_id":id ?? "",
            "product_id":idD ?? "",
            
            
        ]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.PUT,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                
                do {
                    let data = try JSONDecoder().decode(SoldModel.self, from: result!)
                    self.soldData = data
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "CreatorId")
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.id, forKey: "producttId")
                    self.collectionViewEvent.reloadData()
                    
                    
                    DispatchQueue.global().async {
                        // Simulate network delay
                        sleep(2)
                        
                        // Update MarketWDetailData with fetched data
                        // Example data assignment
                        self.soldData = data // Your actual data fetching logic
                        
                        DispatchQueue.main.async {
                            self.hideLoader() // Ensure loader is hidden in both cases
                            completion() // Call completion handler
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(SoldModel.self, from: result!)
                    //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
                } catch {
                    print(error.localizedDescription)
                }
            case .UNAUTHORIZED:
                print(error?.localizedDescription)
                //   self.showLogoutAlert()
            default:
                break
            }
        }
        
        
    }
    //dev.
    func callMarketDetailWebService(completion: @escaping () -> Void) {
        let url = "https://dev.neighbrsnook.com/admin/api/mpk_product_detail?"
        
        // let dictParams: Dictionary<String, Any> = ["":""]
        
        let idName = UserDefaults.standard.string(forKey: "name")
        let idEvent = UserDefaults.standard.string(forKey: "eventid")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        let idPr = UserDefaults.standard.string(forKey: "producttId")
        let dictParams: Dictionary<String, Any> = [
            "user_id":id ?? "",
            "product_id":idD ?? "",
            
            
        ]
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                
                do {
                    let data = try JSONDecoder().decode(ProductResponse.self, from: result!)
                    self.MarketWDetailData = data
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "CreatorId")
                    UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.id, forKey: "producttId")
                    self.collectionViewEvent.reloadData()
                   
                    
                    DispatchQueue.global().async {
                        // Simulate network delay
                        sleep(2)
                        
                        // Update MarketWDetailData with fetched data
                        // Example data assignment
                        self.MarketWDetailData = data // Your actual data fetching logic
                        
                        DispatchQueue.main.async {
                            completion() // Call completion handler
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(ProductResponse.self, from: result!)
                    //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
                } catch {
                    print(error.localizedDescription)
                }
            case .UNAUTHORIZED:
                print(error?.localizedDescription)
                //   self.showLogoutAlert()
            default:
                break
            }
        }
    }
    
    //dev.
    func callMarketCreateWebService(completion: @escaping () -> Void) {
        let url = "https://dev.neighbrsnook.com/admin/api/mpk_product_add?"
       
        
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        let id = UserDefaults.standard.string(forKey: "userid")
        let idCr = UserDefaults.standard.string(forKey: "CreatorId")
        
        let dictParams: Dictionary<String, Any> = [
            "created_by": id ?? "",
            "p_title": self.tfItemName.text ?? "",
            "p_description": self.tfDesc.text ?? "",
            "sale_type": docType,
            "sale_price": self.tfItemPrice.text ?? "",
            "total_price": "0",
            "brand_name":  "",
            "seller_name": self.tfDesc.text ?? "",
            "cat_id": selectedCategoryId ?? "",
            "p_status": "1",
            "neighborhood_id": idNeighbour ?? "",
            "id": idD ?? "",
            
        ]
        print("Param is: \(dictParams)")
        
        // Determine if image upload is required based on `self.from`
        if self.from == 1 {
            // Log the images from gallery
            print("Images from gallery: \(imageArray)")
            
            // Ensure there are no duplicates
            let uniqueImageArray = Array(Set(imageArray))
            
            // Upload from gallery
            callsendImageAPI(param: dictParams, arrImage: uniqueImageArray, imageKey: "p_images[]", URlName: url, withblock: {
//                self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.async {
                    self.onUpdateForBlock!()
                    self.navigationController?.popViewController(animated: false)
                }
                completion()
            })
        } else if self.from == 2 {
            // Log the images from camera
            print("Images from camera: \(images)")
            
            // Ensure there are no duplicates
            let uniqueImages = Array(Set(images))
            
            // Upload from camera
            callsendImageAPI(param: dictParams, arrImage: uniqueImages, imageKey: "p_images[]", URlName: url, withblock: {
                self.navigationController?.popViewController(animated: true)
                completion()
            })
        } else {
            // If no image needs to be uploaded, make a separate data post request
            RSNetworkManager.shared.newRequestApi(withServiceName: url, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true) { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                switch statusCode {
                case .SUCCESS, .CREATED:
                    do {
                        let data = try JSONDecoder().decode(MarketUpdateModel.self, from: result!)
                        self.MarketEditDataNew = data
                        self.collectionViewEvent.reloadData()
                        
                        
                        
                        DispatchQueue.global().async {
                            sleep(2)
                            self.MarketEditDataNew = data
                            DispatchQueue.main.async {
                                completion()
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                    do {
                        let data = try JSONDecoder().decode(MarketUpdateModel.self, from: result!)
                        // Handle any necessary error messages
                    } catch {
                        print(error.localizedDescription)
                    }
                case .UNAUTHORIZED:
                    print(error?.localizedDescription)
                default:
                    break
                }
            }
        }
    }
    
    
    func callsendImageAPI(param: [String: Any], arrImage: [UIImage], imageKey: String, URlName: String, withblock: @escaping () -> Void) {
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        // Ensure there are no duplicate images
        let uniqueImages = Array(Set(arrImage))
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            // Append parameters to the multipart form data
            for (key, value) in param {
                if let stringValue = value as? String {
                    multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                }
            }
            
            // Append images to the multipart form data
            for (index, img) in uniqueImages.enumerated() {
                guard let imgData = img.jpegData(compressionQuality: 0.1) else { return }
                let fileName = "\(NSDate().timeIntervalSince1970.rounded())_image_\(index).jpeg"
                multipartFormData.append(imgData, withName: imageKey, fileName: fileName, mimeType: "image/jpeg")
                
                // Log each image to ensure it's uploaded once
                print("Uploading image with file name: \(fileName)")
            }
            
        }, to: URL(string: URlName)!, method: .post, headers: headers).response { response in
            
            if response.error == nil {
                do {
                    if let jsonData = response.data {
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as? [String: AnyObject]
                        print(parsedData ?? "No data")
                        withblock()
                    }
                } catch {
                    print("Error in JSON parsing: \(error.localizedDescription)")
                }
            } else {
                print("Upload error: \(response.error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
//    @IBAction func serviceNewBtnAction(_ sender: UIButton) {
//        self.view.endEditing(true)
//        self.showDropdownData(showOn: tfCategory, DropdownName: serviceDropdownData)
//        serviceDropdownData.cellHeight = 35
//
//        serviceDropdownData.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
//        //  serviceDropdownData.bottomOffset = CGPoint(x: 50, y: 24)
//        // self.ServiceDescriptionLabel.text = self.ServiceTypeData?.data.seri
//    }
//
//    private func showDropdownData(showOn textField: UITextField, DropdownName dropdown: DropDown) {
//
//        // Set the anchor and dropdown position
//        dropdown.anchorView = textField
//        dropdown.bottomOffset = CGPoint(x: 30, y: (dropdown.anchorView?.plainView.bounds.height)!)
//
//        // Set up the appearance for the dropdown
//        dropdown.backgroundColor = UIColor.white
//        dropdown.cellHeight = 35
//        dropdown.direction = .bottom
//        dropdown.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
//        DropDown.appearance().setupCornerRadius(10)
//        dropdown.width = 200
//
//        // Apply the font settings for the first item
//        dropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
//            if index == 0 {
//                cell.optionLabel.font = UIFont.boldSystemFont(ofSize: 16) // Bold font for the first item
//            } else {
//                cell.optionLabel.font = UIFont.systemFont(ofSize: 16) // Regular font for other items
//            }
//        }
//
//        // Set the selection action after the dropdown is shown
//        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
//            if index != 0 {
//                self.tfCategory.text = self.serviceName[index]
//            } else {
//                self.tfCategory.text = ""
//            }
//
//            UserDefaults.standard.set(self.serviceName[index], forKey: "id")
//            if index != 0 {
//                UserDefaults.standard.set(self.MarketCatDataNew?.category?[index - 1].id, forKey: "idCategoryMarket")
//            }
//        }
//
//        // Show the dropdown
//        dropdown.show()
//    }
    
    
    
    //dev.
    
    func callMarketCatWebService(completion: @escaping () -> Void) {
        let url = "https://dev.neighbrsnook.com/admin/api/category"
        
        let dictParams: Dictionary<String, Any> = ["":""]
        
        
        
        RSNetworkManager.shared.newRequestApi(withServiceName:url,requestMethod:.GET,requestParameters: dictParams, withProgressHUD: true)
        {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            switch statusCode {
            case .SUCCESS ,.CREATED:
                
                do {
                    let data = try JSONDecoder().decode(MarketCategoryModel.self, from: result!)
                    self.MarketCatDataNew = data
                    //  UserDefaults.standard.set(self.MarketWDetailData?.productdetail?.first?.createdBy, forKey: "CreatorId")
                    //                    for value in self.MarketCatDataNew?.category ?? [] {
                    //                        self.serviceName.append(value.catTitle ?? "")
                    //                    }
                    //                    self.serviceDropdownData.dataSource = self.serviceName
                    
                    DispatchQueue.global().async {
                        // Simulate network delay
                        sleep(2)
                        
                        // Update MarketWDetailData with fetched data
                        // Example data assignment
                        self.MarketCatDataNew = data // Your actual data fetching logic
                        for value in self.MarketCatDataNew?.category ?? [] {
                            self.serviceName.append(value.catTitle ?? "")
                        }
                       // self.serviceDropdownData.dataSource = self.serviceName
                        DispatchQueue.main.async {
                            completion() // Call completion handler
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST, .USER_EXISTS:
                do {
                    let data = try JSONDecoder().decode(MarketCategoryModel.self, from: result!)
                    //   self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(data.message))
                    //                    for value in self.MarketCatDataNew?.category ?? [] {
                    //                        self.serviceName.append(value.catTitle ?? "")
                    //                    }
                    //                    self.serviceDropdownData.dataSource = self.serviceName
                } catch {
                    print(error.localizedDescription)
                }
            case .UNAUTHORIZED:
                print(error?.localizedDescription)
                //   self.showLogoutAlert()
            default:
                break
            }
        }
    }
    
}
//pin Sell
