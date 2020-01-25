//
//  Player.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 22/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import Foundation
import ARKit

class Player {
    var geometry: ARSCNFaceGeometry
    var faceAnchor: ARFaceAnchor
    var node: SCNNode
    var counter: Int = 0
    var status: PlayerStatus = .normal
    var scene: SCNView = SCNView()
    
    init(faceAnchor: ARFaceAnchor, node: SCNNode, geometry: ARSCNFaceGeometry) {
        self.faceAnchor = faceAnchor
        self.node = node
        self.geometry = geometry
    }
}
