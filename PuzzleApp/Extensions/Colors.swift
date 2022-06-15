//
//  Colors.swift
//  PuzzleApp
//
//  Created by Marcin Jędrzejak on 06/03/2022.
//

import Foundation
import UIKit

let imageOne = UIImage(named: "IMG_0001")
let imageTwo = UIImage(named: "IMG_0002")
let imageThree = UIImage(named: "IMG_0003")
let imageFour = UIImage(named: "IMG_0004")
let imageFive = UIImage(named: "IMG_0005")
let imageSix = UIImage(named: "IMG_0006")

struct Colors {
    var bundleArray = [
//        TableViewCellModel(subcategory: ["123"], image: testImage!)
        TableViewCellModel(
            category: "Category #1",
            subcategory: ["SubCategory #1.1", "SubCategory #1.2"],
            colors: [
                // SubCategory #1.1
//                [CollectionViewCellModel(color: UIColor.colorFromHex("#DA70D6"), name: "Orchid", image: testImage!)],
                [CollectionViewCellModel(color: UIColor.white, name: "", image: imageOne!),
                 CollectionViewCellModel(color: UIColor.white, name: "2", image: imageTwo!),
                 CollectionViewCellModel(color: UIColor.white, name: "3", image: imageThree!),
                 CollectionViewCellModel(color: UIColor.white, name: "4", image: imageFour!),
                 CollectionViewCellModel(color: UIColor.white, name: "5", image: imageFive!),
                 CollectionViewCellModel(color: UIColor.white, name: "6", image: imageSix!)],
//                 CollectionViewCellModel(color: UIColor.colorFromHex("#FA8072"), name: "Salmon"),
//                 CollectionViewCellModel(color: UIColor.colorFromHex("#FDF5E6"), name: "Old Lace"),
//                 CollectionViewCellModel(color: UIColor.colorFromHex("#00FFFF"), name: "Aqua"),
//                 CollectionViewCellModel(color: UIColor.colorFromHex("#2E8B57"), name: "Sea Green")],
            ]),
//        image: testImage!)
        
//        TableViewCellModel(
//            category: "Category #1",
//            subcategory: ["SubCategory #1.1", "SubCategory #1.2"],
//            colors: [
//                // SubCategory #1.1
//                [CollectionViewCellModel(color: UIColor.colorFromHex("#DA70D6"), name: "Orchid"),
//                 CollectionViewCellModel(color: UIColor.colorFromHex("#FA8072"), name: "Salmon"),
//                 CollectionViewCellModel(color: UIColor.colorFromHex("#FDF5E6"), name: "Old Lace"),
//                 CollectionViewCellModel(color: UIColor.colorFromHex("#00FFFF"), name: "Aqua"),
//                 CollectionViewCellModel(color: UIColor.colorFromHex("#2E8B57"), name: "Sea Green")],
                // SubCategory #1.2
//                [CollectionViewCellModel(color: UIColor.colorFromHex("#2F4F4F"), name: "Dark Slate Gray"),
//                 CollectionViewCellModel(color: UIColor.colorFromHex("#F0FFF0"), name: "Honeydew"),
//                 CollectionViewCellModel(color: UIColor.colorFromHex("#DCDCDC"), name: "Gainsboro")]
//            ])
    ]
}

extension UIColor {
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }
    
    static func colorFromHex(_ hex: String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6 {
            return UIColor.magenta
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255,
                       green: CGFloat((rgb & 0x00FF00) >> 8) / 255,
                       blue: CGFloat(rgb & 0x0000FF) / 255,
                       alpha: 1.0)
    }
}
