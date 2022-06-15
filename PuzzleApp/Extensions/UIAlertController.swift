//
//  UIAlertController.swift
//  PuzzleApp
//
//  Created by Marcin Jędrzejak on 28/12/2021.
//

import UIKit

extension UIAlertController {
    func customImageAlert(image: UIImage) {
        let maxSize = CGSize(width: 245, height: 300)
        let imageSize = image.size
        
        var ratio: CGFloat!
        if(imageSize.width > imageSize.height) {
            ratio = maxSize.width / imageSize.width
        } else {
            ratio = maxSize.height / imageSize.height
        }
        
        let scaledSize = CGSize(width: imageSize.width * ratio, height: imageSize.height * ratio)
        var resizedImage = image.resize(scaledSize)
        
        if imageSize.height > imageSize.width {
            let left = (maxSize.width - resizedImage.size.width) / 2
            resizedImage = resizedImage.withAlignmentRectInsets(UIEdgeInsets(top: 0,left: -left, bottom: 0,right: 0))
        }
        
        let imageAction = UIAlertAction(title: "", style: .default, handler: nil)
        imageAction.isEnabled = false
        imageAction.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imageAction)
    }
}
