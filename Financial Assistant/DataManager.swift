//
//  Validator.swift
//  Financial Assistant
//
//  Created by Andrew on 2/22/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//
import UIKit
import Foundation

struct DataManager {
    static let getData = DataManager()
    
    func name(field: UITextField) -> String? {
        if let str = field.text?.trimmingCharacters(in: .whitespacesAndNewlines), !str.isEmpty {
            return str
        } else {
            print("Empty TF!")
            return nil
        }
    }
    
    func currency(field: CurrencyTextField) -> Double? {
        if let str = field.text?.trimmingCharacters(in: .whitespacesAndNewlines), !str.isEmpty {
            let formattedStr = str.replacingOccurrences(of: " ", with: "")
            if let doubleValue = Double(formattedStr) {
                print("Double parsed: ", doubleValue)
                return Double(round(doubleValue*100)/100)
            } else {
                print("Not a number!")
                return nil
            }
        } else {
            print("TF bad input!")
            return nil
        }
    }
}
