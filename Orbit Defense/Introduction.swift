//
//  Introduction.swift
//  Orbit Defense
//
//  Created by jason kim on 8/21/18.
//  Copyright © 2018 jason kim. All rights reserved.
//

import Foundation
import SpriteKit

class Introduction: SKScene {
    
    override func didMove(to view: SKView) {
        // 1
        backgroundColor = SKColor.black
        
        // 3
        let title = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title.text = "THE YEAR IS 2831."
        title.fontSize = size.width/20
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: 0.8*size.height)
        addChild(title)
        
        let title2 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title2.text = "A LARGE FLEET OF UNIDENTIFIED STARSHIPS"
        title2.fontSize = size.width/20
        title2.fontColor = SKColor.white
        title2.position = CGPoint(x: size.width/2, y: 0.75*size.height)
        addChild(title2)
        
        let title3 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title3.text = "HAS ENTERED THE SOLAR SYSTEM."
        title3.fontSize = size.width/20
        title3.fontColor = SKColor.white
        title3.position = CGPoint(x: size.width/2, y: 0.7*size.height)
        addChild(title3)
        
        let title4 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title4.text = "THE SHIPS APPEAR TO BE DEPLOYING"
        title4.fontSize = size.width/20
        title4.fontColor = SKColor.white
        title4.position = CGPoint(x: size.width/2, y: 0.65*size.height)
        addChild(title4)
        
        let title5 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title5.text = "AND CHARGING UP GRAVITY WELLS THAT"
        title5.fontSize = size.width/20
        title5.fontColor = SKColor.white
        title5.position = CGPoint(x: size.width/2, y: 0.6*size.height)
        addChild(title5)
        
        let title6 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title6.text = "HAVE LAYED WASTE TO COLONIES ON"
        title6.fontSize = size.width/20
        title6.fontColor = SKColor.white
        title6.position = CGPoint(x: size.width/2, y: 0.55*size.height)
        addChild(title6)
        
        let title7 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title7.text = "EUROPA, ENCELADUS, AND MARS. THE"
        title7.fontSize = size.width/20
        title7.fontColor = SKColor.white
        title7.position = CGPoint(x: size.width/2, y: 0.5*size.height)
        addChild(title7)
        
        let title8 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title8.text = "UNITED EARTH COLONIAL ADMINISTRATION"
        title8.fontSize = size.width/20
        title8.fontColor = SKColor.white
        title8.position = CGPoint(x: size.width/2, y: 0.45*size.height)
        addChild(title8)
        
        let title9 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title9.text = "HAS DEPLOYED ORBITAL DEFENSE STATIONS"
        title9.fontSize = size.width/20
        title9.fontColor = SKColor.white
        title9.position = CGPoint(x: size.width/2, y: 0.4*size.height)
        addChild(title9)
        
        let title10 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title10.text = "TO COUNTER THIS NEW THREAT…"
        title10.fontSize = size.width/20
        title10.fontColor = SKColor.white
        title10.position = CGPoint(x: size.width/2, y: 0.35*size.height)
        addChild(title10)
        
        let beginButton: BDButton = {
            let button = BDButton(buttonText: "BEGIN",screenWidth: scsize.width,buttonAction: {
                let p1:[planetInit]=[planetInit(rad: scsize.width*0.09, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.4, diameter: 0, move: false)]
                let t1:[targetInit]=[targetInit(rad: scsize.width/2, x: scsize.width*0.6, y: scsize.height*0.9)]
                let s1:[shieldInit]=[]
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = GameScene(size: scsize, planetArray: p1, targetArray: t1, shieldArray: s1, numTargets: t1.count, stagID: 1, missID: 1)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 1
            return button
        }()
        beginButton.position = CGPoint(x: size.width/2, y: 0.2*size.height)
        addChild(beginButton)
        
        
        let stars: SKEmitterNode = StarField.starfieldEmitterNode(width: scsize.width, height: scsize.height)
        addChild(stars)
        

        
    }
    
    deinit {
        print("Intro")
    }
    
    
}
