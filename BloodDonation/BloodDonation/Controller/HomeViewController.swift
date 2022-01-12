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
    var selectedPostImage:UIImage?

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
        searchBar.delegate = self
        
        filterData = posts
        getPosts()
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
}
extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PostCell
        selectedPostImage = cell.userPostImage.image
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

