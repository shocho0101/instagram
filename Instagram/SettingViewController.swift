//
//  SettingViewController.swift
//  Instagram
//
//  Created by 張翔 on 2017/10/15.
//  Copyright © 2017年 sho. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    
    @IBOutlet var displayNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = Auth.auth().currentUser
        if let user = user{
            displayNameTextField.text = user.displayName
        }
    }
    
    @IBAction func handleChangeButton(){
        if let displayName = displayNameTextField.text{
            if displayName.characters.isEmpty{
                SVProgressHUD.showError(withStatus: "表示名を入力してください")
                return
            }
            
            let user = Auth.auth().currentUser
            if let user = user{
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error{
                        print("DEBUG_PRINT:" + error.localizedDescription)
                    }
                    print("DEBUG_PRINT: [displayName = \(String(describing: user.displayName))]の設定に成功しました)")
                    
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                })
            }else{
                print("DEBUG_PRINT: displayNameの設定に失敗しました")
            }
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func handleLoginButton(){
        try! Auth.auth().signOut()
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
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
