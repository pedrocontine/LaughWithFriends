//
//  CVPixelBuffer+TransformedImage.swift
//  hud
//
//  Created by Gustavo Lima on 23/08/19.
//  Copyright © 2019 Gustavo Lima. All rights reserved.
//

import UIKit

extension CVPixelBuffer {
    func transformedImage(targetSize: CGSize, rotationAngle: CGFloat) -> CIImage? {
        let image = CIImage(cvPixelBuffer: self, options: [:])
        let scaleFactor = Float(targetSize.width) / Float(image.extent.width)
        return image.transformed(by: CGAffineTransform(rotationAngle: rotationAngle)).applyingFilter("CIBicubicScaleTransform", parameters: ["inputScale": scaleFactor])
    }
}
