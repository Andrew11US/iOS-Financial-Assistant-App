//
//  Transaction.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

open class Transaction {
    
    var name: String
    var type: TransactionType
    var category: String
    var currencyCode: String
    var originalAmount: Double
    var unifiedAmount: Double
    var dateCreated: String
    var walletName: String
    var walletID: String
    
    init(name: String, type: TransactionType, category: String, originalAmount: Double, wallet: Wallet) {
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
}
