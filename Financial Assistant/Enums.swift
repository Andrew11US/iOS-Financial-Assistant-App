//
//  Enums.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Foundation

// Transaction type, transfer is not counted to statistics
enum TransactionType: String, CaseIterable {
    case income
    case expense
    case transfer
}

// Wallet type
enum WalletType: String, CaseIterable {
    case payPal
    case bank
    case visa
    case mastercard
    case cash
    case other
    
    static func getArray() -> [String] {
        var output : [String] = []
        for i in WalletType.self.allCases {
            output.append(i.rawValue)
        }
        return output
    }
}

// Nested Enum with Income and Expense sources
enum TransactionCategory {
    
    enum Income: String, CaseIterable {
        case business
        case internship
        case salary
        case transfer
        case other
        
        static func getArray() -> [String] {
            var output : [String] = []
            for i in TransactionCategory.Income.self.allCases {
                output.append(i.rawValue)
            }
            return output
        }
    }

    enum Expense: String, CaseIterable {
        case groceries
        case study
        case bar
        case other
        
        static func getArray() -> [String] {
            var output : [String] = []
            for i in TransactionCategory.Expense.self.allCases {
                output.append(i.rawValue)
            }
            return output
        }
    }
}
