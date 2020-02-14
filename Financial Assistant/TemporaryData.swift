//
//  TemporaryData.swift
//  Financial Assistant
//
//  Created by Andrew on 2/14/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

// Stores data downloaded from persistent storage
struct TemporaryData {
    
    static let shared = TemporaryData()
    
    var transactions : [Transaction] = []
    var wallets : [Wallet] = []
//    var virtuaWallets : [VirtualWallet] = []
}
