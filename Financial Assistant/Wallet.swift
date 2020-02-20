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
    var unifiedCurrencyCode: String
    var balance: Double = 0.0
    var limit: Double = 0.0
    var unifiedBalance: Double = 0.0
    var dateCreated: String
    
    init(id: String, name: String, type: String, currencyCode: String, unifiedCurrencyCode: String, balance: Double, unifiedBalance: Double, limit: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.currencyCode = currencyCode
        self.unifiedCurrencyCode = defaults.string(forKey: "UnifiedCurrencyCode") ?? "USD"
        self.balance = balance
        self.limit = limit
        self.unifiedBalance = unifiedBalance
        self.dateCreated = Date().formattedString
    }
    
    // Initialize from DataSnapshot: Dictionary<String, AnyObject>
    init(id: String, data: Dictionary<String, AnyObject>) {
        self.id = id
        self.name = data["name"] as? String ?? "name"
        self.type = data["type"] as? String ?? "type"
        self.currencyCode = data["currencyCode"] as? String ?? "currencyCode"
        self.unifiedCurrencyCode = data["unifiedCurrencyCode"] as? String ?? "unifiedCurrencyCode"
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
            "unifiedCurrencyCode" : self.unifiedCurrencyCode,
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
