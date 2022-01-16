//
//  DetailsViewController.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit
import UIKit
class DetailsViewController: UIViewController {
    var selectedPost:Post?
    var userImage = ""
    @IBOutlet weak var dateLabelDetails: UILabel!
    @IBOutlet weak var locationLabelDetails: UILabel!
    @IBOutlet weak var notLabelDetails: UILabel!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var emailLabelDetails: UILabel!
    @IBOutlet weak var phoneLabelDetails: UILabel!
    
    @IBOutlet weak var imagenfo: UIImageView!{
        didSet{
            imagenfo.layer.borderColor = UIColor.systemRed.cgColor
            imagenfo.layer.borderWidth = 1.0
            imagenfo.layer.cornerRadius = imagenfo.bounds.height / 2
            imagenfo.layer.masksToBounds = true
            imagenfo.isUserInteractionEnabled = true
    }
}
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLbl.text = "date".localiz
        locationLbl.text = "location".localiz
        noteLbl.text = "note".localiz
        emailLbl.text = "email".localiz
        phoneLbl.text = "phone".localiz
        userNamelabel.text = "userName".localiz
        
        if let selectedPost = selectedPost {
            dateLabelDetails.text = selectedPost.date
            locationLabelDetails.text = selectedPost.location
            notLabelDetails.text = selectedPost.note
            phoneLabelDetails.text = selectedPost.user.phone
            userNamelabel.text = selectedPost.user.userName
            emailLabelDetails.text = selectedPost.user.email
            imagenfo.loadImageUsingCache(with: selectedPost.user.imageUrl)
            
        }
    }
}
