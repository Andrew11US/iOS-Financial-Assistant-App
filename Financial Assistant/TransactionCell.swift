//
//  TransactionCell.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var walletLogo: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var walletName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = CGFloat(7)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(transaction: Transaction) {
        
        self.walletLogo.image = UIImage(named: "FAIconTrans") // << Fix later!!!
        self.date.text = transaction.dateCreated.createDate?.getShort
        self.name.text = transaction.name.capitalized
        self.category.text = transaction.category.capitalized
        self.walletName.text = transaction.walletName.capitalized
        
        self.amount.text = "\(transaction.originalAmount.currencyFormat) \(transaction.currencyCode)"
        
        if transaction.originalAmount < 0 {
            self.amount.textColor = .systemRed
        } else {
            self.amount.textColor = .systemGreen
        }
    }

}
