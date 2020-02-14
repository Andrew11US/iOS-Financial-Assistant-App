//
//  Transaction.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

open class Transaction: Codable {
    
    var id: String
     var name: String
     var type: String
     var category: String
     var currencyCode: String
     var originalAmount: Double
     var unifiedAmount: Double
     var dateCreated: String
     var walletName: String
     var walletID: String
    
    init(id: String, name: String, type: String, category: String, originalAmount: Double, wallet: Wallet) {
        self.id = id
        self.name = name
        self.type = type
        self.category = category
        self.currencyCode = wallet.currencyCode
        self.originalAmount = originalAmount
        self.unifiedAmount = originalAmount * 1 // calculate using fx-rate library
        self.dateCreated = Date().formattedString
        self.walletName = wallet.name
        self.walletID = wallet.ID
        
        wallet.performTransaction(transaction: self)
    }
    
    init(uid: String, data: Dictionary<String, AnyObject>) {
        self.id = uid
        self.name = data["name"] as? String ?? "name"
        self.type = data["type"] as? String ?? "type"
        self.category = data["category"] as? String ?? "category"
        self.currencyCode = data["currencyCode"] as? String ?? "currencyCode"
        self.originalAmount = data["originalAmount"] as? Double ?? 0.0
        self.unifiedAmount = data["unifiedAmount"] as? Double ?? 0.0
        self.dateCreated = data["dateCreated"] as? String ?? "dateCreated"
        self.walletName = data["walletName"] as? String ?? "_walletName"
        self.walletID = data["walletID"] as? String ?? "walletID"
    }
    
}
