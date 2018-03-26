//
//  BallNode.swift
//  Color Pong
//
//  Created by Marco Starker on 14.01.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class BallNode: SKSpriteNode {
    static let DIRECTION_LEFT = 0
    static let DIRECTION_RIGHT = 1
    static let TIMEING_DURATION = 4.0
    
    /* action to the right */
    var actionLeft: SKAction!
    
    /* action to the left */
    var actionRight: SKAction!
    
    /* circles */
    var circles: [ColorCircleNode]!
   
    /* current colorIndex */
    var colorIndex: ColorCircleNode.ColorIndex = ColorCircleNode.ColorIndex.red

    /* counter for every loop to calc the speed... see excel file */
    var counter: Int = 1;

    /* current direction */
    var direction: Int = BallNode.DIRECTION_RIGHT
    
    // get the hit sound
    var audioPlayer: AVAudioPlayer!
    
    /* constructor */
    convenience init(scene: GameScene, circles: [ColorCircleNode]) {
        self.init(imageNamed: "ball-0")
 
        // get the circle
        self.circles = circles
        let circle = self.circles[BallNode.DIRECTION_LEFT]
        
        // configure the ball
        self.xScale = 1
        self.yScale = 1
        self.size.width = circle.size.width / 5
        self.size.height = circle.size.height / 5
        self.position.x = circle.position.x + circle.size.width / 2 + self.size.width / 2
        self.position.y = circle.position.y
        self.zPosition = 20
        
        // define the actions
        self.actionRight = SKAction.group([
            SKAction.moveToX(CGFloat(scene.size.width - self.position.x), duration: BallNode.TIMEING_DURATION),
            SKAction.rotateByAngle(CGFloat(M_PI * BallNode.TIMEING_DURATION * -1), duration: BallNode.TIMEING_DURATION)
        ])

        self.actionLeft = SKAction.group([
            SKAction.moveToX(self.position.x, duration: BallNode.TIMEING_DURATION),
            SKAction.rotateByAngle(CGFloat(M_PI * BallNode.TIMEING_DURATION), duration: BallNode.TIMEING_DURATION)
        ])
        
        // append the audio player
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ball-hit-the-circle", ofType: "mp3")!))
            self.audioPlayer.prepareToPlay()
        } catch {
            print("Player not available")
        }
        
        // start
        self.setNewColor().updateCounter().startAction()
        
        // append ball to scene
        scene.addChild(self)
    }
    
    // set the new color to ball
    func setNewColor() -> BallNode {
        let circle = self.circles[self.direction]
        
        repeat{
            self.colorIndex = ColorCircleNode.ColorIndex(rawValue: Int(arc4random_uniform(UInt32(ColorCircleNode.ColorIndex.count.rawValue))))!
        } while (circle.isCurrentColorIndexSelected(self.colorIndex) == true)
        
        self.texture = SKTexture(imageNamed: "ball-" + String(self.colorIndex.rawValue))
        
        return self
    }
    
    // reset the counter to given value or default and set the speed to calc value
    func updateCounter(counter: Int = 1) -> BallNode {
        let switchAt = 15
        
        let forumlaFactorF1 = 125.0
        let formulaFactorF2 = 150.0
        let formulaFactorG2 = 250.0
        let formulaFactorH2 = 1.5
        
        self.counter = counter
        
        // initial values
        if (self.counter == 1) {
            self.speed = 1
        }
        // first calc... see excel file
        else if (self.counter <= switchAt) {
            self.speed = CGFloat(Double(self.speed) + Double(self.counter) / forumlaFactorF1)
        }
        // second calc... see excel file
        else {
            self.speed = CGFloat(pow(formulaFactorF2, Double(self.counter) / formulaFactorG2) * formulaFactorH2)
        }

        return self
    }
   
    // increase the counter by default 1 or more
    func increaseCounter() -> BallNode {
        return self.updateCounter(self.counter + 1)
    }
    
    // swaps the direction
    func swapDirection() -> BallNode {
        if (self.direction == BallNode.DIRECTION_LEFT) {
            self.direction = BallNode.DIRECTION_RIGHT
        } else {
            self.direction = BallNode.DIRECTION_LEFT
        }
        
        return self
    }
    
    // starts the action
    func startAction() -> BallNode {
        var action = self.actionLeft
        
        if (self.direction == BallNode.DIRECTION_RIGHT) {
            action = self.actionRight
        }
        
        self.runAction(action, completion: actionFinished)

        return self
    }
    
    // the action was finished
    func actionFinished() {
        let circle = self.circles[self.direction]
        let scene = self.scene as! GameScene
        
        // stop the sound
        self.audioPlayer.stop()

        // you lose... wrong color
        if (circle.isCurrentColorIndexSelected(self.colorIndex) == false) {
            scene.gameOver()
            return
        }
        
        // play the hit sound
        if (scene.controller.settingSoundEnabled == true) {
            self.audioPlayer.play()
        }
        
        // it is the same... change direction and color... increase the speed...
        self.swapDirection().setNewColor().increaseCounter().startAction()
        
        // add score
        scene.increaseScore()
    }
}