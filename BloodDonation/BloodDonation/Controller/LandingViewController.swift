//
//  LandingViewController.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit

class LandingViewController: UIViewController {
    @IBOutlet weak var nameAppBloodDonation: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var changeLunguageBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameAppBloodDonation.text = NSLocalizedString("bloodDonation", comment: "Blood Donation")
        loginButton.setTitle(NSLocalizedString("login", comment: ""),
                             for: .normal)
        registerButton.setTitle(NSLocalizedString("register", comment: ""),
                                for: .normal)

        // Do any additional setup after loading the view.
    }
 
    @IBAction func changeLunguageButton(_ sender: Any) {
        let currentLanguage = Locale.current.languageCode
        let newLanguage = currentLanguage == "en" ? "ar" : "en"
        UserDefaults.standard.setValue([newLanguage], forKey: "AppleLanguage")
        exit(0)
    }
}
