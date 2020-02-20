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
    @IBOutlet weak var codeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        
        guard let email = emailTextField.text else {
            print("Provide E-mail to reset password!")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let err = error {
                print("Reset password email has not been sent Error: ", err.localizedDescription)
            } else {
                print("Reset password email has been sent to: ", email)
            }
        }
        
//        self.dismiss(animated: true, completion: nil)
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
