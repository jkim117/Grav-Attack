//
//  ShipSkin.swift
//  Grav Attack
//
//  Created by jason kim on 8/28/18.
//  Copyright © 2018 jason kim. All rights reserved.
//

import Foundation
import SpriteKit

class ShipSkin: SKScene {
    let locks = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        // 1
        backgroundColor = SKColor.black
        
        // 3
        let title = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title.text = "SHIP SKINS"
        title.fontSize = size.width/12
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: 0.85*size.height)
        addChild(title)
        
        let choose1 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        choose1.text = "CURRENT CHOICE: UECA BATTLE STATION"
        choose1.fontSize = size.width/20
        choose1.fontColor = SKColor.white
        choose1.position = CGPoint(x: size.width/2, y: 0.8*size.height)
        choose1.alpha = 0.0
        addChild(choose1)
        let choose2 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        choose2.text = "CURRENT CHOICE: ALIEN STARFIGHTER"
        choose2.fontSize = size.width/20
        choose2.fontColor = SKColor.white
        choose2.position = CGPoint(x: size.width/2, y: 0.8*size.height)
        choose2.alpha = 0.0
        addChild(choose2)
        let choose3 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        choose3.text = "CURRENT CHOICE: LEGENDARY"
        choose3.fontSize = size.width/20
        choose3.fontColor = SKColor.white
        choose3.position = CGPoint(x: size.width/2, y: 0.8*size.height)
        choose3.alpha = 0.0
        addChild(choose3)
        
        if(locks.integer(forKey: "shipchoice")==0){
            choose1.alpha = 1
        }
        else if(locks.integer(forKey: "shipchoice")==1){
            choose2.alpha = 1
        }
        else if(locks.integer(forKey: "shipchoice")==2){
            choose3.alpha = 1
        }
        
        //Checking ship locks:
        if(!locks.bool(forKey: "ship2")){
            var check = true
            for i in 1...4{
                for j in 1...5{
                    if locks.integer(forKey: "hsstage"+String(i)+"mission"+String(j)) == 100{
                        continue
                    }
                    else{
                        check = false
                        break
                    }
                }
                if(!check){
                    break
                }
            }
            if (check){
                locks.set(true,forKey: "ship2")
            }
        }
        
        if(!locks.bool(forKey: "ship3")){
            var check = true
            for i in 1...4{
                if locks.integer(forKey: "hsstage"+String(i)+"mission0") >= 500{
                    continue
                }
                else{
                    check = false
                    break
                }
            }
            if(check){
                locks.set(true,forKey:"ship3")
            }
        }
        
        weak var scself = self
        // Buttons Below ******************
        let ship1Button: BDButton = {
            let button = BDButton(buttonText: "UECA STATION", screenWidth: scsize.width, buttonAction: {
                scself?.locks.set(0, forKey: "shipchoice")
                choose2.alpha = 0.0
                choose3.alpha = 0.0
                choose1.alpha = 1.0
            }, enabled: true)
            button.zPosition = 1
            return button
        }()
        
        let ship2Button: BDButton = {
            let button = BDButton(buttonText: "ALIEN STARFIGHTER", screenWidth: scsize.width, buttonAction: {
                scself?.locks.set(1, forKey: "shipchoice")
                choose2.alpha = 1.0
                choose3.alpha = 0.0
                choose1.alpha = 0.0
            }, enabled: locks.bool(forKey: "ship2"))
            button.zPosition = 1
            return button
        }()
        
        let ship3Button: BDButton = {
            let button = BDButton(buttonText: "LEGENDARY", screenWidth: scsize.width, buttonAction: {
                scself?.locks.set(2, forKey: "shipchoice")
                choose2.alpha = 0.0
                choose3.alpha = 1.0
                choose1.alpha = 0.0
            }, enabled: locks.bool(forKey: "ship3"))
            button.zPosition = 1
            return button
        }()

        
        let backButton: SpriteButton = {
            let button = SpriteButton(buttonImage: "back",buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.3)
                let scene = Settings(size: scsize)
                view.presentScene(scene, transition:reveal)
            })
            button.zPosition = 1
            return button
        }()
        
        ship1Button.position = CGPoint(x:size.width*0.25,y:0.6*size.height)
        ship2Button.position = CGPoint(x:size.width*0.25,y:0.4*size.height)
        ship3Button.position = CGPoint(x:size.width*0.25,y:0.2*size.height)
        addChild(ship1Button)
        addChild(ship2Button)
        addChild(ship3Button)
        
        let player1 = SKSpriteNode(imageNamed: "ship") //player1 node
        player1.size = CGSize(width: size.width/4, height: size.width/5.33)
        player1.position = CGPoint(x: size.width * 0.25, y: size.height * 0.7)
        addChild(player1)
        
        let player2 = SKSpriteNode(imageNamed: "ship2")
        let oldsize2 = player2.size
        player2.size = CGSize(width: size.width/4, height: size.width/5.33)
        let coolship2 = SKEmitterNode()
        coolship2.particleTexture = SKTexture(imageNamed: "ship2")
        coolship2.particleBirthRate = 20
        coolship2.particleLifetime = 1
        coolship2.particleLifetimeRange = 0.2
        coolship2.emissionAngle = 0.0
        coolship2.emissionAngleRange = 360.0
        coolship2.particleSpeed = 50
        coolship2.particleSpeedRange = 20
        coolship2.particleAlpha = 0.8
        coolship2.particleAlphaRange = 0.2
        coolship2.particleAlphaSpeed = -0.75
        coolship2.particleScale = player2.size.width / oldsize2.width
        coolship2.particleScaleRange = 0.1
        coolship2.particleScaleSpeed = -0.2
        coolship2.particleColorBlendFactor = 1
        coolship2.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor.yellow,UIColor.cyan], times: [0.0,0.15])
        player2.addChild(coolship2)
        player2.position = CGPoint(x: size.width * 0.25, y: size.height * 0.5)
        addChild(player2)
        
        let player3 = SKSpriteNode(imageNamed: "ship3")
        let oldsize3 = player3.size
        player3.size = CGSize(width: size.width/4, height: size.width/5.33)
        let coolship3 = SKEmitterNode()
        coolship3.particleTexture = SKTexture(imageNamed: "ship3")
        coolship3.particleBirthRate = 20
        coolship3.particleLifetime = 1
        coolship3.particleLifetimeRange = 0.2
        coolship3.emissionAngle = 0.0
        coolship3.emissionAngleRange = 360.0
        coolship3.particleSpeed = 50
        coolship3.particleSpeedRange = 20
        coolship3.particleAlpha = 0.8
        coolship3.particleAlphaRange = 0.2
        coolship3.particleAlphaSpeed = -0.75
        coolship3.particleScale = player3.size.width / oldsize3.width
        coolship3.particleScaleRange = 0.1
        coolship3.particleScaleSpeed = -0.2
        coolship3.particleColorBlendFactor = 1
        coolship3.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor.blue,UIColor.cyan], times: [0.0,0.15])
        player3.addChild(coolship3)
        player3.position = CGPoint(x: size.width * 0.25, y: size.height * 0.3)
        addChild(player3)
        
        let label1 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label1.text = "DEFAULT"
        label1.fontSize = size.width/27
        label1.fontColor = SKColor.white
        label1.position = CGPoint(x: size.width*0.7, y: 0.65*size.height)
        addChild(label1)
        
        let label2 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label2.text = "SCORE 100 IN ALL MISSIONS"
        label2.fontSize = size.width/27
        label2.fontColor = SKColor.white
        label2.position = CGPoint(x: size.width*0.7, y: 0.45*size.height)
        addChild(label2)
        
        let label3 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label3.text = "SCORE 500 IN ALL ARCADE STAGES"
        label3.fontSize = size.width/27
        label3.fontColor = SKColor.white
        label3.position = CGPoint(x: size.width*0.7, y: 0.25*size.height)
        addChild(label3)
        
        backButton.position = CGPoint(x:size.width*0.075,y:0.95*size.height)
        addChild(backButton)
        
        let stars: SKEmitterNode = StarField.starfieldEmitterNode(width: scsize.width, height: scsize.height)
        addChild(stars)
        
        
    }
    deinit {
        print("Deinit ShipSkin")
    }
    
    
}
