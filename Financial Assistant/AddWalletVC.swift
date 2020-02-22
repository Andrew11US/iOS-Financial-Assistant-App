//
//  AddWalletVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/15/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class AddWalletVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var balanceTextField: CurrencyTextField!
    @IBOutlet weak var limitTextField: CurrencyTextField!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var currencyBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var signBtn: UIButton!
    
    // Pullup view to present currency picker in better way
    @IBOutlet weak var currencyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var typeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // Data to choose when customizing a Wallet
    var types = WalletType.getArray()
    
    private var name = ""
    private var balance = 0.0
    private var unifiedBalance = 0.0
    private var limit = 0.0
    private var sign = true
    private var type = ""
    private var currency = ""
    private var unifiedCurrencyCode = StorageManager.shared.getUserCache().code
    private var selectedCurrency : [String] = []
    private var wasOffline = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.balanceTextField.delegate = self
        self.limitTextField.delegate = self
//        self.currencyView.layer.cornerRadius = 10.0
//        self.typeView.layer.cornerRadius = 10.0
        print("Connection established: ", InternetConnectionManager.isConnected())
    }
  
    @IBAction func typeBtnTapped(_ sender: Any) {
        animateUp(view: typeView, constraint: typeViewHeight)
        resignTextFields()
    }
    
    @IBAction func currencyBtnTapped(_ sender: Any) {
        animateUp(view: currencyView, constraint: currencyViewHeight)
        resignTextFields()
    }
    
    @IBAction func currencySelectedBtnTapped(_ sender: Any) {
        animateDown(view: currencyView, constraint: currencyViewHeight)
        addBtn.isEnabled = false
        if currency == "USD" {
            self.unifiedBalance = self.balance
            self.currencyBtn.setTitle(self.currency, for: .normal)
            self.currencyBtn.setTitleColor(.blue, for: .normal)
            self.addBtn.isEnabled = true
        } else {
            if currency.isEmpty {
                currency = "USD"
                self.unifiedBalance = self.balance
                self.currencyBtn.setTitle(self.currency, for: .normal)
                self.currencyBtn.setTitleColor(.blue, for: .normal)
                self.addBtn.isEnabled = true
            } else {
                NetworkWrapper.getRates(pair: (from: currency, to: "USD")) { coff in
                    self.unifiedBalance = Double(round((self.balance * coff)*100)/100)
                    
                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
                        self.currencyBtn.setTitle(self.currency, for: .normal)
                        self.currencyBtn.setTitleColor(.blue, for: .normal)
                        self.addBtn.isEnabled = true
                    }
                }
            }
        }
        print("Unified Balance: ", self.unifiedBalance, "USD")
    }
    
    @IBAction func typeSelectedBtnTapped(_ sender: Any) {
        animateDown(view: typeView, constraint: typeViewHeight)
        if type.isEmpty {
            type = types[0]
        }
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
            self.typeBtn.setTitle(self.type.capitalized, for: .normal)
            self.typeBtn.setTitleColor(.blue, for: .normal)
        }
    }
    
    @IBAction func nameTextFieldEdited(_ sender: Any) {
        let value = DataManager.getData.name(field: nameTextField)
        if let strValue = value {
            self.name = strValue
            showBadInput(bad: false, view: nameTextField)
        } else {
            self.name = ""
            showBadInput(bad: true, view: nameTextField)
        }
        print("Name set: ", self.name)
    }
    
    @IBAction func balanceTextFieldEdited(_ sender: Any) {
        let value = DataManager.getData.currency(field: balanceTextField)
        if let doubleValue = value {
            if sign {
                self.balance = Double(round(doubleValue*100)/100)
            } else {
                self.balance = Double(round(-doubleValue*100)/100)
            }
            if currency.isEmpty {
                print("Currency hasn't been selected yet!")
            } else if currency == "USD" {
                self.unifiedBalance = self.balance
                self.addBtn.isEnabled = true
            } else {
                NetworkWrapper.getRates(pair: (from: currency, to: "USD")) { coff in
                    self.unifiedBalance = Double(round((self.balance * coff)*100)/100)
                    self.addBtn.isEnabled = true
                }
            }
        } else {
            self.balance = 0
        }
        print("Balance set: ", self.balance)
        print("Unified Balance: ", self.unifiedBalance, "USD")
    }
    
    @IBAction func limitTextFieldEdited(_ sender: Any) {
        let value = DataManager.getData.currency(field: limitTextField)
        if let doubleValue = value {
            self.limit = Double(round(-doubleValue*100)/100)
        } else {
            self.limit = 0
        }
        print("Limit set: ", self.limit)
    }
    
    @IBAction func signBtnTapped(_ sender: Any) {
        resignTextFields()
        if sign {
            sign = false
            self.balance = -balance
            self.unifiedBalance = -unifiedBalance
            signBtn.setTitle("-", for: .normal)
            signBtn.setTitleColor(.red, for: .normal)
        } else {
            sign = true
            self.balance = -balance
            self.unifiedBalance = -unifiedBalance
            signBtn.setTitle("+", for: .normal)
            signBtn.setTitleColor(.green, for: .normal)
        }
        print("Balance sign changed: ", balance)
        print("Unified sign changed: ", unifiedBalance)
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        resignTextFields()
        
        if name.isEmpty {
            print("Name is empty")
            showBadInput(bad: true, view: nameTextField)
        } else if type.isEmpty {
            print("Type has not been selected!")
            typeBtn.setTitleColor(.red, for: .normal)
        } else if currency.isEmpty {
            print("Currency has not been selected!")
            currencyBtn.setTitleColor(.red, for: .normal)
        } else if !InternetConnectionManager.isConnected() {
            print("Connection is offline!")
        } else if wasOffline {
            currencySelectedBtnTapped(Any.self)
            wasOffline = false
        } else {
            
            let key = StorageManager.shared.getAutoKey(at: FDChild.wallets.rawValue)
            let wallet = Wallet(id: key, name: name, type: type, currencyCode: currency, unifiedCurrencyCode: unifiedCurrencyCode, balance: balance, unifiedBalance: unifiedBalance, limit: limit)
            wallets.append(wallet)
            self.createNotification(name: .didUpdateWallets)
            
            StorageManager.shared.pushObject(to: FDChild.wallets.rawValue, key: key, data: wallet.getDictionary())
            dismiss(animated: true, completion: nil)
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
    
    func resignTextFields() {
        self.nameTextField.resignFirstResponder()
        self.balanceTextField.resignFirstResponder()
        self.limitTextField.resignFirstResponder()
    }
    
}

extension AddWalletVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row].capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        type = types[row]
        print("Selected type: ", type)
    }
}

extension AddWalletVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        currency = currencies[indexPath.row][0..<3]
        selectedCurrency.append(currency)
        print("Selected currency: ", currency)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
        let item = currencies[indexPath.row][0..<3]
        for (index, value) in selectedCurrency.enumerated() {
            if value == item {
                selectedCurrency.remove(at: index)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencySelectionCell", for: indexPath) as? CurrencySelectionCell {
            
            // Fixes accessory duplicates issue, when scrolling tableView
            let checkmarks =  selectedCurrency.filter { $0 == currencies[indexPath.row][0..<3] }
            if checkmarks.count > 0 {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
            
            let currency = currencies[indexPath.row]
            cell.configureCell(currency: currency)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension AddWalletVC: UITextFieldDelegate {
    // Dismiss keyboard function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Dismiss when return btn pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        balanceTextField.resignFirstResponder()
        limitTextField.resignFirstResponder()
        return true
    }
}
