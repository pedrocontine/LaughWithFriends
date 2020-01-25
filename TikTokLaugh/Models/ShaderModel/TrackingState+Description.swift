//
//  TrackingState+Description.swift
//  hud
//
//  Created by Gustavo Lima on 23/08/19.
//  Copyright © 2019 Gustavo Lima. All rights reserved.
//

import ARKit

extension ARCamera.TrackingState {
    public var description: String {
        switch self {
        case .notAvailable:
            return "TRACKING UNAVAILABLE"
        case .normal:
            return "TRACKING NORMAL"
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                return "TRACKING LIMITED\nToo much camera movement"
            case .insufficientFeatures:
                return "TRACKING LIMITED\nNot enough surface detail"
            case .initializing:
                return "Tracking LIMITED\nInitialization in progress."
            case .relocalizing:
                return "Tracking LIMITED\nRelocalizing."
            @unknown default:
                fatalError()
            }
        }
    }
}
