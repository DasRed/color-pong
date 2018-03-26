//
//  MusicButtonNode.swift
//  Color Pong
//
//  Created by Marco Starker on 24.01.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class SoundButtonNode: ButtonSmallNode {
    
    // constructor
    convenience init(parent: SKNode, controller: GameViewController) {
        self.init(parent: parent, icon: "menu-item-sound-" + String(Int(controller.settingSoundEnabled)), position: CGPoint(x: 890, y: 10), onTouch: {
            (button: ButtonSmallNode) in
            controller.settingSoundEnabled = !controller.settingSoundEnabled
            button.setIcon("menu-item-sound-" + String(Int(controller.settingSoundEnabled)))
        })
    }
}