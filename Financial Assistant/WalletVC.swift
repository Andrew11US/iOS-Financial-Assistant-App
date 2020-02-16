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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if wallets.count == 0 {
            StorageManager.shared.getWallets {
                self.tableView.reloadData()
            }
        }
        
        StorageManager.shared.listenForChanges(location: FDChild.transactions.rawValue, event: .childChanged) {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
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
    
    
}

