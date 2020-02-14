//
//  StorageManager.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Foundation

public struct StorageManager {
    
    static let shared = StorageManager()
    // Firebase Database main reference
    static let dbReference = Database.database().reference()
    
    let testChildRef = dbReference.child("tests")
    
    func saveData(message: String) {
        
            let msg = [
                "text": message,
                "postedDate": Date().formattedString
                ] as [String : Any]
            
            let fireMsg = testChildRef.childByAutoId()
            fireMsg.setValue(msg)
        
    }
    
    func retrieveData() {
        
        testChildRef.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let dict = snap.value as? [String:AnyObject] {
                        print(dict)
                    }
                }
            }
        }
        
    }
    
    func createUser(uid: String, data: Dictionary<String, String>) {
        
        let defaultData : [String: String] = [
            "name" : "John Doe",
            "wallets" : "no wallets",
            "transactions" : "no transactions",
            "statistics" : "unavailable",
            "virtualVallets" : "no vWallets",
        ]
        
        StorageManager.dbReference.child(uid).updateChildValues(defaultData) // change default!!!!
    }

}
