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
                  let playlist = self.createRandomPlaylist(records: records, count: 5) else {return}
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                self.playlist = playlist
                self.videoPlayer.load(withVideoId: playlist.first!, playerVars: self.videoConfigs())
            }
        }
    }
    
    func createRandomPlaylist(records: [CKRecord], count: Int) -> [String]? {
        guard var fullPlaylist = records.first?.object(forKey: "videosID") as? [String], count > 0 else {return nil}
        
        var randomPlaylist: [String] = []
        
        for _ in 0...(count - 1) {
            let index = Int.random(in: 0...fullPlaylist.count-1)
            randomPlaylist.append(fullPlaylist[index])
            fullPlaylist.remove(at: index)
        }
        
        return randomPlaylist
    }
    
    func videoConfigs() -> [String : Any] {
        return ["autoplay" : 1,
                "controls" : 1,
                "playsinline" : 1,
                "origin": "https://www.youtube.com",
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
            if interstitial.isReady {
              interstitial.present(fromRootViewController: self)
            }
        default:
            gameController.isPlaying = true
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        playerView.cuePlaylist(byVideos: self.playlist, index: 0, startSeconds: 0, suggestedQuality: .auto)
        playerView.playVideo()
    }
    
}

