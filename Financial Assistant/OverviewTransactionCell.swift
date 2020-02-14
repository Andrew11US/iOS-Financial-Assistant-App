//
//  OverviewTransactionCell.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class OverviewTransactionCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var amount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(transaction: Transaction) {
        
        self.date.text = transaction.dateCreated // << make reformatting!!!
        self.name.text = transaction.name
        self.amount.text = "\(transaction.originalAmount) \(transaction.currencyCode)"
    }
    
    func configureCell(test: String) {
        
        self.date.text = test
        self.name.text = test
        self.amount.text = "$ 11.1"
    }

}
