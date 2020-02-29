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
}

// Wallet type
enum WalletType: String, CaseIterable {
    case AMEX
    case appleCard
    case bank
    case cash
    case discovery
    case maestro
    case mastercard
    case online
    case payoneer
    case payPal
    case visa
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
        case ads
        case appStore
        case business
        case cashback
        case course
        case dividends
        case freelance
        case gift
        case internship
        case online
        case rent
        case royalties
        case salary
        case sales
        case schoolarship
        case youTube
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
        case apartments
        case appStore
        case bar
        case beauty
        case cellphone
        case clothing
        case commute
        case dentist
        case drugstore
        case entertainment
        case fee
        case fitness
        case gift
        case groceries
        case haircut
        case health
        case hobby
        case insurance
        case investment
        case lease
        case owed
        case parking
        case study
        case subscription
        case tax
        case travel
        case utilities
        case visa
        case transfer
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
