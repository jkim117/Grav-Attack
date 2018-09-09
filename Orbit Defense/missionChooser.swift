//
//  missionChooser.swift
//  Orbit Defense
//
//  Created by jason kim on 8/16/18.
//  Copyright © 2018 jason kim. All rights reserved.
//

import SpriteKit

var stage:Int = 0

class missionChooser: SKScene {
    let locks = UserDefaults.standard
    
    init(size: CGSize, stag: Int){
        stage = stag
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        let title = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title.text = "MISSION SELECT"
        title.fontSize = size.width/10
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: 0.85*size.height)
        addChild(title)
        
        //*Buttons**********************************
        let Button1: BDButton = {
            let button = BDButton(buttonText: "1",screenWidth: scsize.width, buttonAction: {
                if stage == 1
                {
                    /*let p1:[planetInit]=[planetInit(rad: scsize.width*0.09, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.4, diameter: 0, move: false)]
                    let t1:[targetInit]=[targetInit(rad: scsize.width/2, x: scsize.width*0.6, y: scsize.height*0.9)]
                    let s1:[shieldInit]=[]*/
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    //let scene = GameScene(size: scsize, planetArray: p1, targetArray: t1, shieldArray: s1, numTargets: t1.count, stagID: 1, missID: 1)
                    let scene = Introduction(size:scsize)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 2
                {
                    let p2:[planetInit]=[planetInit(rad: scsize.width*0.11, mass: scsize.width*11, x: scsize.width*0.5, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.11, mass: scsize.width*11, x: scsize.width*0.5, y: scsize.height*1.2, diameter: 0, move: false),planetInit(rad: scsize.width*0.11, mass: scsize.width*11, x: scsize.width*0.1, y: scsize.height*1.1, diameter: 0, move: false),planetInit(rad: scsize.width*0.11, mass: scsize.width*11, x: scsize.width*0.9, y: scsize.height*1.1, diameter: 0, move: false),planetInit(rad: scsize.width*0.11, mass: scsize.width*11, x: scsize.width*0.5, y: scsize.height * -0.1, diameter: 0, move: false)]
                    let t2:[targetInit]=[targetInit(rad: scsize.width/4, x: scsize.width*0.5, y: scsize.height*0.9)]
                    let s2:[shieldInit]=[]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p2, targetArray: t2, shieldArray: s2, numTargets: t2.count, stagID: 2, missID: 1)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 3
                {
                    let p3:[planetInit]=[planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.5, y: scsize.height*0.5, diameter: scsize.height*0.5, move: true),planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.5, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*7, x: scsize.width*0.5, y: scsize.height*0.75, diameter: 0, move: false)]
                    let t3:[targetInit]=[targetInit(rad: scsize.width/4, x: scsize.width*0.5, y: scsize.height*0.9)]
                    let s3:[shieldInit]=[shieldInit(x: scsize.width*0.25, y: scsize.height*0.9, width: scsize.width*0.5, angle: 90), shieldInit(x: scsize.width*0.75, y: scsize.height*0.9, width: scsize.width*0.5, angle: 90),shieldInit(x: scsize.width*0.5, y: scsize.height*1.1, width: scsize.width*0.5, angle: 0)]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p3, targetArray: t3, shieldArray: s3, numTargets: t3.count, stagID: 3, missID: 1)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 4
                {
                    let p4:[planetInit]=[planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.7, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.1, y: scsize.height*0.7, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.9, y: scsize.height*0.7, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: -scsize.width*0.3, y: scsize.height*0.7, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*1.3, y: scsize.height*0.7, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.1, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.9, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: -scsize.width*0.3, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*1.3, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*1.1, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.1, y: scsize.height*1.1, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.9, y: scsize.height*1.1, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: -scsize.width*0.3, y: scsize.height*1.1, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*1.3, y: scsize.height*1.1, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: -scsize.width*0.3, y: scsize.height*0.9, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*1.3, y: scsize.height*0.9, diameter: 0, move: false)]
                    let t4:[targetInit]=[targetInit(rad: scsize.width/5, x: scsize.width*0.5, y: scsize.height*0.9), targetInit(rad: scsize.width/5, x: scsize.width*0.1, y: scsize.height*0.9), targetInit(rad: scsize.width/5, x: scsize.width*0.9, y: scsize.height*0.9)]
                    let s4:[shieldInit]=[]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p4, targetArray: t4, shieldArray: s4, numTargets: t4.count, stagID: 4, missID: 1)
                    view.presentScene(scene, transition:reveal)
                }
                
            }, enabled:true)
            button.zPosition = 1
            return button
        }()
        
        let Button2: BDButton = {
            let button = BDButton(buttonText: "2",screenWidth: scsize.width, buttonAction: {
                if stage == 1
                {
                    let p1:[planetInit]=[planetInit(rad: scsize.width*0.07, mass: scsize.width*7, x: scsize.width*0.3, y: scsize.height*0.4, diameter: 0, move: false),planetInit(rad: scsize.width*0.05, mass: scsize.width*5, x: scsize.width*0.7, y: scsize.height*0.6, diameter: 0, move: false)]
                    let t1:[targetInit]=[targetInit(rad: scsize.width/2, x: scsize.width*0.7, y: scsize.height*0.9),targetInit(rad: scsize.width/2, x: scsize.width*0.2, y: scsize.height*0.8)]
                    let s1:[shieldInit]=[]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p1, targetArray: t1, shieldArray: s1, numTargets: t1.count, stagID: 1, missID: 2)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 2
                {
                    let p2:[planetInit]=[planetInit(rad: scsize.width*0.09, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.09, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.7, diameter: 0, move: false),planetInit(rad: scsize.width*0.09, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.3, diameter: 0, move: false),planetInit(rad: scsize.width*0.11, mass: scsize.width*11, x: scsize.width*0.5, y: scsize.height*1.2, diameter: 0, move: false),planetInit(rad: scsize.width*0.11, mass: scsize.width*11, x: scsize.width*0.1, y: scsize.height*1.1, diameter: 0, move: false),planetInit(rad: scsize.width*0.11, mass: scsize.width*11, x: scsize.width*0.9, y: scsize.height*1.1, diameter: 0, move: false),planetInit(rad: scsize.width*0.11, mass: scsize.width*11, x: scsize.width, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.11, mass: scsize.width*11, x:0, y: scsize.height*0.5, diameter: 0, move: false)]
                    let t2:[targetInit]=[targetInit(rad: scsize.width/4, x: scsize.width*0.5, y: scsize.height*0.75)]
                    let s2:[shieldInit]=[]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p2, targetArray: t2, shieldArray: s2, numTargets: t2.count, stagID: 2, missID: 2)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 3
                {
                    let p3:[planetInit]=[planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.5, y: scsize.height*0.5, diameter: scsize.height*0.5, move: true),planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.5, y: scsize.height*0.5, diameter: 0, move: false)]
                    let t3:[targetInit]=[targetInit(rad: scsize.width/4, x: scsize.width*0.5, y: scsize.height*0.9)]
                    let s3:[shieldInit]=[shieldInit(x: scsize.width*0.25, y: scsize.height*0.9, width: scsize.width*0.5, angle: 120), shieldInit(x: scsize.width*0.75, y: scsize.height*0.9, width: scsize.width*0.5, angle: 60)]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p3, targetArray: t3, shieldArray: s3, numTargets: t3.count, stagID: 3, missID: 2)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 4
                {
                    let p4:[planetInit]=[planetInit(rad: scsize.width*0.05, mass: scsize.width*9, x: scsize.width*0.3, y: scsize.height/5, diameter:0, move: false), planetInit(rad: scsize.width*0.05, mass: scsize.width*9, x: scsize.width*0.7, y: 2*scsize.height/5, diameter:0, move: false),planetInit(rad: scsize.width*0.05, mass: scsize.width*9, x: scsize.width*0.3, y: 3*scsize.height/5, diameter:0, move: false), planetInit(rad: scsize.width*0.05, mass: scsize.width*9, x: scsize.width*0.7, y: 4*scsize.height/5, diameter:0, move: false)]
                    let t4:[targetInit]=[targetInit(rad: scsize.width/5, x: scsize.width*0.5, y: scsize.height*0.9)]
                    let s4:[shieldInit]=[shieldInit(x: scsize.width*0.5, y: -scsize.height*0.1, width: scsize.width, angle:0),shieldInit(x: scsize.width*0.5, y: scsize.height*1.1, width: scsize.width, angle: 0),shieldInit(x: 0, y: scsize.height*0.5, width: scsize.height*1.1, angle: 90),shieldInit(x: scsize.width, y: scsize.height*0.5, width: scsize.height*1.1, angle: 90),shieldInit(x: scsize.width*0.5, y: scsize.height*0.2, width: 0.3*scsize.width, angle:0)]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p4, targetArray: t4, shieldArray: s4, numTargets: t4.count, stagID: 4, missID: 2)
                    view.presentScene(scene, transition:reveal)
                }
            }, enabled:locks.bool(forKey: "stage"+String(stage)+"mission2"))
            button.zPosition = 1
            return button
        }()
        
        let Button3: BDButton = {
            let button = BDButton(buttonText: "3",screenWidth: scsize.width, buttonAction: {
                if stage == 1
                {
                    let p1:[planetInit]=[planetInit(rad: scsize.width*0.07, mass: scsize.width*7, x: scsize.width*0.4, y: scsize.height*0.4, diameter: 0, move: false),planetInit(rad: scsize.width*0.05, mass: scsize.width*5, x: scsize.width*0.4, y: scsize.height*0.4, diameter: scsize.width*0.4, move: true)]
                    let t1:[targetInit]=[targetInit(rad: scsize.width/2, x: scsize.width*0.7, y: scsize.height*0.9),targetInit(rad: scsize.width/2, x: scsize.width*0.2, y: scsize.height*0.8)]
                    let s1:[shieldInit]=[]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p1, targetArray: t1, shieldArray: s1, numTargets: t1.count, stagID: 1, missID: 3)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 2
                {
                    let p2:[planetInit]=[planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.9, y: scsize.height*0.75, diameter: 0, move: false),planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.1, y: scsize.height*0.75, diameter: 0, move: false)]
                    let t2:[targetInit]=[targetInit(rad: scsize.width/4, x: scsize.width*0.35, y: scsize.height*0.6),targetInit(rad: scsize.width/4, x: scsize.width*0.65, y: scsize.height*0.6)]
                    let s2:[shieldInit]=[shieldInit(x: scsize.width*0.5, y: scsize.height*0.5, width: scsize.width*0.6, angle: 0)]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p2, targetArray: t2, shieldArray: s2, numTargets: t2.count, stagID: 2, missID: 3)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 3
                {
                    let p3:[planetInit]=[planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.5, y: scsize.height*0.7, diameter: scsize.height*0.5, move: true)]
                    let t3:[targetInit]=[targetInit(rad: scsize.width/4, x: scsize.width*0.5, y: scsize.height*0.7)]
                    let s3:[shieldInit]=[shieldInit(x: scsize.width*0.4, y: scsize.height*0.6, width: scsize.width*0.4, angle: 150), shieldInit(x: scsize.width*0.6, y: scsize.height*0.6, width: scsize.width*0.4, angle: 30)]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p3, targetArray: t3, shieldArray: s3, numTargets: t3.count, stagID: 3, missID: 3)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 4
                {
                    let p4:[planetInit]=[planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.5, diameter: 0, move: false), planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.5, diameter: scsize.width*0.2, move: true),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.5, diameter: scsize.width*0.4, move: true), planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.5, diameter: scsize.width*0.6, move: true), planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.5, diameter: scsize.width*0.8, move: true), planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.5, diameter: scsize.width, move: true),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.5, diameter: scsize.width*1.2, move: true),planetInit(rad: scsize.width*0.07, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.5, diameter: scsize.width*1.4, move: true)]
                    let t4:[targetInit]=[targetInit(rad: scsize.width/5, x: scsize.width*0.5, y: scsize.height*0.9),targetInit(rad: scsize.width/5, x: scsize.width*0.1, y: scsize.height*0.9),targetInit(rad: scsize.width/5, x: scsize.width*0.9, y: scsize.height*0.9)]
                    let s4:[shieldInit]=[]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p4, targetArray: t4, shieldArray: s4, numTargets: t4.count, stagID: 4, missID: 3)
                    view.presentScene(scene, transition:reveal)
                }
            }, enabled:locks.bool(forKey: "stage"+String(stage)+"mission3"))
            button.zPosition = 1
            return button
        }()
        
        let Button4: BDButton = {
            let button = BDButton(buttonText: "4",screenWidth: scsize.width, buttonAction: {
                if stage == 1
                {
                    let p1:[planetInit]=[planetInit(rad: scsize.width*0.07, mass: scsize.width*7, x: scsize.width*0.5, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.05, mass: scsize.width*5, x: scsize.width*0.5, y: scsize.height*0.5, diameter: scsize.width*0.5, move: true),planetInit(rad: scsize.width*0.03, mass: scsize.width*3, x: scsize.width*0.5, y: scsize.height*0.5, diameter: scsize.width*0.75, move: true)]
                    let t1:[targetInit]=[targetInit(rad: scsize.width/2, x: scsize.width*0.5, y: scsize.height*0.9)]
                    let s1:[shieldInit]=[]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p1, targetArray: t1, shieldArray: s1, numTargets: t1.count, stagID: 1, missID: 4)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 2
                {
                    let p2:[planetInit]=[planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.5, y: scsize.height*0.25, diameter: 0, move: false),planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.75, y: scsize.height*0.9, diameter: 0, move: false)]
                    let t2:[targetInit]=[targetInit(rad: scsize.width/4, x: scsize.width*0.25, y: scsize.height*0.5),targetInit(rad: scsize.width/4, x: scsize.width*0.75, y: scsize.height*0.5),targetInit(rad: scsize.width/3, x: scsize.width*0.55, y: scsize.height*0.95)]
                    let s2:[shieldInit]=[shieldInit(x: scsize.width*0.5, y: scsize.height*0.6, width: scsize.width*0.8, angle: 0), shieldInit(x: scsize.width*0.08, y: scsize.height*0.5, width: scsize.width*0.5, angle: 120),shieldInit(x: scsize.width*0.92, y: scsize.height*0.5, width: scsize.width*0.5, angle: 60)]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p2, targetArray: t2, shieldArray: s2, numTargets: t2.count, stagID: 2, missID: 4)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 3
                {
                    let p3:[planetInit]=[planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.5, y: scsize.height*0.7, diameter: 0, move: false),planetInit(rad: scsize.width*0.05, mass: scsize.width*7, x: scsize.width*0.5, y: scsize.height*0.7, diameter: scsize.width*0.5, move: true),planetInit(rad: scsize.width*0.07, mass: scsize.width*11, x: scsize.width*0.5, y: scsize.height*0.7, diameter: scsize.width*1.1, move: true)]
                    let t3:[targetInit]=[targetInit(rad: scsize.width/4, x: scsize.width*0.05, y: scsize.height*0.7), targetInit(rad: scsize.width/4, x: scsize.width*0.85, y: scsize.height*0.7)]
                    let s3:[shieldInit]=[shieldInit(x: scsize.width*0.1, y: scsize.height*0.6, width: scsize.width*0.4, angle: 60), shieldInit(x: scsize.width*0.1, y: scsize.height*0.8, width: scsize.width*0.4, angle: 120),shieldInit(x: scsize.width*0.9, y: scsize.height*0.6, width: scsize.width*0.4, angle: 60), shieldInit(x: scsize.width*0.9, y: scsize.height*0.8, width: scsize.width*0.4, angle: 120)]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p3, targetArray: t3, shieldArray: s3, numTargets: t3.count, stagID: 3, missID: 4)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 4
                {
                    let p4:[planetInit]=[planetInit(rad: scsize.width*0.07, mass: scsize.width*13, x: scsize.width*0.1, y: scsize.height*0.5, diameter:0, move: false), planetInit(rad: scsize.width*0.07, mass: scsize.width*13, x: scsize.width*0.9, y: scsize.height*0.5, diameter:0, move: false)]
                    let t4:[targetInit]=[targetInit(rad: scsize.width/5, x: scsize.width*0.5, y: scsize.height*0.6),targetInit(rad: scsize.width/5, x: scsize.width*0.2, y: scsize.height*0.6),targetInit(rad: scsize.width/5, x: scsize.width*0.8, y: scsize.height*0.6),targetInit(rad: scsize.width/5, x: scsize.width*0.5, y: scsize.height*0.7),targetInit(rad: scsize.width/5, x: scsize.width*0.2, y: scsize.height*0.7),targetInit(rad: scsize.width/5, x: scsize.width*0.8, y: scsize.height*0.7),targetInit(rad: scsize.width/5, x: scsize.width*0.5, y: scsize.height*0.8),targetInit(rad: scsize.width/5, x: scsize.width*0.2, y: scsize.height*0.8),targetInit(rad: scsize.width/5, x: scsize.width*0.8, y: scsize.height*0.8),targetInit(rad: scsize.width/5, x: scsize.width*0.5, y: scsize.height*0.9),targetInit(rad: scsize.width/5, x: scsize.width*0.2, y: scsize.height*0.9),targetInit(rad: scsize.width/5, x: scsize.width*0.8, y: scsize.height*0.9)]
                    let s4:[shieldInit]=[shieldInit(x: scsize.width*0.5, y: scsize.height*0.4, width: 0.7*scsize.width, angle:0)]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p4, targetArray: t4, shieldArray: s4, numTargets: t4.count, stagID: 4, missID: 4)
                    view.presentScene(scene, transition:reveal)
                }
            }, enabled:locks.bool(forKey: "stage"+String(stage)+"mission4"))
            button.zPosition = 1
            return button
        }()
        
        let Button5: BDButton = {
            let button = BDButton(buttonText: "5",screenWidth: scsize.width, buttonAction: {
                if stage == 1
                {
                    let p1:[planetInit]=[planetInit(rad: scsize.width*0.07, mass: scsize.width*7, x: scsize.width*0.2, y: scsize.height*0.65, diameter: 0, move: false),planetInit(rad: scsize.width*0.05, mass: scsize.width*5, x: scsize.width*0.2, y: scsize.height*0.65, diameter: scsize.width*0.3, move: true),planetInit(rad: scsize.width*0.09, mass: scsize.width*9, x: scsize.width*0.5, y: scsize.height*0.4, diameter: 0, move: false), planetInit(rad: scsize.width*0.07, mass: scsize.width*7, x: scsize.width*0.9, y: scsize.height*0.6, diameter: 0, move: false)]
                    let t1:[targetInit]=[targetInit(rad: scsize.width/2, x: scsize.width*0.2, y: scsize.height*0.85),targetInit(rad: scsize.width/2, x: scsize.width*0.8, y: scsize.height*0.85)]
                    let s1:[shieldInit]=[]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p1, targetArray: t1, shieldArray: s1, numTargets: t1.count, stagID: 1, missID: 5)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 2
                {
                    let p2:[planetInit]=[planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.5, y: scsize.height*0.25, diameter: 0, move: false),planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.5, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*7, x: scsize.width*0.5, y: scsize.height*0.75, diameter: 0, move: false)]
                    let t2:[targetInit]=[targetInit(rad: scsize.width/4, x: scsize.width*0.5, y: scsize.height*0.9)]
                    let s2:[shieldInit]=[shieldInit(x: scsize.width*0.25, y: scsize.height*0.9, width: scsize.width*0.5, angle: 90), shieldInit(x: scsize.width*0.75, y: scsize.height*0.9, width: scsize.width*0.5, angle: 90),shieldInit(x: scsize.width*0.5, y: scsize.height*1.1, width: scsize.width*0.5, angle: 0)]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p2, targetArray: t2, shieldArray: s2, numTargets: t2.count, stagID: 2, missID: 5)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 3
                {
                    let p3:[planetInit]=[planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width*0.5, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width, y: scsize.height*0.5, diameter: 0, move: false),planetInit(rad: scsize.width*0.09, mass: scsize.width*13, x: scsize.width, y: scsize.height*0.5, diameter: scsize.width, move: true)]
                    let t3:[targetInit]=[targetInit(rad: scsize.width/4, x: scsize.width*0.5, y: -scsize.width/11.24)]
                    let s3:[shieldInit]=[]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p3, targetArray: t3, shieldArray: s3, numTargets: t3.count, stagID: 3, missID: 5)
                    view.presentScene(scene, transition:reveal)
                }
                else if stage == 4
                {
                    let p4:[planetInit]=[planetInit(rad: scsize.width*0.07, mass: scsize.width*13, x: scsize.width*0.1, y: scsize.height*0.5, diameter:0, move: false), planetInit(rad: scsize.width*0.07, mass: scsize.width*13, x: scsize.width*0.9, y: scsize.height*0.5, diameter:0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*13, x: scsize.width*0.7, y: scsize.height*0.7, diameter:0, move: false),planetInit(rad: scsize.width*0.07, mass: scsize.width*13, x: scsize.width*0.3, y: scsize.height*0.7, diameter:0, move: false)]
                    let t4:[targetInit]=[targetInit(rad: scsize.width/5, x: scsize.width*0.4, y: scsize.height*0.6),targetInit(rad: scsize.width/5, x: scsize.width*0.6, y: scsize.height*0.6)]
                    let s4:[shieldInit]=[shieldInit(x: scsize.width*0.5, y: scsize.height*0.4, width: 0.7*scsize.width, angle:0)]
                    let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                    let scene = GameScene(size: scsize, planetArray: p4, targetArray: t4, shieldArray: s4, numTargets: t4.count, stagID: 4, missID: 5)
                    view.presentScene(scene, transition:reveal)
                }
            }, enabled:locks.bool(forKey: "stage"+String(stage)+"mission5"))
            button.zPosition = 1
            return button
        }()
        
        let backButton: SpriteButton = {
            let button = SpriteButton(buttonImage: "back",buttonAction: {
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.3)
                let scene = CampStageMenu(size: scsize)
                view.presentScene(scene, transition:reveal)
            })
            button.zPosition = 1
            return button
        }()
        
        //**End of Buttons*****************
        Button1.position = CGPoint(x: size.width/2, y: 0.7*size.height)
        addChild(Button1)
        let label1 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label1.text = String(format: "HIGHSCORE: %d", locks.integer(forKey: "hsstage"+String(stage)+"mission1"))
        label1.fontSize = size.width/27
        label1.position = CGPoint(x: size.width*0.8, y: 0.7*size.height-scsize.height/140)
        addChild(label1)
        
        Button2.position = CGPoint(x: size.width/2, y: 0.6*size.height)
        addChild(Button2)
        let label2 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label2.text = String(format: "HIGHSCORE: %d", locks.integer(forKey: "hsstage"+String(stage)+"mission2"))
        label2.fontSize = size.width/27
        label2.position = CGPoint(x: size.width*0.8, y: 0.6*size.height-scsize.height/140)
        addChild(label2)
        
        Button3.position = CGPoint(x: size.width/2, y: 0.5*size.height)
        addChild(Button3)
        let label3 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label3.text = String(format: "HIGHSCORE: %d", locks.integer(forKey: "hsstage"+String(stage)+"mission3"))
        label3.fontSize = size.width/27
        label3.position = CGPoint(x: size.width*0.8, y: 0.5*size.height-scsize.height/140)
        addChild(label3)
        
        Button4.position = CGPoint(x: size.width/2, y: 0.4*size.height)
        addChild(Button4)
        let label4 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label4.text = String(format: "HIGHSCORE: %d", locks.integer(forKey: "hsstage"+String(stage)+"mission4"))
        label4.fontSize = size.width/27
        label4.position = CGPoint(x: size.width*0.8, y: 0.4*size.height-scsize.height/140)
        addChild(label4)
        
        Button5.position = CGPoint(x: size.width/2, y: 0.3*size.height)
        addChild(Button5)
        let label5 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label5.text = String(format: "HIGHSCORE: %d", locks.integer(forKey: "hsstage"+String(stage)+"mission5"))
        label5.fontSize = size.width/27
        label5.position = CGPoint(x: size.width*0.8, y: 0.3*size.height-scsize.height/140)
        addChild(label5)
        
        
        backButton.position = CGPoint(x:size.width*0.075,y:0.95*size.height)
        addChild(backButton)
        let stars: SKEmitterNode = StarField.starfieldEmitterNode(width: size.width, height: size.height)
        addChild(stars)
        
        
    }
    
    deinit {
        print("Deinit missionchooser")
    }
    
    
}
