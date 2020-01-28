//
//  YoutubeVideoQuality.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 27/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import Foundation
import XCDYouTubeKit

struct YouTubeVideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}
