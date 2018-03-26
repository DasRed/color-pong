//
//  ColorCircle.swift
//  Color Pong
//
//  Created by Marco Starker on 14.01.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonBigNode: SKSpriteNode {
    // text
    var labelText: SKLabelNode = SKLabelNode(fontNamed: "Zorque")
    
    // callback
    private var onTouch: ((button: ButtonBigNode) -> Void)!
    
    /* constructor */
    convenience init(parent: SKNode, text: String, position: CGPoint, onTouch: (button: ButtonBigNode) -> Void) {
        self.init(imageNamed: "button-big-normal")
        
        self.onTouch = onTouch
        
        let sizeOfScreen = CGSize(width: parent.frame.width, height: 2 * 287)
        let scaleFactorY = sizeOfScreen.height / parent.frame.height
        
        self.xScale = scaleFactorY
        self.yScale = scaleFactorY
        self.size.width = 374 * scaleFactorY
        self.size.height = 69 * scaleFactorY
        self.position.x = -1.0 * sizeOfScreen.width / 2 + (position.x + self.size.width / 2)
        self.position.y = sizeOfScreen.height / 2 - (position.y * scaleFactorY + self.size.height / 2)
        self.zPosition = 40
        self.userInteractionEnabled = true
        
        parent.addChild(self)
        
        // Text
        self.labelText.fontSize = 36
        self.labelText.fontColor = GameViewController.textColor
        self.labelText.color = UIColor.blackColor()
        self.labelText.horizontalAlignmentMode = .Center
        self.labelText.verticalAlignmentMode = .Center
        self.labelText.xScale = 1
        self.labelText.yScale = 1
        self.labelText.position = CGPoint(x: 0, y: 0)
        self.labelText.zPosition = 40
        self.labelText.userInteractionEnabled = false
        self.addChild(self.labelText)
        
        self.setText(text)
    }
    
    // sets the icon
    func setText(text: String) -> ButtonBigNode {
        self.labelText.text = text
        
        return self
    }
    
    // touch starts
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.texture = SKTexture(imageNamed: "button-big-touched")
    }
    
    // touch ended
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.texture = SKTexture(imageNamed: "button-big-normal")
        
        self.onTouch(button: self)
    }
}