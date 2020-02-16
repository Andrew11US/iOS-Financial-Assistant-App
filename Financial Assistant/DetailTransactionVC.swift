//
//  DetailTransactionVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/16/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class DetailTransactionVC: UIViewController {
    
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var originalAmountLbl: UILabel!
    @IBOutlet weak var unifiedAmountLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var walletNameLbl: UILabel!
    @IBOutlet weak var walletIdLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var transaction: (Transaction, Int)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showTransaction()
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        StorageManager.shared.deleteObject(location: FDChild.transactions.rawValue, id: transaction.0.id)
        transactions.remove(at: transaction.1)
        dismiss(animated: true, completion: nil)
    }
    
    func showTransaction() {
        self.idLbl.text = transaction.0.id
        self.nameLbl.text = transaction.0.name
        self.originalAmountLbl.text = "\(transaction.0.originalAmount) \(transaction.0.currencyCode)"
        self.unifiedAmountLbl.text = "\(transaction.0.unifiedAmount) USD"
        self.categoryLbl.text = transaction.0.category
        self.currencyLbl.text = transaction.0.currencyCode
        self.dateLbl.text = transaction.0.dateCreated
        self.walletNameLbl.text = transaction.0.walletName
        self.walletIdLbl.text = transaction.0.walletID
    }

}
