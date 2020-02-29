//
//  OverviewVC.swift
//  Financial Assistant
//
//  Created by Andrew on 1/25/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import FirebaseAuth

class OverviewVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalBalanceLbl: UILabel!
    
    let spinner = SpinnerViewController()
    let userCache = StorageManager.shared.getUserCache()
//    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSpinner(spinner)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if transactions.count == 0 {
            StorageManager.shared.getTransactions {
                transactions = transactions.sorted { $0.dateCreated > $1.dateCreated }
                self.removeSpinner(self.spinner)
                self.tableView.reloadData()
            }
        }
        
        if wallets.count == 0 {
            StorageManager.shared.getWallets {
                wallets = wallets.sorted { $0.name.lowercased() < $1.name.lowercased() }
                self.createNotification(name: .didUpdateWallets)
                Statistics.calculateTotal()
                self.totalBalanceLbl.text = "\(availableAmount.currencyFormat) \(self.userCache.code)"
            }
        }
        
        if statistics.count == 0 {
            StorageManager.shared.getStatistics {
                currentMonth = Statistics.getMonth(id: Date().getYearAndMonth)
                appFlags[AppFlags.statistics.rawValue] = true
                print(currentMonth.0?.id ?? "CM")
            }
        }
        
        StorageManager.shared.listenForChanges(location: FDChild.wallets.rawValue, event: .childChanged) {
            self.createNotification(name: .didChangeWalletInDB)
            print("Wallet changed in DB")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocalChange(notification:)), name: .didUpdateTransactions, object: nil)
        
//        if let user = user {
//            StorageManager.shared.setUserCache(uid: user.uid)
//        }
        
//        StorageManager.shared.listenForChanges(location: FDChild.wallets.rawValue, event: .childAdded) {
//            self.createNotification(name: .didAddWalletInDB)
//            print("New Wallet added to DB")
//        }
        
//        StorageManager.shared.listenForChanges(location: FDChild.wallets.rawValue, event: .childRemoved) {
//            self.createNotification(name: .didRemoveWalletInDB)
//            print("Wallet removed from DB")
//        }
//        StorageManager.shared.listenForChanges(location: FDChild.transactions.rawValue, event: .childAdded) {
//            self.createNotification(name: .didAddTransactionInDB)
//            print("Transaction added to DB")
//        }
//        StorageManager.shared.listenForChanges(location: FDChild.transactions.rawValue, event: .childRemoved) {
//            self.createNotification(name: .didRemoveTransactionInDB)
//            print("Transaction removed from DB")
//        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleDatabaseChange(notification:)), name: .didAddTransactionInDB, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleDatabaseChange(notification:)), name: .didRemoveTransactionInDB, object: nil)
    }
    
    @objc func handleLocalChange(notification: Notification) {
        print("Received: ", notification.name.rawValue)
        transactions = transactions.sorted { $0.dateCreated > $1.dateCreated }
        self.tableView.reloadData()
    }
    
    @objc func handleDatabaseChange(notification: Notification) {
        print("Received: ", notification.name.rawValue)
        transactions.removeAll()
        StorageManager.shared.getTransactions {
            transactions = transactions.sorted { $0.dateCreated > $1.dateCreated }
            self.tableView.reloadData()
        }
    }

}

extension OverviewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as? OverviewTransactionCell {
            
            let transaction = transactions[indexPath.row]
            cell.configureCell(transaction: transaction)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

