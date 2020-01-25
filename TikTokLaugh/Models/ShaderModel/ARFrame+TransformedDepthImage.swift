//
//  ARFrame+TransformedDepthImage.swift
//  hud
//
//  Created by Gustavo Lima on 23/08/19.
//  Copyright © 2019 Gustavo Lima. All rights reserved.
//

import ARKit

extension ARFrame {
    func transformedDepthImage(targetSize: CGSize) -> CIImage? {
        guard let depthData = capturedDepthData else { return nil }
        return depthData.depthDataMap.transformedImage(targetSize: CGSize(width: targetSize.height, height: targetSize.width), rotationAngle: -CGFloat.pi/2)
    }
}
