//
//  PostCell.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var userPostImage: UIImageView!
    @IBOutlet weak var infoImagePost: UIImageView!{
        didSet {
            infoImagePost.layer.borderColor = UIColor.systemGreen.cgColor
            infoImagePost.layer.borderWidth = 2.0
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
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        userNamePost.text = "Doner:  \(post.user.userName)"
        userPhone.text = post.user.phone
        typeOfBlood.text = post.user.typeOfBlood
        userAgeLabel.text = "age  \(post.user.age)"
        userPostImage.loadImageUsingCache(with: post.imageUrl)
        infoImagePost.loadImageUsingCache(with: post.user.imageUrl)
        return self
    }
    override func prepareForReuse() {
        userPostImage.image = nil
        infoImagePost.image = nil
    }
}
