//
//  CameraPermission.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 25/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit

class CameraPermission {
    func alertForPermission() -> UIAlertController {
        
        let alertController = UIAlertController(title: "Can't use camera :(", message: "Please go to Settings and allow the app to use your camera!", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
             }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        return alertController
    }
}
