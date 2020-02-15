//
//  AddTransactionVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/13/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class AddTransactionVC: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var walletBtn: UIButton!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var currencyLbl: UILabel!
    
    var pickerData: [String] = []
    var currentBtn: String = ""
    var wallet = ""
    var date = ""
    var category = ""
    var amount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

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
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        print(segmentControl.selectedSegmentIndex)
    }
    
    @IBAction func walletBtnTapped(_ sender: Any) {
        self.pickerView.isHidden = false
        currentBtn = "walletBtn"
    }
    
    @IBAction func dateBtnTapped(_ sender: Any) {
        self.pickerView.isHidden = false
        pickerData = ["Today", "Yesterday"]
        pickerView.reloadAllComponents()
        currentBtn = "dateBtn"
    }
    
    @IBAction func categoryeBtnTapped(_ sender: Any) {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            pickerData = TransactionCategory.Income.getArray()
        case 1:
            pickerData = TransactionCategory.Expense.getArray()
//        pickerData = TransactionCategory.Expense.getArray()
        default:
            pickerData = []
        }
        pickerView.reloadAllComponents()
        self.pickerView.isHidden = false
        currentBtn = "categoryBtn"
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
        guard let name = nameTextField.text else { return }
        if let amount = amountTextField.text {
            if let doubleValue = Double(amount) {
                self.amount = doubleValue
            }
        }
        var type = TransactionType.income.rawValue
        if segmentControl.selectedSegmentIndex == 0 {
            type = TransactionType.income.rawValue
        } else {
            type = TransactionType.expense.rawValue
            amount = -amount
        }
        
        let transaction = Transaction(id: "INIT_ID", name: name, type: type, category: category, originalAmount: amount, wallet: wallets[0])
//        transaction.getDictionary()
        StorageManager.shared.pushObject(to: FDChild.transactions.rawValue, data: transaction.getDictionary())
        transactions.append(transaction)
        dismiss(animated: true, completion: nil)
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

extension AddTransactionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch currentBtn {
        case "walletBtn":
            walletBtn.setTitle(pickerData[row], for: .normal)
            wallet = pickerData[row]
            case "dateBtn":
            dateBtn.setTitle(pickerData[row], for: .normal)
            date = pickerData[row]
            case "categoryBtn":
            categoryBtn.setTitle(pickerData[row], for: .normal)
            category = pickerData[row]
        default: break
        }
        pickerView.isHidden = true
    }
    
    
}
