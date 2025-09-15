//
//  CreatePollViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 15/10/24.
//

import UIKit

@available(iOS 16.0, *)
class CreatePollViewController: UIViewController, UITextViewDelegate {

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
   
    var CreatePollData : CreatePollModel?
    let placeholderText = "What is your question?"
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        self.tvQuest.font = UIFont(name: "Montserrat-Regular", size: 17)
        
        self.tfop1.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfop2.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfop3.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfop4.font = UIFont(name: "Montserrat-Regular", size: 17)
        
        self.tfStartDatee.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.tfEndDate.font = UIFont(name: "Montserrat-Regular", size: 17)
        tvQuest.delegate = self
        NetworkMonitor.shared.startMonitoring()
        tvQuest.textColor =  #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
        //        PollsView.backgroundColor = UIColor.systemBackground
        //        option1.backgroundColor = UIColor.systemBackground
        //        option2.backgroundColor = UIColor.systemBackground
        //        option3.backgroundColor = UIColor.systemBackground
        //        option4.backgroundColor = UIColor.systemBackground
        //        updateColors()
        // Set initial placeholder
        tvQuest.text = placeholderText
        //  tvQuest.textColor =  #colorLiteral(red: 0.3098039216, green: 0.4745098039, blue: 0.3490196078, alpha: 1)
        
        //        tfStartDatee.attributedPlaceholder = NSAttributedString(
        //            string: "Start date", // Placeholder text
        //            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray] // Set the color
        //        )
        //
        //        tfEndDate.attributedPlaceholder = NSAttributedString(
        //            string: "End date", // Placeholder text
        //            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray] // Set the color
        //        )
        
          //  tfBrand.autocapitalizationType = .sentences
            tvQuest.autocapitalizationType = .sentences
            tfop1.autocapitalizationType = .sentences
            tfop2.autocapitalizationType = .sentences
            tfop3.autocapitalizationType = .sentences
            tfop4.autocapitalizationType = .sentences
            
            // Do any additional setup after loading the view.
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
            questionView.isUserInteractionEnabled = true
                   startDateView.isUserInteractionEnabled = true
                   EndDateView.isUserInteractionEnabled = true
                   
                   option1.isUserInteractionEnabled = true
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            updateColors()
        }
    }
    
    @IBAction func btnStartDate(_ sender: UIButton) {
        showDatePicker(for: tfStartDatee)
    }
    
    @IBAction func btnEndDate(_ sender: UIButton) {
        showDatePicker(for: tfEndDate)
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
        selectedDate = sender.date
    }

    @objc func doneButtonTapped() {
        let selectedDate = selectedDate ?? Date()

        // Formatter for display (dd-MM-yyyy)
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd-MM-yyyy"
        let displayDateString = displayFormatter.string(from: selectedDate)

        // Formatter for storing/sending (yyyy-MM-dd)
        let sendFormatter = DateFormatter()
        sendFormatter.dateFormat = "yyyy-MM-dd"
        let sendDateString = sendFormatter.string(from: selectedDate)

        if tfStartDatee.isFirstResponder {
            tfStartDatee.text = displayDateString
            selectedStartDateForAPI = sendDateString  // Store for API
        } else if tfEndDate.isFirstResponder {
            tfEndDate.text = displayDateString
            selectedEndDateForAPI = sendDateString  // Store for API
        }

        view.endEditing(true)
    }

    // Variables to store dates for API
    var selectedStartDateForAPI: String?
    var selectedEndDateForAPI: String?

  

    @objc func cancelButtonTapped() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.text == placeholderText {
               textView.text = "" // Remove the placeholder text
               textView.textColor =  #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1) // Change the text color to black for user input
           }
       }
       
       // UITextViewDelegate method to handle when the user finishes editing
       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = placeholderText // Add the placeholder text back if the text view is empty
               textView.textColor =  #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1) // C // Set the placeholder text color to light gray
           }
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
        
        // 🔴 Empty check
        if question.isEmpty || question == placeholderText {
            showPopAlert(message: "Please enter poll title")
            return
        }
        
        // 🚫 Bad word check for question
        if containsBadWords(question) {
            showPopAlert(message: "Poll title contains inappropriate words. Please revise.")
            return
        }
        
        if tfStartDatee.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            showPopAlert(message: "Please enter poll open date")
            return
        } else if tfEndDate.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            showPopAlert(message: "Please enter poll close date")
            return
        } else if option1.isEmpty {
            showPopAlert(message: "Please enter poll option 1")
            return
        } else if option2.isEmpty {
            showPopAlert(message: "Please enter at least one other option.")
            return
        }

        // 🚫 Bad word check for options
        let allOptions = [option1, option2, option3, option4]
        for (index, option) in allOptions.enumerated() where !option.isEmpty {
            if containsBadWords(option) {
                showPopAlert(message: "Poll option \(index + 1) contains inappropriate words.")
                return
            }
        }

        // ✅ Duplicate check
        let nonEmptyOptions = allOptions.filter { !$0.isEmpty }
        let optionsSet = Set(nonEmptyOptions)
        
        if optionsSet.count < nonEmptyOptions.count {
            showPopAlert(message: "Options contain duplicate data. Please enter unique values.")
            return
        }

        // ✅ Proceed with web service
        callPollCreateWebService {
            self.navigationController?.popViewController(animated: true)
        }
    }

    
    func showNewAlert(message: String) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)

        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)] // Adjust the size as needed
        let messageAttrString = NSAttributedString(string: message, attributes: messageFont)

        alert.setValue(messageAttrString, forKey: "attributedMessage") // Apply the attributed string

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

    
    func showPopAlert(message: String) {
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let font = UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.darkGray
            ]
            
            let attributedTitle = NSAttributedString(string: title ?? "", attributes: titleAttributes)
            let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            okAction.setValue(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1), forKey: "titleTextColor")
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }

    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    func callPollCreateWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let idNeighbour = UserDefaults.standard.string(forKey: "neighbrshood")
        

        
        let dictParams: Dictionary<String, Any> = [
                                                               "userid":id ?? "",
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

        WebService.sharedInstance.callPollCreateWebService(withParams: dictParams) { data in
            // Directly assign the PollVotedModel object to self.PollVotedData
            self.CreatePollData = data  // Assuming data is already of type PollVotedModel
            
            // Log response data
            print("Response Data: \(self.CreatePollData)")
            
            completionClosure()
        }
    }
}
