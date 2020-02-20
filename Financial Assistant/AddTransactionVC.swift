//
//  AddTransactionVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/13/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Foundation

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
    @IBOutlet weak var walletCollectionView: UICollectionView!
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var walletViewHeight: NSLayoutConstraint!
    @IBOutlet weak var walletView: UIView!
    
    // Data for selection when customizing new transaction
    private var categories = TransactionCategory.Income.getArray()
    
    private var wallet: (Wallet?, Int?)
    private var selectedWallet = 0
    private var date = ""
    private var category = ""
    private var amount = 0.0
    private var unifiedAmount = 0.0
    private var tempRate: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.amountTextField.delegate = self
        self.nameTextField.delegate = self
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        print("Segment index: ", segmentControl.selectedSegmentIndex)
        category = "Select Category"
        categorySelectedTapped((Any).self)
    }
    
    @IBAction func amountTextFieldEdited(_ sender: Any) {
        if let amountStr = amountTextField.text {
            if let amountDouble = Double(amountStr) {
                self.amount = amountDouble
                if tempRate != 0.0 {
                    unifiedAmount = amount * tempRate
                }
                print("Amount set: ", amount)
            }
        }
    }
    
    @IBAction func walletBtnTapped(_ sender: Any) {
//        pickerData = []
//        var walletStr: [String] = []
//        for w in wallets {
//            walletStr.append(w.name)
//        }
//        pickerData = walletStr
//        self.pickerView.isHidden = false
//        pickerView.reloadAllComponents()
//        currentBtn = "walletBtn"
        animateUp(view: walletView, constraint: walletViewHeight)
    }
    
    @IBAction func walletSelectedTapped(_ sender: Any) {
        animateDown(view: walletView, constraint: walletViewHeight)
        if wallet.0 == nil {
            wallet.0 = wallets[0]
        }
        guard let wallet = wallet.0 else { return }

        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
            self.walletBtn.setTitle(wallet.name.capitalized, for: .normal)
            NetworkWrapper.getRates(pair: (from: wallet.currencyCode, to: "USD")) { coff in
                self.unifiedAmount = self.amount * coff
                print("Unified: ", self.unifiedAmount, "USD")
                self.tempRate = coff
            }
        }
    }
    
    // Delete date picking <<<
    @IBAction func dateBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func categoryBtnTapped(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            categories = TransactionCategory.Income.getArray()
        } else {
            categories = TransactionCategory.Expense.getArray()
        }
        categoryTableView.reloadData()
        animateUp(view: categoryView, constraint: categoryViewHeight)
        categoryView.superview?.subviews[0].isUserInteractionEnabled = false
    }
    
    @IBAction func categorySelectedTapped(_ sender: Any) {
        animateDown(view: categoryView, constraint: categoryViewHeight)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
            self.categoryBtn.setTitle(self.category.capitalized, for: .normal)
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
        guard let name = nameTextField.text else { return }
        guard var wallet = self.wallet.0 else { return }
        guard let walletIndex = self.wallet.1 else { return }
 
        if let amount = amountTextField.text {
            if let doubleValue = Double(amount), doubleValue != 0.0 {
                self.amount = doubleValue
            } else {
                return
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
        
        let transaction = Transaction(id: key, name: name, type: type, category: category, originalAmount: amount, unifiedAmount: unifiedAmount, wallet: wallet)
//        transaction.getDictionary()

        transactions.append(transaction)
        wallet.balance += transaction.originalAmount
        print("Wallet new balance: ", wallet.balance)
        
            
                
        wallet.unifiedBalance = wallet.balance * tempRate
        print("New unified balance: ", wallet.unifiedBalance)
        
        StorageManager.shared.pushObject(to: FDChild.transactions.rawValue, key: key, data: transaction.getDictionary())
        StorageManager.shared.updateObject(at: FDChild.wallets.rawValue, id: wallet.id, data: wallet.getDictionary())
        
        wallets[walletIndex] = wallet
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // popView animations
    func animateUp(view: UIView, constraint: NSLayoutConstraint) {
        // Optimized for iPhone SE 4-inch screen and Up
        constraint.constant = 550
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            view.superview?.subviews[0].isUserInteractionEnabled = false
//            view.superview?.layer.backgroundColor = UIColor(red: 12, green: 12, blue: 12, transparency: 0.9).cgColor
        }
    }
    
    func animateDown(view: UIView, constraint: NSLayoutConstraint) {
        constraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            view.superview?.subviews[0].isUserInteractionEnabled = true
        }
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
            
            let category = categories[indexPath.row].capitalized
            cell.configureCell(category: category)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension AddTransactionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 5.0
        collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.systemRed.cgColor
        print(indexPath.row)
        wallet.0 = wallets[indexPath.row]
        wallet.1 = indexPath.row
        print("Selected wallet: ", wallet.0?.id ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 0
        collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.clear.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletSelectionCell", for: indexPath) as? WalletSelectionCell {
            
            let wallet = wallets[indexPath.row].name.capitalized // <<< to be changed!!!
            cell.configureCell(wallet: wallet)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension AddTransactionVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.walletBtn.endEditing(true)
    }
    override func resignFirstResponder() -> Bool {
        self.amountTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        return true
    }
}
