//
//  MainMenu.swift
//  Orbit Defense
//
//  Created by jason kim on 8/16/18.
//  Copyright © 2018 jason kim. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class MainMenu: SKScene {
    
    
    override func didMove(to view: SKView) {
        // 1
        backgroundColor = SKColor.black
       
        // 3
        let title = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title.text = "GRAV ATTACK"
        title.fontSize = size.width/8
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: 0.8*size.height)
        addChild(title)
        
        let camButton: BDButton = {
            let button = BDButton(buttonText: "CAMPAIGN",screenWidth: scsize.width,buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = CampStageMenu(size: scsize)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 1
            return button
        }()
        camButton.position = CGPoint(x: size.width/2, y: 0.6*size.height)
        addChild(camButton)
        
        let arcButton: BDButton = {
            let button = BDButton(buttonText: "ARCADE", screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = ArcadeMenu(size: scsize)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 1
            return button
        }()
        arcButton.position = CGPoint(x: size.width/2, y: 0.5*size.height)
        addChild(arcButton)
        
        let setButton: BDButton = {
            let button = BDButton(buttonText: "SETTINGS", screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = Settings(size: scsize)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 1
            return button
        }()
        setButton.position = CGPoint(x: size.width/2, y: 0.4*size.height)
        addChild(setButton)
        
        let stars: SKEmitterNode = StarField.starfieldEmitterNode(width: scsize.width, height: scsize.height)
        addChild(stars)
        
        weak var scself = self
        let scoreButton: SpriteButton = {
            let button = SpriteButton(buttonImage: "score",buttonAction: {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "checkLeaderBoard"), object: scself)
            })
            button.zPosition = 1
            return button
        }()
        scoreButton.position = CGPoint(x: 0.9*size.width, y: 0.95*size.height)
        addChild(scoreButton)
        /*let backgroundMusic = SKAudioNode(fileNamed: "pulsar.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)*/

    }
    deinit {
        print("Deinit MainMenu")
    }


}
