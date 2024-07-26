//
//  LaunchScreenViewController.swift
//  TaskWeboconnect
//
//  Created by Sandeep Srivastava on 25/07/24.
//

import UIKit

class LaunchScreenViewController: UIViewController {

   
    override func viewDidLoad() {
           super.viewDidLoad()
           // Set up your placeholder view here, similar to the launch screen
           
           // Start the process to transition to the main view controller
           startTransition()
       }

       func startTransition() {
           // Simulate loading process (e.g., data loading)
           DispatchQueue.global(qos: .background).async {
               // Perform any loading tasks here, for example:
               // loadData()

               // Simulate a delay (replace with actual loading time if necessary)
               sleep(3) // Just for demonstration; avoid using sleep in production code

               // Once loading is complete, transition to the main view controller
               DispatchQueue.main.async {
                   self.transitionToMainViewController()
               }
           }
       }

       func transitionToMainViewController() {
           let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
           if let mainVC = mainStoryboard.instantiateInitialViewController() {
               mainVC.modalTransitionStyle = .crossDissolve
               mainVC.modalPresentationStyle = .fullScreen
               self.present(mainVC, animated: true, completion: nil)
           }
       }
    }



