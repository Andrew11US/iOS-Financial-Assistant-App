//
//  Wallet.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

open class Wallet {
    
    var name: String
    var type: String
    var currencyCode: String
    var balance: Double = 0.0
    var dateCreated: String
    var limit: Double = 0.0
    var ID: String
    
    init(name: String, type: String, currencyCode: String, initialBalance: Double, limit: Double) {
        self.name = name
        self.type = type
        self.currencyCode = currencyCode
        self.balance = initialBalance
        self.dateCreated = Date().formattedString
        self.limit = limit
        self.ID = "\(Date().formattedString)%\(name)@\(currencyCode)&\(limit)"
    }
    
    func performTransaction(transaction: Transaction) {
        
        if balance + transaction.originalAmount < limit {
            print("Unable to perform transaction! Over the limit!")
        } else {
            balance += transaction.originalAmount
        }
        
        print(balance)
    }
    
    func changeLimit(new: Double) {
        self.limit = new
        
        print("New limit is: ", self.limit)
    }
    
}
