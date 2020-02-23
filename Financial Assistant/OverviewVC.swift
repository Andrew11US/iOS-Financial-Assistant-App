//
//  OverviewVC.swift
//  Financial Assistant
//
//  Created by Andrew on 1/25/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class OverviewVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let spinner = SpinnerViewController()

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
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: .didUpdateTransactions, object: nil)
    }
    
    @objc func handleNotification(notification: Notification) {
        print("Received: ", notification.name.rawValue)
        transactions = transactions.sorted { $0.dateCreated > $1.dateCreated }
        self.tableView.reloadData()
    }

}

extension OverviewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
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

