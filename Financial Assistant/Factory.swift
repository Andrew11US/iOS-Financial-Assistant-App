//
//  Factory.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

class Factory {
    
    init() {}
    
    static let shared = Factory()
    
    func createTransaction(name: String, type: TransactionType, category: String, originalAmount: Double, wallet: Wallet) -> Transaction {
        return Transaction(name: name, type: type, category: category, originalAmount: originalAmount, wallet: wallet)
    }
    
    func createWallet(name: String, type: String, currencyCode: String, initialBalance: Double, limit: Double) -> Wallet {
        return Wallet(name: name, type: type, currencyCode: currencyCode, initialBalance: initialBalance, limit: limit)
    }
    
}
