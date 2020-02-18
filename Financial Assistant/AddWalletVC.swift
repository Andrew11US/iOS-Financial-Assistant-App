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
    @IBOutlet weak var pickerView: UIPickerView!
    // Pullup view to present currency picker in better way
    @IBOutlet weak var popViewHeight: NSLayoutConstraint!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var pickerData: [String] = []
    var currentBtn: String = ""
    var balance = 0.0
    var limit = 0.0
    var type = ""
    private var currency = ""
    
    var currencies = ["USD", "EUR", "PLN", "UAH"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.popView.layer.cornerRadius = 15.0
    }
  
    @IBAction func typeBtnTapped(_ sender: Any) {
        self.pickerView.isHidden = false
        pickerData = WalletType.getArray()
        pickerView.reloadAllComponents()
        currentBtn = "typeBtn"
    }
    
    @IBAction func currencyBtnTapped(_ sender: Any) {
        animateViewUp()
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        animateViewDown()
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
            self.currencyBtn.setTitle(self.currency, for: .normal)
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
        
        let key = StorageManager.shared.getAutoKey(at: FDChild.wallets.rawValue)
        
        let wallet = Wallet(id: key, name: name, type: type, currencyCode: currency, initialBalance: balance, limit: limit)
        
//        let transaction = Transaction(id: "INIT_ID", name: name, type: type, category: category, originalAmount: amount, wallet: wallets[0])
        //        transaction.getDictionary()
        StorageManager.shared.pushObject(to: FDChild.wallets.rawValue, key: key, data: wallet.getDictionary())
        wallets.append(wallet)
        dismiss(animated: true, completion: nil)
    }
    
    // popView animations
    func animateViewUp() {
        popViewHeight.constant = 600
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func animateViewDown() {
        popViewHeight.constant = 0
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
        pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch currentBtn {
        case "typeBtn":
            typeBtn.setTitle(pickerData[row], for: .normal)
            type = pickerData[row]
        case "currencyBtn":
            currencyBtn.setTitle(pickerData[row], for: .normal)
            currency = pickerData[row]
        default: break
        }
        pickerView.isHidden = true
    }
}

extension AddWalletVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        currency = currencies[indexPath.row]
        print(currency)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        selected = "none"
        //        print(selected)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencySelectCell", for: indexPath) as? CurrencySelectCell {
            
            let currency = currencies[indexPath.row]
            cell.configureCell(currency: currency)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
}
