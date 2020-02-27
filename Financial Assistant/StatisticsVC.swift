//
//  StatisticsVC.swift
//  Financial Assistant
//
//  Created by Andrew on 2/7/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class StatisticsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleLocalChange(notification:)), name: .didUpdateStatistics, object: nil)
    }
    
    @objc func handleLocalChange(notification: Notification) {
        print("Statistics changed!")
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
