//
//  LoginViewController.swift
//  Instagram
//
//  Created by 張翔 on 2017/10/15.
//  Copyright © 2017年 sho. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet var mailAddressTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var displayNameTextFiled: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func handleCreateAcountButton(){
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextFiled.text{
            
            if address.characters.isEmpty || password.characters.isEmpty || displayName.characters.isEmpty{
                print("DEBUG_PRINT: 何かが空文字です")
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            Auth.auth().createUser(withEmail: address, password: password, completion: { (user, error) in
                if let error = error{
                    print("DEBUG_PRINT:" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました")
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました")
                
                let user = Auth.auth().currentUser
                if let user = user{
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges(completion: { (error) in
                        if let error = error{
                            print("DEBUG_PRINT:" + (error.localizedDescription))
                            SVProgressHUD.showError(withStatus: "ユーザー作成時にエラーが発生しました")
                        }
                        print("DEBUG_PRINT: [displayName = \(String(describing: user.displayName))]の設定に成功しました)")
                        
                        SVProgressHUD.dismiss()
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                }else{
                    print("DEBUG_PRINT: displayNameの設定に失敗しました")
                }
            })
        }
    }
    
    @IBAction func handleLoginButton(){
        if let address = mailAddressTextField.text, let password = passwordTextField.text{
            if address.characters.isEmpty || password.characters.isEmpty{
                return
            }
            
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password, completion: { (user, error) in
                if let error = error{
                    print("DEBUG_PRINT:" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました")
                    return
                }else{
                    print("DEBUG_PRINT: ログインに成功しました")
                    SVProgressHUD.dismiss()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
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
