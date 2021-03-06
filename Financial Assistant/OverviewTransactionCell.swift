//
//  OverviewTransactionCell.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class OverviewTransactionCell: UITableViewCell {
    
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
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
        
        self.monthLbl.text = transaction.dateCreated.createDate?.getMonth
        self.dayLbl.text = transaction.dateCreated.createDate?.getDay
        self.name.text = transaction.name
        self.amount.text = "\(transaction.originalAmount.currencyFormat) \(transaction.currencyCode)"
        
        if transaction.originalAmount < 0 {
            self.amount.textColor = .systemRed
        } else {
            self.amount.textColor = .systemGreen
        }
    }

}
