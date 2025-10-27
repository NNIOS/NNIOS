//
//  EditPollViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 14/01/25.
//

import UIKit

@available(iOS 16.0, *)
class EditPollViewController: BaseViewController {
    
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
    
    var id : String?
    var jPollId:Int?
    var pollid : String?
    var selectedDate: Date?
    var selectedIndex: IndexPath?
    var selectedPollOption: String?
    var selectedEndDateForAPI: String?
    var selectedStartDateForAPI: String?
    var previousSelectedIndex: IndexPath?
    var objDecryptPollDetailData:PollDetailsDecryptModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStartDate(_ sender: UIButton) {
        showDatePicker(for: tfStartDatee)
    }
    
    @IBAction func btnEndDate(_ sender: UIButton) {
        showDatePicker(for: tfEndDate)
    }
    
    @IBAction func PublishBtn(_ sender: UIButton) {
        if Reach().isInternet() {
            if validatePollInputs() {
                self.updatepollApi()
            }
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
}

extension EditPollViewController {
    
    func setupUI() {
        if Reach().isInternet() {
            tvQuest.autocapitalizationType = .sentences
            tfop1.autocapitalizationType = .sentences
            tfop2.autocapitalizationType = .sentences
            tfop3.autocapitalizationType = .sentences
            tfop4.autocapitalizationType = .sentences
            self.lblHeading.text = "Edit Poll"
            self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
            self.tvQuest.font = UIFont(name: "Montserrat-Regular", size: 17)
            self.tfop1.font = UIFont(name: "Montserrat-Regular", size: 17)
            self.tfop2.font = UIFont(name: "Montserrat-Regular", size: 17)
            self.tfop3.font = UIFont(name: "Montserrat-Regular", size: 17)
            self.tfop4.font = UIFont(name: "Montserrat-Regular", size: 17)
            self.tfStartDatee.font = UIFont(name: "Montserrat-Regular", size: 17)
            self.tfEndDate.font = UIFont(name: "Montserrat-Regular", size: 17)
            PollsView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
            option1.backgroundColor = UIColor.systemBackground
            option2.backgroundColor = UIColor.systemBackground
            option3.backgroundColor = UIColor.systemBackground
            option4.backgroundColor = UIColor.systemBackground
            let item = objDecryptPollDetailData?.data.data
            self.tvQuest.text = item?.poll_ques
            self.tfEndDate.text = item?.end_date
            self.tfStartDatee.text = item?.start_date
            if let options = objDecryptPollDetailData?.data.data.options {
                let textFields = [tfop1, tfop2, tfop3, tfop4]
                for (index, option) in options.prefix(textFields.count).enumerated() {
                    let cleanedOption = option.option
                        .replacingOccurrences(of: "[", with: "")
                        .replacingOccurrences(of: "]", with: "")
                        .replacingOccurrences(of: "\"", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    textFields[index]?.text = cleanedOption
                }
            }
        } else {
            AlertViewManager.shared.alertMessage(title: "Neighbrsnook", message: AlertMessages.NoInternetConnection, controller: self)
        }
    }
    
    func updatepollApi() {
        var optionArray : [String]?
         optionArray = [
            tfop1.text ?? "",
            tfop2.text ?? "",
            tfop3.text ?? "",
            tfop4.text ?? ""
        ].filter { !$0.isEmpty }
        
        let convertedStartDate = convertToAPIDateFormat(tfStartDatee.text ?? "")
        let convertedEndDate = convertToAPIDateFormat(tfEndDate.text ?? "")
        let request = pollUpdate_Request(title: tvQuest.text ?? "",
                                         question: tvQuest.text ?? "",
                                         options: optionArray,
                                         start_date: convertedStartDate,
                                         end_date: convertedEndDate,
                                         id: jPollId)
        
        let param: [String: Any] = [
            "title": request.title ?? "",
            "question": request.question ?? "",
            "options[]": "[\(request.options?.joined(separator: ",") ?? "")]",
            "start_date": request.start_date ?? "",
            "end_date": request.end_date ?? "",
            "id":request.id ?? 0
        ]
        print("Edit poll param is: \(param)")
        let ViewModel = PollDetail_VM()
        ViewModel.fetchPollUpdate(parameter: param, request: request) { response in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func convertToAPIDateFormat(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd MMM, yyyy"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
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
        selectedDate = sender.date
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
    
    func validatePollInputs() -> Bool {
        let option1 = tfop1.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let option2 = tfop2.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let option3 = tfop3.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let option4 = tfop4.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let question = tvQuest.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let startDate = tfStartDatee.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let endDate = tfEndDate.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if question.isEmpty { alertToast(Message: "Please enter a question."); return false }
        if containsBadWords(question) { alertToast(Message: "Question contains inappropriate words. Please revise."); return false }
        if startDate.isEmpty { alertToast(Message: "Please enter a start date."); return false }
        if endDate.isEmpty { alertToast(Message: "Please enter an end date."); return false }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let endDateObj = dateFormatter.date(from: endDate), isPreviousDate(endDateObj) {
            alertToast(Message: "Please select today’s date or a future date to publish your poll."); return false
        }
        let allOptions = [option1, option2, option3, option4]
        for (index, option) in allOptions.enumerated() {
            if index < 2 && option.isEmpty {  alertToast(Message: "Please enter Option \(index + 1)."); return false }
            if !option.isEmpty && containsBadWords(option) {
                alertToast(Message: "Option \(index + 1) contains inappropriate words."); return false
            }
        }
        return true
    }
}
