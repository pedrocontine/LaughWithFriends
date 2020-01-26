//
//  ScoreCollectionViewCell.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 25/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit

class ScoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var score: UILabel!
    
    func setCell(player: Player) {
        self.score.text = "\(player.counter)"
        self.image.image = UIImage(named: "p\(player.num)_smile")
    }
    
}
