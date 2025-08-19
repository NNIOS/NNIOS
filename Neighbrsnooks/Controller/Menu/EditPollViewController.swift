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
    
    @IBOutlet weak var PollsView: UIView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var EndDateView: UIView!
    
    @IBOutlet weak var option1: UIView!
    @IBOutlet weak var option2: UIView!
    @IBOutlet weak var option3: UIView!
    @IBOutlet weak var option4: UIView!
    
    var PollDetailData : PollDetailModel?
    var PollVotedData : PollVotedModel?
    var PollEditData : PollEditModel?
    
    var pollid : String?
    var id : String?
    var selectedPollOption: String?
    var selectedIndex: IndexPath?
    var previousSelectedIndex: IndexPath?
    var selectedDate: Date?
    
    var selectedStartDateForAPI: String?
    var selectedEndDateForAPI: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvQuest.autocapitalizationType = .sentences
        tfop1.autocapitalizationType = .sentences
        tfop2.autocapitalizationType = .sentences
        tfop3.autocapitalizationType = .sentences
        tfop4.autocapitalizationType = .sentences
        createStartDatePicker()
         createEndDatePicker()
        NetworkMonitor.shared.startMonitoring()
        
        PollsView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        option1.backgroundColor = UIColor.systemBackground
        option2.backgroundColor = UIColor.systemBackground
        option3.backgroundColor = UIColor.systemBackground
        option4.backgroundColor = UIColor.systemBackground
        //        updateColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeading.text = "Edit Poll"
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
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
            
//            if let startDate = self.PollDetailData?.startDate {
//                selectedStartDateForAPI = formatDateForAPI(from: startDate)
//            }
//            if let endDate = self.PollDetailData?.endDate {
//                selectedEndDateForAPI = formatDateForAPI(from: endDate)
//            }
            if let startDate = self.PollDetailData?.startDate {
                selectedStartDateForAPI = startDate // already yyyy-MM-dd
                tfStartDatee.text = formatDateForDisplay(from: startDate) // dd MMM, yyyy
            }

            if let endDate = self.PollDetailData?.endDate {
                selectedEndDateForAPI = endDate // already yyyy-MM-dd
                tfEndDate.text = formatDateForDisplay(from: endDate) // dd MMM, yyyy
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
    
    private func updateColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark mode colors
            questionView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            startDateView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            EndDateView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            option1.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            option2.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            option3.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            option4.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
            questionView.layer.borderWidth = 1.0 // Enable border in dark mode
            startDateView.layer.borderWidth = 1.0
            EndDateView.layer.borderWidth = 1.0
            option1.layer.borderWidth = 1.0 // Enable border in dark mode
            option2.layer.borderWidth = 1.0
            option3.layer.borderWidth = 1.0
            option4.layer.borderWidth = 1.0
            
            
        } else {
            // Light mode mein storyboard ke original colors preserve karna
            //  questionView.textColor = UIColor.secondaryLabel
            questionView.isUserInteractionEnabled = true // Disable in light mode
            startDateView.isUserInteractionEnabled = true
            EndDateView.isUserInteractionEnabled = true
            
            option1.isUserInteractionEnabled = true // Disable in light mode
            option2.isUserInteractionEnabled = true
            option3.isUserInteractionEnabled = true
            option4.isUserInteractionEnabled = true
            
            questionView.layer.borderWidth = 0 // Remove border in light mode
            startDateView.layer.borderWidth = 0
            EndDateView.layer.borderWidth = 0
            
            option1.layer.borderWidth = 0 // Remove border in light mode
            option2.layer.borderWidth = 0
            option3.layer.borderWidth = 0
            option4.layer.borderWidth = 0
            PollsView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            
        }
        //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
    }
    
    @IBAction func btnStartDate(_ sender: UIButton) {
        showDatePicker(for: tfStartDatee)
    }
    
    @IBAction func btnEndDate(_ sender: UIButton) {
        showDatePicker(for: tfEndDate)
    }
    
//    func formatDateForAPI(from dateString: String) -> String {
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "dd-MM-yyyy"
//        
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = "yyyy-MM-dd"
//        
//        if let date = inputFormatter.date(from: dateString) {
//            return outputFormatter.string(from: date)
//        }
//        return dateString
//    }
    
    func formatDateForDisplay(from apiDate: String) -> String {
        let apiFormatter = DateFormatter()
        apiFormatter.dateFormat = "yyyy-MM-dd"

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd MMM, yyyy" // 👈 Display format (e.g. 16 Jul, 2025)

        if let date = apiFormatter.date(from: apiDate) {
            return displayFormatter.string(from: date)
        }
        return apiDate
    }


    
    
    func createStartDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
        tfStartDatee.inputView = datePicker
    }

    func createEndDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
        tfEndDate.inputView = datePicker
    }

    @objc func startDateChanged(_ sender: UIDatePicker) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd-MM-yyyy"
        
        let selectedDate = sender.date
        tfStartDatee.text = displayFormatter.string(from: selectedDate)
        
        // ✅ Format and Save for API
        selectedStartDateForAPI = formatDateForAPI(from: tfStartDatee.text ?? "")
    }

    @objc func endDateChanged(_ sender: UIDatePicker) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd-MM-yyyy"
        
        let selectedDate = sender.date
        tfEndDate.text = displayFormatter.string(from: selectedDate)
        
        // ✅ Format and Save for API
        selectedEndDateForAPI = formatDateForAPI(from: tfEndDate.text ?? "")
    }

    
    
    func formatDateForAPI(from displayDate: String) -> String? {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd-MM-yyyy"
        
        let apiFormatter = DateFormatter()
        apiFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = displayFormatter.date(from: displayDate) {
            return apiFormatter.string(from: date)
        }
        return nil
    }

    
    
    func showDatePicker(for textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
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
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if tfStartDatee.isFirstResponder {
            tfStartDatee.text = formatter.string(from: sender.date)
        } else if tfEndDate.isFirstResponder {
            tfEndDate.text = formatter.string(from: sender.date)
        }
        selectedDate = sender.date
    }
    
    @objc func doneButtonTapped() {
        let selectedDate = selectedDate ?? Date()

        // For API format: yyyy-MM-dd
        let apiFormatter = DateFormatter()
        apiFormatter.dateFormat = "yyyy-MM-dd"
        apiFormatter.locale = Locale(identifier: "en_US_POSIX")
        let apiDateString = apiFormatter.string(from: selectedDate)

        // For Display format: dd MMM, yyyy
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd MMM, yyyy"
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        let displayDateString = displayFormatter.string(from: selectedDate)

        if tfStartDatee.isFirstResponder {
            tfStartDatee.text = displayDateString
            selectedStartDateForAPI = apiDateString
        } else if tfEndDate.isFirstResponder {
            tfEndDate.text = displayDateString
            selectedEndDateForAPI = apiDateString
        }

        view.endEditing(true)
    }



    func isPreviousDate(_ date: Date) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let inputDate = Calendar.current.startOfDay(for: date)
        return inputDate < today
    }
    
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
    
    @IBAction func PublishBtn(_ sender: UIButton) {
        
        let option1 = tfop1.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let option2 = tfop2.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let option3 = tfop3.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let option4 = tfop4.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let question = tvQuest.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let startDate = tfStartDatee.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let endDate = tfEndDate.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if question.isEmpty {
            showSimpleAlert("Please enter a question.")
            return
        }
        
        if containsBadWords(question) {
            showSimpleAlert("Question contains inappropriate words. Please revise.")
            return
        }
        
        if startDate.isEmpty {
            showSimpleAlert("Please enter a start date.")
            return
        }
        
        if endDate.isEmpty {
            showSimpleAlert("Please enter an end date.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let endDateObj = dateFormatter.date(from: endDate), isPreviousDate(endDateObj) {
            showSimpleAlert("Please select today’s date or a future date to publish your poll.")
            return
        }
        
        if option1.isEmpty {
            showSimpleAlert("Please enter Option 1.")
            return
        }
        
        if option2.isEmpty {
            showSimpleAlert("Please enter Option 2.")
            return
        }
        
        let allOptions = [option1, option2, option3, option4]
        for (index, option) in allOptions.enumerated() where !option.isEmpty {
            if containsBadWords(option) {
                showSimpleAlert("Option \(index + 1) contains inappropriate words.")
                return
            }
        }
        
        callPollEditWebService {
            if let viewControllers = self.navigationController?.viewControllers, viewControllers.count >= 3 {
                let targetVC = viewControllers[viewControllers.count - 3]
                self.navigationController?.popToViewController(targetVC, animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showSimpleAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let attributedMessage = NSAttributedString(
            string: message,
            attributes: [.font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)]
        )
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor")
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func callPollDetailWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        var dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "poll_id":pollid ?? ""
        ]
        WebService.sharedInstance.callPollDetailWebService(withParams: dictParams) { responseData in
            if let PollDetailData = responseData as? PollDetailModel {
                self.PollDetailData = PollDetailData
                UserDefaults.standard.set(self.PollDetailData?.pID, forKey: "Pollid")
                print("Decoded data: \(PollDetailData)")
                completionClosure()
            } else {
                print("Error: Could not cast responseData to NewNotificationModel")
            }
        }
    }
    
    
    // 🔁 Convert from display format to API format
    func convertToAPIDateFormat(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd MMM, yyyy"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString // fallback
        }
    }

    
    func callPollEditWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        
        // ✅ Convert the displayed start date to correct format
        let convertedStartDate = convertToAPIDateFormat(tfStartDatee.text ?? "")
        let convertedEndDate = convertToAPIDateFormat(tfEndDate.text ?? "")

        let dictParams: Dictionary<String, Any> = [
            "userid": id ?? "",
            "poll_id": pollid ?? "",
            "title": self.tvQuest.text ?? "",
            "start_date": convertedStartDate,
            "end_date": convertedEndDate,
            "poll_ques": self.tvQuest.text ?? "",
            "firstoption": self.tfop1.text ?? "",
            "secondoption": self.tfop2.text ?? "",
            "thirdoption": self.tfop3.text ?? "",
            "fourthoption": self.tfop4.text ?? ""
        ]
        
        print("Request Parameters: \(dictParams)")
        
        WebService.sharedInstance.callPollEditWebService(withParams: dictParams) { data in
            self.PollEditData = data
            print("Response Data: \(data)")
            completionClosure()
        }
    }

    
    
    
//    func callPollEditWebService(_ completionClosure: @escaping () -> ()) {
//        let id = UserDefaults.standard.string(forKey: "userid")
//        let dictParams: Dictionary<String, Any> = [
//            "userid":id ?? "",
//            "poll_id":pollid ?? "",
//            "title":self.tvQuest.text ?? "",
//            "start_date":selectedStartDateForAPI ?? "",
//            "end_date":selectedEndDateForAPI ?? "",
//            "poll_ques":self.tvQuest.text ?? "",
//            "firstoption": self.tfop1.text ?? "",
//            "secondoption":self.tfop2.text ?? "",
//            "thirdoption":self.tfop3.text ?? "",
//            "fourthoption": self.tfop4.text ?? ""
//        ]
//        print("Request Parameters: \(dictParams)")
//        WebService.sharedInstance.callPollEditWebService(withParams: dictParams) { data in
//            self.PollEditData = data
//            print("Response Data: \(data)")
//            completionClosure()
//        }
//    }
}
