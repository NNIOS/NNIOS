//
//  PDFViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 06/12/24.
//

import UIKit
import PDFKit
class PDFViewController: UIViewController {
    
    @IBOutlet weak var pdfView: UIView!
    @IBOutlet weak var deleteButton: UIButton!

    
    var pdfURL: URL?  // Variable to hold the selected PDF URL
    var shouldHideDeleteButton: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPDFView()
        deleteButton.isHidden = shouldHideDeleteButton  // ✅ THIS IS IMPORTANT
    }
    
    // Function to setup PDFView and display PDF
       private func setupPDFView() {
           guard let pdfURL = pdfURL else { return }
           
           // Create a PDFView and set its frame
           let pdfView = PDFView(frame: view.bounds)
           pdfView.autoScales = true  // Automatically scale PDF to fit the screen
           
           // Load the PDF document
           if let pdfDocument = PDFDocument(url: pdfURL) {
               pdfView.document = pdfDocument
           } else {
               print("Failed to load PDF document.")
           }
           
           // Add PDFView to the controller's view
           self.pdfView.addSubview(pdfView)
       }
    
    
    // Close button action to pop the view controller
        @IBAction func actionClose(_ sender: UIButton) {
            if let updateVC = self.navigationController?.viewControllers.first(where: { $0 is UpdateBusinessViewController }) as? UpdateBusinessViewController {
                updateVC.shouldCallAPI = false
            }
            self.navigationController?.popViewController(animated: true)  // Pop the view controller
        }
    

          
    @IBAction func actionDeletePdf(_ sender: UIButton) {
        guard let pdfURL = pdfURL else {
            print("No PDF file to delete.")
            return
        }

        do {
            try FileManager.default.removeItem(at: pdfURL)
            print("PDF file deleted successfully.")
            
            self.pdfURL = nil
            
            for subview in self.pdfView.subviews {
                subview.removeFromSuperview()
            }
            
            // Notify parent controller
            NotificationCenter.default.post(name: NSNotification.Name("PDFDeleted"), object: nil)

            showAlert(message: "PDF file deleted successfully.")
        } catch {
            print("Error deleting PDF file: \(error.localizedDescription)")
            showAlert(message: "Failed to delete the PDF file.")
        }
    }

          // Function to show an alert
          private func showAlert(message: String) {
              let alert = UIAlertController()
              
              // Add an "OK" action to dismiss the alert
              let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
              alert.addAction(okAction)
              if let updateVC = self.navigationController?.viewControllers.first(where: { $0 is UpdateBusinessViewController }) as? UpdateBusinessViewController {
                  updateVC.shouldCallAPI = false
              }
              // Present the alert
              self.navigationController?.popViewController(animated: true)  // Pop the view controller
          }
    
}
