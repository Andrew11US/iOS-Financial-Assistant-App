//
//  CustomTextField.swift
//  BrainTeaser
//
//  Created by Andrew Foster on 2/5/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 0
    
    @IBInspectable override var cornerRadius: CGFloat {
        didSet {
            setupView()
        }  
    }
    
    @IBInspectable override var borderWidth: CGFloat {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable override var borderColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable override var backgroundColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
        self.layer.backgroundColor = backgroundColor?.cgColor
    }
    
}
