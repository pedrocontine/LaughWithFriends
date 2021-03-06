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
    var hasScreenshot: Bool = false
    
    func orderPlayers() {
        players.sort { (player1, player2) -> Bool in
            player1.counter < player2.counter
        }
        
        delegate?.updatePlayerRanking()
    }
    
    func addCounter(player: Player) {
        if !isPlaying { return }
        
        player.counter += 1
        orderPlayers()
        
        delegate?.updateScoreLabel()
        
        if !hasScreenshot {
            takeScreenshot()
        }
    }
    
    //take screenshot when everyone is laughing
    func takeScreenshot() {
        let laughingPlayers = players.filter({$0.status == .laughing})
    
        if laughingPlayers.count == players.count {
            hasScreenshot = true
            delegate?.takeScreenshot()
        }
    }
    
    func addPlayer(faceAnchor: ARFaceAnchor, node: SCNNode, geometry: ARSCNFaceGeometry) {
        if getPlayer(faceAnchor: faceAnchor) == nil && self.canAddPlayer() {
            let num = players.count + 1
            let newPlayer = Player(faceAnchor: faceAnchor, node: node, num: num)
            players.append(newPlayer)
        }
        
        delegate?.updatePlayerRanking()
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
        
        updatePlayerImage(player: player)
    }
    
    func updatePlayerImage(player: Player) {
        switch player.status {
        case .laughing:
            player.image = UIImage(named: "p\(player.num)_smile")!
        case .normal:
            player.image = UIImage(named: "p\(player.num)_normal")!
        }
        delegate?.updatePlayerRanking()
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
    func updateScoreLabel()
    func updatePlayerRanking()
    func takeScreenshot()
}
