//
//  ScoreCollectionViewCell.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 25/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit

class ScoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var crown: UIImageView!
    @IBOutlet weak var medalLayer: UIView!
    @IBOutlet weak var blackBackground: UIView!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var layerScore: UIView!
    
    func setCell(player: Player, pos: Int) {
        let height = self.layerScore.bounds.height
        self.playerImage.image = player.image
        self.score.text = "\(player.counter)"
        
        self.backgroundColor = .clear
        self.backgroundView = UIView()
        self.selectedBackgroundView = UIView()
        
        let layerHeight = self.blackBackground.frame.height
        self.blackBackground.layer.cornerRadius = layerHeight * 0.5
        
        self.layerScore.backgroundColor = getMedalColor(pos: pos)
        self.layerScore.layer.cornerRadius = height * 0.5
        
        let medalHeight = self.medalLayer.frame.height
        self.medalLayer.layer.cornerRadius = medalHeight * 0.5
        //self.medalLayer.backgroundColor = getMedalColor(pos: pos)
        
        self.blackBackground.addShadow()
        self.medalLayer.addShadow()
        self.layerScore.addShadow()
        
        if pos == 1 {
            self.crown.isHidden = false
        } else {
            self.crown.isHidden = true
        }
    }
    
    func getMedalColor(pos: Int) -> UIColor {
        switch pos {
        case 1:
            return UIColor.Custom.gold
        case 2:
            return UIColor.Custom.silver
        case 3:
            return UIColor.Custom.bronze
        default:
            return .white
        }
    }
    
}
