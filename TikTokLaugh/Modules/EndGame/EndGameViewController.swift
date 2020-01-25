//
//  EndGameViewController.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 23/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var screenshotView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    var screenshot: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenshotView.image = screenshot
        roundButtons()
    }
    
    func roundButtons() {
        self.instagramButton.adjustsImageWhenHighlighted = false
        self.instagramButton.layer.cornerRadius = 30
        self.instagramButton.layer.masksToBounds = true
        
        self.shareButton.layer.cornerRadius = 30
        self.playAgainButton.layer.cornerRadius = 30
    }
    
    @IBAction func playAgainButtonPressed() {
        Haptic().heavy()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareInstagramStories() {
        Haptic().heavy()
        
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
        
        guard let image = screenshot else {return}

        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)

        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.print, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.mail,
            UIActivity.ActivityType.markupAsPDF]

        self.present(activityViewController, animated: true, completion: nil)
    }
}
