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
    
    @IBOutlet weak var dateTextFieldPost: UITextField!
    @IBOutlet weak var locationTextFieldPost: UITextField!
    @IBOutlet weak var noteTextFieldPost: UITextField!
    @IBOutlet weak var switchQuetion1: UISwitch!
    @IBOutlet weak var switchQuetion2: UISwitch!
    @IBOutlet weak var switchQuetion3: UISwitch!
    @IBOutlet weak var switchQuetion4: UISwitch!
    @IBOutlet weak var actionButtonAdd: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    let activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedPost = selectedPost ,
           let selectedImage = selectedPostImage {
            dateTextFieldPost.text = selectedPost.title
            locationTextFieldPost.text = selectedPost.description
            noteTextFieldPost.text = selectedPost.nottt
            postImageView.image = selectedImage
            actionButtonAdd.setTitle("Update Post", for: .normal)
            let deleteBarButton = UIBarButtonItem(image:UIImage(systemName: "trash fill"),style: .plain, target: self, action: #selector(handleDelete))
            self.navigationItem.rightBarButtonItem = deleteBarButton
        }else {
            actionButtonAdd.setTitle("Add Post", for: .normal)
            self.navigationItem.rightBarButtonItem = nil
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
        
        if let image = postImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.25),
           let date = dateTextFieldPost.text,
           let location = locationTextFieldPost.text,
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
                                "imageUrl":url.absoluteString,
                                "createdAt":selectedPost.createdAt ?? FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                        }else {
                            postData = [
                                "userId":currentUser.uid,
                                "date":date,
                                "location":url.absoluteString,
                                "createdAt":FieldValue.serverTimestamp()
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
        
        let alert = UIAlertController(title: "Choose Profile Picture", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        postImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
