//
//  TemporaryData.swift
//  Financial Assistant
//
//  Created by Andrew on 2/14/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

// Stores temporary data downloaded from persistent storage and used for current session
var wallets : [Wallet] = []
var transactions : [Transaction] = []
var exchangeRates : [String: Double] = [:]
