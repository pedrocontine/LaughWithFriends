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
    @IBOutlet weak var gameModeSegmented: UISegmentedControl!
    
    weak var delegate: GameStartMenuDelegate?
    
    var gameModeSelected: GameMode {
        get {
           return self.getGameModeSelected()
        }
    }
    
    fileprivate func getGameModeSelected() -> GameMode {
        switch gameModeSegmented.selectedSegmentIndex {
        case 0:
            return .laughCounter
        case 1:
            return .youLaughYouLose
        default:
            return .laughCounter
        }
    }

    @IBAction func startButtonPressed() {
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
        self.startButton.layer.cornerRadius = 60
        self.addSubview(contentView)
    }
        
}

protocol GameStartMenuDelegate: class {
    func startButtonPressed()
}
