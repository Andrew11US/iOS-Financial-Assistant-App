//
//  Wallet.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

public struct Wallet: Codable {
    
    var id: String
    var name: String
    var type: String
    var currencyCode: String
    var balance: Double = 0.0
    var limit: Double = 0.0
    var unifiedBalance: Double = 0.0
    var dateCreated: String
    
    init(id: String, name: String, type: String, currencyCode: String, initialBalance: Double, limit: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.currencyCode = currencyCode
        self.balance = initialBalance
        self.limit = limit
        self.unifiedBalance = initialBalance * 1 // Calculate using library FX
        self.dateCreated = Date().formattedString
    }
    
    // Initialize from DataSnapshot: Dictionary<String, AnyObject>
    init(id: String, data: Dictionary<String, AnyObject>) {
        self.id = id
        self.name = data["name"] as? String ?? "name"
        self.type = data["type"] as? String ?? "type"
        self.currencyCode = data["currencyCode"] as? String ?? "currencyCode"
        self.balance = data["balance"] as? Double ?? 0.0
        self.limit = data["limit"] as? Double ?? 0.0
        self.unifiedBalance = data["unifiedBalance"] as? Double ?? 0.0
        self.dateCreated = data["dateCreated"] as? String ?? "dateCreated"
    }
    
    // Returns wallet like Dictionary<String, AnyObject>
    func getDictionary() -> [String : AnyObject] {
        return [
            "id" : self.id,
            "name" : self.name,
            "type" : self.type,
            "currencyCode" : self.currencyCode,
            "balance" : self.balance,
            "unifiedBalance" : self.unifiedBalance,
            "limit" : self.limit,
            "dateCreated" : self.dateCreated,
            ] as [String : AnyObject]
    }
    
//    func performTransaction(transaction: Transaction) {
//
//        if balance + transaction.originalAmount < limit {
//            print("Unable to perform transaction! Over the limit!")
//        } else {
//            balance += transaction.originalAmount
//        }
//
//        print(balance)
//    }
}
