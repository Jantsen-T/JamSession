//
//  Styleguide.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/29/21.
//

import UIKit


struct Colors {
    static let lighterGray = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
    // jam sesh 1 color pallet
    static let grayX11Gray = UIColor(red: 191.255, green: 189/255, blue: 193/255, alpha: 1)
    static let dimGray = UIColor(red: 109/255, green: 106/255, blue: 117/255, alpha: 1)
    static let blackCoffeee = UIColor(red: 55/255, green: 50/255, blue: 62/255, alpha: 1)
    static let goldMetalic = UIColor(red: 222/255, green: 184/255, blue: 65/255, alpha: 1)
    static let marigold = UIColor(red: 222/255, green: 158/255, blue: 54/255, alpha: 1)
    
    //Jam Session color pallet
    static let arylideYellow = UIColor(red: 233/255, green: 215/255, blue: 88/255, alpha: 1)
    static let chineseRed = UIColor(red: 165/255, green: 64/255, blue: 45/255, alpha: 1)
    static let bottleGreen = UIColor(red: 34/255, green: 111/255, blue: 84/255, alpha: 1)
    static let palePink = UIColor(red: 255/255, green: 221/255, blue: 226/255, alpha: 1)
    static let cyanProcess = UIColor(red: 8/255, green: 178/255, blue: 227/255, alpha: 1)
    
    //jam sesh 3 pallet
    static let darkPurple = UIColor(red: 54/255, green: 29/255, blue: 46/255, alpha: 1)
    static let yellowOragne = UIColor(red: 254/255, green: 153/255, blue: 32/255, alpha: 1)
    static let vegasGold = UIColor(red: 185/255, green: 164/255, blue: 76/255, alpha: 1)
    static let darkOliveGreen = UIColor(red: 86/255, green: 110/255, blue: 61/255, alpha: 1)
    static let indigoDye = UIColor(red: 12/255, green: 71/255, blue: 103/255, alpha: 1)
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
