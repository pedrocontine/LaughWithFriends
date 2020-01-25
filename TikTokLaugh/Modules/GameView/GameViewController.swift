//
//  ViewController.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 20/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit
import ARKit
import YoutubePlayer_in_WKWebView

class GameViewController: UIViewController, GameControllerDelegate, GameStartMenuDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gameStartMenu: GameStartMenu!
    @IBOutlet weak var videoPlayer: WKYTPlayerView!
    @IBOutlet weak var arSceneView: ARSCNView!
    
    var boundsSize : CGSize!
    
    var gameController: GameController!

    func initView() {
        gameController = GameController()
        gameController.delegate = self
        
        gameStartMenu.isHidden = false
        
        initARScene()
        initVideoPlayer()
        initGameStartMenu()
        
        tableView.reloadData()
    }
    
    func initGameStartMenu() {
        gameStartMenu.delegate = self
        gameStartMenu.sceneView.isPlaying = true
        gameStartMenu.sceneView.scene = arSceneView.scene
    }
    
    func initVideoPlayer() {
        videoPlayer.delegate = self
        loadVideo()
    }
    
    func initARScene() {
        arSceneView.delegate = self
        arSceneView.automaticallyUpdatesLighting = true
        
        let scene = SCNScene()
        arSceneView.scene = scene
        boundsSize = arSceneView.bounds.size
        
        verifyFaceTrackingAvailability()
    }
    
    func startButtonPressed() {
        if gameController.canStart() {
            gameStartMenu.isHidden = true
            videoPlayer.playVideo()
        }
    }
    
    func updateScoreLabel() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updatePlayerRanking() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func addScene() {
        let index = gameController.players.count - 1
        let player = gameController.players[index]
        
        let sceneView = player.scene
        
        sceneView.scene = SCNScene(named: "ship.scn")

        let emptyNode = sceneView.scene?.rootNode.childNode(withName: "emptyNode", recursively: true)

        emptyNode?.geometry = player.node.geometry

        let color = getPlayerFaceColor(index: index)
        emptyNode?.geometry?.materials.first?.diffuse.contents = color
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func getPlayerFaceColor(index: Int) -> UIColor {
        switch index {
        case 0:
            return UIColor.PlayerFace.red
        case 1:
            return UIColor.PlayerFace.blue
        case 2:
            return UIColor.PlayerFace.green
        default:
            return .yellow
        }
    }
    
    func verifyFaceTrackingAvailability() {
        guard ARFaceTrackingConfiguration.isSupported
            else {fatalError("Device does not support face tracking")}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initView()
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.maximumNumberOfTrackedFaces = gameController.maxPlayers

        arSceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
        
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      arSceneView.session.pause()
    }
    
}

