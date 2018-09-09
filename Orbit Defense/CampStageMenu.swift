//
//  CampStageMenu.swift
//  Orbit Defense
//
//  Created by jason kim on 8/16/18.
//  Copyright © 2018 jason kim. All rights reserved.
//

import Foundation
import SpriteKit

class CampStageMenu: SKScene {
    let locks = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        // 1
        backgroundColor = SKColor.black

        // 3
        let title = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title.text = "CAMPAIGN: STAGE SELECT"
        title.fontSize = size.width/12
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: 0.85*size.height)
        addChild(title)
        
        // Buttons Below ******************
        let Button1: BDButton = {
            let button = BDButton(buttonText: "STAGE 1",screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = missionChooser(size: scsize,stag: 1)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 1
            return button
        }()
        
        let Button2: BDButton = {
            let button = BDButton(buttonText: "STAGE 2",screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = missionChooser(size: scsize,stag: 2)
                view.presentScene(scene, transition:reveal)
            }, enabled:locks.bool(forKey: "stage2"))
            button.zPosition = 1
            return button
        }()
        
        let Button3: BDButton = {
            let button = BDButton(buttonText: "STAGE 3",screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = missionChooser(size: scsize,stag: 3)
                view.presentScene(scene, transition:reveal)
            }, enabled:locks.bool(forKey: "stage3"))
            button.zPosition = 1
            return button
        }()
        
        let Button4: BDButton = {
            let button = BDButton(buttonText: "STAGE 4",screenWidth: scsize.width, buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = missionChooser(size: scsize,stag: 4)
                view.presentScene(scene, transition:reveal)
            }, enabled:locks.bool(forKey: "stage4"))
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
        Button1.position = CGPoint(x: size.width/2, y: 0.6*size.height)
        addChild(Button1)
        Button2.position = CGPoint(x: size.width/2, y: 0.5*size.height)
        addChild(Button2)
        Button3.position = CGPoint(x: size.width/2, y: 0.4*size.height)
        addChild(Button3)
        Button4.position = CGPoint(x: size.width/2, y: 0.3*size.height)
        addChild(Button4)
        backButton.position = CGPoint(x:size.width*0.075,y:0.95*size.height)
        addChild(backButton)
        
        let stars: SKEmitterNode = StarField.starfieldEmitterNode(width: scsize.width, height: scsize.height)
        addChild(stars)

        
    }
    deinit {
        print("Deinit Camp")
    }
    
    
}
