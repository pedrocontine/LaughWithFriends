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
import GoogleMobileAds
import AVKit

class GameViewController: UIViewController, GameControllerDelegate, GameStartMenuDelegate, GADInterstitialDelegate {
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var internetMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gameStartMenu: GameStartMenu!
    @IBOutlet weak var arSceneView: ARSCNView!
    @IBOutlet weak var videoPlayer: WKYTPlayerView!
    
    var boundsSize : CGSize!
    
    var interstitial: GADInterstitial!
    var gameController: GameController!
    var screenshot: UIImage?
    var deltaTime = TimeInterval()
    var lastUpdateTime = TimeInterval()
    
    var videosCount : Int = 5
    let moviePlayer = AVPlayerViewController()
    var playlist: [String] = []

    func initView() {
        gameController = GameController()
        gameController.delegate = self
        
        gameStartMenu.isHidden = false
        
        initARScene()
        initGameStartMenu()
        initInterstitial()
        
        tableView.reloadData()
    }
    
    func initGameStartMenu() {
        gameStartMenu.delegate = self
        gameStartMenu.sceneView.isPlaying = true
        gameStartMenu.sceneView.scene = arSceneView.scene
    }
    
    func checkCameraPermission() {
        switch (AVCaptureDevice.authorizationStatus(for: .video)){
        case .authorized:
            print("Authorize.")
        case .notDetermined, .restricted, .denied:
            let alert = CameraPermission().alertForPermission()
            self.present(alert, animated: true, completion: nil)
        @unknown default:
            print("Unknown status.")
        }
    }
    
    func initVideoPlayer() {
        videoPlayer.delegate = self
        
        if Reachability.isConnectedToNetwork(){
            refreshButton.isHidden = true
            loadVideos()
        }
        else {
            activityIndicator.stopAnimating()
            internetMessage.isHidden = false
            refreshButton.isHidden = false
        }
    }
    
    func initARScene() {
        arSceneView.delegate = self
        arSceneView.automaticallyUpdatesLighting = true
        
        let scene = SCNScene()
        arSceneView.scene = scene
        boundsSize = arSceneView.bounds.size
        
        verifyFaceTrackingAvailability()
    }
    
    func initInterstitial() {
        //interstitial = GADInterstitial(adUnitID: "ca-app-pub-4893647003110985/7489510343")
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        performSegue(withIdentifier: "showEndGame", sender: nil)
    }
    
    @IBAction func refreshButtonPressed() {
        initVideoPlayer()
    }
    
    func takeScreenshot() {
        DispatchQueue.main.async {
            self.arSceneView.isHidden = false
            self.screenshot = self.arSceneView.takeScreenshot()
            self.arSceneView.isHidden = true
        }
    }
    
    func startButtonPressed() {
        if gameController.canStart() {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            gameStartMenu.isHidden = true
            
            //Take first screenshot
            takeScreenshot()
            
            initVideoPlayer()
        }
        else {
            showNoPlayersMassage()
        }
    }
    
    func showNoPlayersMassage() {
        let alertController = UIAlertController(title: "No players!", message: "Move your camera to detect faces", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
       self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEndGame" {
            let vc = segue.destination as! EndGameViewController
            vc.screenshot = self.screenshot
            vc.players = self.gameController.players
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
    
    func verifyFaceTrackingAvailability() {
        guard ARFaceTrackingConfiguration.isSupported
            else {fatalError("Device does not support face tracking")}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "PlayerCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell2")
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

