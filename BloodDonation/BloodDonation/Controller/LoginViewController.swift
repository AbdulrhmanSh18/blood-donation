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
    @IBOutlet weak var emailTextFieldLogin: UITextField!
    @IBOutlet weak var passwordTextFieldLogin: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func handelingLoginButton(_ sender: Any) {
        if let email = emailTextFieldLogin.text,
           let paswword = passwordTextFieldLogin.text {
           Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: paswword) { authResult, error in
                if let _ = authResult {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                        vc.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
