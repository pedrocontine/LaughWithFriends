//
//  YoutubePlayer.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 21/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import Foundation
import YoutubePlayer_in_WKWebView
import CloudKit

extension GameViewController: WKYTPlayerViewDelegate {
    
    func loadVideo() {
        self.getPlaylists { (records) in
            guard let records = records,
                  let playlist = records[0].object(forKey: "videosID") as? [String]
            else {return}
            
            let randomVideo = playlist.randomElement()!
            
            DispatchQueue.main.async {
                self.videoPlayer.load(withVideoId: randomVideo, playerVars: self.videoConfigs())
            }
        }
    }
    
    func videoConfigs() -> [String : Any] {
        return ["autoplay" : 0,
                "controls" : 0,
                "playsinline" : 1,
                "enablejsapi": 1,
                "iv_load_policy": 3,
                "modestbranding": 1,
                "rel": 0,
                "fs" : 0,
                "showinfo": 0]
    }
    
    func getPlaylists(completion: @escaping (_ records: [CKRecord]?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Playlist", predicate: predicate)
        
        let db = CKContainer.default().publicCloudDatabase
        let zone = CKRecordZone.default().zoneID
        
        db.perform(query, inZoneWith: zone) { (records, error) in
            if error != nil {
               completion(nil)
            }
            completion(records)
        }
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        switch state {
        case .buffering:
            gameController.isPlaying = false
        case .ended:
            gameController.isPlaying = false
            performSegue(withIdentifier: "showEndGame", sender: nil)
        default:
            gameController.isPlaying = true
        }
    }
    
}
