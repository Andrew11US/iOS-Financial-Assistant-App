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
import CoreData

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
    
//    func pushObject(to: String, data: [String:AnyObject]) {
//        let dbRef = userReference.child(to).childByAutoId()
//            dbRef.setValue(data)
//    }
    
    func pushObject(to: String, key: String, data: [String:AnyObject]) {
        let dbRef = userReference.child(to).child(key)
            dbRef.setValue(data)
    }
    
    func updateObject(at: String, id: String, data: [String:AnyObject]) {
        let dbRef = userReference.child(at).child(id)
            dbRef.updateChildValues(data)
    }
    
    func getAutoKey(at: String) -> String {
        return userReference.child(at).childByAutoId().key ?? "INIT_KEY"
    }
    
    func getTransactions(_ completion: @escaping () -> Void) {
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
            print("Transactions: ", transactions.count)
            completion()
        }
    }
    
        func getWallets(_ completion: @escaping () -> Void) {
    //        var transactions : [Transaction] = []
            // Remove duplicates
            wallets.removeAll()
            
            userReference.child("wallets").observeSingleEvent(of: .value) { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshot {
                        if let dict = snap.value as? Dictionary<String,AnyObject> {
                            let id = snap.key
                            let wallet = Wallet(id: id, data: dict)
                            
                            wallets.append(wallet)
                            
    //                        print(Transaction(id: id, data: dict).convertToString ?? "zz")
                        }
                    }
                }
                print("Wallets: ", wallets.count)
                completion()
            }
        }
    
    func deleteObject(location: String, id: String) {
        userReference.child(location).child(id).removeValue { (error, ref) in
            if error != nil {
                print("Error occured while trying to delete an object with \(id)")
                print(error.debugDescription)
            }
        }
        print("value deleted for: ", id)
    }
    
    func listenForChanges(location: String, event: DataEventType, completion: @escaping () -> Void) {
        userReference.child(location).observe( event) { (snapshot) in
            print("db changed!")
            completion()
        }
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
    
    public func saveToCoreData(toEntity: String, value: [String:Double], forKey: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 13.0, *) {
            let context = appDelegate.persistentContainer.viewContext
            let newObject = NSEntityDescription.insertNewObject(forEntityName: toEntity, into: context)
            
            newObject.setValue(value, forKey: forKey)
            
            do {
                try context.save()
                print("Saved to CoreData ", toEntity)
                
            } catch {
                print("Error occured when saving data")
                print("\(error.localizedDescription)")
            }
        } else {
            let context = appDelegate.persistentContainer2.viewContext
            let newObject = NSEntityDescription.insertNewObject(forEntityName: toEntity, into: context)
            
            newObject.setValue(value, forKey: forKey)
            
            do {
                try context.save()
                print("Saved to CoreData < iOS 13 ", toEntity)
                
            } catch {
                print("Error occured when saving data")
                print("\(error.localizedDescription)")
            }
        }

    }
    
    public func getFromCoreData(fromEntity: String, key: String) -> [String:Double]? {
        
        var output : [String:Double] = [:]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 13.0, *) {
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: fromEntity)
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(request)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        if let value = result.value(forKey: key) {
                            print(value)
                            output = value as! Dictionary<String,Double>
                        }
                    }
                    return output
                }
                
            } catch {
                print("Error loading data from Core Data")
                print("\(error.localizedDescription)")
            }
            return nil
        } else {
            let context = appDelegate.persistentContainer2.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: fromEntity)
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(request)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        if let value = result.value(forKey: key) {
                            print(value)
                            if let dict = value as? [String:Double] {
                                print(dict)
                            }
                            output = value as! [String:Double]
                        }
                    }
                    return output
                }
                
            } catch {
                print("Error loading data from Core Data")
                print("\(error.localizedDescription)")
            }
            return nil
        }
    }
    
    public func deleteInCoreData(entity: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 13.0, *) {
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(request)
                
                if results.count > 0 {
                    for object in results as! [NSManagedObject] {
                        context.delete(object)
                    }
                }
            } catch {
                print("Error loading data from Core Data")
                print("\(error.localizedDescription)")
            }
        } else {
            let context = appDelegate.persistentContainer2.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(request)
                
                if results.count > 0 {
                    for object in results as! [NSManagedObject] {
                        context.delete(object)
                    }
                }
            } catch {
                print("Error loading data from Core Data")
                print("\(error.localizedDescription)")
            }
        }

    }
    
    func createUser(uid: String) {
        
        let data : [String: String] = [
            "name" : "John Doe",
            "wallets" : "no wallets",
            "transactions" : "no transactions",
            "statistics" : "unavailable",
            "virtualWallets" : "no vWallets",
            "dateCreated" : Date().formattedString,
            "uid" : uid
        ]
        
        StorageManager.dbReference.child(uid).updateChildValues(data)
    }
    
    // Cache user data to use offline in order to decrease number of calls to DB
    func setUserCache(uid: String, name: String = "John Doe") {
        let dict : [String: String] = [
            "name" : name,
            "latestLogin" : Date().formattedString,
            "uid" : uid,
            "UnifiedCurrencyCode": "USD"
        ]
        defaults.set(dict, forKey: "CurrentUser")
    }
    
    func updateUserCache(key: String, value: String) {
        let dict : [String: String] = [
            key : value
        ]
        defaults.set(dict, forKey: "CurrentUser")
    }
    
    func getUserCache() -> (name:String,uid:String,date:String,code:String) {
        var out : (name:String,uid:String,date:String,code:String) = ("name","uid","date","USD")
        
        if let dict = defaults.dictionary(forKey: "CurrentUser") {
            if let name = dict["name"] as? String {
                out.name = name
            }
            if let uid = dict["uid"] as? String {
                out.uid = uid
            }
            if let date = dict["latestLogin"] as? String {
                out.date = date
            }
            if let code = dict["UnifiedCurrencyCode"] as? String {
                out.code = code
            }
        }
        
        return out
    }
    
    func removeUserCache() {
        defaults.removeObject(forKey: "CurrentUser")
    }

}
