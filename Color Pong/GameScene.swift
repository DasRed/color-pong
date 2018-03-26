//
//  GameScene.swift
//  Color Pong
//
//  Created by Marco Starker on 14.01.16.
//  Copyright (c) 2016 Marco Starker. All rights reserved.
//

import SpriteKit
import CoreData
import GameKit

class GameScene: BaseScene {
    
    /* current score */
    var score = 0
   
    /* the moving ball */
    var spriteBall: BallNode!
    
    /* the circles to rotate */
    var spriteCircles:[ColorCircleNode] = []
    
    /* score label */
    let labelScore = SKLabelNode(fontNamed: "Zorque")
   
    // starts everything
    override func didMoveToView(view: SKView) {
        // background
        let spriteBackground = SKSpriteNode(imageNamed: "background-game")
        spriteBackground.position.x = self.size.width / 2
        spriteBackground.position.y = self.size.height / 2
        spriteBackground.size.width = self.size.width
        spriteBackground.size.height = self.size.height
        spriteBackground.zPosition = 1
        spriteBackground.userInteractionEnabled = false
        self.addChild(spriteBackground)
 
        // menu button
        _ = ButtonSmallNode(parent: spriteBackground, icon: "menu-item-menu", position: CGPoint(x: 20, y: 10), onTouch: {
            (button: ButtonSmallNode) in
            for spriteCircle in self.spriteCircles {
                spriteCircle.stop()
            }
            self.controller.showMenu()
        })
        
        // music button
        _ = MusicButtonNode(parent: spriteBackground, controller: self.controller)
        
        // sound button
        _ = SoundButtonNode(parent: spriteBackground, controller: self.controller)
        
        // score button
        let score = ButtonBigNode(parent: spriteBackground, text: "Punkte".localized, position: CGPoint(x: 375, y: 10), onTouch: {
            (button: ButtonBigNode) in
        })
        score.userInteractionEnabled = false
        score.labelText.horizontalAlignmentMode = .Left
        score.labelText.position.x = -1 * (18 + score.size.width / 2)
        
        // score value
        self.labelScore.fontSize = score.labelText.fontSize
        self.labelScore.fontColor = GameViewController.textColor
        self.labelScore.color = UIColor.blackColor()
        self.labelScore.horizontalAlignmentMode = .Right
        self.labelScore.verticalAlignmentMode = .Center
        self.labelScore.xScale = 1
        self.labelScore.yScale = 1
        self.labelScore.position = CGPoint(x: 151, y: 0)
        self.labelScore.zPosition = 40
        self.labelScore.userInteractionEnabled = false
        score.addChild(self.labelScore)

        // create the circles
        self.spriteCircles.append(ColorCircleNode(scene: self, orientation: ColorCircleNode.Orientation.left))
        self.spriteCircles.append(ColorCircleNode(scene: self, orientation: ColorCircleNode.Orientation.right))
        
        // create the ball
        self.spriteBall = BallNode(scene: self, circles: self.spriteCircles)
        
        // update score
        self.updateScore()
    }

    // updates the score
    func updateScore(score: Int = 0) -> GameScene {
        self.score = score
        self.labelScore.text = String(self.score)
        
        return self
    }
    
    // increase the score
    func increaseScore() -> GameScene {
        return self.updateScore(self.score + 1)
    }

    // game is over...
    func gameOver() -> GameScene {
        // stop the circles
        for spriteCircle in self.spriteCircles {
            spriteCircle.stop()
        }
        
        // save score if score availabe
        if (self.score > 0) {
            self.saveScore(self.score)
        }
        
        // show play again
        self.controller.showPlayAgain(self.score)

        return self
    }
    
    // save a score
    func saveScore(score: Int) -> GameScene {
        self.controller.scores.append((Score(score: self.score)).save())
        EGC.reportScoreLeaderboard(leaderboardIdentifier: "World", score: score)
        
        return self
    }
}
