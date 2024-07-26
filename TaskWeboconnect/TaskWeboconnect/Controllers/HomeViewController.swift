//
//  HomeViewController.swift
//  TaskWeboconnect
//
//  Created by Sandeep Srivastava on 25/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MArks:-IBOutlet
    @IBOutlet weak var btnGetStarted: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnGetStarted.layer.cornerRadius = 5
        navigationItem.backButtonTitle = ""
    }
    
    @IBAction func btnGetStarted(_ sender: Any) {
        
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(identifier: "RequestOtpVc") as? RequestOtpVc
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
