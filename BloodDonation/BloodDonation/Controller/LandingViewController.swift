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
   
    @IBOutlet weak var changeLungaugeSegment: UISegmentedControl! {
    didSet {
        if let lang = UserDefaults.standard.string(forKey: "currentLanguage") {
            switch lang {
            case "ar":
                changeLungaugeSegment.selectedSegmentIndex = 0
            case "en":
                changeLungaugeSegment.selectedSegmentIndex = 1
           
            default:
                let localLang =  Locale.current.languageCode
                 if localLang == "ar" {
                     changeLungaugeSegment.selectedSegmentIndex = 0
                 } else if localLang == "en"{
                     changeLungaugeSegment.selectedSegmentIndex = 1
                 }else {
                     changeLungaugeSegment.selectedSegmentIndex = 1
                 }
              
            }
        
        }else {
            let localLang =  Locale.current.languageCode
             if localLang == "ar" {
                 changeLungaugeSegment.selectedSegmentIndex = 0
             }else {
                 changeLungaugeSegment.selectedSegmentIndex = 1
             }
        }
    }
}
    //    @IBOutlet weak var changeLunguageBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameAppBloodDonation.text = NSLocalizedString("bloodDonation", comment: "Blood Donation")
        loginButton.setTitle(NSLocalizedString("login", comment: ""),
                             for: .normal)
        registerButton.setTitle(NSLocalizedString("register", comment: ""),
                                for: .normal)
    }
    
  
    @IBAction func actionCgLanguage(_ sender: UISegmentedControl) {
    
    if let lang = sender.titleForSegment(at:sender.selectedSegmentIndex)?.lowercased() {
            UserDefaults.standard.set(lang, forKey: "currentLanguage")
            Bundle.setLanguage(lang)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
            }
        }
    }
}



