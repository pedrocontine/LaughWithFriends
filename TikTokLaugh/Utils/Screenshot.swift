//
//  Screenshot.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 25/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit

extension UIView {

    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil) {
            return image!
        }
        
        return UIImage()
    }
}
