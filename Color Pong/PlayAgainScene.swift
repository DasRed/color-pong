import SpriteKit
import AVFoundation

class PlayAgainScene: BaseScene {
    // the score to show
    var score: Int!
    
    // the audio player
    var audioPlayer: AVAudioPlayer!
    
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
        
        // new game button button
        _ = ButtonBigNode(parent: spriteBackground, text: "Ja".localized, position: CGPoint(x: 375, y: 320), onTouch: {
            (button: ButtonBigNode) in
            self.controller.startNewGame()
        })
        
        // new game button button
        let buttonNo = ButtonBigNode(parent: spriteBackground, text: "Nein".localized, position: CGPoint(x: 375, y: 400), onTouch: {
            (button: ButtonBigNode) in
            self.controller.showMenu()
        })
        
        // Text
        let labelText = SKLabelNode(fontNamed: "Zorque")
        labelText.text = "Du hast %i Punkte! Nochmal spielen?".localized(self.score)
        labelText.fontSize = buttonNo.labelText.fontSize
        labelText.fontColor = GameViewController.textColor
        labelText.color = UIColor.blackColor()
        labelText.horizontalAlignmentMode = .Center
        labelText.verticalAlignmentMode = .Center
        labelText.xScale = 1
        labelText.yScale = 1
        labelText.position = CGPoint(x: 0, y: 75)
        labelText.zPosition = 40
        labelText.userInteractionEnabled = false
        spriteBackground.addChild(labelText)
        
        // append the audio player
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("game-over", ofType: "mp3")!))
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.stop()
            if (self.controller.settingSoundEnabled == true) {
                self.audioPlayer.play()
            }
        } catch {
            print("Player not available")
        }
    }
}
