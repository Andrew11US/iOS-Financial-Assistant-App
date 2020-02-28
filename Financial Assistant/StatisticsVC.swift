//
//  StatisticsVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/7/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class StatisticsVC: UIViewController {
    
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var expenceLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var eraceBtn: CustomButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleLocalChange(notification:)), name: .didUpdateStatistics, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if appFlags[AppFlags.statistics.rawValue]! {
            showStatistics()
        } else {
            print("Error when loading statistics!")
            eraceBtn.isEnabled = false
        }
    }
    
    @IBAction func eraceStatisticsTapped(sender: UIButton) {
        StorageManager.shared.deleteObject(location: FDChild.statistics.rawValue, id: currentMonth.0!.id)
        statistics.remove(at: currentMonth.1!)
        currentMonth.0 = nil
    }
    
    @objc func handleLocalChange(notification: Notification) {
        print("Statistics changed!")
    }
    
    func showStatistics() {
        idLbl.text = currentMonth.0?.id
        incomeLbl.text = currentMonth.0?.incomes.currencyFormat
        expenceLbl.text = currentMonth.0?.expenses.currencyFormat
        balanceLbl.text = currentMonth.0?.balance.currencyFormat
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
