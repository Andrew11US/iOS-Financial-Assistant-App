//
//  DataExtensions.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Foundation

// Extends Date with formatted string property for datestamp unification
extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "eu_EU")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}

// Extends String with a property that creates a Date object from formatted string
extension String {
    var createDate: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "eu_EU")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
}

//  Extends Double with properties that add currency code or symbol prior to the Double value
extension Double {
    var currencyCode: String {
        return "\(NumberFormatter.init().currencyCode!) \(self)"
    }
    
    var currencySymbol: String {
        if let code = NumberFormatter().currencySymbol {
            return "\(code)\(self)"
        } else {
            return "UAH \(self)"
        }
    }
    
}
