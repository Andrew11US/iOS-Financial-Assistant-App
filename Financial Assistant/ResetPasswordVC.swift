//
//  ResetPasswordVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/20/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    let spinner = SpinnerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.delegate = self
    }
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        
        guard let emailStr = emailTextField.text else {
            print("Provide E-mail to reset password!")
            return
        }
        
        let email = emailStr.trimmingCharacters(in: .whitespacesAndNewlines)
        
        addSpinner(spinner)
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let err = error {
                print(err.localizedDescription)
                self.removeSpinner(self.spinner)
            } else {
                print("Reset password email has been sent to: ", email)
                self.removeSpinner(self.spinner)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.view.endEditing(true)
    }

}

extension ResetPasswordVC: UITextFieldDelegate {
    // Dismiss keyboard function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Dismiss when return btn pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
}
