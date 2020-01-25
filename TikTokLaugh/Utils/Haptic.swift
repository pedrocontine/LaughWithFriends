//
//  Feedback.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 25/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit

public class Haptic {
    func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
