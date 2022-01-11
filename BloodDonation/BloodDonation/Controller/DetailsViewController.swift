//
//  DetailsViewController.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit

class DetailsViewController: UIViewController {
    var selectedPost:Post?
    @IBOutlet weak var dateLabelDetails: UILabel!
    @IBOutlet weak var locationLabelDetails: UILabel!
    @IBOutlet weak var notLabelDetails: UILabel!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var emailLabelDetails: UILabel!
//    @IBOutlet weak var userImageView: UIImageView!{
//        didSet {
//            userImageView.layer.borderColor = UIColor.systemRed.cgColor
//            userImageView.layer.borderWidth = 0.1
//            userImageView.layer.cornerRadius = userImageView.bounds.height / 0
//            userImageView.layer.masksToBounds = true
//            userImageView.isUserInteractionEnabled = true
//        }
//    }
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLbl.text = NSLocalizedString("date", comment: "")
        locationLbl.text = NSLocalizedString("location", comment: "")
        noteLbl.text = NSLocalizedString("note", comment: "")
        emailLbl.text = NSLocalizedString("email", comment: "")
        userNamelabel.text = NSLocalizedString("userName", comment: "")
        
        if let selectedPost = selectedPost {
            dateLabelDetails.text = selectedPost.date
            locationLabelDetails.text = selectedPost.location
            notLabelDetails.text = selectedPost.note
            userNamelabel.text = selectedPost.user.userName
            emailLabelDetails.text = selectedPost.user.email
            
            
        }
    }
}
