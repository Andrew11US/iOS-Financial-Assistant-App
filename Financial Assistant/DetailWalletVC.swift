//
//  DetailWalletVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/16/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class DetailWalletVC: UIViewController {

    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var unifiedBalanceLbl: UILabel!
    @IBOutlet weak var limitTextField: CurrencyTextField!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
 
    var wallet: (Wallet, Int)!
    private var limit = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.limitTextField.delegate = self
        showWallet()
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        StorageManager.shared.deleteObject(location: FDChild.wallets.rawValue, id: wallet.0.id)
        wallets.remove(at: wallet.1)
        print(wallet.1)
        self.createNotification(name: .didUpdateWallets)
        dismiss(animated: true, completion: nil)
    }
    
    func showWallet() {
        self.idLbl.text = wallet.0.id
        self.nameLbl.text = wallet.0.name
        self.typeLbl.text = wallet.0.type
        self.balanceLbl.text = "\(wallet.0.balance.currencyFormat) \(wallet.0.currencyCode)"
        self.unifiedBalanceLbl.text = "\(wallet.0.unifiedBalance) USD"
        self.currencyLbl.text = wallet.0.currencyCode
        self.limitTextField.text = "\(wallet.0.limit.currencyFormat)"
        self.dateLbl.text = wallet.0.dateCreated
    }
    
    @IBAction func limitChange(_ sender: Any) {
        let value = DataManager.getData.currency(field: limitTextField)
        if let doubleValue = value {
            self.limit = Double(round(-doubleValue*100)/100)
            wallet.0.limit = -doubleValue
        } else {
            self.limit = 0
            wallet.0.limit = 0
        }
         
        wallets[wallet.1] = wallet.0
        print(wallet.0)
        self.createNotification(name: .didUpdateWallets)
        
        let newLimit = ["limit": limit] as [String: AnyObject]
        StorageManager.shared.updateObject(at: FDChild.wallets.rawValue, id: wallet.0.id, data: newLimit)
        print("New limit set: ", self.limit)
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

extension DetailWalletVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Dismiss when return btn pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        limitTextField.resignFirstResponder()
        return true
    }
}
