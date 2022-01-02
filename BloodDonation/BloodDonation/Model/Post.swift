//
//  Post.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import Foundation
import Firebase
struct Post {
    var id = ""
    var date = ""
    var location = ""
    var note = ""
    var imageUrl = ""
    var user:User
    var createdAt:Timestamp?
    
    init(dict:[String:Any],id:String,user:User) {
        if let date = dict["date"] as? String,
           let location = dict["location"] as? String,
           let note = dict["note"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
            let createdAt = dict["createdAt"] as? Timestamp{
            self.date = date
            self.location = location
            self.note = note
            self.imageUrl = imageUrl
            self.createdAt = createdAt
        }
        self.id = id
        self.user = user
    }
}
