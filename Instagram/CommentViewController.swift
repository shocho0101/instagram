//
//  ComentViewController.swift
//  Instagram
//
//  Created by 張翔 on 2017/10/22.
//  Copyright © 2017年 sho. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    
    var postData: PostData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func comment(){
        if (textField.text?.isEmpty)! == false {
            let name = Auth.auth().currentUser?.displayName
            postData.comment.append(["name": name, "comment": textField.text])
            
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            postRef.updateChildValues(["comment": postData.comment])
            
            SVProgressHUD.showSuccess(withStatus: "コメントしました")
            self.dismiss(animated: true, completion: nil)
        }else{
            SVProgressHUD.showError(withStatus: "コメントが入力されていません")
        }
    }
    
    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
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
