//
//  Wallet.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

public struct Wallet: Codable {
    
    var name: String
    var type: String
    var currencyCode: String
    var balance: Double = 0.0
    var dateCreated: String
    var limit: Double = 0.0
    var id: String
    
    init(name: String, type: String, currencyCode: String, initialBalance: Double, limit: Double) {
        self.name = name
        self.type = type
        self.currencyCode = currencyCode
        self.balance = initialBalance
        self.limit = limit
        self.dateCreated = Date().formattedString
        self.id = "\(Date().formattedString)%\(name)@\(currencyCode)&\(limit)"
    }
    
    // Initialize from DataSnapshot
    init(id: String, data: Dictionary<String, AnyObject>) {
        self.id = id
        self.name = data["name"] as? String ?? "name"
        self.type = data["type"] as? String ?? "type"
        self.currencyCode = data["currencyCode"] as? String ?? "currencyCode"
        self.balance = data["balance"] as? Double ?? 0.0
        self.limit = data["limit"] as? Double ?? 0.0
        self.dateCreated = data["dateCreated"] as? String ?? "dateCreated"
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
