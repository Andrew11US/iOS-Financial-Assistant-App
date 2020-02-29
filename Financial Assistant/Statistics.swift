//
//  Statistics.swift
//  Financial Assistant
//
//  Created by Andrew on 2/27/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

public struct StatisticMonth: Codable {
    var id: String
    var month: String
    var year: String
    var incomes: Double
    var expenses: Double
    var balance: Double
    var detailByCategory: [String: Double]
    
    init(month: String, year: String, incomes: Double, expenses: Double) {
        self.id = "\(year)-\(month)"
        self.month = month
        self.year = year
        self.incomes = incomes
        self.expenses = expenses
        self.balance = incomes + expenses
        detailByCategory = [:]
    }
    
    // Initialize from DataSnapshot
    init(id: String, data: Dictionary<String, AnyObject>) {
        self.id = id
        self.month = data["month"] as? String ?? "month"
        self.year = data["year"] as? String ?? "year"
        self.incomes = data["incomes"] as? Double ?? 0.0
        self.expenses = data["expenses"] as? Double ?? 0.0
        self.balance = data["balance"] as? Double ?? 0.0
        self.detailByCategory = data["detailByCategory"] as? Dictionary<String,Double> ?? [:]
        
//        for item in detailByCategory {
//
//        }
    }
    
    // Returns transaction like Dictionary<String, AnyObject>
    func getDictionary() -> [String : AnyObject] {
        return [
            "id" : self.id,
            "month" : self.month,
            "year" : self.year,
            "incomes" : self.incomes,
            "expenses" : self.expenses,
            "balance" : self.balance,
            "detailByCategory" : self.detailByCategory as AnyObject
            ] as [String : AnyObject]
    }
}

public struct Statistics {
    // If month is not in the array - create empty, else find one that already exists
    static func getMonth(id: String) -> (StatisticMonth, Int) {
        let year = Date().getYear
        let month = Date().getMonth
        let output = StatisticMonth(month: month, year: year, incomes: 0, expenses: 0)
        
        if statistics.count > 0 {
            for (key,value) in statistics.enumerated() {
                if id == value.id {
                    print("Month found!")
                    return (value, key)
                }
            }
            print("No match in statistics, creating new month")
            statistics.append(output)
            return (output, statistics.count-1)
        } else {
            print("Creating first month")
            statistics.append(output)
            return (output, 0)
        }
    }
    
    static func update(month: inout StatisticMonth, income: Double = 0, expense: Double = 0) {
        month.incomes = Double(month.incomes + income).round(places: 2)
        month.expenses = Double(month.expenses + expense).round(places: 2)
        month.balance = Double(month.incomes + month.expenses).round(places: 2)
        print("Month stat updated: ", month)
    }
    
    static func calculateTotal() {
        for w in wallets {
            availableAmount += w.unifiedBalance
        }
        availableAmount = Double(availableAmount).round(places: 2)
        print("Available: ", availableAmount)
    }
}
