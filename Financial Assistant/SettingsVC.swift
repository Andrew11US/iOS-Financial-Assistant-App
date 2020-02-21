//
//  SettingsVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/7/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper

class SettingsVC: UIViewController {
    
    @IBOutlet weak var signOutBtn: UIButton!
    
    let spinner = SpinnerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        
        self.addSpinner(spinner)
        
        do {
            try Auth.auth().signOut()
            let result = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            StorageManager.shared.removeUserCache()
            print("Key has been removed from the keychain: ", result)
            wallets.removeAll()
            transactions.removeAll()
            self.removeSpinner(spinner)
            self.performSegue(withIdentifier: Segue.signedOut.rawValue, sender: nil)
        } catch let error {
            print(error.localizedDescription)
            self.removeSpinner(spinner)
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
