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
    
    let spinner = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Deletes KEY for auto login if uncommented
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        // Auto Login if ID is found in Keychain
        if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
            print("Key has been found in keychain!")
            DispatchQueue.main.async { () -> Void in
                self.performSegue(withIdentifier: Segue.toOverview.rawValue, sender: nil)
            }
        }
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func signInBtnPressed(_ sender: AnyObject) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        addSpinner(spinner)
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print(err.localizedDescription)
                self.removeSpinner(self.spinner)
            } else {
                guard let user = user?.user else { return }
                print("Succesfully authenticated for: ", user.uid)
                KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                self.performSegue(withIdentifier: Segue.toOverview.rawValue, sender: nil)
                self.removeSpinner(self.spinner)
            }
        }
        
        self.view.endEditing(true)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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

