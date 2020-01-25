//
//  GameController.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 22/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import Foundation
import ARKit

class GameController {
    
    weak var delegate: GameControllerDelegate?
    
    var players: [Player] = []
    var smileFactor: CGFloat = 0.6
    var maxPlayers: Int = 3
    var isPlaying: Bool = false
    
    func orderPlayers() {
        players.sort { (player1, player2) -> Bool in
            player1.counter < player2.counter
        }
        
        delegate?.updatePlayerRanking()
    }
    
    func addCounter(player: Player) {
        player.counter += 1
        orderPlayers()
        
        delegate?.updateScoreLabel()
        delegate?.takeScreenshot()
    }
    
    func addPlayer(faceAnchor: ARFaceAnchor, node: SCNNode, geometry: ARSCNFaceGeometry) {
        if getPlayer(faceAnchor: faceAnchor) == nil && self.canAddPlayer() {
            let newPlayer = Player(faceAnchor: faceAnchor, node: node, geometry: geometry)
            players.append(newPlayer)
            delegate?.addScene()
        }
    }
    
    func canStart() -> Bool {
        return players.count > 0 ? true : false
    }
    
    func canAddPlayer() -> Bool {
        if players.count >= maxPlayers || isPlaying == true {
            return false
        }
        return true
    }
    
    func getPlayer(faceAnchor: ARFaceAnchor) -> Player? {
        let id = faceAnchor.identifier
        if let player = players.filter({$0.faceAnchor.identifier == id}).first {
            return player
        }
        else {
            return nil
        }
    }
    
    func handleSmile(faceAnchor: ARFaceAnchor) {
        if !isPlaying { return }
        
        guard let player = getPlayer(faceAnchor: faceAnchor) else {return}
        
        let smileValue = getSmileValue(faceAnchor: faceAnchor)
        let laughing = isLaughing(smileValue: smileValue)
        
        if laughing && !wasLaughing(player: player){
            player.status = .laughing
            addCounter(player: player)
        }
        else if !laughing {
            player.status = .normal
        }
    }
    
    func wasLaughing(player: Player) -> Bool {
        return player.status == .laughing ? true : false
    }
    
    func isLaughing(smileValue: CGFloat) -> Bool {
        if smileValue > smileFactor {
            return true
        }
        
        return false
    }
    
    func getSmileValue(faceAnchor: ARFaceAnchor) -> CGFloat {
        let leftValue = faceAnchor.blendShapes[.mouthSmileLeft] as! CGFloat
        let rightValue = faceAnchor.blendShapes[.mouthSmileRight] as! CGFloat
        
        return (leftValue + rightValue)/2.0
    }
    
}

protocol GameControllerDelegate: class {
    func addScene()
    func updateScoreLabel()
    func updatePlayerRanking()
    func takeScreenshot()
}
