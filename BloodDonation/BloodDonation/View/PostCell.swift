//
//  PostCell.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var viewOfDonation: UIView!{
        didSet{
            viewOfDonation.layer.masksToBounds = true
            viewOfDonation.layer.cornerRadius = 8
            viewOfDonation.layer.borderWidth = 1
            viewOfDonation.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
//    @IBOutlet weak var userPostImage: UIImageView!{
//        didSet {
//            userPostImage.layer.borderColor = UIColor.systemRed.cgColor
//            userPostImage.layer.borderWidth = 3.0
//            userPostImage.layer.cornerRadius = userPostImage.bounds.height / 2
//            userPostImage.layer.masksToBounds = true
//            userPostImage.isUserInteractionEnabled = true
//
//        }
//    }
    @IBOutlet weak var infoImagePost: UIImageView!{
        didSet {
            infoImagePost.layer.borderColor = UIColor.systemRed.cgColor
            infoImagePost.layer.borderWidth = 1.0
            infoImagePost.layer.cornerRadius = infoImagePost.bounds.height / 2
            infoImagePost.layer.masksToBounds = true
            infoImagePost.isUserInteractionEnabled = true
            
        }
    }
    @IBOutlet weak var datePost: UILabel!
    @IBOutlet weak var locationPost: UILabel!
    @IBOutlet weak var userNamePost: UILabel!
    @IBOutlet weak var notePost: UILabel!
    @IBOutlet weak var typeOfBlood: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var donateTimes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePost.text = NSLocalizedString("date", comment: "")
        locationPost.text = NSLocalizedString("location", comment: "")
        userNamePost.text = NSLocalizedString("userName", comment: "")
        notePost.text = NSLocalizedString("note", comment: "")
        typeOfBlood.text = NSLocalizedString("typeOfBlood", comment: "")
        userAgeLabel.text = NSLocalizedString("age", comment: "")
        donateTimes.text = NSLocalizedString("", comment: "")
        
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(with post:Post) -> UITableViewCell {
       
        datePost.text = post.date
        locationPost.text = post.location
        notePost.text = post.note
        userNamePost.text = post.user.userName
        typeOfBlood.text = post.user.typeOfBlood
        userAgeLabel.text = "age  \(post.user.age)"
        donateTimes.text = post.donate
        infoImagePost.loadImageUsingCache(with: post.user.imageUrl)
        return self
    }
    override func prepareForReuse() {
//        userPostImage.image = nil
        infoImagePost.image = nil
    }
}
