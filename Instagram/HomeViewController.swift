//
//  HomeViewController.swift
//  Instagram
//
//  Created by 張翔 on 2017/10/15.
//  Copyright © 2017年 sho. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var postArray: [PostData] = []
    
    var observing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil{
            if self.observing == false{
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: { (snapshot) in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました")
                    
                    if let uid = Auth.auth().currentUser?.uid{
                        let postData = PostData(snapshot: snapshot, myID: uid)
                        self.postArray.insert(postData, at: 0)
                        
                        self.tableView.reloadData()
                    }
                })
                
                postsRef.observe(.childChanged, with: { (snapshot) in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました")
                    
                    if let uid = Auth.auth().currentUser?.uid{
                        let postData = PostData(snapshot: snapshot, myID: uid)
                        
                        var index: Int = 0
                        for post in self.postArray{
                            if post.id == postData.id{
                                index = self.postArray.index(of: post)!
                                break
                            }
                            
                        }
                        
                        self.postArray.remove(at: index)
                        
                        self.postArray.insert(postData, at: index)
                        
                        self.tableView.reloadData()
                    }
                })
                observing = true
            }
        }else{
            if observing == true{
                postArray = []
                tableView.reloadData()
                
                Database.database().reference().removeAllObservers()
                
                observing = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.postData = postArray[indexPath.row]
        cell.setPostData()
        
        cell.likeButton.addTarget(self, action: #selector(handleLikeButton(sender:event:)), for: .touchUpInside)
        cell.commenButton.addTarget(self, action: #selector(handleCommentButton(sender:event:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func handleLikeButton(sender: UIButton, event: UIEvent ){
        print("DEBUG_PRINT: likeボタンがタップされました")
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        if let uid = Auth.auth().currentUser?.uid{
            if postData.isLiked{
                var  index = -1
                for likedID in postData.likes{
                    if likedID == uid{
                        index = postData.likes.index(of: likedID)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            }else{
                postData.likes.append(uid)
            }
            
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
        }
        
    }
    
    func handleCommentButton(sender: UIButton, event: UIEvent){
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        let commentViewController = storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        commentViewController.postData = postData
        present(commentViewController, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
