//
//  AddTransactionVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/13/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Foundation
import CenteredCollectionView

class AddTransactionVC: UIViewController {
    
    @IBOutlet weak var amountTextField: CurrencyTextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var walletBtn: CustomButton!
    @IBOutlet weak var addBtn: CustomButton!
    @IBOutlet weak var categoryBtn: CustomButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var currencyLbl: UILabel!
    
    // Selection subViews
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var categoryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var walletViewHeight: NSLayoutConstraint!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var connectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var walletCollectionView: UICollectionView!
    var walletCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    let spinner = SpinnerViewController()
    // Data for selection when customizing new transaction
    private var categories = TransactionCategory.Income.getArray()
    
    private var wallet: (Wallet?, Int?)
    private var selectedWallet = 0
    private var date = ""
    private var category = ""
    private var name = ""
    private var type = ""
    private var amount = 0.0
    private var unifiedAmount = 0.0
    private var tempRate: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.amountTextField.delegate = self
        self.nameTextField.delegate = self
        setWalletCollectionView()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if !InternetConnectionManager.isConnected() {
                print("Connection is offline!")
                if self.connectionViewHeight.constant != 50 {
                    self.showNoConnection(view: self.connectionView, constraint: self.connectionViewHeight, to: 50, interaction: false)
                }
            } else {
                if self.connectionViewHeight.constant != 0 {
                    self.showNoConnection(view: self.connectionView, constraint: self.connectionViewHeight, to: 0, interaction: true)
                }
            }
        }
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        print("Segment index: ", segmentControl.selectedSegmentIndex)
        if segmentControl.selectedSegmentIndex == 0 {
            self.addBtn.layer.backgroundColor = UIColor.appGreen.cgColor
            amount = -amount
            type = TransactionType.income.rawValue
            print("Amount: ", amount)
        } else {
            self.addBtn.layer.backgroundColor = UIColor.appRed.cgColor
            amount = -amount
            type = TransactionType.expense.rawValue
            print("Amount: ", amount)
        }
        category.removeAll()
        self.categoryBtn.setTitle("Select Category", for: .normal)
        self.categoryBtn.setTitleColor(.blue, for: .normal)
    }
    
    @IBAction func amountTextFieldEdited(_ sender: Any) {
        let value = DataManager.getData.currency(field: amountTextField)
        if let doubleValue = value, doubleValue != 0.0 {
            if segmentControl.selectedSegmentIndex == 0 {
                self.amount = Double(round(doubleValue*100)/100)
            } else {
                self.amount = Double(round(-doubleValue*100)/100)
            }
//            self.amount = Double(round(doubleValue*100)/100)
            if let wallet = wallet.0 {
                addSpinner(spinner)
                NetworkWrapper.getRates(pair: (from: wallet.currencyCode, to: "USD")) { coff in
                    self.unifiedAmount = Double(round((self.amount * coff)*100)/100)
                    self.tempRate = coff
                    self.removeSpinner(self.spinner)
                }
            } else {
                print("Wallet has not been selected yet!")
            }
            self.showBadInput(bad: false, view: amountTextField)
        } else {
            self.amount = 0
            self.showBadInput(bad: true, view: amountTextField)
        }
        print("Amount set: ", self.amount)
        print("Unified Amount: ", self.unifiedAmount, "USD")
    }
    
    @IBAction func walletBtnTapped(_ sender: Any) {
        resignTextFields()
        self.animate(view: walletView, constraint: walletViewHeight, to: 200)
    }
    
    @IBAction func walletSelectedTapped(_ sender: Any) {
        self.animate(view: walletView, constraint: walletViewHeight, to: 0)
        
        if let wallet = wallet.0 {
            print("Currency default: ", wallet.name)
            self.currencyLbl.text = wallet.currencyCode
            addSpinner(spinner)
            NetworkWrapper.getRates(pair: (from: wallet.currencyCode, to: "USD")) { coff in
                self.unifiedAmount = Double(round((self.amount * coff)*100)/100)
                self.walletBtn.setTitle(wallet.name.capitalized, for: .normal)
                self.walletBtn.setTitleColor(.blue, for: .normal)
                self.tempRate = coff
                self.removeSpinner(self.spinner)
                print("Calculated unified: ", self.unifiedAmount)
            }
        } else {
            print("No wallet selected!")
            self.walletBtn.setTitle("Select Wallet", for: .normal)
            self.walletBtn.setTitleColor(.red, for: .normal)
        }
        print("Unified Amount: ", self.unifiedAmount, "USD")
    }
    
    @IBAction func categoryBtnTapped(_ sender: Any) {
        resignTextFields()
        if segmentControl.selectedSegmentIndex == 0 {
            categories = TransactionCategory.Income.getArray()
        } else {
            categories = TransactionCategory.Expense.getArray()
        }
        categoryTableView.reloadData()
//        animateUp(view: categoryView, constraint: categoryViewHeight)
        self.animate(view: categoryView, constraint: categoryViewHeight, to: 500)
        categoryView.superview?.subviews[0].isUserInteractionEnabled = false
    }
    
    @IBAction func categorySelectedTapped(_ sender: Any) {
//        animateDown(view: categoryView, constraint: categoryViewHeight)
        self.animate(view: categoryView, constraint: categoryViewHeight, to: 0)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
            if self.category.isEmpty {
                self.categoryBtn.setTitle("Select Category", for: .normal)
                self.categoryBtn.setTitleColor(.blue, for: .normal)
            } else {
                self.categoryBtn.setTitle(self.category.capitalized, for: .normal)
                self.categoryBtn.setTitleColor(.blue, for: .normal)
            }
        }
    }
    
    @IBAction func nameTextFieldEdited(_ sender: Any) {
        let value = DataManager.getData.text(field: nameTextField)
        if let strValue = value {
            self.name = strValue
            showBadInput(bad: false, view: nameTextField)
        } else {
            self.name = ""
            showBadInput(bad: true, view: nameTextField)
        }
        print("Name set: ", self.name)
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        resignTextFields()
        
        if type.isEmpty {
            type = TransactionType.income.rawValue
        }
        
        if !InternetConnectionManager.isConnected() {
            print("Connection is offline!")
            self.showNoConnection(view: self.connectionView, constraint: self.connectionViewHeight, to: 50, interaction: false)
        } else if amount == 0.0 {
            print("Amount can not be 0!")
            showBadInput(bad: true, view: amountTextField)
        } else if wallet.0 == nil && wallet.1 == nil {
            print("Wallet has not been selected!")
            walletBtn.setTitleColor(.red, for: .normal)
        } else if category.isEmpty {
            print("Category has not been selected!")
            categoryBtn.setTitleColor(.red, for: .normal)
        } else if name.isEmpty {
            print("Name is empty")
            showBadInput(bad: true, view: nameTextField)
        } else {
            guard var wallet = self.wallet.0, let walletIndex = self.wallet.1 else { return }
            
            if amount + wallet.balance < wallet.limit {
                print("Wallet balance exceeded!, unable to process")
                return
            }
            
            let key = StorageManager.shared.getAutoKey(at: FDChild.transactions.rawValue)
            
            let transaction = Transaction(id: key, name: name, type: type, category: category, originalAmount: amount, unifiedAmount: unifiedAmount, wallet: wallet)
            
            transactions.append(transaction)
            wallet.balance += transaction.originalAmount
            wallet.unifiedBalance = wallet.balance * tempRate
            wallets[walletIndex] = wallet
            print("Wallet new balance: ", wallet.balance)
            print("New unified balance: ", wallet.unifiedBalance)
            self.createNotification(name: .didUpdateTransactions)
            
            StorageManager.shared.pushObject(to: FDChild.transactions.rawValue, key: key, data: transaction.getDictionary())
            StorageManager.shared.updateObject(at: FDChild.wallets.rawValue, id: wallet.id, data: wallet.getDictionary())
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // popView animations
    func animateUp(view: UIView, constraint: NSLayoutConstraint) {
        // Optimized for iPhone SE 4-inch screen and Up
        constraint.constant = 550
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            view.superview?.subviews[0].isUserInteractionEnabled = false
        }
    }
    
    func animateDown(view: UIView, constraint: NSLayoutConstraint) {
        constraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            view.superview?.subviews[0].isUserInteractionEnabled = true
        }
    }
    
    func showBadInput(bad: Bool, view: UIView) {
        if bad {
            view.layer.borderWidth = 2.0
            view.layer.borderColor = UIColor.red.cgColor
        } else {
            view.layer.borderWidth = 0
            view.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func showNoConnection(view: UIView, constraint: NSLayoutConstraint, to: Int, interaction: Bool) {
        constraint.constant = CGFloat(to)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            view.superview?.subviews[0].isUserInteractionEnabled = interaction
        }
    }
    
    func resignTextFields() {
        self.nameTextField.resignFirstResponder()
        self.amountTextField.resignFirstResponder()
    }
    
    func setWalletCollectionView() {
        // Get the reference to the CenteredCollectionViewFlowLayout (REQURED)
        walletCollectionViewFlowLayout = (walletCollectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        // Modify the collectionView's decelerationRate (REQURED)
        walletCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        walletCollectionViewFlowLayout.itemSize = CGSize(width: 200, height: 100)
        // Configure the optional inter item spacing (OPTIONAL)
        walletCollectionViewFlowLayout.minimumLineSpacing = 20
    }

}

extension AddTransactionVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
