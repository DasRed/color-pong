//
//  ColorCircle.swift
//  Color Pong
//
//  Created by Marco Starker on 14.01.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class ColorCircleNode: SKSpriteNode {
    
    /* interval for touch timer */
    static let TIMER_INTERVAL = 0.025
    
    /* angle for rotation */
    static let ROTATION_ANGLE = 5.0
    
    /* color indexes */
    enum ColorIndex: Int {
        case red = 0
        case orange
        case yellow
        case green
        case turquoise
        case blue
        case violet
        case pink
        
        case count
    }
    
    /* struct for color range */
    private struct ColorRange {
        var index: ColorIndex
        var start: Double
        var end: Double
    }
    
    /* circle orientation */
    enum Orientation: Int {
        case left = 0
        case right = 1
    }
    
    /* ranges of all colors */
    private var colorRanges = [
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.orange,    start: -405.0, end: -360.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.yellow,    start: -360.0, end: -315.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.green,     start: -315.0, end: -270.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.turquoise, start: -270.0, end: -225.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.blue,      start: -225.0, end: -180.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.violet,    start: -180.0, end: -135.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.pink,      start: -135.0, end:  -90.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.red,       start:  -90.0, end:  -45.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.orange,    start:  -45.0, end:    0.0),
        
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.yellow,    start:    0.0, end:   45.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.green,     start:   45.0, end:   90.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.turquoise, start:   90.0, end:  135.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.blue,      start:  135.0, end:  180.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.violet,    start:  180.0, end:  225.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.pink,      start:  225.0, end:  270.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.red,       start:  270.0, end:  315.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.orange,    start:  315.0, end:  360.0),
        ColorCircleNode.ColorRange(index: ColorCircleNode.ColorIndex.orange,    start:  360.0, end:  405.0)
    ]
    
    /* current angle of color */
    var colorAngle: Double = 0
    
    /* current colorIndex */
    private var colorIndex: Int = 0
    
    /* which orientation? Left (=0) or right (=1) */
    var orientation: ColorCircleNode.Orientation = ColorCircleNode.Orientation.left
    
    /* point of touch location start */
    private var touchLocation: CGPoint?
    
    /* the timer */
    private var touchTimer: NSTimer?
    
    /* ranges for touch */
    private var touchRanges:[CGRect] = []
    
    /* constructor */
    convenience init(scene: GameScene, orientation: ColorCircleNode.Orientation = ColorCircleNode.Orientation.left) {
        self.init(imageNamed: "colorCircle")
        
        /* adding the circle */
        self.orientation = orientation
        self.colorIndex = orientation == ColorCircleNode.Orientation.left ? 0 : 4
        
        self.xScale = 1
        self.yScale = 1
        self.size.width = 200
        self.size.height = 200
        self.position.x = (
            orientation == ColorCircleNode.Orientation.left
                ? self.size.width / 2 + 40
                : scene.size.width - self.size.width / 2 - 40
        )
        
        self.position.y = scene.size.height / 2
        self.zPosition = 10
        self.zRotation = CGFloat(self.colorAngle * M_PI / 180)
        self.userInteractionEnabled = true
        
        scene.addChild(self)
        
        /* calculate the position for fast rotations */
        // split in percent part the half height
        let heightPart = CGFloat(((scene.size.height / 2) / 100.0))
        
        // 10%
        let h0 = 10 * heightPart
        let y0 = self.position.y - h0
        self.touchRanges.append(CGRect(x: self.position.x, y: y0, width: self.size.width / 2, height: h0))
        
        // 20%
        let h1 = 20 * heightPart
        let y1 = y0 - h1
        self.touchRanges.append(CGRect(x: self.position.x, y: y1, width: self.size.width / 2, height: h1))
        
        // 30%
        let h2 = 30 * heightPart
        let y2 = y1 - h2
        self.touchRanges.append(CGRect(x: self.position.x, y: y2, width: self.size.width / 2, height: h2))
        
        // 40%
        let h3 = 40 * heightPart
        let y3 = y2 - h3
        self.touchRanges.append(CGRect(x: self.position.x, y: y3, width: self.size.width / 2, height: h3))
    }
    
    // test if given color index is selected, overlapping angles will be also tested
    func isCurrentColorIndexSelected(colorIndex: ColorCircleNode.ColorIndex) -> Bool {
        let angle = (self.colorAngle + (self.orientation == ColorCircleNode.Orientation.left ? 0 : 180)) % 360.0
        
        for colorRange in self.colorRanges {
            // test index and angle range...
            if (colorRange.index == colorIndex && colorRange.start <= angle && angle <= colorRange.end) {
                return true
            }
        }
        
        return false
    }
    
    // set the angle
    private func setAngle(angle: Double) -> ColorCircleNode  {
        self.colorAngle = angle
        self.zRotation = CGFloat(angle * M_PI / 180)
        
        return self
    }
    
    // rotation to left
    private func rotateLeft() -> ColorCircleNode {
        return self.setAngle(self.colorAngle + ColorCircleNode.ROTATION_ANGLE * (self.orientation == ColorCircleNode.Orientation.left ? 1 : -1))
    }
    
    // rotation to right
    private func rotateRight() -> ColorCircleNode {
        return self.setAngle(self.colorAngle - ColorCircleNode.ROTATION_ANGLE * (self.orientation == ColorCircleNode.Orientation.left ? 1 : -1))
    }
    
    // calculate the next color direction by the touch events
    func calcNextColorByTouches()-> ColorCircleNode {
        if (self.touchLocation == nil) {
            return self
        }
        
        let position = self.scene!.size.height / 2 - abs(self.touchLocation!.y - self.scene!.size.height / 2)
        
        // find in which rect the point is
        for (var index, rect) in self.touchRanges.enumerate() {
            // found
            if (rect.origin.y <= position && position < rect.origin.y + rect.size.height) {
                // loop while index is greater zero ... thats count the rotations
                while (index > 0) {
                    if (self.touchLocation!.y > self.scene!.size.height / 2) {
                        self.rotateLeft()
                    }
                    else {
                        self.rotateRight()
                    }
                    index--
                }
                
                return self
            }
        }
        
        return self
    }
    
    // touch starts
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touchTimer = NSTimer.scheduledTimerWithTimeInterval(ColorCircleNode.TIMER_INTERVAL, target: self, selector: "calcNextColorByTouches", userInfo: nil, repeats: true)
    }
    
    // touch moved
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touchLocation = touches.first!.locationInNode(self.parent!)
    }
    
    // touch ended
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.touchLocation == nil) {
            self.touchLocation = touches.first!.locationInNode(self.parent!)
            for _ in 1...4 {
                if (self.touchLocation!.y > self.scene!.size.height / 2) {
                    self.rotateLeft()
                }
                else {
                    self.rotateRight()
                }
            }
        }
        
        self.stop()
    }
    
    // stops timer and co
    func stop()-> ColorCircleNode {
        if (self.touchTimer != nil) {
            self.touchTimer!.invalidate()
        }
        
        self.touchTimer = nil
        self.touchLocation = nil
        
        return self
    }
}