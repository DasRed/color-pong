import SpriteKit

class MenuScene: BaseScene {
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

        let btnYStart = 230
        let btnYDelta = 80
        
        // new game button
        _ = ButtonBigNode(parent: spriteBackground, text: "Neues Spiel".localized, position: CGPoint(x: 375, y: btnYStart + 0 * btnYDelta), onTouch: {
            (button: ButtonBigNode) in
            self.controller.startNewGame()
        })
        
        // score button
        _ = ButtonBigNode(parent: spriteBackground, text: "Punkte (Plural)".localized, position: CGPoint(x: 375, y: btnYStart + 1 * btnYDelta), onTouch: {
            (button: ButtonBigNode) in
            self.controller.showScoreList()
        })
        
        // gaem center button
        _ = ButtonBigNode(parent: spriteBackground, text: "Game Center".localized, position: CGPoint(x: 375, y: btnYStart + 2 * btnYDelta), onTouch: {
            (button: ButtonBigNode) in
            EGC.showGameCenterLeaderboard(leaderboardIdentifier: "WorldRanking")
        })
        
        // buy remove add button
        if (self.controller.settingAdEnabled == true) {
            let buttonBuy = ButtonBigNode(parent: spriteBackground, text: "keine Werbung".localized, position: CGPoint(x: 225, y: btnYStart + 3 * btnYDelta), onTouch: {
                (button: ButtonBigNode) in
                self.controller.store.get(Store.Product.Identifier.removeAd).buy()
            })
            buttonBuy.labelText.fontSize = 20

            let buttonRestoreBuy = ButtonBigNode(parent: spriteBackground, text: "Einkäufe wiederherstellen".localized, position: CGPoint(x: 525, y: btnYStart + 3 * btnYDelta), onTouch: {
                (button: ButtonBigNode) in
                self.controller.store.restoreAll()
            })
            buttonRestoreBuy.labelText.fontSize = 20
        }

        // music button
        _ = MusicButtonNode(parent: spriteBackground, controller: self.controller)
        
        // sound button
        _ = SoundButtonNode(parent: spriteBackground, controller: self.controller)
     }
}
