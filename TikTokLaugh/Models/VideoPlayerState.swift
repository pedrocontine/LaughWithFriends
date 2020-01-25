//
//  VideoPlayerState.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 23/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import Foundation

enum VideoPlayerState: CaseIterable {
    case unstarted
    case ended
    case playing
    case paused
    case buffering
    case videoCued
}
