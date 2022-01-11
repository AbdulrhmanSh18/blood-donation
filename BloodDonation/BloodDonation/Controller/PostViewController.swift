//
//  PostViewController.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit
import Firebase
class PostViewController: UIViewController {
    var selectedPost:Post?
    
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    //    @IBOutlet weak var dateTextFieldPost: UITextField!
    @IBOutlet weak var locationTextFieldPost: UITextField!
    @IBOutlet weak var noteTextFieldPost: UITextField!
    
    @IBOutlet weak var donateTimesPost: UITextField!
    @IBOutlet weak var switchQuetion1: UISwitch!{
        didSet {
            switchQuetion1.isOn = false
        }
    }
    @IBOutlet weak var switchQuetion2: UISwitch!{
        didSet {
            switchQuetion2.isOn = false
        }
    }
    @IBOutlet weak var switchQuetion3: UISwitch!{
        didSet {
            switchQuetion3.isOn = false
        }
    }
    @IBOutlet weak var switchQuetion4: UISwitch!{
        didSet {
            switchQuetion4.isOn = false
        }
    }
    @IBOutlet weak var actionButtonAdd: UIButton!
    @IBOutlet weak var donateQuestionLabel: UILabel!
    @IBOutlet weak var questionLabel1: UILabel!
    @IBOutlet weak var questionLabel2: UILabel!
    @IBOutlet weak var questionLabel3: UILabel!
    @IBOutlet weak var questionLabel4: UILabel!
    let activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextFieldPost.placeholder = NSLocalizedString("location", comment: "")
        noteTextFieldPost.placeholder = NSLocalizedString("note", comment: "")
        donateTimesPost.placeholder = NSLocalizedString("howMany", comment: "")
        donateTimesPost.placeholder = NSLocalizedString("", comment: "")
        donateQuestionLabel.text = NSLocalizedString("howManyTimesDoYouDonate", comment: "")
        questionLabel1.text = NSLocalizedString("haveYouTravelledLast14Days", comment: "")
        questionLabel2.text = NSLocalizedString("haveYouTakenAspirin", comment: "")
        questionLabel3.text = NSLocalizedString("haveYouDonatedLast60Days", comment: "")
        questionLabel4.text = NSLocalizedString("haveYouhadSurgery", comment: "")
        actionButtonAdd.setTitle(NSLocalizedString("add", comment: ""), for: .normal)
        
        //        createDatePicker()
        
        
        if let selectedPost = selectedPost {
            //            dateTextFieldPost.text = selectedPost.date
            locationTextFieldPost.text = selectedPost.location
            noteTextFieldPost.text = selectedPost.note
            donateTimesPost.text = selectedPost.donate
            actionButtonAdd.setTitle("Update Post", for: .normal)
            actionButtonAdd.setTitle(NSLocalizedString("update", comment: ""), for: .normal)
            let deleteBarButton = UIBarButtonItem(image:UIImage(systemName: "trash.fill"),style: .plain, target: self, action: #selector(handleDelete))
            self.navigationItem.rightBarButtonItem = deleteBarButton
            // delete butten
            let deleteButton = UIButton(frame: CGRect(x: 80, y: 650, width: 250, height: 50))
            deleteButton.setTitle("Delete", for: .normal)
            deleteButton.setTitle(NSLocalizedString("delete", comment: ""), for: .normal)
            self.navigationItem.rightBarButtonItem = deleteBarButton
            deleteButton.backgroundColor = .systemGray4
            deleteButton.setTitleColor(UIColor.black, for: .normal)
            deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
            self.view.addSubview(deleteButton)
            
        }else {
            actionButtonAdd.setTitle("add", for: .normal)
            actionButtonAdd.setTitle(NSLocalizedString("add", comment: ""), for: .normal)
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    @IBAction func dateChange(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func switchActionOne(_ sender: Any) {
        if switchQuetion1.isOn == true || switchQuetion2.isOn == true || switchQuetion3.isOn == true || switchQuetion4.isOn == true {
            actionButtonAdd.isEnabled = false
        } else {
            actionButtonAdd.isEnabled = true
        }
    }
    
    @IBAction func switchAction2(_ sender: Any) {
        if switchQuetion1.isOn == true || switchQuetion2.isOn == true || switchQuetion3.isOn == true || switchQuetion4.isOn == true {
            actionButtonAdd.isEnabled = false
        } else {
            actionButtonAdd.isEnabled = true
        }
    }
    @IBAction func switchAction3(_ sender: Any) {
        if switchQuetion1.isOn == true || switchQuetion2.isOn == true || switchQuetion3.isOn == true || switchQuetion4.isOn == true {
            actionButtonAdd.isEnabled = false
        } else {
            actionButtonAdd.isEnabled = true
        }
    }
    
    @IBAction func switchAction4(_ sender: Any) {
        if switchQuetion1.isOn == true || switchQuetion2.isOn == true || switchQuetion3.isOn == true || switchQuetion4.isOn == true {
            actionButtonAdd.isEnabled = false
        } else {
            actionButtonAdd.isEnabled = true
        }
    }
    
    @objc func handleDelete (_ sender: UIBarButtonItem) {
        let ref = Firestore.firestore().collection("posts")
        if let selectedPost = selectedPost {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            ref.document(selectedPost.id).delete { error in
                if let error = error {
                    print("ERROR in db delete",error)
                }else {
                    let storageRef = Storage.storage().reference(withPath: "posts/\(selectedPost.user.id)/\(selectedPost.id)")
                    storageRef.delete { error in
                        if let error = error {
                            print("Error in stoarge delete",error)
                        }else {
                            self.activityIndicator.stopAnimating()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func handlingAddQ(_ sender: Any) {
        let formatter = DateFormatter()
        let locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.locale = locale
        formatter.dateFormat = "yyyy-MM-dd"
        let date = datePicker.date
        
        let dateString = formatter.string(from: date)
        
        if let location = locationTextFieldPost.text,
           let note = noteTextFieldPost.text,
           let donate = donateTimesPost.text,
           let currentUser = Auth.auth().currentUser {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            //                        ref.addDocument(data:)
            var postId = ""
            if let selectedPost = selectedPost {
                postId = selectedPost.id
            }else {
                postId = "\(Firebase.UUID())"
            }
            var postData = [String:Any]()
            let db = Firestore.firestore()
            let ref = db.collection("posts")
            if let selectedPost = self.selectedPost {
                postData = [
                    "userId":selectedPost.user.id,
                    "date":dateString,
                    "location":location,
                    "note":note,
                    "donate":donate,
                    "createdAt":selectedPost.createdAt ?? FieldValue.serverTimestamp(),
                    "updatedAt": FieldValue.serverTimestamp()
                ]
            }else {
                postData = [
                    "userId":currentUser.uid,
                    "date":dateString,
                    "location":location,
                    "note":note,
                    "donate":donate,
                    "createdAt":FieldValue.serverTimestamp(),
                    "updatedAt": FieldValue.serverTimestamp()
                ]
            }
            ref.document(postId).setData(postData) {
                error in
                if let error = error {
                    print("FireStore Error",error.localizedDescription)
                }
                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func chooseImage() {
        self.showAlert()
    }
    private func showAlert() {
        
        let alert = UIAlertController(title: "Choose Picture", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "camera".localiz, style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "photoAlbum".localiz, style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "cancel".localiz, style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    //    func createDatePicker(){
    //        let toolbar = UIToolbar()
    //        toolbar.sizeToFit()
    //
    //        let doneButoon = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
    //        toolbar.setItems([doneButoon], animated: true)
    //        dateTextFieldPost.inputAccessoryView = toolbar
    //        dateTextFieldPost.inputView = dateText
    //        datePicker.datePickerMode = .date
    //
    //    }
    //    @objc func donePressed(){
    //    let formatter = DateFormatter()
    //        formatter.dateStyle = .medium
    ////        formatter.timeStyle = .none
    //        dateTextFieldPost.text = formatter.string(from: datePicker.date)
    //        dateTextFieldPost.text = "\(datePicker.date)"
    //        self.view.endEditing(true)
    //    }
}
