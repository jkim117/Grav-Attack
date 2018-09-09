//
//  ArcadeMenu.swift
//  Orbit Defense
//
//  Created by jason kim on 8/16/18.
//  Copyright © 2018 jason kim. All rights reserved.
//

import Foundation
import SpriteKit

class ArcadeMenu: SKScene {
    let locks = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        // 1
        backgroundColor = SKColor.black
        
        // 3
        let title = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title.text = "ARCADE: STAGE SELECT"
        title.fontSize = size.width/11
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: 0.85*size.height)
        addChild(title)
        
        //*Buttons****************
        let Button1: BDButton = {
            let button = BDButton(buttonText: "STAGE 1",screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = ArcadeScene(size: scsize, stagID: 1, newScore: 0, newTimer: 30)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 1
            return button
        }()
        
        let Button2: BDButton = {
            let button = BDButton(buttonText: "STAGE 2",screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = ArcadeScene(size: scsize, stagID: 2, newScore: 0, newTimer: 30)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 1
            return button
        }()
        
        let Button3: BDButton = {
            let button = BDButton(buttonText: "STAGE 3", screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = ArcadeScene(size: scsize, stagID: 3, newScore: 0, newTimer: 30)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 1
            return button
        }()
        
        let Button4: BDButton = {
            let button = BDButton(buttonText: "STAGE 4",screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = ArcadeScene(size: scsize, stagID: 4, newScore: 0, newTimer: 30)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 1
            return button
        }()
        
        let backButton: SpriteButton = {
            let button = SpriteButton(buttonImage: "back",buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.3)
                let scene = MainMenu(size: scsize)
                view.presentScene(scene, transition:reveal)
            })
            button.zPosition = 1
            return button
        }()
        //*End of Buttons**********************
        
        Button1.position = CGPoint(x: size.width/2, y: 0.6*size.height)
        addChild(Button1)
        let label1 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label1.text = String(format: "HIGHSCORE: %d", locks.integer(forKey: "hsstage1mission0"))
        label1.fontSize = size.width/27
        label1.position = CGPoint(x: size.width*0.8, y: 0.6*size.height-scsize.height/140)
        addChild(label1)
        
        Button2.position = CGPoint(x: size.width/2, y: 0.5*size.height)
        addChild(Button2)
        let label2 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label2.text = String(format: "HIGHSCORE: %d", locks.integer(forKey: "hsstage2mission0"))
        label2.fontSize = size.width/27
        label2.position = CGPoint(x: size.width*0.8, y: 0.5*size.height-scsize.height/140)
        addChild(label2)
        
        Button3.position = CGPoint(x: size.width/2, y: 0.4*size.height)
        addChild(Button3)
        let label3 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label3.text = String(format: "HIGHSCORE: %d", locks.integer(forKey: "hsstage3mission0"))
        label3.fontSize = size.width/27
        label3.position = CGPoint(x: size.width*0.8, y: 0.4*size.height-scsize.height/140)
        addChild(label3)
        
        Button4.position = CGPoint(x: size.width/2, y: 0.3*size.height)
        addChild(Button4)
        let label4 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label4.text = String(format: "HIGHSCORE: %d", locks.integer(forKey: "hsstage4mission0"))
        label4.fontSize = size.width/27
        label4.position = CGPoint(x: size.width*0.8, y: 0.3*size.height-scsize.height/140)
        addChild(label4)
        
        backButton.position = CGPoint(x:size.width*0.075,y:0.95*size.height)
        addChild(backButton)
        let stars: SKEmitterNode = StarField.starfieldEmitterNode(width: size.width, height: size.height)
        addChild(stars)
        
    }
    
    deinit {
        print("Deinit arcade")
    }
    
    
}
