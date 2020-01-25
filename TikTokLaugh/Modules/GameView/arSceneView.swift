//
//  AR.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 21/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import Foundation
import ARKit

extension GameViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let sceneView = renderer as? ARSCNView,
            let frame = arSceneView.session.currentFrame,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return nil }
        
        guard let device = sceneView.device else { return nil }
        guard let faceGeometry = ARSCNFaceGeometry(device: device, fillMesh: true) else { return nil }
               
//        if let material = faceGeometry.firstMaterial {
//            material.diffuse.contents = arSceneView.scene.background.contents
//            material.lightingModel = .constant // .physicallyBased
//
//            guard let shaderURL = Bundle.main.url(forResource: "VideoTexturedFace", withExtension: "shader"),
//                  let modifier = try? String(contentsOf: shaderURL)
//                else {return nil}
//
//            faceGeometry.shaderModifiers = [ .geometry: modifier]
//
//            // Pass view-appropriate image transform to the shader modifier so
//            // that the mapped video lines up correctly with the background video.
//            let affineTransform = frame.displayTransform(for: .landscapeRight, viewportSize: boundsSize)
//
//            let transform = SCNMatrix4(affineTransform)
//
//            faceGeometry.setValue(SCNMatrix4Invert(transform), forKey: "displayTransform")
//        }
        
        let faceNode = SCNNode(geometry: faceGeometry)
        
        faceNode.geometry?.firstMaterial?.fillMode = .lines
        //faceNode.geometry?.firstMaterial?.transparency = 0.0
        
        gameController.addPlayer(faceAnchor: faceAnchor, node: faceNode, geometry: faceGeometry)
        
        return faceNode
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else
        { return }
          
        faceGeometry.update(from: faceAnchor.geometry)
          
        gameController.handleSmile(faceAnchor: faceAnchor)
    }
    
}
