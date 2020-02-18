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
    
    // Selection subViews
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var walletTableView: UITableView!
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var walletViewHeight: NSLayoutConstraint!
    @IBOutlet weak var walletView: UIView!
    
    // Data for selection when customizing new transaction
    private var categories = TransactionCategory.Income.getArray()
//    var wallets = wallets
    
    var pickerData: [String] = []
    var currentBtn: String = ""
    var wallet: Wallet?
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
        pickerData = []
        var walletStr: [String] = []
        for w in wallets {
            walletStr.append(w.name)
        }
        pickerData = walletStr
        self.pickerView.isHidden = false
        pickerView.reloadAllComponents()
        currentBtn = "walletBtn"
    }
    
    // Delete date picking <<<
    @IBAction func dateBtnTapped(_ sender: Any) {
        pickerData = []
        self.pickerView.isHidden = false
        pickerData = ["Today", "Yesterday"]
        pickerView.reloadAllComponents()
        currentBtn = "dateBtn"
    }
    
    @IBAction func categoryBtnTapped(_ sender: Any) {
       animateUp(constraint: categoryViewHeight)
    }
    
    @IBAction func categorySelectedTapped(_ sender: Any) {
       animateDown(constraint: categoryViewHeight)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
            self.categoryBtn.setTitle(self.category, for: .normal)
        }
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
        
        let key = StorageManager.shared.getAutoKey(at: FDChild.transactions.rawValue)
        
        let transaction = Transaction(id: key, name: name, type: type, category: category, originalAmount: amount, wallet: wallet!)
//        transaction.getDictionary()
        StorageManager.shared.pushObject(to: FDChild.transactions.rawValue, key: key, data: transaction.getDictionary())
        transactions.append(transaction)
        dismiss(animated: true, completion: nil)
    }
    
    // popView animations
    func animateUp(constraint: NSLayoutConstraint) {
        // Optimized for iPhone SE 4-inch screen and Up
        constraint.constant = 550
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func animateDown(constraint: NSLayoutConstraint) {
        constraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

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
            wallet = wallets[row]
            case "dateBtn":
            dateBtn.setTitle(pickerData[row], for: .normal)
            date = pickerData[row]
            case "categoryBtn":
            categoryBtn.setTitle(pickerData[row], for: .normal)
            category = pickerData[row]
        default: break
        }
        pickerView.isHidden = true
        pickerData.removeAll()
    }
}

extension AddTransactionVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.category = categories[indexPath.row]
        print("Selected category: ", category)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategorySelectionCell", for: indexPath) as? CategorySelectionCell {
            
            let category = categories[indexPath.row]
            cell.configureCell(category: category)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
