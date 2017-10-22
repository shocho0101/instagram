//
//  PostViewController.swift
//  Instagram
//
//  Created by 張翔 on 2017/10/15.
//  Copyright © 2017年 sho. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    
    var image: UIImage!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePostButton(){
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let imageString = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        let time = NSDate.timeIntervalSinceReferenceDate
        let name = Auth.auth().currentUser?.displayName
        
        let comment = ["name": name, "comment": textField.text!]
        let commentArray = [comment]
        
        let postRef = Database.database().reference().child(Const.PostPath)
        let postData = ["image": imageString!, "time": String(time), "name": name!, "comment": commentArray] as [String : Any]
        postRef.childByAutoId().setValue(postData)
        
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleCancelButton(){
        dismiss(animated: true, completion: nil)
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
