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
    
    var pickerData: [String] = []
    var currentBtn: String = ""
    var balance = 0.0
    var limit = 0.0
    var type = ""
    var currency = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    @IBAction func typeBtnTapped(_ sender: Any) {
        self.pickerView.isHidden = false
        pickerData = WalletType.getArray()
        pickerView.reloadAllComponents()
        currentBtn = "typeBtn"
    }
    
    @IBAction func currencyBtnTapped(_ sender: Any) {
//        let alert = UIAlertController(style: .actionSheet, message: "Select Currency")
//        alert.addLocalePicker(type: .currency) { info in
//            print(info?.currencyCode ?? "xxx")
//            self.currency = info?.currencyCode ?? "USD"
//        }
//        alert.addAction(title: "OK", style: .cancel)
//        alert.show()
        presentViewController(animated: true, completion: nil)
    }
    
    // Trying to present alertView
    private func presentViewController(animated: Bool, completion: (() -> Void)?) -> Void {
        
        let alert = UIAlertController(style: .actionSheet, message: "Select Currency")
        alert.addLocalePicker(type: .currency) { info in
            print(info?.currencyCode ?? "xxx")
            self.currency = info?.currencyCode ?? "USD"
        }
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
        
       UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: animated, completion: completion)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
