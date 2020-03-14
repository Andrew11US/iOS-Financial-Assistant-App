//
//  StatisticsCell.swift
//  Financial Assistant
//
//  Created by Andrew on 3/14/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class StatisticsCell: UITableViewCell {
    
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var expenseLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(month: StatisticMonth) {
        self.monthLbl.text = month.month
        self.incomeLbl.text = month.incomes.currencyFormat
        self.expenseLbl.text = month.expenses.currencyFormat
        self.balanceLbl.text = month.balance.currencyFormat
    }

}
