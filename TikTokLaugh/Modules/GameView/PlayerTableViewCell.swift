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

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    
    func setCell(player: Player) {
        self.playerImage.image = player.image
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 30
        self.layer.masksToBounds = true
        
        self.scoreLabel.text = "\(player.counter)"
    }

}
