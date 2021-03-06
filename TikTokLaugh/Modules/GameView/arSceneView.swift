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
        
        let faceNode = SCNNode(geometry: faceGeometry)
        
        faceNode.geometry?.firstMaterial?.fillMode = .lines
        faceNode.geometry?.firstMaterial?.transparency = 0.0
                
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let image = gameController.getPlayer(faceAnchor: faceAnchor)?.image
        else {return}
        
        let imageNode = insertImage(image: image)
        node.addChildNode(imageNode)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        self.checkCameraPermission()
    }
    
//    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        guard let renderer = renderer as? ARSCNView else {return}
//
//        deltaTime = time - lastUpdateTime
//
//        if deltaTime > 1 {
//            updatePlayersScreenPositions(renderer: renderer)
//            lastUpdateTime = time
//        }
//    }
    
    func updatePlayersScreenPositions(renderer: SCNSceneRenderer) {
        for player in gameController.players {
            
            let pos = player.node.position
            let pPoint = renderer.projectPoint(pos)
            let point = CGPoint(x: CGFloat(pPoint.x), y: CGFloat(pPoint.y))
            
            DispatchQueue.main.async {
                player.isOnScreen = self.view.frame.contains(point)
                
                if !player.isOnScreen{
                    guard let index = self.gameController.players.firstIndex(where: {$0.num == player.num}) else {return}
                   
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: index)], with: .none)
                }
            }
        }
    }
    
    func insertImage(image: UIImage, width: CGFloat = 0.05, height: CGFloat = 0.045) -> SCNNode {
        let plane = SCNPlane(width: width, height: height)
        plane.firstMaterial!.diffuse.contents = image
        
        let node = SCNNode(geometry: plane)
        let pos = node.position
        node.position = SCNVector3(pos.x, pos.y + 0.15, pos.z)
        node.constraints = [SCNBillboardConstraint()]
        return node
    }

}

