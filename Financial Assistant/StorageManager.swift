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
import SwiftKeychainWrapper
import Foundation

public struct StorageManager {
    
    static let shared = StorageManager()
    // Firebase Database main reference
    static let dbReference = Database.database().reference()
    
    var userReference: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let reference = StorageManager.dbReference.child(uid!)
        return reference
    }
    
    let testChildRef = dbReference.child("tests")
    
    func saveData() {
        
            let msg = [
                 "name" : "Food",
                 "category" : "groceries",
                 "originalAmount" : -123.23,
                 "type" : "expense",
                 "dateCreated" : "2020-02-14 21:42:23",
                 "walletName" : "Mastercard",
                 "unifiedAmount" : -123.23,
                 "walletID" : "2020-02-14 21:42:23%Mastercard@USD&0.0",
                 "currencyCode" : "USD"
                ] as [String : AnyObject]
            
        let fireMsg = userReference.child("transactions").childByAutoId()
            fireMsg.setValue(msg)
    }
    
    func pushObject(to: String, data: [String:AnyObject]) {
        let dbRef = userReference.child(to).childByAutoId()
            dbRef.setValue(data)
    }
    
    func getTransactions(_ completion: @escaping () -> Void) -> [Transaction] {
//        var transactions : [Transaction] = []
        // Remove duplicates
        transactions.removeAll()
        
        userReference.child("transactions").observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let dict = snap.value as? Dictionary<String,AnyObject> {
                        let id = snap.key
                        let transaction = Transaction(id: id, data: dict)
                        
                        transactions.append(transaction)
                        
//                        print(Transaction(id: id, data: dict).convertToString ?? "zz")
                    }
                }
            }
            print(transactions.count)
            completion()
        }
        
        return transactions
    }
    
    func retrieveData() {
        
        userReference.child("transactions").observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let dict = snap.value as? Dictionary<String,AnyObject> {
                        let id = snap.key
                        print(Transaction(id: id, data: dict).convertToString ?? "zz")
                    }
                }
            }
        }
        
    }
    
//    func monitorForchanges() {
//        userReference.child("transactions").observe(.value) { (snapshot) in
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                for snap in snapshot {
//                    if let dict = snap.value as? Dictionary<String,AnyObject> {
//                        let id = snap.key
//                        print(Transaction(uid: id, data: dict).convertToString ?? "zz")
//                    }
//                }
//            }
//        }
//    }
    
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
