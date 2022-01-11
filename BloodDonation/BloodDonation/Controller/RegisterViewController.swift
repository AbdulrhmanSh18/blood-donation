//
//  RegisterViewController.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    var groupOfBloodType = ["A+","A-","AB+","AB-","O+","O-","B+","B-"]
    let pickerViewTOB = UIPickerView()
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var userRegisterImageView: UIImageView! {
        didSet {
            userRegisterImageView.layer.borderColor = UIColor.systemRed.cgColor
            userRegisterImageView.layer.borderWidth = 3.0
            userRegisterImageView.layer.cornerRadius = userRegisterImageView.bounds.height / 2
            userRegisterImageView.layer.masksToBounds = true
            userRegisterImageView.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userRegisterImageView.addGestureRecognizer(tabGesture)
        }
    }
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInNewUser: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var typeBloodLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var conPasswordLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var typeOfBloodTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var phoneTextFeild: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confrimPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeOfBloodTextField.inputView = pickerViewTOB
        pickerViewTOB.dataSource = self
        pickerViewTOB.delegate = self
        setUpElements()
        //Localization
        signInNewUser.text = "singIn".localiz
        userNameLabel.text = "userName".localiz
        typeBloodLabel.text = "typeOfBlood".localiz
        ageLabel.text = "age".localiz
        phoneLabel.text = "phone".localiz
        emailLabel.text = "email".localiz
        passwordLabel.text = "password".localiz
        conPasswordLabel.text = "confrimPassword".localiz
        registerButton.setTitle(NSLocalizedString("register", comment: ""), for: .normal)
        
        
        
        imagePickerController.delegate = self
    }
    
    @IBAction func handelingRegisterButton(_ sender: Any) {
        let error = validateField()
        if error != nil {
            showError(error!)
        }else
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
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Registration Auth Error",error.localizedDescription)
                }
                if let authResult = authResult {
                    let storageRef = Storage.storage().reference(withPath: "users/\(authResult.user.uid)")
                    let uploadMeta = StorageMetadata.init()
                    uploadMeta.contentType = "image/jpeg"
                    storageRef.putData(imageData,metadata: uploadMeta) {
                        storageMeta,error in
                        if let error = error {
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
                                    "userName":userName,
                                    "email":email,
                                    "typeOfBlood":typeOfBlood,
                                    "age":age,
                                    "phone":phone,
                                    "imageUrl":url.absoluteString
                                ]
                                db.collection("users").document(authResult.user.uid)
                                    .setData(userData) { error in
                                        if let error = error {
                                            print("Registration Database error",error.localizedDescription)
                                            
                                        }else {
                                            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UITabBarController {
                                                vc.modalPresentationStyle = .fullScreen
                                                
                                                self.present(vc, animated: true, completion: nil)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }else {
            if passwordTextField.text != confrimPasswordTextField.text! {
                errorLabel.text = "passwordNotCorrect".localiz
                errorLabel.alpha = 1
            }else {
                errorLabel.text = "Empty".localiz
                errorLabel.alpha = 1
            }
        }
    }
}
extension RegisterViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func selectImage() {
        showAlart()
    }
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func showAlart(){
        let alert = UIAlertController(title: "choosePic".localiz, message: "choocePictur".localiz, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "camera".localiz, style: .default) { Action in
            self.getImage(from: .camera)
            
        }
        let galeryAction = UIAlertAction(title: "phothAlbum".localiz, style: .default) { Action in
            self.getImage(from: .photoLibrary)
        }
        let dismissAction = UIAlertAction(title: "cancle".localiz, style: .destructive) { Action in
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
    func validateField() -> String? {
        if userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            typeOfBloodTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneTextFeild.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confrimPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "errorFillFields".localiz
        }
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) ==  false {
            return "errorPassword".localiz
        }
        return nil
    }
    func setUpElements() {
        errorLabel.alpha = 0
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

extension RegisterViewController:UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupOfBloodType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupOfBloodType[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeOfBloodTextField.text = groupOfBloodType[row]
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
