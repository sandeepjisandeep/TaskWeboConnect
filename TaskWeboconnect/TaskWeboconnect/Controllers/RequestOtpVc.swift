//
//  RequestOtpVc.swift
//  TaskWeboconnect
//
//  Created by Sandeep Srivastava on 25/07/24.
//

import UIKit

class RequestOtpVc: UIViewController,UITextFieldDelegate {
    //MARKS:- IBOutlets
    @IBOutlet weak var lblBottom: UILabel!
    @IBOutlet weak var txtphoneNumber: UITextField!
    @IBOutlet weak var otpConfirmationView: UIView!
    @IBOutlet weak var btnRequestotp: UIButton!
    @IBOutlet weak var bgViewOtp: UIView!
    @IBOutlet weak var otpD1: UILabel!
    @IBOutlet weak var otpD2: UILabel!
    @IBOutlet weak var otpD3: UILabel!
    @IBOutlet weak var otpD4: UILabel!
    
    var firstDigit: String = ""
    var secondDigit: String = ""
    var thirdDigit: String = ""
    var fourthDigit: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtphoneNumber.becomeFirstResponder()
        otpConfirmationView.isHidden = true
        btnRequestotp.layer.cornerRadius = 5
        bgViewOtp.layer.cornerRadius = 10
        txtphoneNumber.delegate = self
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.backButtonTitle = ""
        let fullText = "By creating passcode you agree with our Terms & Conditions and Privacy Policy"
        
        let termsText = "Terms & Conditions"
        let privacyText = "Privacy Policy"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 255/255, green: 127/255, blue: 93/255, alpha: 1)
        ]
        
        
        attributedString.addAttributes(normalAttributes, range: NSRange(location: 0, length: fullText.count))
        
        
        if let termsRange = fullText.range(of: termsText) {
            let nsRange = NSRange(termsRange, in: fullText)
            attributedString.addAttributes(linkAttributes, range: nsRange)
        }
        
        if let privacyRange = fullText.range(of: privacyText) {
            let nsRange = NSRange(privacyRange, in: fullText)
            attributedString.addAttributes(linkAttributes, range: nsRange)
        }
        
        
        lblBottom.attributedText = attributedString
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        let isNumber = allowedCharacters.isSuperset(of: characterSet)
        
        
        if let currentText = textField.text, let range = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            
            return isNumber && updatedText.count <= 10
        }
        
        return false
    }
    
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        return phoneNumber.count == 10
    }
    
    func generateOtp(from phoneNumber: String) {
        
        firstDigit = String(phoneNumber[phoneNumber.index(phoneNumber.startIndex, offsetBy: 0)])
        secondDigit = String(phoneNumber[phoneNumber.index(phoneNumber.startIndex, offsetBy: 1)])
        thirdDigit = String(phoneNumber[phoneNumber.index(phoneNumber.endIndex, offsetBy: -2)])
        fourthDigit = String(phoneNumber[phoneNumber.index(phoneNumber.endIndex, offsetBy: -1)])
    }
    
    
    func pushViewControllerAfterDelay() {
        let delayInSeconds = 3.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { [weak self] in
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let otpVerificationVc = storyboard.instantiateViewController(withIdentifier: "OtpVerificationVC") as? OtpVerificationVC
            
            otpVerificationVc?.phoneNumber = self?.txtphoneNumber.text ?? ""
            otpVerificationVc!.receivedOtp = [self?.firstDigit ?? "", self?.secondDigit ?? "", self?.thirdDigit ?? "", self?.fourthDigit ?? ""]
            
            
            self?.navigationController?.pushViewController(otpVerificationVc!, animated: true)
        }
    }
    
    
    @IBAction func RequestOTPAction(_ sender: Any) {
        if let phoneNumber = txtphoneNumber.text {
            if isValidPhoneNumber(phoneNumber) {
                generateOtp(from: phoneNumber)
                otpConfirmationView.isHidden = false
                otpD1.text = "\(firstDigit)"
                otpD2.text = "\(secondDigit)"
                otpD3.text = "\(thirdDigit)"
                otpD4.text = "\(fourthDigit)"
                pushViewControllerAfterDelay()
            } else {
                print("Invalid phone number")
                let alertController = UIAlertController(title: title, message: "Please Enter full phone number", preferredStyle: .alert)
                
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
}





