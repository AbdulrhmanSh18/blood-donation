//
//  LoginViewController.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var emailTextFieldLogin: UITextField!
    @IBOutlet weak var passwordTextFieldLogin: UITextField!
    @IBOutlet weak var loginPage: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        setUpElements()
        //Localization for Login Page
        
        loginPage.text = NSLocalizedString("login", comment: "")
        emailLabel.text = NSLocalizedString("email", comment: "")
        passwordLabel.text = NSLocalizedString("password", comment: "")
        loginButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)

    }
   
    @IBAction func handelingLoginButton(_ sender: Any) {
        let error = validateField()
        if error != nil {
            showError(error!)
        }else
            
        if let email = emailTextFieldLogin.text,
           let paswword = passwordTextFieldLogin.text {
           Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: paswword) { authResult, error in
                if error != nil {
                    self.errorLbl.text = error!.localizedDescription
                    self.errorLbl.alpha = 1
                }else 
                if let _ = authResult {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UITabBarController {
                        vc.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    func showError(_ message:String) {
        errorLbl.text = message
        errorLbl.alpha = 1
    }
    
    func validateField() -> String? {
        if
            emailTextFieldLogin.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextFieldLogin.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "errorFillFields".localiz
        }
        let cleanedPassword = passwordTextFieldLogin.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) ==  false {
            return "errorPassword".localiz
        }
        return nil
    }
    func setUpElements() {
        errorLbl.alpha = 0
//        Utilities.styleTextField(emailTextFieldLogin)
//        Utilities.styleTextField(passwordTextFieldLogin)
//        Utilities.styleFielledButton(loginButton)
    }
}

