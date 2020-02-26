//
//  WalletVC.swift
//  Financial Assistant
//
//  Created by Andrew on 1/25/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class WalletVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let spinner = SpinnerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocalChange(notification:)), name: .didUpdateWallets, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleDatabaseChange(notification:)), name: .didAddWalletInDB, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleDatabaseChange(notification:)), name: .didChangeWalletInDB, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleDatabaseChange(notification:)), name: .didRemoveWalletInDB, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wallets = wallets.sorted { $0.name.lowercased() < $1.name.lowercased() }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailWalletVC {
            if let wallet = sender as? (Wallet, Int) {
                destination.wallet = wallet
            }
        }
    }
    
    @objc func handleLocalChange(notification: Notification) {
        wallets = wallets.sorted { $0.name.lowercased() < $1.name.lowercased() }
        self.tableView.reloadData()
    }
    
    @objc func handleDatabaseChange(notification: Notification) {
        wallets.removeAll()
        StorageManager.shared.getWallets {
            wallets = wallets.sorted { $0.name.lowercased() < $1.name.lowercased() }
            self.tableView.reloadData()
        }
    }

}

extension WalletVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as? WalletCell {
            
            let wallet = wallets[indexPath.row]
            cell.configureCell(wallet: wallet)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wallet = (wallets[indexPath.row], indexPath.row)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "DetailWallet", sender: wallet)
        }
    }
}

