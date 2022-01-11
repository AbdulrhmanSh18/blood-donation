//
//  Utilities.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 07/06/1443 AH.
//

import Foundation
import UIKit

class Utilities {
    static func styleTextField(_ textfield:UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 220/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleFielledButton(_ button:UIButton){
        button.backgroundColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleHellowButton(_ button:UIButton){
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    //NSPredicate
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
