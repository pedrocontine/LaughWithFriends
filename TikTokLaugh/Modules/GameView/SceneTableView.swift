//
//  SceneTableView.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 22/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        gameController.players.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! PlayerCellView
        
        let player = gameController.players[indexPath.section]
        cell.setCell(player: player, pos: indexPath.section + 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height
        return height * 0.2415
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let height = UIScreen.main.bounds.height
        let view = UIView(frame: CGRect(x: 0, y: 0, width: height * 0.282, height: 2.5))
        view.backgroundColor = .clear
        return view
    }
    
}
