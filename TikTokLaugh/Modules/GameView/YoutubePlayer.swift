//
//  YoutubePlayer.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 21/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import Foundation
import XCDYouTubeKit
import CloudKit
import AVKit

extension GameViewController: AVPlayerViewControllerDelegate {
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        playNextVideo()
    }
    
    func playNextVideo() {
        if currentMovie < videosCount {
            playVideo(videoID: playlist[currentMovie])
        }
        //no more movies to display
        else {
            gameController.isPlaying = false
            
            CloudkitDAO().updateUserSeenMovies(newSeenMovie: self.playlist)

            if interstitial.isReady {
              interstitial.present(fromRootViewController: self)
            }
        }
    }
    
    func playVideo(videoID: String?) {
        XCDYouTubeClient.default().getVideoWithIdentifier(videoID) { (video, error) in
            guard let video = video, let url = self.createStreamURLs(video: video) else {return}
            self.moviePlayer.player = AVPlayer(url: url)
            self.moviePlayer.player?.play()
            self.gameController.isPlaying = true
            self.currentMovie += 1
        }
    }
    
    func createStreamURLs(video: XCDYouTubeVideo) -> URL? {
        if let streamURL = (video.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? video.streamURLs[YouTubeVideoQuality.hd720] ?? video.streamURLs[YouTubeVideoQuality.medium360] ?? video.streamURLs[YouTubeVideoQuality.small240]) {
            return streamURL
        }
        else {
            return nil
        }
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
            self.currentMovie = 0
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
    
}
