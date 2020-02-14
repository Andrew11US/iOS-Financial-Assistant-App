//
//  SignInVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/14/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Delete key and turn off auto login in
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        // Auto Login if ID is found in Keychain
        if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
            print("Key has been found in keychain, performing login in")
            DispatchQueue.main.async { () -> Void in
                self.performSegue(withIdentifier: Segue.toOverview.rawValue, sender: nil)
            }
            
        }
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    
    
    @IBAction func signInBtnPressed(_ sender: AnyObject) {
        
        // Sign in using E-mail and Password
        if let email = emailTextField.text, let pwd = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (data, error) in
                
                guard let user = data?.user else { return }
                
                if error == nil {
                    print("Email user authenticated with Firebase")
                    let keychainResult = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                    
//                    print("Data saved to keychain: \(keychainResult)")
//                    print(user.uid)
                    
                    
                    self.performSegue(withIdentifier: Segue.toOverview.rawValue, sender: nil)
                    
                } else {
                    print("Unable to authenticate")
                    
                    self.showAlertWithTitle("Error", message: "E-mail or password is not correct")
                }
            })
        }
        
        self.view.endEditing(true)
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

extension SignInVC: UITextFieldDelegate {
    // Dismiss keyboard function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Dismiss when return btn pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

