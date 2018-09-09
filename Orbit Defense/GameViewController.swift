//
//  GameViewController.swift
//  Orbit Defense
//
//  Created by jason kim on 8/15/18.
//  Copyright © 2018 jason kim. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import GameKit
import GoogleMobileAds
import AudioToolbox

var scsize: CGSize = CGSize(width: 0, height: 0)

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GADBannerViewDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    //locks.integer(forKey: "hsstage"+String(stage)+"mission"+String(0))
    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "com.score.orbitdefense"
    
    
    let locks = UserDefaults.standard
    var bgSoundPlayer:AVAudioPlayer?
    
    // Ad banner and interstitial views
    var adMobBannerView = GADBannerView()
    //let ADMOB_BANNER_UNIT_ID = "ca-app-pub-7443781191929181/2173512984"
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-3940256099942544/6300978111" //test ad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.playBackgroundSound(_:)), name: NSNotification.Name(rawValue: "PlayBackgroundSound"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.stopBackgroundSound), name: NSNotification.Name(rawValue: "StopBackgroundSound"), object: nil) //add this to stop the audio
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.checkLeaderBoard), name: NSNotification.Name(rawValue: "checkLeaderBoard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.initAdMobBanner), name: NSNotification.Name(rawValue: "initAdMobBanner"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.deinitAdMobBanner), name: NSNotification.Name(rawValue: "deinitAdMobBanner"), object: nil)
        scsize = view.bounds.size
        
        // Init AdMob banner
        initAdMobBanner()
        
        
        let scene = MainMenu(size: view.bounds.size)
        let skView = view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        
        if(!locks.bool(forKey: "music"))
        {
            let dictToSend: [String: String] = ["fileToPlay": "pulsar" ]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: self, userInfo:dictToSend) //posts the notification
        }
        
        // Call the GC authentication controller
        authenticateLocalPlayer()
        
    }
    
    // MARK: -  ADMOB BANNER
    @objc func initAdMobBanner() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 320, height: 50)
        } else  {
            // iPad
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 468, height: 60))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 468, height: 60)
        }
        
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        adMobBannerView.load(request)
    }
    
    @objc func deinitAdMobBanner() {
        adMobBannerView.removeFromSuperview()
    }
    
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        hideBanner(adMobBannerView)
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print("error")
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print("error")
            }
        }
    }
    
    @objc func checkLeaderBoard(){
        // Submit score to GC leaderboard
        
        let bestScoreInt1 = GKScore(leaderboardIdentifier: "com.score.orbitdefense1")
        bestScoreInt1.value = Int64(locks.integer(forKey: "hsstage1mission0"))
        GKScore.report([bestScoreInt1]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
        let bestScoreInt2 = GKScore(leaderboardIdentifier: "com.score.orbitdefense2")
        bestScoreInt2.value = Int64(locks.integer(forKey: "hsstage2mission0"))
        GKScore.report([bestScoreInt2]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
        let bestScoreInt3 = GKScore(leaderboardIdentifier: "com.score.orbitdefense3")
        bestScoreInt3.value = Int64(locks.integer(forKey: "hsstage3mission0"))
        GKScore.report([bestScoreInt3]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
        let bestScoreInt4 = GKScore(leaderboardIdentifier: "com.score.orbitdefense4")
        bestScoreInt4.value = Int64(locks.integer(forKey: "hsstage4mission0"))
        GKScore.report([bestScoreInt4]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
        let maxscore = max(locks.integer(forKey: "hsstage1mission0"),locks.integer(forKey: "hsstage2mission0"),locks.integer(forKey: "hsstage3mission0"),locks.integer(forKey: "hsstage4mission0"))
        let combScoreInt = GKScore(leaderboardIdentifier: "com.score.orbitdefense")
        combScoreInt.value = Int64(maxscore)
        GKScore.report([combScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
        
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
    @objc func playBackgroundSound(_ notification: Notification) {
        
        //get the name of the file to play from the data passed in with the notification
        let name = (notification as NSNotification).userInfo!["fileToPlay"] as! String
        
        
        //if the bgSoundPlayer already exists, stop it and make it nil again
        if (bgSoundPlayer != nil){
            
            bgSoundPlayer!.stop()
            bgSoundPlayer = nil
            
            
        }
        
        //as long as name has at least some value, proceed...
        if (name != ""){
            
            //create a URL variable using the name variable and tacking on the "mp3" extension
            let fileURL:URL = Bundle.main.url(forResource:name, withExtension: "mp3")!
            
            //basically, try to initialize the bgSoundPlayer with the contents of the URL
            do {
                bgSoundPlayer = try AVAudioPlayer(contentsOf: fileURL)
            } catch _{
                bgSoundPlayer = nil
                
            }
            
            bgSoundPlayer!.volume = 0.75 //set the volume anywhere from 0 to 1
            bgSoundPlayer!.numberOfLoops = -1 // -1 makes the player loop forever
            bgSoundPlayer!.prepareToPlay() //prepare for playback by preloading its buffers.
            bgSoundPlayer!.play() //actually play
            
        }
        
        
    }
    
    @objc func stopBackgroundSound() {
        
        //if the bgSoundPlayer isn't nil, then stop it
        if (bgSoundPlayer != nil){
            
            bgSoundPlayer!.stop()
            bgSoundPlayer = nil
            
            
        }
        
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
