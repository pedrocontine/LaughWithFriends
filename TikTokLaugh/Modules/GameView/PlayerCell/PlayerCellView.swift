//
//  PlayerCellView.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 27/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit

class PlayerCellView: UITableViewCell {

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var layerScore: UIView!
    @IBOutlet weak var blackBackground: UIView!
    @IBOutlet weak var medalLayer: UIView!
    @IBOutlet weak var rankingLayer: UIView!
    
    func setCell(player: Player, pos: Int) {
        let height = self.layerScore.bounds.height
        self.playerImage.image = player.image
        
        //self.blackBackground.alpha = updateImageAlpha(isOnScreen: player.isOnScreen)
        //self.rankingLayer.alpha = updateImageAlpha(isOnScreen: player.isOnScreen)
        
        self.score.text = "\(player.counter)"
        
        self.backgroundColor = .clear
        self.backgroundView = UIView()
        self.selectedBackgroundView = UIView()
        
        let layerHeight = self.blackBackground.frame.height
        self.blackBackground.layer.cornerRadius = layerHeight * 0.5
        
        self.layerScore.backgroundColor = getMedalColor(pos: pos)
        self.layerScore.layer.cornerRadius = height * 0.5
        self.medalLayer.layer.cornerRadius = height * 0.5
        self.medalLayer.backgroundColor = getMedalColor(pos: pos)
        
        let rankLayerHeight = self.rankingLayer.frame.height
        self.rankingLayer.layer.cornerRadius = rankLayerHeight * 0.5
        
        self.blackBackground.addShadow()
        self.medalLayer.addShadow()
        self.layerScore.addShadow()
    }
    
    func updateImageAlpha(isOnScreen: Bool) -> CGFloat {
        switch isOnScreen {
        case true:
            return 1
        case false:
            return 0.5
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
