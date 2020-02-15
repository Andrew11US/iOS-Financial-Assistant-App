//
//  AddTransactionVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/13/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class AddTransactionVC: UIViewController {
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var retrieve: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        StorageManager.shared.getTransactions()
    }
    
    @IBAction func save(sender: UIButton) {
        StorageManager.shared.saveData()
    }
    
    @IBAction func retrieve(sender: UIButton) {
//        StorageManager.shared.retrieveData()
//        for t in transactions {
//            print(t.convertToString ?? "")
//        }
//        let t = Factory.shared.createTransaction(id: "x1x", name: "Food", type: TransactionType.expense.rawValue, category: TransactionCategory.Expense.groceries.rawValue, originalAmount: -123.23, wallet: wallets[0])
//        print(t.convertToString ?? "xx")
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
