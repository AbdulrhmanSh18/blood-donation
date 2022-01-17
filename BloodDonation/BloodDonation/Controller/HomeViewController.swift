//
//  HomeViewController.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit
import Firebase
class HomeViewController: UIViewController {
    var posts = [Post]()
    var selectedPost:Post?
    
    @IBOutlet weak var searchBar: UISearchBar!
    var filterData : [Post]!
    @IBOutlet weak var postTabelViewHome: UITableView!{
        didSet{
            postTabelViewHome.delegate = self
            postTabelViewHome.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        searchBar.delegate = self
        
        filterData = posts
        getPosts()
        
        searchBar.endEditing(true)
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
        
    }
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
    
    func getPosts() {
        let ref = Firestore.firestore()
        ref.collection("posts").order(by: "createdAt",descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("DB ERROR Posts",error.localizedDescription)
            }
            if let snapshot = snapshot {
                snapshot.documentChanges.forEach { diff in
                    let post = diff.document.data()
                    switch diff.type {
                    case .added :
                        if let userId = post["userId"] as? String {
                            ref.collection("users").document(userId).getDocument { userSnapshot, error in
                                if let error = error {
                                    print("ERROR user Data",error.localizedDescription)
                                    
                                }
                                if let userSnapshot = userSnapshot,
                                   let userData = userSnapshot.data(){
                                    let user = User(dict:userData)
                                    let post = Post(dict:post,id:diff.document.documentID,user:user)
                                    self.posts.insert(post, at: 0)
                                    DispatchQueue.main.async {
                                        self.postTabelViewHome.reloadData()
                                    }
                                    
                                }
                            }
                        }
                    case .modified:
                        let postId = diff.document.documentID
                        if let currentPost = self.posts.first(where: {$0.id == postId}),
                           let updateIndex = self.posts.firstIndex(where: {$0.id == postId}){
                            let newPost = Post(dict:post, id: postId, user: currentPost.user)
                            self.posts[updateIndex] = newPost
                            DispatchQueue.main.async {
                                self.postTabelViewHome.reloadData()
                            }
                        }
                    case .removed:
                        let postId = diff.document.documentID
                        if let deleteIndex = self.posts.firstIndex(where: {$0.id == postId}){
                            self.posts.remove(at: deleteIndex)
                            DispatchQueue.main.async {
                                self.postTabelViewHome.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func handlingLogoutButoon(_ sender: Any) {
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
            } else {
                let vc = segue.destination as! DetailsViewController
                vc.selectedPost =  selectedPost
            }
        }
    }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterData.count > 0 {
            return filterData.count
        } else {
            return posts.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DonationCell", for: indexPath) as! PostCell
        if filterData.count > 0 {
            return cell.configure(with: filterData[indexPath.row])
        } else {
            return cell.configure(with: posts[indexPath.row])
        }
    }
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//
//        return true
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            Firestore.firestore()
//            posts.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            if  let uID = Auth.auth().currentUser?.uid, posts[indexPath.row].user.id == uID {
                let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                    
                    let ref = Firestore.firestore().collection("posts")
                    ref.document(self.posts[indexPath.row].id).delete(completion: { error in
                        if let error = error {
                            print("Error in db delete",error)
                        } else {
                            DispatchQueue.main.async {
                                self.postTabelViewHome.reloadData()
                            }
                        }
                    })
                }
                
                return UISwipeActionsConfiguration(actions: [action])
            }else {
                return UISwipeActionsConfiguration(actions: [])
            }
        }
}


extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 137
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.cellForRow(at: indexPath) as! PostCell
        selectedPost = posts[indexPath.row]
        if let currentUser = Auth.auth().currentUser,
           currentUser.uid == posts[indexPath.row].user.id {
            performSegue(withIdentifier: "toDonationAdd", sender: self)
        }else {
            performSegue(withIdentifier: "toDateilsDonation", sender: self)
        }
    }
}
extension HomeViewController : UISearchBarDelegate {
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText:String) {
        filterData = []
        if searchText == "" {
            filterData = posts
        }else {
            for flter in posts {
                if flter.user.typeOfBlood.lowercased().contains(searchText.lowercased()) ||
                    flter.user.userName.lowercased().contains(searchText.lowercased()) ||
                    flter.user.age.lowercased().contains(searchText.lowercased()) ||
                    flter.date.lowercased().contains(searchText.lowercased()) {
                    filterData.append(flter)
                }
            }
        }
        self.postTabelViewHome.reloadData()
    }
}
