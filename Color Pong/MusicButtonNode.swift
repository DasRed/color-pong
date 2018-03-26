//
//  MusicButtonNode.swift
//  Color Pong
//
//  Created by Marco Starker on 24.01.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class MusicButtonNode: ButtonSmallNode {
    
    // constructor
    convenience init(parent: SKNode, controller: GameViewController) {
        self.init(parent: parent, icon: "menu-item-music-" + String(Int(controller.settingMusicEnabled)), position: CGPoint(x: 952, y: 10), onTouch: {
            (button: ButtonSmallNode) in
            controller.settingMusicEnabled = !controller.settingMusicEnabled
            button.setIcon("menu-item-music-" + String(Int(controller.settingMusicEnabled)))
            
            if (controller.settingMusicEnabled == true) {
                controller.startMusic()
            }
            else {
                controller.stopMusic()
            }
        })
    }
}