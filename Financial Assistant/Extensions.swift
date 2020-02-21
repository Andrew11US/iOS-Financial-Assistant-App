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

// JSON Encoder encodes Class to JSON String
extension Encodable {
    var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

// Transaction decodable
extension Decodable {
    var convertToObject: Transaction? {
        let jsonDecoder = JSONDecoder()
        do {
            if let data = self as? Data {
                let object = try jsonDecoder.decode(Transaction.self, from: data)
                return object
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}

// Notification extension that adds new names for custom notifications to pass data back between ViewControllers
extension Notification.Name {
    static let didUpdateTransactions = Notification.Name(rawValue: "didUpdateTransactions")
    static let didUpdateWallets = Notification.Name(rawValue: "didUpdateWallets")
}

// Adds wrapper to UIViewController to easily show alert
public extension UIViewController {
    
    func showAlertWithTitle(_ title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertVC.addAction(action)
        
        DispatchQueue.main.async { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    internal func addSpinner(_ spinner: SpinnerViewController) {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    internal func removeSpinner(_ spinner: SpinnerViewController) {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    internal func createNotification(name: Notification.Name) {
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
