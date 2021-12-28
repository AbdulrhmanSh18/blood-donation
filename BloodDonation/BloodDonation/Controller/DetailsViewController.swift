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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedPost = selectedPost,
               let selectedImage = selectedPostImage {
                   dateLabelDetails.text = selectedPost.title
                   locationLabelDetails.text = selectedPost.description
                   notLabelDetails.text = selectedPost.nottt
               }
    }
}
