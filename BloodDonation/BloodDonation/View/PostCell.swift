//
//  PostCell.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var userPostImage: UIImageView!
    @IBOutlet weak var datePost: UILabel!
    @IBOutlet weak var locationPost: UILabel!
    @IBOutlet weak var userNamePost: UILabel!
    
    @IBOutlet weak var notePost: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with post:Post) -> UITableViewCell {
        datePost.text = post.title
        locationPost.text = post.description
        notePost.text = post.nottt
        return self
    }
    override func prepareForReuse() {
        userPostImage.image = nil
    }
}
