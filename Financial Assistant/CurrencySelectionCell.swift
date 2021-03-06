//
//  CurrencyCell.swift
//  Financial Assistant
//
//  Created by Andrew on 2/18/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class CurrencySelectionCell: UITableViewCell {

    @IBOutlet weak var currencyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(currency: String) {
        
        self.currencyLbl.text = currency
    }

}
