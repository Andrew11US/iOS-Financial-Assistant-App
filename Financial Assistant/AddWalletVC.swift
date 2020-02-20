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
    @IBOutlet weak var initialBalanceTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var currencyBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    // Pullup view to present currency picker in better way
    @IBOutlet weak var currencyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var typeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // Data to choose when customizing a Wallet
    var currencies = ["USD", "EUR", "PLN", "UAH"]
    var types = WalletType.getArray()
    
    private var balance = 0.0
    private var limit = 0.0
    private var type = WalletType.getArray()[0]
    private var currency = Locale.current.currencyCode ?? "UAH"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.currencyView.layer.cornerRadius = 15.0
//        self.typeView.layer.cornerRadius = 15.0
    }
  
    @IBAction func typeBtnTapped(_ sender: Any) {
        animateUp(constraint: typeViewHeight)
    }
    
    @IBAction func currencyBtnTapped(_ sender: Any) {
        animateUp(constraint: currencyViewHeight)
    }
    
    @IBAction func currencySelectedBtnTapped(_ sender: Any) {
        animateDown(constraint: currencyViewHeight)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
            self.currencyBtn.setTitle(self.currency, for: .normal)
        }
    }
    
    @IBAction func typeSelectedBtnTapped(_ sender: Any) {
        animateDown(constraint: typeViewHeight)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
            self.typeBtn.setTitle(self.type.capitalized, for: .normal)
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
        guard let name = nameTextField.text else { return }
        
        if let balance = initialBalanceTextField.text {
            if let doubleValue = Double(balance) {
                self.balance = doubleValue
            }
        }
        if let limit = limitTextField.text {
            if let doubleValue = Double(limit) {
                self.limit = -doubleValue
            }
        }
        
        let unifiedBalance = 1.0
        let unifiedCurrencyCode = defaults.string(forKey: "UnifiedCurrencyCode") ?? "USD"
        
        let key = StorageManager.shared.getAutoKey(at: FDChild.wallets.rawValue)
        let wallet = Wallet(id: key, name: name, type: type, currencyCode: currency, unifiedCurrencyCode: unifiedCurrencyCode, balance: balance, unifiedBalance: unifiedBalance, limit: limit)
    
        StorageManager.shared.pushObject(to: FDChild.wallets.rawValue, key: key, data: wallet.getDictionary())
        wallets.append(wallet)
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
        currency = currencies[indexPath.row]
        print("Selected currency: ", currency)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencySelectionCell", for: indexPath) as? CurrencySelectionCell {
            
            let currency = currencies[indexPath.row]
            cell.configureCell(currency: currency)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
