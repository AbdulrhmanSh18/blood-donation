//
//  User.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import Foundation

struct User {
    var id = ""
    var userName = ""
    var imageUrl = ""
    var email = ""
    var age = ""
    var typeOfBlood = ""
    var phone = ""
    
    init(dict:[String:Any]) {
        if let id = dict["id"] as? String,
           let userName = dict["name"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
           let age = dict["age"] as? String,
           let typeOfBlood = dict["tyoeOfBlood"] as? String,
           let phone = dict["phone"] as? String,
           let email = dict["email"] as? String {
            self.userName = userName
            self.id = id
            self.email = email
            self.imageUrl = imageUrl
            self.age = age
            self.typeOfBlood = typeOfBlood
            self.phone = phone
        }
    }
}
