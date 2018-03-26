//
//  ColorCircle.swift
//  Color Pong
//
//  Created by Marco Starker on 14.01.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonSmallNode: SKSpriteNode {
    // icon
    let icon: SKSpriteNode = SKSpriteNode()
    
    // callback
    private var onTouch: ((button: ButtonSmallNode) -> Void)!
    
    /* constructor */
    convenience init(parent: SKNode, icon: String, position: CGPoint, onTouch: (button: ButtonSmallNode) -> Void) {
        self.init(imageNamed: "button-small-normal")
        
        self.onTouch = onTouch
        
        let sizeOfScreen = CGSize(width: parent.frame.width, height: 2 * 287)
        let scaleFactorY = sizeOfScreen.height / parent.frame.height
        
        self.xScale = scaleFactorY
        self.yScale = scaleFactorY
        self.size.width = 71 * scaleFactorY
        self.size.height = 69 * scaleFactorY
        self.position.x = -1.0 * sizeOfScreen.width / 2 + (position.x + self.size.width / 2)
        self.position.y = sizeOfScreen.height / 2 - (position.y * scaleFactorY + self.size.height / 2)
        self.zPosition = 40
        self.userInteractionEnabled = true

        parent.addChild(self)
        
        // Icon
        self.icon.xScale = 1
        self.icon.yScale = 1
        self.icon.position = CGPoint(x: 0, y: 0)
        self.icon.size.width = 24
        self.icon.size.height = 24
        self.icon.zPosition = 40
        self.icon.userInteractionEnabled = false
        self.addChild(self.icon)

        self.setIcon(icon)
    }

    // sets the icon
    func setIcon(icon: String) -> ButtonSmallNode {
        self.icon.texture = SKTexture(imageNamed: icon)

        return self
    }
    
    // touch starts
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.texture = SKTexture(imageNamed: "button-small-touched")
    }
    
    // touch ended
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.texture = SKTexture(imageNamed: "button-small-normal")
        
        self.onTouch(button: self)
    }
}