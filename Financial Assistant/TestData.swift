//
//  TestData.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

var wallets : [Wallet] = [
    Factory.shared.createWallet(name: "Mastercard", type: "mastercard", currencyCode: "USD", initialBalance: 1000.00, limit: 0)
]

var transactions : [Transaction] = [
    Factory.shared.createTransaction(id: "x1x", name: "Food", type: TransactionType.expense.rawValue, category: TransactionCategory.Expense.groceries.rawValue, originalAmount: -123.23, wallet: wallets[0])
]

//var last10 : [Transaction] = transactions
