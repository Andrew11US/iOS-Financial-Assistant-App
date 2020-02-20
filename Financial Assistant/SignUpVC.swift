//
//  SignUpVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/20/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper

class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    let spinner = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpBtnPressed(_ sender: AnyObject) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let confirmation = confirmPassTextField.text else { return }
        
        if password == confirmation {
            addSpinner(spinner)
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                guard error != nil else {
                    print("User has already been created! ", user?.user.email ?? "")
                    self.removeSpinner(self.spinner)
                    return
                }
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let err = error {
                    print("User has not been created due to error: ", err.localizedDescription)
                } else {
                    guard let user = user?.user else { return }
                    print("New user has been succesfully created: ", user.uid)
                    StorageManager.shared.createUser(uid: user.uid)
                    KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                    self.performSegue(withIdentifier: Segue.signedUp.rawValue, sender: nil)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
