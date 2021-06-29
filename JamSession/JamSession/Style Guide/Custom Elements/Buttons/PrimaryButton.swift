//
//  PrimaryButton.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/29/21.
//

import UIKit

class PrimaryButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    func setupButton() {
        updateFontTo(font: FontNames.verdanaBold)
        setTitleColor(.white, for: .normal)
        self.backgroundColor = Colors.lighterGray
        self.addCornerRadius()
    }
    
    func updateFontTo(font: String) {
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: font, size: size)
    }
}
