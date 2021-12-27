//
//  RegisterViewController.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {
let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var userRegisterImageView: UIImageView! {
        didSet {
            userRegisterImageView.layer.borderColor = UIColor.systemRed.cgColor
            userRegisterImageView.layer.borderWidth = 3.0
            userRegisterImageView.bounds.height / 2
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
                                                print("")
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
