//
//  ProfileViewController.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 01/06/1443 AH.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    var userImage = ""
    @IBOutlet weak var viewOfProfile: UIView!{
        didSet {
            viewOfProfile.layer.masksToBounds = true
            viewOfProfile.layer.cornerRadius = 18
        }
    }
    @IBOutlet weak var userImageViewPrf: UIImageView!{
        didSet {
            userImageViewPrf.layer.borderColor = UIColor.systemRed.cgColor
            userImageViewPrf.layer.borderWidth = 1.0
            userImageViewPrf.layer.cornerRadius = userImageViewPrf.bounds.height / 2
            userImageViewPrf.layer.masksToBounds = true
            userImageViewPrf.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var emaillabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var updateButtonPrf: UIButton!
    @IBOutlet weak var typeOfBlood: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileData()
    }
    func getProfileData(){
            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
            Firestore.firestore()
                .document("users/\(currentUserID)")
                .addSnapshotListener{ doucument, error in
                    if error != nil {
                        print ("error",error!.localizedDescription)
                        return
                    }
                    
                    self.userImage = (doucument?.data()?["imageUrl"] as? String)!
                    self.userName.text = doucument?.data()?["userName"] as? String
                    self.userPhone.text = doucument?.data()?["phone"] as? String
                    self.emaillabel.text = doucument?.data()?["email"] as? String
                    self.ageLabel.text = doucument?.data()?["age"] as? String
                    self.typeOfBlood.text = doucument?.data()?["typeOfBlood"] as? String
                    
                    
                    var image:String
                    image = self.userImage
                    
                    if let ImagemnueURl = URL(string:image )
                    {
                        
                        DispatchQueue.global().async {
                            if let ImageData = try? Data(contentsOf:ImagemnueURl) {
                                let Image = UIImage(data: ImageData)
                                DispatchQueue.main.async {
                                    self.userImageViewPrf.image = Image
                                    
                                }
                            }
                        }
                        
                    }
                    
                }
}
    
    @IBAction func logOutHandeling(_ sender: Any) {
    
    do {
        try Auth.auth().signOut()
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingNavigationController") as? UINavigationController {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }catch {
        print("ERROR in signout", error.localizedDescription)
    }
}
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
        if identifier == "toDonationAdd" {
            let vc = segue.destination as! PostViewController
            vc.selectedPost = selectedPost
            vc.selectedPostImage = selectedPostImage
        } else {
            let vc = segue.destination as! DetailsViewController
            vc.selectedPost =  selectedPost
            vc.selectedPostImage = selectedPostImage
        }
    }
}
}

