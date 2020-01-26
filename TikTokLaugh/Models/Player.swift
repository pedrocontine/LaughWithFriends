//
//  Player.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 22/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit
import ARKit

class Player {
    //var geometry: ARSCNFaceGeometry
    var faceAnchor: ARFaceAnchor
    var node: SCNNode
    var counter: Int = 0
    var status: PlayerStatus = .normal
    var scene: SCNView = SCNView()
    var image: UIImage
    var num: Int
    
    init(faceAnchor: ARFaceAnchor, node: SCNNode, num: Int) {
        self.faceAnchor = faceAnchor
        self.node = node
        self.num = num
        self.image = UIImage(named: "p\(num)_normal")!
    }
}
