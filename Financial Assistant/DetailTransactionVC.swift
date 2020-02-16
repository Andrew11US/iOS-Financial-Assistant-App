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
    
    private var _transaction: Transaction!
    
    var transaction: Transaction {
        get {
            return _transaction
        } set {
            _transaction = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showTransaction()
    }
    
    @IBAction func deletBtnTapped(_ sender: Any) {
        
    }
    
    func showTransaction() {
        self.idLbl.text = transaction.id
        self.nameLbl.text = transaction.name
        self.originalAmountLbl.text = "\(transaction.originalAmount) \(transaction.currencyCode)"
        self.unifiedAmountLbl.text = "\(transaction.unifiedAmount) USD"
        self.categoryLbl.text = transaction.category
        self.currencyLbl.text = transaction.currencyCode
        self.dateLbl.text = transaction.dateCreated
        self.walletNameLbl.text = transaction.walletName
        self.walletIdLbl.text = transaction.walletID
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
