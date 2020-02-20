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
        
        // MARK: Deletes KEY for auto login if uncommented
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        // Auto Login if ID is found in Keychain
        if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
            print("Key has been found in keychain! Loging in without credentials")
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
                    KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                    self.performSegue(withIdentifier: Segue.toOverview.rawValue, sender: nil)
                    
                } else {
                    print("Unable to authenticate")
                    self.showAlertWithTitle("Ooops:(", message: "Looks like your email or password wasn't correct")
                }
            })
        }
        
        self.view.endEditing(true)
    }
    
    // Getting transactions before switching to destination VC
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        StorageManager.shared.getTransactions {}
     }
     
    
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

