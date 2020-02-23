//
//  NetworkWrapper.swift
//  Financial Assistant
//
//  Created by Andrew on 2/19/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

struct NetworkWrapper {
    static func getRates(pair: (from:String,to:String), completion: @escaping (Double) -> Void) {
        let url = "https://api.exchangerate-api.com/v4/latest/\(pair.from)"
//        var out : Double = 0
        
        if exchangeRates.count > 0 {
            for rate in exchangeRates {
                if rate.key == "\(pair.from)&\(pair.to)" {
                    print("Using temparary fx rate: \(rate.value) \(pair.from)&\(pair.to)")
                    completion(rate.value)
                    return
                }
            }
            
            AF.request(url).validate().responseJSON { response in
                print(response.value ?? " ")
                if let dict = response.value as? Dictionary<String, AnyObject> {
                    if let rates = dict["rates"] as? Dictionary<String, AnyObject> {
                        if let rate = rates[pair.to] as? Double {
                            print("Rate: ", rate)
                            exchangeRates["\(pair.from)&\(pair.to)"] = rate
                            completion(rate)
                        }
                    } else {
                        print("Unable to find currency pair.(to:)")
                    }
                }
            }
            // No offline fx avaliable, call API for fx rate
        } else {
            AF.request(url).validate().responseJSON { response in
                print(response.value ?? " ")
                if let dict = response.value as? Dictionary<String, AnyObject> {
                    if let rates = dict["rates"] as? Dictionary<String, AnyObject> {
                        if let rate = rates[pair.to] as? Double {
                            print("Rate: ", rate)
                            exchangeRates["\(pair.from)&\(pair.to)"] = rate
                            completion(rate)
                        }
                    } else {
                        print("Unable to find currency pair.(to:)")
                    }
                }
            }
        }
    }
    
}
