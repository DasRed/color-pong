import SpriteKit

class ScoreScene: BaseScene {

    // starts everything
    override func didMoveToView(view: SKView) {
        // background
        let spriteBackground = SKSpriteNode(imageNamed: "background-menu")
        spriteBackground.position.x = self.size.width / 2
        spriteBackground.position.y = self.size.height / 2
        spriteBackground.size.width = self.size.width
        spriteBackground.size.height = self.size.height
        spriteBackground.zPosition = 1
        spriteBackground.userInteractionEnabled = false
        self.addChild(spriteBackground)
        
        // music button
        _ = MusicButtonNode(parent: spriteBackground, controller: self.controller)
        
        // sound button
        _ = SoundButtonNode(parent: spriteBackground, controller: self.controller)
        
        // menu button
        _ = ButtonSmallNode(parent: spriteBackground, icon: "menu-item-menu", position: CGPoint(x: 20, y: 10), onTouch: {
            (button: ButtonSmallNode) in
            self.controller.showMenu()
        })

        // label settings
        let fontSizeTitles = CGFloat(44)
        let fontSizeValues = CGFloat(34)
        let offsetYTitles = 80
        let offsetYValues = 30
        let deltaY = 50
        
        // Text Date
        let labelDateText = SKLabelNode(fontNamed: "Zorque")
        labelDateText.text = "Datum".localized
        labelDateText.fontSize = fontSizeTitles
        labelDateText.fontColor = GameViewController.textColor
        labelDateText.color = UIColor.blackColor()
        labelDateText.horizontalAlignmentMode = .Right
        labelDateText.verticalAlignmentMode = .Center
        labelDateText.xScale = 1
        labelDateText.yScale = 1
        labelDateText.position = CGPoint(x: -10, y: offsetYTitles)
        labelDateText.zPosition = 40
        labelDateText.userInteractionEnabled = false
        spriteBackground.addChild(labelDateText)
        
        // Score
        let labelScoreText = SKLabelNode(fontNamed: "Zorque")
        labelScoreText.text = "Punkte".localized
        labelScoreText.fontSize = fontSizeTitles
        labelScoreText.fontColor = GameViewController.textColor
        labelScoreText.color = UIColor.blackColor()
        labelScoreText.horizontalAlignmentMode = .Left
        labelScoreText.verticalAlignmentMode = .Center
        labelScoreText.xScale = 1
        labelScoreText.yScale = 1
        labelScoreText.position = CGPoint(x: 10, y: offsetYTitles)
        labelScoreText.zPosition = 40
        labelScoreText.userInteractionEnabled = false
        spriteBackground.addChild(labelScoreText)
        
        // date formatter
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        formatter.locale = NSLocale.currentLocale()
        
        // render the values
        for (index, score) in self.controller.scores.collection.enumerate() {
            if (index > 2) {
                break
            }
            
            // Value Date
            let labelDateValue = SKLabelNode(fontNamed: "Zorque")
            labelDateValue.text = formatter.stringFromDate(score.date)
            labelDateValue.fontSize = fontSizeValues
            labelDateValue.fontColor = GameViewController.textColor
            labelDateValue.color = UIColor.blackColor()
            labelDateValue.horizontalAlignmentMode = .Right
            labelDateValue.verticalAlignmentMode = .Center
            labelDateValue.xScale = 1
            labelDateValue.yScale = 1
            labelDateValue.position = CGPoint(x: -10, y: offsetYValues + (-1 * index * deltaY))
            labelDateValue.zPosition = 40
            labelDateValue.userInteractionEnabled = false
            spriteBackground.addChild(labelDateValue)
           
            // Score
            let labelScoreValue = SKLabelNode(fontNamed: "Zorque")
            labelScoreValue.text = String(score.score)
            labelScoreValue.fontSize = fontSizeValues
            labelScoreValue.fontColor = GameViewController.textColor
            labelScoreValue.color = UIColor.blackColor()
            labelScoreValue.horizontalAlignmentMode = .Left
            labelScoreValue.verticalAlignmentMode = .Center
            labelScoreValue.xScale = 1
            labelScoreValue.yScale = 1
            labelScoreValue.position = CGPoint(x: 10, y: offsetYValues + (-1 * index * deltaY))
            labelScoreValue.zPosition = 40
            labelScoreValue.userInteractionEnabled = false
            spriteBackground.addChild(labelScoreValue)
        }
    }
}
