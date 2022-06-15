//
//  UIButton.swift
//  PuzzleApp
//
//  Created by Marcin Jędrzejak on 28/12/2021.
//

import UIKit

extension UIButton {
    func modify() {
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 4, height: 2)
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.contentMode = .scaleToFill
    }
}
