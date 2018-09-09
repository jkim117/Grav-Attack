//
//  Settings.swift
//  Orbit Defense
//
//  Created by jason kim on 8/21/18.
//  Copyright © 2018 jason kim. All rights reserved.
//

import Foundation
import SpriteKit

class Settings: SKScene {
    let locks = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        // 1
        backgroundColor = SKColor.black
        
        // 3
        let title = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title.text = "SETTINGS"
        title.fontSize = size.width/12
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: 0.85*size.height)
        addChild(title)
        
        weak var scself = self
        // Buttons Below ******************
        
        let ButtonMusic: BDButton = {
            let button = BDButton(buttonText: "TOGGLE MUSIC",screenWidth: scsize.width, buttonAction: {
                if(!(scself?.locks.bool(forKey: "music"))!){
                    scself?.locks.set(true, forKey: "music")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "StopBackgroundSound"), object: scself)
                }
                else{
                    scself?.locks.set(false, forKey: "music")
                    let dictToSend: [String: String] = ["fileToPlay": "pulsar" ]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: scself, userInfo:dictToSend) //posts the notification
                }
                
            }, enabled: true)
            button.zPosition = 1
            return button
        }()
        
        let skinButton: BDButton = {
            let button = BDButton(buttonText: "CHOOSE SHIP SKIN", screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = ShipSkin(size: scsize)
                view.presentScene(scene, transition:reveal)
                }, enabled: true)
            button.zPosition = 1
            return button
        }()
        
        /*let ButtonCredits: BDButton = {
            let button = BDButton(buttonText: "CREDITS",screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = missionChooser(size: scsize,stag: 4)
                view.presentScene(scene, transition:reveal)
            }, enabled:locks.bool(forKey: "stage4"))
            button.zPosition = 1
            return button
        }()*/
        
        let backButton: SpriteButton = {
            let button = SpriteButton(buttonImage: "back",buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.3)
                let scene = MainMenu(size: scsize)
                view.presentScene(scene, transition:reveal)
            })
            button.zPosition = 1
            return button
        }()
        ButtonMusic.position = CGPoint(x: size.width/2, y: 0.55*size.height)
        addChild(ButtonMusic)
        skinButton.position = CGPoint(x: size.width/2, y: 0.45*size.height)
        addChild(skinButton)
        //ButtonCredits.position = CGPoint(x: size.width/2, y: 0.5*size.height)
        //addChild(ButtonCredits)
        backButton.position = CGPoint(x:size.width*0.075,y:0.95*size.height)
        addChild(backButton)
        
        let stars: SKEmitterNode = StarField.starfieldEmitterNode(width: scsize.width, height: scsize.height)
        addChild(stars)
        
        
    }
    deinit {
        print("Deinit Settings")
    }
    
    
}
