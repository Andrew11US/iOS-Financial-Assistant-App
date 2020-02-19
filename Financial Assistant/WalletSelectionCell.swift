//
//  WalletSelectionCell.swift
//  Financial Assistant
//
//  Created by Andrew on 2/19/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class WalletSelectionCell: UICollectionViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(wallet: String) {
        self.nameLbl.text = wallet
    }

}
