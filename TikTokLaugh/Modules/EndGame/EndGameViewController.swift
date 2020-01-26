//
//  EndGameViewController.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 23/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit
import ARKit

class EndGameViewController: UIViewController {

    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var screenshotView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionWidth: NSLayoutConstraint!
    @IBOutlet weak var bigScreenshot: UIView!
    
    var screenshot: UIImage?
    var players: [Player] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenshotView.image = screenshot
        roundButtons()
        applyCollectionDesign()
    }
    
    func applyCollectionDesign() {
        let width = UIScreen.main.bounds.width
        let height = self.collectionView.frame.height
        
        self.collectionWidth.constant = CGFloat(players.count) * width * 0.103
        self.collectionView.layer.cornerRadius = height * 0.3
        self.collectionView.layer.masksToBounds = true
        
        self.appIcon.layer.cornerRadius = height * 0.3
        self.appIcon.layer.masksToBounds = true
    }
    
    func roundButtons() {
        let height = self.instagramButton.frame.height
        self.instagramButton.adjustsImageWhenHighlighted = false
        self.instagramButton.layer.cornerRadius = height * 0.3
        self.instagramButton.layer.masksToBounds = true
        
        self.shareButton.layer.cornerRadius = height * 0.3
        self.playAgainButton.layer.cornerRadius = height * 0.3
    }
    
    @IBAction func playAgainButtonPressed() {
        Haptic().heavy()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareInstagramStories() {
        Haptic().heavy()
        
        screenshot = bigScreenshot.takeScreenshot()
        
        guard let image = screenshot,
              let urlScheme = URL(string: "instagram-stories://share"),
            UIApplication.shared.canOpenURL(urlScheme) else {return}

        let pasteboardItems = [["com.instagram.sharedSticker.backgroundImage": image]]
        let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]

        UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)

        UIApplication.shared.open(urlScheme)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        Haptic().heavy()
        
        screenshot = bigScreenshot.takeScreenshot()
        guard let image = screenshot else {return}

        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)

        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.print, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.mail,
            UIActivity.ActivityType.markupAsPDF]

        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension EndGameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ScoreCollectionViewCell
        
        cell.setCell(player: players[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        return CGSize(width: bounds.width * 0.089, height: bounds.height * 0.193)
    }
    
}
