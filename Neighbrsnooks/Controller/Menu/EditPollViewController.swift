//
//  EditPollViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 14/01/25.
//

import UIKit

@available(iOS 16.0, *)
class EditPollViewController: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
   
    
    @IBOutlet weak var tvQuest: UITextView!
    @IBOutlet weak var tfop1: UITextField!
    @IBOutlet weak var tfop2: UITextField!
    @IBOutlet weak var tfop3: UITextField!
    @IBOutlet weak var tfop4: UITextField!
    
    @IBOutlet weak var tfStartDatee: UITextField!
    @IBOutlet weak var tfEndDate: UITextField!
   
   // @IBOutlet weak var profileImgView : UIImageView!
    
    var PollDetailData : PollDetailModel?
    var PollVotedData : PollVotedModel?
    var PollEditData : PollEditModel?
    
    var pollid : String?
    var id : String?
    var selectedPollOption: String?
    var selectedIndex: IndexPath? // To store the selected index
    var previousSelectedIndex: IndexPath?
    var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        tvQuest.autocapitalizationType = .sentences
        tfop1.autocapitalizationType = .sentences
        tfop2.autocapitalizationType = .sentences
        tfop3.autocapitalizationType = .sentences
        tfop4.autocapitalizationType = .sentences
        NetworkMonitor.shared.startMonitoring()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.tvQuest.font = UIFont(name: "Montserrat-Regular", size: 17)
        
        self.tfop1.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfop2.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfop3.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfop4.font = UIFont(name: "Montserrat-Regular", size: 17)
        
        self.tfStartDatee.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfEndDate.font = UIFont(name: "Montserrat-Regular", size: 17)
       
        callPollDetailWebService { [self] in
            self.tfStartDatee.text = self.PollDetailData?.startDate
            self.tfEndDate.text = self.PollDetailData?.endDate
            self.tvQuest.text = self.PollDetailData?.pollQues

            if let startDate = self.PollDetailData?.startDate {
                selectedStartDateForAPI = formatDateForAPI(from: startDate)
            }
            if let endDate = self.PollDetailData?.endDate {
                selectedEndDateForAPI = formatDateForAPI(from: endDate)
            }

            if let options = self.PollDetailData?.options {
                self.tfop1.text = options.indices.contains(0) ? options[0].option : nil
                self.tfop2.text = options.indices.contains(1) ? options[1].option : nil
                self.tfop3.text = options.indices.contains(2) ? options[2].option : nil
                self.tfop4.text = options.indices.contains(3) ? options[3].option : nil
            }
        }
    }

    @IBAction func BackButtionAction(_ : UIButton){

        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnStartDate(_ sender: UIButton) {
        showDatePicker(for: tfStartDatee)
    }
    
    @IBAction func btnEndDate(_ sender: UIButton) {
        showDatePicker(for: tfEndDate)
    }
    
    func formatDateForAPI(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString // Agar conversion fail ho jaye toh original string return karo
    }

    
    func showDatePicker(for textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        // Set the selectedDate to current date if nil
        if selectedDate == nil {
            selectedDate = Date()
        }
        datePicker.date = selectedDate!

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))

        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)

        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        textField.becomeFirstResponder()
    }

       @objc func dateChanged(_ sender: UIDatePicker) {
           // Convert date to string format
           let formatter = DateFormatter()
           formatter.dateFormat = "dd-MM-yyyy"
           
           if let textField = tfStartDatee.isFirstResponder ? tfStartDatee : tfEndDate {
               textField.text = formatter.string(from: sender.date)
           }
       }
    
    @objc func doneButtonTapped() {
        let selectedDate = selectedDate ?? Date()

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd-MM-yyyy"
        let displayDateString = displayFormatter.string(from: selectedDate)

        let sendFormatter = DateFormatter()
        sendFormatter.dateFormat = "yyyy-MM-dd"
        let sendDateString = sendFormatter.string(from: selectedDate)

        if tfStartDatee.isFirstResponder {
            tfStartDatee.text = displayDateString
            selectedStartDateForAPI = sendDateString
        } else if tfEndDate.isFirstResponder {
            tfEndDate.text = displayDateString
            selectedEndDateForAPI = sendDateString
        }

        view.endEditing(true)
    }


    // Variables to store dates for API
    var selectedStartDateForAPI: String?
    var selectedEndDateForAPI: String?

       @objc func cancelButtonTapped() {
           view.endEditing(true)
       }
    
    func showTimePicker(completion: @escaping (String) -> Void) {
            let alert = UIAlertController(title: "Select Time", message: "\n\n\n\n\n\n", preferredStyle: .alert)
            
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 270, height: 200))
            datePicker.datePickerMode = .time
            
            alert.view.addSubview(datePicker)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                completion(formatter.string(from: datePicker.date))
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    
    @IBAction func PublishBtn(_ sender: UIButton){
        
        let option1 = tfop1.text ?? ""
            let option2 = tfop2.text ?? ""
            let option3 = tfop3.text ?? ""
            let option4 = tfop4.text ?? ""

        
        if tvQuest.text == "" {
        let alert = UIAlertController(title: "", message: "Please Enter Question", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
                         
        }
        else if tfStartDatee.text == ""{
        let alert = UIAlertController(title: "", message: "Please Enter Start Date", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        else if tfEndDate.text == ""{
        let alert = UIAlertController(title: "", message: "Please Enter End Date", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        
        else if tfop1.text == ""{
        let alert = UIAlertController(title: "", message: "Please Enter Option 1", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        else if tfop2.text == ""{
        let alert = UIAlertController(title: "", message: "Please Enter Option 2", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }

        else {
               // Check for duplicate options
               let optionsArray = [option1, option2, option3, option4]
               let optionsSet = Set(optionsArray)

               if optionsSet.count < optionsArray.count {
                   showAlert(message: "Options contain duplicate data. Please enter unique values.")
               }  else{
                   callPollEditWebService{
                       self.navigationController?.popViewController(animated: true)
                   }
               }
           }
        
      
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func callPollDetailWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let Pollid = UserDefaults.standard.string(forKey: "Pollid")
        var dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "poll_id":pollid ?? ""
        ]

        

        WebService.sharedInstance.callPollDetailWebService(withParams: dictParams) { responseData in
            // Handle the response
            if let PollDetailData = responseData as? PollDetailModel {
                self.PollDetailData = PollDetailData
                UserDefaults.standard.set(self.PollDetailData?.pID, forKey: "Pollid")
                print("Decoded data: \(self.PollDetailData)")
                completionClosure()
            } else {
                print("Error: Could not cast responseData to NewNotificationModel")
            }
        }
    }

    func callPollEditWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        


        let dictParams: Dictionary<String, Any> = [
                                                               "userid":id ?? "",
                                                               "poll_id":pollid ?? "",
                                                               "title":self.tvQuest.text ?? "",
                                                               "start_date":selectedStartDateForAPI ?? "",
                                                               "end_date":selectedEndDateForAPI ?? "",
                                                               "poll_ques":self.tvQuest.text ?? "",
                                                               "firstoption": self.tfop1.text ?? "",
                                                               "secondoption":self.tfop2.text ?? "",
                                                               "thirdoption":self.tfop3.text ?? "",
                                                               "fourthoption": self.tfop4.text ?? ""
        ]
        
        print("Request Parameters: \(dictParams)")

        WebService.sharedInstance.callPollEditWebService(withParams: dictParams) { data in
            // Directly assign the PollVotedModel object to self.PollVotedData
            self.PollEditData = data  // Assuming data is already of type PollVotedModel
            
            // Log response data
            print("Response Data: \(self.PollEditData)")
            
            completionClosure()
        }
    }
}
