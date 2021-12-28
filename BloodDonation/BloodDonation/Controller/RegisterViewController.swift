//
//  RegisterViewController.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit
import Firebase
import SwiftUI
class RegisterViewController: UIViewController {
let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var userRegisterImageView: UIImageView! {
        didSet {
            userRegisterImageView.layer.borderColor = UIColor.systemRed.cgColor
            userRegisterImageView.layer.borderWidth = 3.0
            userRegisterImageView.bounds.height/2
            userRegisterImageView.layer.masksToBounds = true
            userRegisterImageView.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userRegisterImageView.addGestureRecognizer(tabGesture)
        }
    }

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var typeOfBloodTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var phoneTextFeild: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confrimPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    }
    
    @IBAction func handelingRegisterButton(_ sender: Any) {
        if let image = userRegisterImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.25),
           let userName = userNameTextField.text,
           let typeOfBlood = typeOfBloodTextField.text,
           let age = ageTextField.text,
           let phone = phoneTextFeild.text,
           let email = emailTextField.text,
           let password = passwordTextField.text,
           let confrimPassword = confrimPasswordTextField.text,
           password == confrimPassword {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().createUser(withEmail: email, password: password){
                authResult , error in
                if let error = error {
                    print("Registration Auth Error",error.localizedDescription)
                }
                if let authResult = authResult {
                        let storageRef = Storage.storage().reference(withPath: "users/\(authResult.user.uid)")
                        let uploadMeta = StorageMetadata.init()
                        uploadMeta.contentType = "image/jpeg"
                        storageRef.putData(imageData,metadata: uploadMeta){
                            storageMeta,error in if let error = error {
                                print("Registration Storage Error",error.localizedDescription)
                            }
                            storageRef.downloadURL { url, error in
                                if let error = error {
                                    print("Registration Storage Download Url Error",error.localizedDescription)
                                }
                                if let url = url {
                                    print("URL",url.absoluteString)
                                    let db = Firestore.firestore()
                                    let userData :[String:String] = [
                                        "id":authResult.user.uid,
                                        "name":userName,
                                        "email":email,
                                        "imageUrl":url.absoluteString
                                    ]
                                    db.collection("users").document(authResult.user.uid)
                                        .setData(userData) { error in
                                            if let error = error {
                                                print("Registration Database error",error.localizedDescription)
                                                
                                            }else {
                                                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                                                    vc.modalPresentationStyle = .fullScreen
                                                    Activity.removeIndicator(parentView:self.view, childView: self.activityIndicator)
                                                    self.present(vc, animated: true, completion: nil)
                                                }
                                }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
extension RegisterViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func selectImage() {
        showAlart()
    }
    func showAlart(){
        let alert = UIAlertController(title: "choose Profile Picture", message: "where do you want to pick tour image frome?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { Action in
            self.getImage(from: .camera)
        }
        let galeryAction = UIAlertAction(title: "Photh Album", style: .default) { Action in
            self.getImage(from: .photoLibrary)
        }
        let dismissAction = UIAlertAction(title: "Cancle", style: .default)
        { Action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(galeryAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        }
    func getImage(from sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
        func imagePickerController(_ picker:UIImagePickerController ,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return
                
            }
            userRegisterImageView.image = chosenImage
            dismiss(animated: true, completion: nil)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }

