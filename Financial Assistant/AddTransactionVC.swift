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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(sender: UIButton) {
        
        StorageManager().saveData(toEntity: "Wallets", value: "1123", forKey: "data")
        StorageManager().saveData(toEntity: "Wallets", value: "textfield.text!", forKey: "data")
        StorageManager().saveData(toEntity: "Wallets", value: "hgfj45", forKey: "data")
    }
    
    @IBAction func retrieve(sender: UIButton) {
        StorageManager().getDataArray(fromEntity: "Wallets", key: "data")
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
