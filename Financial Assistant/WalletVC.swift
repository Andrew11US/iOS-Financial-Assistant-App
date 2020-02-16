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
        
        if wallets.count == 0 {
            StorageManager.shared.getWallets {
                self.tableView.reloadData()
            }
        }
        
        StorageManager.shared.listenForChanges(location: FDChild.wallets.rawValue, event: .childRemoved) {
//            self.addSpinner(self.spinner)
//            StorageManager.shared.getWallets {
//                self.tableView.reloadData()
//                self.removeSpinner(self.spinner)
//            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailWalletVC {
            
            if let wallet = sender as? (Wallet, Int) {
                destination.wallet = wallet
            }
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

