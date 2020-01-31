//
//  Shadow.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 28/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 0.7
    }
}
