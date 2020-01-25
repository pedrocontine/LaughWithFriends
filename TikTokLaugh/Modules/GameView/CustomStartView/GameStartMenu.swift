//
//  GameStartMenu.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 23/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit
import ARKit

class GameStartMenu: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var startButton: UIButton!
    
    weak var delegate: GameStartMenuDelegate?

    @IBAction func startButtonPressed() {
        Haptic().heavy()
        delegate?.startButtonPressed()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { 
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GameStartMenu", owner: self, options: nil)
        self.startButton.layer.cornerRadius = 30
        self.addSubview(contentView)
    }
        
}

protocol GameStartMenuDelegate: class {
    func startButtonPressed()
}
