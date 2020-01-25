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
        static var red = UIColor(displayP3Red: 206/255, green: 70/255, blue: 70/255, alpha: 1)
        static var blue = UIColor(displayP3Red: 70/255, green: 138/255, blue: 206/255, alpha: 1)
        static var green = UIColor(displayP3Red: 69/255, green: 208/255, blue: 138/255, alpha: 1)
    }
}

extension CGColor {
    struct Custom {
        static var buttonOrange = CGColor(srgbRed: 220/255, green: 139/255, blue: 70/255, alpha: 1)
    }
}
