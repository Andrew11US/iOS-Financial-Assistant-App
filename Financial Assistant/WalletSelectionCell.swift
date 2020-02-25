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
        
        self.layer.cornerRadius = CGFloat(20)
//        self.layer.backgroundColor = UIColor.systemTeal.cgColor
        addGradient()
    }
    
    func configureCell(wallet: String) {
        self.nameLbl.text = wallet
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.colors = [
            UIColor.blue.cgColor,
            UIColor.systemTeal.cgColor
        ]
        layer.insertSublayer(gradient, at: 0)
    }

}
