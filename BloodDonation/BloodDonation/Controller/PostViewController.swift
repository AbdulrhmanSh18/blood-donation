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
    var selectedPostImage:UIImage?
    
   
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateTextFieldPost: UITextField!
//    let datePicker = UIDatePicker()
    @IBOutlet weak var locationTextFieldPost: UITextField!
    @IBOutlet weak var noteTextFieldPost: UITextField!
    
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
    @IBOutlet weak var newimagePost: UIImageView! {
        didSet {
            
            newimagePost.layer.borderColor = UIColor.systemRed.cgColor
            newimagePost.layer.borderWidth = 3.0
            newimagePost.layer.cornerRadius = newimagePost.bounds.height / 2
            newimagePost.layer.masksToBounds = true
            newimagePost.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
            newimagePost.addGestureRecognizer(tapGesture)
        }
    }
    let activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createDatePicker()n

        
        if let selectedPost = selectedPost ,
           let selectedImage = selectedPostImage {
            dateTextFieldPost.text = selectedPost.date
            locationTextFieldPost.text = selectedPost.location
            noteTextFieldPost.text = selectedPost.note
            newimagePost.image = selectedImage
            actionButtonAdd.setTitle("Update Post", for: .normal)
            let deleteBarButton = UIBarButtonItem(image:UIImage(systemName: "trash.fill"),style: .plain, target: self, action: #selector(handleDelete))
            self.navigationItem.rightBarButtonItem = deleteBarButton
        }else {
            actionButtonAdd.setTitle("Add Post", for: .normal)
            self.navigationItem.rightBarButtonItem = nil
        }
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
        
        if let image = newimagePost.image,
           let imageData = image.jpegData(compressionQuality: 0.25),
           let date = dateTextFieldPost.text,
           let location = locationTextFieldPost.text,
           let note = noteTextFieldPost.text,
           let currentUser = Auth.auth().currentUser {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            //            ref.addDocument(data:)
            var postId = ""
            if let selectedPost = selectedPost {
                postId = selectedPost.id
            }else {
                postId = "\(Firebase.UUID())"
            }
            let storageRef = Storage.storage().reference(withPath: "posts/\(currentUser.uid)/\(postId)")
            let updloadMeta = StorageMetadata.init()
            updloadMeta.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: updloadMeta) { storageMeta, error in
                if let error = error {
                    print("Upload error",error.localizedDescription)
                }
                storageRef.downloadURL { url, error in
                    var postData = [String:Any]()
                    if let url = url {
                        let db = Firestore.firestore()
                        let ref = db.collection("posts")
                        if let selectedPost = self.selectedPost {
                            postData = [
                                "userId":selectedPost.user.id,
                                "date":date,
                                "location":location,
                                "note":note,
                                "imageUrl":url.absoluteString,
                                "createdAt":selectedPost.createdAt ?? FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                        }else {
                            postData = [
                                "userId":currentUser.uid,
                                "date":date,
                                "location":location,
                                "note":note,
                                "imageUrl":url.absoluteString,
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
        }
    }
}
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func chooseImage() {
        self.showAlert()
    }
    private func showAlert() {
        
        let alert = UIAlertController(title: "Choose Picture", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
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
//        dateTextFieldPost.inputView = datePicker
//        datePicker.datePickerMode = .date
//    }
//    @objc func donePressed(){
//    let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        dateTextFieldPost.text = formatter.string(from: datePicker.date)
////        dateTextFieldPost.text = "\(datePicker.date)"
//        self.view.endEditing(true)
//    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        newimagePost.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
}
