//
//  Factory.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

public struct Factory {
    
    static let shared = Factory()
    
    func createTransaction(id: String, name: String, type: String, category: String, originalAmount: Double, wallet: Wallet) -> Transaction {
        return Transaction(id: id, name: name, type: type, category: category, originalAmount: originalAmount, wallet: wallet)
    }
//
    func createWallet(name: String, type: String, currencyCode: String, initialBalance: Double, limit: Double) -> Wallet {
        return Wallet(name: name, type: type, currencyCode: currencyCode, initialBalance: initialBalance, limit: limit)
    }
    
}
