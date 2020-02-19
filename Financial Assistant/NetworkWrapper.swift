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
        var out : Double = 1
        
        AF.request(url).validate().responseJSON { response in
            
            print(response.value ?? " ")
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
                //                print(dict)
                if let rates = dict["rates"] as? Dictionary<String, AnyObject> {
                    if let currency = rates[pair.to] as? Double {
                       
                            print(currency)
                            out = currency
                        
                    }
                } else {
                    print("Unable to find currency pair.(to:)")
                }
            }
            completion(out)
        }
    }
}
