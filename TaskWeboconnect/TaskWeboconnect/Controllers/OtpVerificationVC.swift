//
//  OtpVerificationVC.swift
//  TaskWeboconnect
//
//  Created by Sandeep Srivastava on 25/07/24.
//

import UIKit

class OtpVerificationVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    @IBOutlet weak var otpT1: UITextField!
    
    @IBOutlet weak var otpT2: UITextField!
    
    @IBOutlet weak var otpT3: UITextField!
    
    @IBOutlet weak var otpT4: UITextField!
    
    
    @IBOutlet weak var lblNOtReceiveOtp: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    var phoneNumber = String()
    var receivedOtp: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSubmit.layer.cornerRadius = 5
        lblPhoneNumber.text = "+91 \(phoneNumber)"
        otpT1.becomeFirstResponder()
        navigationItem.backButtonTitle = ""
        let fullText = "Don't Receive OTP? Resend"
        
        let resendText = "Resend"
        
        
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 255/255, green: 127/255, blue: 93/255, alpha: 1)
        ]
        
        
        attributedString.addAttributes(normalAttributes, range: NSRange(location: 0, length: fullText.count))
        
        
        if let termsRange = fullText.range(of: resendText) {
            let nsRange = NSRange(termsRange, in: fullText)
            attributedString.addAttributes(linkAttributes, range: nsRange)
        }
        
        lblNOtReceiveOtp.attributedText = attributedString
        
        
        otpT1.delegate = self
        otpT2.delegate = self
        otpT3.delegate = self
        otpT4.delegate = self
        
        
        otpT1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpT2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpT3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpT4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count >= 1 {
            switch textField {
            case otpT1:
                otpT2.becomeFirstResponder()
            case otpT2:
                otpT3.becomeFirstResponder()
            case otpT3:
                otpT4.becomeFirstResponder()
            case otpT4:
                otpT4.resignFirstResponder()
            default:
                break
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            
            handleBackspace(for: textField)
            return false
        } else {
            
            handleCharacterInput(for: textField, with: string)
            return false
        }
    }
    
    private func handleBackspace(for textField: UITextField) {
        // Move cursor to the previous text field
        switch textField {
        case otpT2:
            otpT1.becomeFirstResponder()
        case otpT3:
            otpT2.becomeFirstResponder()
        case otpT4:
            otpT3.becomeFirstResponder()
        default:
            break
        }
        
        textField.text = ""
    }
    
    private func handleCharacterInput(for textField: UITextField, with string: String) {
        
        textField.text = string
        
        
        switch textField {
        case otpT1:
            otpT2.becomeFirstResponder()
        case otpT2:
            otpT3.becomeFirstResponder()
        case otpT3:
            otpT4.becomeFirstResponder()
        case otpT4:
            otpT4.resignFirstResponder()
        default:
            break
        }
    }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        let enteredOtp = "\(otpT1.text ?? "")\(otpT2.text ?? "")\(otpT3.text ?? "")\(otpT4.text ?? "")"
        let combinedReceivedOtp = receivedOtp.joined()
        if enteredOtp == combinedReceivedOtp {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let createProfileVc = storyboard.instantiateViewController(withIdentifier: "CreateProfileVc") as? CreateProfileVc
            
            self.navigationController?.pushViewController(createProfileVc!, animated: true)
            
        } else {
            showAlert(title: "Error", message: "Incorrect OTP. Please try again.")
        }
    }
    
}
