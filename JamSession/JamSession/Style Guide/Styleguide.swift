//
//  Styleguide.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/29/21.
//

import UIKit


struct Colors {
    static let lighterGray = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
}


struct FontNames {
    static let verdanaBold = "Verdana-Bold"
    
    
}
extension UIView {
    func addCornerRadius(_ radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
    }
    
    func addAccentBorder(width: CGFloat = 1, color: UIColor = Colors.lighterGray) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
