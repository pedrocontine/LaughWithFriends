//
//  Colors.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 23/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    struct Custom {
        static var gold = UIColor(displayP3Red: 225/255, green: 173/255, blue: 61/255, alpha: 1)
        static var silver = UIColor(displayP3Red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        static var bronze = UIColor(displayP3Red: 209/255, green: 128/255, blue: 91/255, alpha: 1)
    }
}

extension CGColor {
    struct Custom {
        static var buttonOrange = CGColor(srgbRed: 220/255, green: 139/255, blue: 70/255, alpha: 1)
    }
}
