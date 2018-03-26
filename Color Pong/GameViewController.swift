//
//  GameViewController.swift
//  Color Pong
//
//  Created by Marco Starker on 14.01.16.
//  Copyright (c) 2016 Marco Starker. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData
import AVFoundation
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate, StoreDelegate {
    
    // google Ad Banner Id
    static let AD_BANNER_ID = "ca-app-pub-3926977073039595/5005623062"
    
    // the default text color
    static let textColor = UIColor(red: 254 / 255, green: 57 / 255, blue: 12 / 255, alpha: 1.0)
    
    // banner view
    var bannerView: GADBannerView?
    
    // current scene
    var currentScene: BaseScene!
    
    // the skView
    var skView: SKView!
    
    // scorelist
    var scores = Scores()
    
    // Store
    var store: Store!
    
    // the settings
    private let settings: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    // the audio player
    var audioPlayer: AVAudioPlayer!
    
    // setting for music enabled or not
    var settingMusicEnabled: Bool {
        get {
            if (self.settings.objectForKey("music.enabled") == nil) {
                return true
            }
            
            return self.settings.boolForKey("music.enabled")
        }
        set(state) {
            self.settings.setBool(state, forKey: "music.enabled")
        }
    }
    
    // setting for sound enabled or not
    var settingSoundEnabled: Bool {
        get {
            if (self.settings.objectForKey("sound.enabled") == nil) {
                return true
            }
            
            return self.settings.boolForKey("sound.enabled")
        }
        set(state) {
            self.settings.setBool(state, forKey: "sound.enabled")
        }
    }

    // setting for add enabled or not
    var settingAdEnabled: Bool {
        get {
            if (self.settings.objectForKey("ad.enabled") == nil) {
                return true
            }
            
            return self.settings.boolForKey("ad.enabled")
        }
        set(state) {
            let previousState = self.settingAdEnabled
            
            self.settings.setBool(state, forKey: "ad.enabled")
            
            // remove ad banner
            if (previousState == true && state == false) {
                self.removeAdBanner()
            }
                // add ad banner
            else if (previousState == false && state == true) {
                self.appendAdBanner()
            }
        }
    }
   
    // view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.store = Store(controller: self, delegate: self)
        
        EGC.sharedInstance(self)
        
        #if DEBUG
            // If you want see message debug
            EGC.debugMode = true
        #else
            EGC.debugMode = false
        #endif
        
        // configure the AD
        self.appendAdBanner()
        
        // Configure the view.
        self.skView = self.view as! SKView
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.skView.ignoresSiblingOrder = true

        self.startMusic()
        
        self.showMenu()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // starts a game
    func startNewGame() -> GameViewController {
        return self.updateCurrentScene(GameScene(fileNamed:"BaseScene")!)
    }
    
    // shows the score lsit
    func showScoreList() -> GameViewController {
        return self.updateCurrentScene(ScoreScene(fileNamed:"BaseScene")!)
    }
    
    // shows the main menu
    func showMenu() -> GameViewController {
        return self.updateCurrentScene(MenuScene(fileNamed:"BaseScene")!)
    }
    
    // shows the play again
    func showPlayAgain(score: Int) -> GameViewController {
        let scene = PlayAgainScene(fileNamed: "BaseScene")!
        scene.score = score
        return self.updateCurrentScene(scene)
    }

    // set current
    func updateCurrentScene(scene: BaseScene) -> GameViewController {
        self.removeCurrentScene()
        
        self.currentScene = scene
        self.currentScene.controller = self
        self.currentScene.scaleMode = .AspectFill
        self.skView.presentScene(self.currentScene)
        
        return self
    }

    // remove current
    func removeCurrentScene() -> GameViewController {
        if (self.currentScene != nil) {
            self.currentScene.removeFromParent()
        }
        
        return self
    }
    
    // start the music
    func startMusic() -> GameViewController {
        // append the audio player
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("background", ofType: "mp3")!))
            self.audioPlayer.volume = 0.7
            self.audioPlayer.numberOfLoops = -1
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.stop()
            if (self.settingMusicEnabled == true) {
                self.audioPlayer.play()
            }
        } catch {
            print("Player not available")
        }
        
        return self
    }
    
    // stop the music
    func stopMusic() -> GameViewController {
        self.audioPlayer.stop()
        
        return self
    }
    
    // append the ad banner
    func appendAdBanner() -> GameViewController {
        if (self.settingAdEnabled == false || self.bannerView != nil) {
            NSLog("AdBanner call: Can not add: Setting: %i    HasBanner: %i", Int(self.settingAdEnabled), Int(self.bannerView != nil))
            return self
        }
        
        NSLog("AdBanner starts")

        let request = GADRequest()
        
        #if DEBUG
            request.testDevices = [kGADSimulatorID]
        #endif
        
        var position = CGPoint()
        position.x = self.view.frame.size.width / 2 - kGADAdSizeBanner.size.width / 2
        position.y = self.view.frame.size.height - kGADAdSizeBanner.size.height
        
        let banner = GADBannerView(adSize: kGADAdSizeBanner, origin: position)
        banner.adUnitID = GameViewController.AD_BANNER_ID
        banner.rootViewController = self
        banner.loadRequest(request)
        banner.delegate = self
        banner.hidden = true
        self.view.addSubview(banner)
        self.bannerView = banner
        
       return self
    }
    
    /// Tells the delegate that an ad request successfully received an ad. The delegate may want to add
    /// the banner view to the view hierarchy if it hasn't been added yet.
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        bannerView.hidden = false
    }
    
    /// Tells the delegate that an ad request failed. The failure is normally due to network
    /// connectivity or ad availablility (i.e., no fill).
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        bannerView.hidden = true
        NSLog("adView. didFailToReceiveAdWithError: %@", error.description)
    }
    
    /// Tells the delegate that a full screen view will be presented in response to the user clicking on
    /// an ad. The delegate may want to pause animations and time sensitive interactions.
    func adViewWillPresentScreen(bannerView: GADBannerView!) {
        self.currentScene.paused = true
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(bannerView: GADBannerView!) {}
    
    /// Tells the delegate that the full screen view has been dismissed. The delegate should restart
    /// anything paused while handling adViewWillPresentScreen:.
    func adViewDidDismissScreen(bannerView: GADBannerView!) {
        self.currentScene.paused = false
    }
    
    /// Tells the delegate that the user click will open another app, backgrounding the current
    /// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
    /// are called immediately before this method is called.
    func adViewWillLeaveApplication(bannerView: GADBannerView!) {}
    
    // remove the ad banner
    func removeAdBanner() -> GameViewController {
        if (self.settingAdEnabled == true || self.bannerView == nil) {
            return self
        }
        
        self.bannerView!.removeFromSuperview()
        self.bannerView = nil
        
        return self
    }
    
    // a store product was buyed
    func productWasBuyed(product: Store.Product) {
        if (product.identifier == Store.Product.Identifier.removeAd) {
            self.settingAdEnabled = false
            self.showMenu()
        }
    }
}
