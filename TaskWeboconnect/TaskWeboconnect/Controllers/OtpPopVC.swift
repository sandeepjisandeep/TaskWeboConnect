//
//  OtpPopVC.swift
//  TaskWeboconnect
//
//  Created by Sandeep Srivastava on 25/07/24.
//

import UIKit

class OtpPopVC: UIViewController {
    
    
    @IBOutlet weak var bgViewOtp: UIView!
    
    @IBOutlet weak var otpD1: UILabel!
    
    @IBOutlet weak var otpD2: UILabel!
   
    @IBOutlet weak var otpD3: UILabel!
    
    @IBOutlet weak var otpD4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).withAlphaComponent(0.2)
            self.view.isOpaque = true
        self.navigationController?.navigationBar.isTranslucent = false
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
     //   view.backgroundColor = UIColor.white
        bgViewOtp.layer.cornerRadius = 10
        pushViewControllerAfterDelay()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Background color: \(String(describing: self.view.backgroundColor))")
        print("Is Opaque: \(self.view.isOpaque)")
    }


    
    func pushViewControllerAfterDelay() {
            let delayInSeconds = 3.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { [weak self] in
                guard let strongSelf = self else { return }
                
                // Check if the navigation controller exists
                guard let navigationController = strongSelf.navigationController else {
                    print("No navigation controller found.")
                    return
                }
                
                // Instantiate the new view controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let secondViewController = storyboard.instantiateViewController(withIdentifier: "OtpVerificationVC") as? OtpVerificationVC else {
                    print("SecondViewController not found.")
                    return
                }
                
                // Push the new view controller onto the navigation stack
                navigationController.pushViewController(secondViewController, animated: true)
            }
        }
}
