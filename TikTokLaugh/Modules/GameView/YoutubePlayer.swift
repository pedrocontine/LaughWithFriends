//
//  YoutubePlayer.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 21/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import Foundation
import CloudKit
import AVKit
import YoutubePlayer_in_WKWebView

extension GameViewController: WKYTPlayerViewDelegate {
    
    func playVideo(videoID: String?) {
        guard let id = videoID else {return}
        self.videoPlayer.load(withVideoId: id, playerVars: self.videoConfigs())
        self.activityIndicator.stopAnimating()
    }
    
    func loadVideos() {
        CloudkitDAO().getUnseenMovies { (movies) in
            if movies.count >= self.videosCount {
                self.loadPlaylist(playlist: movies)
            }
            else {
                CloudkitDAO().getAllMoviescompletion { (movies) in
                   self.loadPlaylist(playlist: movies)
                }
            }
        }
    }
    
    func loadPlaylist(playlist: [String]) {
        guard let playlist = self.createRandomPlaylist(playlist: playlist, count: self.videosCount) else {return}
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.playlist = playlist
            self.playVideo(videoID: playlist.first)
        }
    }
    
    func createRandomPlaylist(playlist: [String], count: Int) -> [String]? {
        if count < 0 {return nil}
        
        var movies = playlist
        var randomPlaylist: [String] = []
        
        for _ in 0...(count - 1) {
            let index = Int.random(in: 0...movies.count-1)
            randomPlaylist.append(movies[index])
            movies.remove(at: index)
        }
        
        return randomPlaylist
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
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: WKYTPlayerView) -> UIColor {
        return .black
    }
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        playerView.cuePlaylist(byVideos: self.playlist, index: 0, startSeconds: 0, suggestedQuality: .small)
        playerView.playVideo()
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        switch state {
        case .buffering:
            gameController.isPlaying = false
        case .ended:
            gameController.isPlaying = false
            
            CloudkitDAO().updateUserSeenMovies(newSeenMovie: self.playlist)
            
            if interstitial.isReady {
              interstitial.present(fromRootViewController: self)
            }
            
        default:
            gameController.isPlaying = true
        }
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
    
    
}

