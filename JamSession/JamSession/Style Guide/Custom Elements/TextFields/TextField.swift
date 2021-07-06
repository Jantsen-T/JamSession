//
//  TextField.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/29/21.
//

import UIKit

class MainTextField: UITextField {
    

        override func awakeFromNib() {
            super.awakeFromNib()
            setTextField()
            
        }
        
        func setTextField() {
            self.addCornerRadius()
            self.addAccentBorder()
            updateFontTo(font: FontNames.bodoniSmallCaps)
            self.backgroundColor = .white
            self.layer.masksToBounds = true
            
        }
        
        func setPlaceHolderText() {
            let currentPlaceHolder = self.placeholder
            self.attributedPlaceholder = NSAttributedString(string: currentPlaceHolder ?? "", attributes: [NSAttributedString.Key.foregroundColor : Colors.lighterGray, NSAttributedString.Key.font: UIFont(name: FontNames.bodoniSmallCaps, size: 16)!
            ])
        }
    func updateFontTo(font: String) {
        guard let size = self.font?.pointSize else {return}
        self.font = UIFont(name: font, size: size)
    }
        
    }// End of class


