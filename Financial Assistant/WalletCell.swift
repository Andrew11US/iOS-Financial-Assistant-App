//
//  WalletCell.swift
//  Financial Assistant
//
//  Created by Andrew on 2/15/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class WalletCell: UITableViewCell {
    
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var balance: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(wallet: Wallet) {
        
        self.type.text = wallet.type
        self.name.text = wallet.name
        self.balance.text = "\(wallet.balance.currencyFormat) \(wallet.currencyCode)"
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.colors = [
            UIColor(hexString: "fbc2eb").cgColor,
            UIColor(hexString: "a6c1ee").cgColor
        ]
        layer.insertSublayer(gradient, at: 0)
    }

}
