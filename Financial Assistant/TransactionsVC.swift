//
//  TransactionsVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/7/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class TransactionsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        StorageManager.shared.listenForChanges(location: FDChild.transactions.rawValue, event: .childChanged) {
//            self.tableView.reloadData()
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocalChange(notification:)), name: .didUpdateTransactions, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleDatabaseChange(notification:)), name: .didAddTransactionInDB, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleDatabaseChange(notification:)), name: .didRemoveTransactionInDB, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailTransactionVC {
            
            if let trans = sender as? (Transaction, Int) {
                destination.transaction = trans
            }
        }
    }
    
    @objc func handleLocalChange(notification: Notification) {
        print("Received: ", notification.name.rawValue)
        transactions = transactions.sorted { $0.dateCreated > $1.dateCreated }
        self.tableView.reloadData()
    }
    
    @objc func handleDatabaseChange(notification: Notification) {
        print("Received: ", notification.name.rawValue)
            self.tableView.reloadData()
    }
    
}

extension TransactionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell {
            
            let transaction = transactions[indexPath.row]
            cell.configureCell(transaction: transaction)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trans = (transactions[indexPath.row], indexPath.row)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "DetailTransaction", sender: trans)
        }
    }
}
