//
//  PlayerTableViewCell.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 22/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit
import ARKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func setCell(player: Player) {        
        self.sceneView.isPlaying = true
        self.sceneView.layer.borderWidth = 2
        self.sceneView.layer.borderColor = UIColor.white.cgColor
        self.sceneView.layer.cornerRadius = 20
        self.sceneView.layer.masksToBounds = true
        self.sceneView.scene = player.scene.scene
        self.scoreLabel.text = "\(player.counter)"
    }

}
