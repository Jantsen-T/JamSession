//
//  TextField.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/29/21.
//

import UIKit

class TextField: UITextField {

    
        override class func awakeFromNib() {
            super.awakeFromNib()
            
        }
        
        func setupTextField() {
            self.addCornerRadius()
            self.addAccentBorder()
            
        }
        
        func setPlaceHolderText() {
            let currentPlaceHolder = self.placeholder
            self.attributedPlaceholder = NSAttributedString(string: currentPlaceHolder ?? "", attributes: [NSAttributedString.Key.foregroundColor : Colors.lighterGray, NSAttributedString.Key.font: UIFont(name: FontNames.verdanaBold, size: 16)!
            ])
        }
        
    }// End of class


