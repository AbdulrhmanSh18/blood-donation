//
//  DetailsViewController.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit

class DetailsViewController: UIViewController {
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    @IBOutlet weak var dateLabelDetails: UILabel!
    @IBOutlet weak var locationLabelDetails: UILabel!
    @IBOutlet weak var notLabelDetails: UILabel!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!{
        didSet {
            userImageView.layer.borderColor = UIColor.systemRed.cgColor
            userImageView.layer.borderWidth = 0.1
            userImageView.layer.cornerRadius = userImageView.bounds.height / 0
            userImageView.layer.masksToBounds = true
            userImageView.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedPost = selectedPost,
        let selectedImage = selectedPostImage {
                   dateLabelDetails.text = "The date donation at '  \(selectedPost.date) ' "
                   locationLabelDetails.text = "The location ' \(selectedPost.location) ' "
                   notLabelDetails.text = "Note about donation ' \(selectedPost.note)' "
            userNamelabel.text = " Doner /   \(selectedPost.user.userName)"
            userImageView.image = selectedImage

            
               }
    }
}
