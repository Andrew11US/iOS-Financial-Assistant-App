//
//  ExchangeManager.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

struct ExchangeManager {
    static let shared = ExchangeManager()
    
    func getRate() {
        
    }
    
    func hitAPI(_for URLString: String) {
       let configuration = URLSessionConfiguration.default
       let session = URLSession(configuration: configuration)
       let url = URL(string: URLString)
       //let url = NSURL(string: urlString as String)
       var request : URLRequest = URLRequest(url: url!)
       request.httpMethod = "GET"
//       request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//       request.addValue("application/json", forHTTPHeaderField: "Accept")
       let dataTask = session.dataTask(with: url!) { data,response,error in
          // 1: Check HTTP Response for successful GET request
          guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
          else {
             print("error: not a valid http response")
             return
          }
          switch (httpResponse.statusCode) {
             case 200:
                print(receivedData)
                if let json = String(data: receivedData, encoding: .utf8) {
                    print(json)
                }
                break
             case 400:
                break
             default:
                break
          }
       }
       dataTask.resume()
    }
    
    static func downloadData(url: String, completed: @escaping (Double) -> Void) {
        var out: Double = 1
        
        AF.request(url).validate().responseJSON { response in
            
//            print(response.value ?? " ")
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
//                print(dict)
                if let rates = dict["rates"] as? Dictionary<String, AnyObject> {
                    if let pair = rates["USDUAH"] as? Dictionary<String, AnyObject> {
                        if let rate = pair["rate"] as? Double {
                            print(rate)
                            out = rate
                        }
                        
                    }
//                    print(rates)
                }
            }
            completed(out)
        }
    }
}
