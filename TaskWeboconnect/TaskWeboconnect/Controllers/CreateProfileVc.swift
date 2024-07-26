//
//  CreateProfileVc.swift
//  TaskWeboconnect
//
//  Created by Sandeep Srivastava on 26/07/24.
//

import UIKit
import MobileCoreServices
import Network

class CreateProfileVc: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var locationView: UIView!
    
    private var profile: Profile?
    private var activityIndicator: UIActivityIndicatorView!
    private var networkMonitor: NWPathMonitor?
    private var isNetworkAvailable: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        locationView.layer.cornerRadius = 5
        navigationItem.title = "Create Profile"
        navigationItem.backButtonTitle = ""
        selectImg.layer.cornerRadius = 60
        btnSubmit.layer.cornerRadius = 10
        txtPhoneNumber.delegate = self
        txtPostCode.delegate = self

        // Set up activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Set up network monitoring
        startNetworkMonitoring()

        // Set up image picker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        selectImg.isUserInteractionEnabled = true
        selectImg.addGestureRecognizer(tapGesture)
    }

    // MARK: - Function for Pick image from Gallery
    @objc func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            selectImg.image = selectedImage
            selectImg.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSubmitAction(_ sender: UIButton) {
        guard isNetworkAvailable else {
            // Show alert if no network connection
            let alertController = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let image = selectImg.image, let imageData = image.jpegData(compressionQuality: 0.7) else {
            // Handle error: No image selected
            return
        }

        let firstName = txtFirstName.text ?? ""
        let lastName = txtLastName.text ?? ""
        let phoneNumber = txtPhoneNumber.text ?? ""
        let postCode = txtPostCode.text ?? ""

        profile = Profile(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, postCode: postCode, imageData: imageData)

        guard let profile = profile else { return }
        
        activityIndicator.startAnimating()
        
        ProfileService.uploadProfile(profile) { success in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                let message = success ? "Profile Data uploaded successfully." : "Failed to upload profile."
                let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    private func startNetworkMonitoring() {
        networkMonitor = NWPathMonitor()
        networkMonitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isNetworkAvailable = path.status == .satisfied
                if !self.isNetworkAvailable {
                    // Optionally, show an alert if network becomes unavailable while the view is active
                    let alertController = UIAlertController(title: "No Internet Connection", message: "Internet connection lost.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        networkMonitor?.start(queue: queue)
    }
}

extension CreateProfileVc {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength: Int
        
        if textField == txtPhoneNumber {
            maxLength = 10
        } else if textField == txtPostCode {
            maxLength = 6
        } else {
            return true
        }
        
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
}
