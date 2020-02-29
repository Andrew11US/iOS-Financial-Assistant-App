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
    @IBOutlet weak var connectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let spinner = SpinnerViewController()
    
    private var types = WalletType.getArray()
    private var unifiedCurrencyCode = StorageManager.shared.getUserCache().code
    private var selectedCurrency : [String] = []
    private var sign = true
    private var balance = 0.0
    private var unifiedBalance = 0.0
    private var limit = 0.0
    private var name = ""
    private var type = ""
    private var currency = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.balanceTextField.delegate = self
        self.limitTextField.delegate = self
        
        monitorConnection(interval: 1, view: connectionView, constraint: connectionViewHeight)
    }
  
    @IBAction func typeBtnTapped(_ sender: Any) {
        animate(view: typeView, constraint: typeViewHeight, to: 500)
        resignTextFields()
    }
    
    @IBAction func currencyBtnTapped(_ sender: Any) {
        animate(view: currencyView, constraint: currencyViewHeight, to: 500)
        resignTextFields()
    }
    
    @IBAction func currencySelectedBtnTapped(_ sender: Any) {
        animate(view: currencyView, constraint: currencyViewHeight, to: 0)
        
        if currency.isEmpty {
            currency = "USD"
            self.unifiedBalance = self.balance
            self.currencyBtn.setTitle(self.currency, for: .normal)
            self.currencyBtn.setTitleColor(.appPurple, for: .normal)
            print("Currency default: ", currency)
        } else if currency == "USD" {
            self.unifiedBalance = self.balance
            self.currencyBtn.setTitle(self.currency, for: .normal)
            self.currencyBtn.setTitleColor(.appPurple, for: .normal)
            print("Currency selected: ", currency)
        } else {
            addSpinner(spinner)
            NetworkWrapper.getRates(pair: (from: currency, to: "USD")) { coff in
                self.unifiedBalance = Double(self.balance * coff).round(places: 2)
                self.currencyBtn.setTitle(self.currency, for: .normal)
                self.currencyBtn.setTitleColor(.appPurple, for: .normal)
                self.removeSpinner(self.spinner)
                print("Calculated unified: ", self.unifiedBalance)
            }
        }
    }
    
    @IBAction func typeSelectedBtnTapped(_ sender: Any) {
        animate(view: typeView, constraint: typeViewHeight, to: 0)
        if type.isEmpty {
            type = types[0]
        }
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
            self.typeBtn.setTitle(self.type.capitalized, for: .normal)
            self.typeBtn.setTitleColor(.appPurple, for: .normal)
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
    
    @IBAction func balanceTextFieldEdited(_ sender: Any) {
        let value = DataManager.getData.currency(field: balanceTextField)
        if let doubleValue = value {
            if sign {
                self.balance = Double(doubleValue).round(places: 2)
            } else {
                self.balance = Double(-doubleValue).round(places: 2)
            }
            if currency.isEmpty {
                print("Currency hasn't been selected yet!")
            } else if currency == "USD" {
                self.unifiedBalance = self.balance
            } else {
                addSpinner(spinner)
                NetworkWrapper.getRates(pair: (from: currency, to: "USD")) { coff in
                    self.unifiedBalance = Double(self.balance * coff).round(places: 2)
                    self.removeSpinner(self.spinner)
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
            self.limit = Double(-doubleValue).round(places: 2)
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
            signBtn.setTitleColor(.appRed, for: .normal)
        } else {
            sign = true
            self.balance = -balance
            self.unifiedBalance = -unifiedBalance
            signBtn.setTitle("+", for: .normal)
            signBtn.setTitleColor(.appGreen, for: .normal)
        }
        print("sign changed: ", balance, unifiedBalance)
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        resignTextFields()
        
        if !InternetConnectionManager.isConnected() {
            print("Connection is offline!")
            animate(view: connectionView, constraint: connectionViewHeight, to: 60)
        } else if name.isEmpty {
            print("Name is empty")
            showBadInput(bad: true, view: nameTextField)
        } else if type.isEmpty {
            print("Type has not been selected!")
            typeBtn.setTitleColor(.appRed, for: .normal)
        } else if currency.isEmpty {
            print("Currency has not been selected!")
            currencyBtn.setTitleColor(.appRed, for: .normal)
        } else {
            
            let key = StorageManager.shared.getAutoKey(at: FDChild.wallets.rawValue)
            let wallet = Wallet(id: key, name: name, type: type, currencyCode: currency, unifiedCurrencyCode: unifiedCurrencyCode, balance: balance, unifiedBalance: unifiedBalance, limit: limit)
            wallets.append(wallet)
            createNotification(name: .didUpdateWallets)
            
            StorageManager.shared.pushObject(at: FDChild.wallets.rawValue, key: key, data: wallet.getDictionary())
            dismiss(animated: true, completion: nil)
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
