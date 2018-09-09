//
//  ArcadeScene.swift
//  Orbit Defense
//
//  Created by jason kim on 8/15/18.
//  Copyright © 2018 jason kim. All rights reserved.
//

import SpriteKit
import GameplayKit

class ArcadeScene: SKScene {
    let locks = UserDefaults.standard
    var gunOff = false
    var thisTimer:Int
    var thisScore:Int
    
    init(size: CGSize, stagID: Int, newScore: Int, newTimer: Int){
        stage = stagID
        score = newScore // starts at 0, increments by 100 by each call
        thisScore = newScore
        zoomed = false
        pause = false
        thisTimer = newTimer // starts at 30, decrements by 5 down to 10
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var pauseButton: SpriteButton = {
        let button = SpriteButton(buttonImage: "pause",buttonAction: {})
        button.zPosition = 1
        return button}()
    var zoomButton: SpriteButton = {
        let button = SpriteButton(buttonImage: "zoom",buttonAction: {})
        button.zPosition = 1
        return button}()
    
    var projnodes: [SKShapeNode] = [] //array of projectile nodes
    var planetnodes: [SKShapeNode] = [] //array of planet nodes
    let dt: CGFloat = 1.0/60.0 //Delta time.
    let radiusLowerBound: CGFloat = 1.0 //Minimum radius between nodes check.
    let strength: CGFloat = 10 //Change gravity strength
    
    var startLaunchPos:CGPoint = CGPoint(x:0.0,y:0.0) //start position of a drag
    
    let player = SKSpriteNode(imageNamed: "ship") //player node
    let arrow = SKSpriteNode(imageNamed: "arrow") //arrow node
    let arrowLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light") //label for arrow
    let scoreLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light") //label for score
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    //didMove function
    override func didMove(to view: SKView) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "deinitAdMobBanner"), object: self)
        
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(cameraNode)
        camera = cameraNode
        
        let startLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        startLabel.text = String(format:"LEVEL %d",(thisScore+100)/100)
        startLabel.fontSize = scsize.width/11
        startLabel.fontColor = SKColor.white
        startLabel.position = CGPoint(x: 0, y: 0.35*scsize.height)
        camera?.addChild(startLabel)
        var alpha:CGFloat = 1.0
        run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 0.1),SKAction.run {
            startLabel.alpha = alpha - 0.1
            alpha = alpha - 0.1
            }]), count: 11),SKAction.run {
                startLabel.removeFromParent()
            }]))
        
        weak var weakcamera = camera
        zoomButton = {
            let button = SpriteButton(buttonImage: "zoom",buttonAction: {
                if(!zoomed){
                    zoomed = true
                    let zoomInAction = SKAction.scale(to: 2, duration: 0.5)
                    weakcamera?.run(zoomInAction)
                }
                else{
                    zoomed = false
                    let zoomInAction = SKAction.scale(to: 1, duration: 0.5)
                    weakcamera?.run(zoomInAction)
                }
                
            })
            button.zPosition = 1
            return button
        }()
        zoomButton.position = CGPoint(x: 0.4*size.width, y: -0.45*size.height)
        camera?.addChild(zoomButton)
        
        backgroundColor = SKColor.black
        let stars: SKEmitterNode = StarField.starfieldEmitterNode(width: size.width, height: size.height)
        stars.position = CGPoint(x:0,y:0)
        camera?.addChild(stars)
        
        weak var scself = self
        //Main Menu
        let mmButton: BDButton = {
            let button = BDButton(buttonText: "MAIN MENU",screenWidth: scsize.width, buttonAction: {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "initAdMobBanner"), object: scself)
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.3)
                let scene = MainMenu(size: scsize)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 11
            return button
        }()
        
        //Mission select
        let msButton: BDButton = {
            let button = BDButton(buttonText: "STAGE SELECT",screenWidth: scsize.width, buttonAction: {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "initAdMobBanner"), object: scself)
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.3)
                let scene = ArcadeMenu(size: scsize)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 11
            return button
        }()
        
        //Re-Start
        let restartButton: BDButton = {
            let button = BDButton(buttonText: "RE-START",screenWidth: scsize.width, buttonAction: {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "initAdMobBanner"), object: scself)
                let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let scene = ArcadeScene(size: scsize, stagID: stage, newScore: 0, newTimer: 30)
                view.presentScene(scene, transition:reveal)
            }, enabled:true)
            button.zPosition = 11
            return button
        }()
        
        let overlay = SKShapeNode(rect:CGRect(x: -scsize.width/2, y: -scsize.height/2, width: scsize.width, height: scsize.height))
        overlay.fillColor = SKColor.gray
        overlay.zPosition = 10
        overlay.alpha = 0.0
        camera?.addChild(overlay)
        
        let title = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
        title.text = "PAUSE"
        title.fontSize = scsize.width/11
        title.fontColor = SKColor.white
        title.position = CGPoint(x: 0, y: 0.35*scsize.height)
        title.zPosition = 11
        
        //*Pause Button***************************
        
        weak var weakspeed = self.physicsWorld
        pauseButton = {
            let button = SpriteButton(buttonImage: "pause",buttonAction: {
                if(!pause){
                    pause = true
                    
                    scself?.physicsWorld.speed = 0.0
                    
                    overlay.alpha = 0.75
                    
                    
                    scself?.camera?.addChild(title)
                    mmButton.position = CGPoint(x: 0, y: 0)
                    scself?.camera?.addChild(mmButton)
                    msButton.position = CGPoint(x: 0, y: -scsize.height*0.1)
                    scself?.camera?.addChild(msButton)
                    restartButton.position = CGPoint(x: 0, y: -scsize.height*0.2)
                    scself?.camera?.addChild(restartButton)
                    
                    //Resume Button
                    weak var weakoverlay = overlay
                    let resumeButton: BDButton = {
                        let button = BDButton(buttonText: "RESUME",screenWidth: scsize.width, buttonAction: {
                            weakoverlay?.alpha = 0.0
                            weakspeed?.speed = 1.0
                            pause = false
                            mmButton.removeFromParent()
                            msButton.removeFromParent()
                            restartButton.removeFromParent()
                            title.removeFromParent()
                        }, enabled:true)
                        button.zPosition = 11
                        return button
                    }()
                    resumeButton.alpha = 1.333333
                    resumeButton.position = CGPoint(x: 0, y: scsize.height*0.1)
                    overlay.addChild(resumeButton)
                }
            })
            button.zPosition = 1
            return button
        }()
        //pauseButton.position = CGPoint(x: -0.4625*size.width, y: 0.475*size.height)
        pauseButton.position = CGPoint(x: -0.45*size.width, y: 0.465*size.height)
        camera?.addChild(pauseButton)
        //*End of Pause Button****************
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        scoreLabel.fontSize = size.width/27
        scoreLabel.fontColor = SKColor.white
        scoreLabel.zPosition = 5
        camera?.addChild(scoreLabel)
        scoreLabel.text = String(format: "SCORE: %d", score)
        scoreLabel.position = CGPoint(x: size.width*0.375, y: size.height*0.475)
        arrowLabel.fontSize = size.width/27
        arrowLabel.fontColor = SKColor.white
        arrow.size.width = 100.0
        arrow.zPosition = -1
        
        // adding effects for ship2 and ship3
        if(locks.integer(forKey: "shipchoice")==2){
            player.texture = SKTexture(imageNamed: "ship3")
            let oldsize = player.size
            player.size = CGSize(width: size.width/4, height: size.width/5.33)
            let coolship = SKEmitterNode()
            coolship.particleTexture = SKTexture(imageNamed: "ship3")
            coolship.particleBirthRate = 20
            coolship.particleLifetime = 1
            coolship.particleLifetimeRange = 0.2
            coolship.emissionAngle = 0.0
            coolship.emissionAngleRange = 360.0
            coolship.particleSpeed = 50
            coolship.particleSpeedRange = 20
            coolship.particleAlpha = 0.8
            coolship.particleAlphaRange = 0.2
            coolship.particleAlphaSpeed = -0.75
            coolship.particleScale = player.size.width / oldsize.width
            coolship.particleScaleRange = 0.1
            coolship.particleScaleSpeed = -0.2
            coolship.particleColorBlendFactor = 1
            //coolship.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor.yellow,UIColor.cyan], times: [0.0,0.15])
            coolship.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor.blue,UIColor.cyan], times: [0.0,0.15])
            player.addChild(coolship)
        }
        else if locks.integer(forKey: "shipchoice")==1{
            player.texture = SKTexture(imageNamed: "ship2")
            let oldsize = player.size
            player.size = CGSize(width: size.width/4, height: size.width/5.33)
            let coolship = SKEmitterNode()
            coolship.particleTexture = SKTexture(imageNamed: "ship2")
            coolship.particleBirthRate = 20
            coolship.particleLifetime = 1
            coolship.particleLifetimeRange = 0.2
            coolship.emissionAngle = 0.0
            coolship.emissionAngleRange = 360.0
            coolship.particleSpeed = 50
            coolship.particleSpeedRange = 20
            coolship.particleAlpha = 0.8
            coolship.particleAlphaRange = 0.2
            coolship.particleAlphaSpeed = -0.75
            coolship.particleScale = player.size.width / oldsize.width
            coolship.particleScaleRange = 0.1
            coolship.particleScaleSpeed = -0.2
            coolship.particleColorBlendFactor = 1
            coolship.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor.yellow,UIColor.cyan], times: [0.0,0.15])
            player.addChild(coolship)
        }
        else{
            player.size = CGSize(width: size.width/4, height: size.width/5.33)
        }
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.05)
        //player.fillColor = SKColor.orange
        
        func incrementScore(){
            if (!pause){
                score = score+1
                scoreLabel.text = String(format: "SCORE: %d", score)
                if(score == 100+thisScore){
                    if(thisTimer > 10){
                        thisTimer = thisTimer - 5
                    }
                    let reveal = SKTransition.fade(withDuration: 0.2)
                    let scene = ArcadeScene(size: scsize, stagID: stage, newScore: 100+thisScore, newTimer: thisTimer)
                    scself?.view?.presentScene(scene, transition:reveal)
                }
            }
            
        }
        addChild(player)
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 1),SKAction.run(incrementScore)
                ])
        ))
        
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addTarget),
                SKAction.wait(forDuration: 3)
                ])
        ))
        if (stage==1)
        {
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*7, planetX: scsize.width*0.2, planetY: scsize.height*0.65, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.05, planetMass: scsize.width*5, planetX: scsize.width*0.2, planetY: scsize.height*0.65, diameter: scsize.width*0.3, move: true)
            addPlanet(planetRad: scsize.width*0.09, planetMass: scsize.width*9, planetX: scsize.width*0.5, planetY: scsize.height*0.4, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*7, planetX: scsize.width*0.9, planetY: scsize.height*0.6, diameter: 0, move: false)
        }
        else if(stage==2)
        {
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.5, planetY: scsize.height*0.7, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.1, planetY: scsize.height*0.7, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.9, planetY: scsize.height*0.7, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: -scsize.width*0.3, planetY: scsize.height*0.7, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*1.3, planetY: scsize.height*0.7, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*5, planetY: scsize.height*0.5, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.1, planetY: scsize.height*0.5, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.9, planetY: scsize.height*0.5, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: -scsize.width*0.3, planetY: scsize.height*0.5, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*1.3, planetY: scsize.height*0.5, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.5, planetY: scsize.height*1.1, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.1, planetY: scsize.height*1.1, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.9, planetY: scsize.height*1.1, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: -scsize.width*0.3, planetY: scsize.height*1.1, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*1.3, planetY: scsize.height*1.1, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: -scsize.width*0.3, planetY: scsize.height*0.9, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*1.3, planetY: scsize.height*0.9, diameter: 0, move: false)
        }
        else if (stage==3){
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*13, planetX: scsize.width*0.1, planetY: scsize.height*0.5, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*13, planetX: scsize.width*0.9, planetY: scsize.height*0.5, diameter: 0, move: false)
            addShield(shieldWidth: 0.7*scsize.width, shieldX: scsize.width*0.5, shieldY: scsize.height*0.4, angle:0)

        }
        else if(stage==4){
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.5, planetY: scsize.height*0.5, diameter: 0, move: false)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.5, planetY: scsize.height*0.5, diameter: scsize.width*0.2, move: true)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.5, planetY: scsize.height*0.5, diameter: scsize.width*0.4, move: true)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.5, planetY: scsize.height*0.5, diameter: scsize.width*0.6, move: true)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.5, planetY: scsize.height*0.5, diameter: scsize.width*0.8, move: true)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.5, planetY: scsize.height*0.5, diameter: scsize.width, move: true)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.5, planetY: scsize.height*0.5, diameter: scsize.width*1.2, move: true)
            addPlanet(planetRad: scsize.width*0.07, planetMass: scsize.width*9, planetX: scsize.width*0.5, planetY: scsize.height*0.5, diameter: scsize.width*1.4, move: true)

        }
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragView))
        
        view.addGestureRecognizer(dragGesture)
        
        
    }
    
    // Update Gravitational Forces
    override func update(_ currentTime: TimeInterval) {
        for node1 in projnodes {
            // removes projectile if sufficiently off the screen
            if (node1.position.x>5*size.width || node1.position.y>5*size.height)
            {
                node1.removeFromParent()
                continue
            }
            else if(node1.position.x < -4*size.width || node1.position.y < -4*size.height)
            {
                node1.removeFromParent()
                continue
            }
            for node2 in planetnodes {
                let m1 = node1.physicsBody!.mass*strength
                let m2 = node2.physicsBody!.mass*strength
                let disp = CGVector(dx: node2.position.x-node1.position.x, dy: node2.position.y-node1.position.y)
                let radius = sqrt(disp.dx*disp.dx+disp.dy*disp.dy)//*(size.width/414)
                if radius < radiusLowerBound { //Radius lower-bound.
                    continue
                }
                let force = (m1*m2)/(radius*radius)*(size.width/414);
                let normal = CGVector(dx: disp.dx/radius, dy: disp.dy/radius)
                let impulse = CGVector(dx: normal.dx*force*dt, dy: normal.dy*force*dt)
                
                node1.physicsBody!.velocity = CGVector(dx: node1.physicsBody!.velocity.dx + impulse.dx, dy: node1.physicsBody!.velocity.dy + impulse.dy)
            }
        }
    }
    
    // based on drag gesture, gets the start and end position of the drag in order to calculate initial launch velocity
    @objc func dragView(_ sender: UIPanGestureRecognizer) {
        sender.cancelsTouchesInView = false
        if sender.state == .began && !pause{
            var touchLocation = sender.location(in:sender.view)
            touchLocation = convertPoint(fromView:touchLocation)
            startLaunchPos = touchLocation
            arrow.alpha = 0.0
            player.addChild(arrow)
            camera?.addChild(arrowLabel)
        }
        else if sender.state == .changed && !pause{
            var touchLocation = sender.location(in:sender.view)
            touchLocation = convertPoint(fromView:touchLocation)
            
            let yDiff = (startLaunchPos.y-touchLocation.y)*size.width/414
            let xDiff = (startLaunchPos.x-touchLocation.x)*size.width/414
            
            let velMag: CGFloat = sqrt(xDiff*xDiff+yDiff*yDiff)
            // use angle to determine pointing of the gun
            var angle:CGFloat = 0.0
            if (xDiff>0 && yDiff>0)
            {
                angle = -CGFloat.pi/2+atan(yDiff/xDiff)
            }
            else if (xDiff<0 && yDiff>0)
            {
                angle = CGFloat.pi/2-atan(yDiff/(-1*xDiff))
            }
            else if (xDiff>0 && yDiff==0)
            {
                angle = -CGFloat.pi/2
            }
            else if (xDiff<0 && yDiff==0)
            {
                angle = CGFloat.pi/2
            }
            else if (xDiff>0 && yDiff<0)
            {
                angle = -CGFloat.pi/2-atan((-1*yDiff)/xDiff)
            }
            else if (xDiff<0 && yDiff<0)
            {
                angle = CGFloat.pi/2+atan((-1*yDiff)/(-1*xDiff))
            }
            else if (xDiff==0 && yDiff<0)
            {
                angle = CGFloat.pi
            }
            
            var rotate = SKAction.rotate(toAngle: 0.0, duration: 0.001, shortestUnitArc: true)
            if(angle >= -CGFloat.pi/2 && angle <= CGFloat.pi/2)
            {
                rotate = SKAction.rotate(toAngle: angle, duration: 0.001, shortestUnitArc: true)
                angle = -180/CGFloat.pi*angle
            }
            else if(angle > CGFloat.pi/2)
            {
                angle = -90.0
                rotate = SKAction.rotate(toAngle: CGFloat.pi/2, duration: 0.001, shortestUnitArc: true)
            }
            else if(angle < -CGFloat.pi/2)
            {
                angle = 90.0
                rotate = SKAction.rotate(toAngle: -CGFloat.pi/2, duration: 0.001, shortestUnitArc: true)
            }
            arrow.size.height = velMag
            arrow.position.y = velMag/2
            arrow.alpha = 1.0
            
            arrowLabel.position.x = size.width*0.25
            arrowLabel.position.y = -size.height*0.25
            arrowLabel.text = String(format: "SPEED: %.2f  ANGLE: %.2f", velMag, angle)
            
            player.run(rotate)
            
        }
        else if sender.state == .ended && !pause{
            arrow.removeFromParent()
            arrowLabel.removeFromParent()
            
            if(!gunOff){
                gunOff = true
                weak var scself = self
                
                run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run({scself?.gunOff = false})]))
                
                var touchLocation = sender.location(in:sender.view)
                touchLocation = convertPoint(fromView:touchLocation)
                
                var yDiff = (startLaunchPos.y-touchLocation.y)//*size.width/414
                var xDiff = (startLaunchPos.x-touchLocation.x)//*size.width/414
                
                if(yDiff<0)
                {
                    if(xDiff>0)
                    {
                        xDiff = sqrt(xDiff*xDiff+yDiff*yDiff)
                        yDiff = 0
                    }
                    else
                    {
                        xDiff = -1*sqrt(xDiff*xDiff+yDiff*yDiff)
                        yDiff = 0
                    }
                    
                }
                // use angle and dragDist to determine the velocity of the projectile node
                let projectile = SKShapeNode(circleOfRadius:size.width/80)
                projectile.position = player.position
                projectile.fillColor = SKColor.clear
                projectile.strokeColor = SKColor.clear
                
                let projEffect = SKEmitterNode(fileNamed: "Proj")
                projEffect?.particleScale = 2*size.width/1000
                projEffect?.particleScaleSpeed = -0.75*size.width/1000
                projEffect?.particleSpeed = 75*size.width/1000
                
                
                projectile.addChild(projEffect!)
                addChild(projectile)
                run(SKAction.playSoundFileNamed("cannon.mp3", waitForCompletion: false))
                projectile.physicsBody = SKPhysicsBody(circleOfRadius: size.width/80)
                projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
                projectile.physicsBody?.contactTestBitMask = PhysicsCategory.target
                projectile.physicsBody?.contactTestBitMask = PhysicsCategory.planet
                //projectile.physicsBody?.usesPreciseCollisionDetection = true
                
                projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
                projectile.physicsBody?.mass = size.width/8.28
                projectile.physicsBody?.velocity = CGVector(dx: xDiff, dy: yDiff)
                
                projnodes.append(projectile)
            }
            
            
        }
        
     }
    

    // adds a planet node to the view
    func addPlanet(planetRad:CGFloat,planetMass:CGFloat,planetX:CGFloat,planetY:CGFloat, diameter:CGFloat, move:Bool) {
        
        // Create planet
        let planet = SKShapeNode(circleOfRadius: planetRad)
        planet.fillColor = SKColor.black
        planet.strokeColor = SKColor.black
        
        if(!move){
            planet.position = CGPoint(x: planetX, y: planetY)
        }
        
        let void = SKEmitterNode(fileNamed: "Void")
        void?.particleScale = 2*size.width/414*planetRad/(scsize.width*0.07)
        void?.particleScaleRange = size.width/414*planetRad/(scsize.width*0.07)
        void?.particleScaleSpeed = -0.5*size.width/414*planetRad/(scsize.width*0.07)
        void?.particleSpeed = 50*size.width/414*planetRad/(scsize.width*0.07)
        void?.particleSpeedRange = 20*size.width/414*planetRad/(scsize.width*0.07)
        
        if(planetMass<scsize.width*9){
            void?.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor.white,UIColor.orange,UIColor.red], times: [0,0.1,0.75])
        }
        else if (planetMass>scsize.width*11){
            void?.particleColorSequence = SKKeyframeSequence(keyframeValues: [UIColor.white,UIColor.cyan,UIColor.blue], times: [0,0.1,0.75])
        }
        planet.addChild(void!)
        // Add the planet to the scene
        addChild(planet)
        planet.physicsBody = SKPhysicsBody(circleOfRadius: planetRad)
        planet.physicsBody?.isDynamic = true
        planet.physicsBody?.categoryBitMask = PhysicsCategory.planet
        planet.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        planet.physicsBody?.collisionBitMask = PhysicsCategory.none
        planet.physicsBody?.mass = planetMass
        planetnodes.append(planet)
        
        // move planet in path
        if (move){
            let circle = UIBezierPath(ovalIn: CGRect(x: planetX-diameter/2, y: planetY-diameter/2, width: diameter, height: diameter))
            let followCircle = SKAction.follow(circle.cgPath, asOffset: false, orientToPath: false, speed: scsize.height*41*1/diameter)
            planet.run(SKAction.repeatForever(followCircle))
        }
        
    }
    
    // adds a target node to the view
    func addTarget() {
        if(pause==true)
        {
            return
        }
        // Create target
        let target = SKSpriteNode(imageNamed: "alien")
        //let target = SKShapeNode(circleOfRadius: targetRad)
        //target.fillColor = SKColor.green
        let targetRad = scsize.width/4.5
        let oldsize = target.size
        target.size = CGSize(width: targetRad, height: 0.75*targetRad)
        target.position = CGPoint(x: random(min:0,max:scsize.width), y: random(min:scsize.height*0.15,max:scsize.height))
        
        // Add the target to the scene
        let teleport = SKEmitterNode(fileNamed: "Tele")
        run(SKAction.sequence([SKAction.run({target.addChild(teleport!)}),SKAction.wait(forDuration: 2),SKAction.run({teleport?.removeFromParent()})]))
        addChild(target)
        
        let targetPower = SKEmitterNode(fileNamed: "alienpower")
        targetPower?.particleScale = target.size.width / oldsize.width
        target.addChild(targetPower!)
        
        //target.physicsBody = SKPhysicsBody(circleOfRadius: targetRad)
        target.physicsBody = SKPhysicsBody(circleOfRadius: targetRad/2)
        target.physicsBody?.isDynamic = true
        target.physicsBody?.categoryBitMask = PhysicsCategory.target
        target.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        target.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let targetLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light") //label for target
        var timer = thisTimer
        targetLabel.text = String(format: "FIRING IN: %d", timer)
        targetLabel.fontSize = size.width/25
        targetLabel.fontColor = SKColor.white
        targetLabel.zPosition = 5
        target.addChild(targetLabel)
        targetLabel.position = CGPoint(x: size.width*0.05, y: -size.height*0.025)
        func decTimer(){
            if(pause)
            {
                return
            }
            timer = timer-1
            targetLabel.text = String(format: "FIRING IN: %d", timer)
            
            if(timer==0 && target.inParentHierarchy(self)){
                let zam = SKEmitterNode(fileNamed: "Zam")
                zam?.alpha = 0.9
                target.addChild(zam!)
                zam?.particleSpeed = size.width/414*100
                
                func endgame()
                {
                    player.removeFromParent()
                    let exp = SKEmitterNode(fileNamed: "Explosion")
                    exp?.position = CGPoint(x:player.position.x,y:player.position.y)
                    addChild(exp!)
                }
                run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run({endgame()}),SKAction.playSoundFileNamed("boom.mp3", waitForCompletion: false)]))
                
                let overlay = SKShapeNode(rect:CGRect(x: -scsize.width/2, y: -scsize.height/2, width: scsize.width, height: scsize.height))
                overlay.fillColor = SKColor.gray
                overlay.alpha = 0.75
                overlay.zPosition = 10
                camera?.addChild(overlay)
                
                weak var scself = self
                //Stage Select
                let nextButton: BDButton = {
                    let button = BDButton(buttonText: "STAGE SELECT",screenWidth: scsize.width, buttonAction: {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "initAdMobBanner"), object: scself)
                        let reveal = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.3)
                        let scene = ArcadeMenu(size: scsize)
                        scself?.view?.presentScene(scene, transition:reveal)
                    }, enabled:true)
                    button.zPosition = 1
                    return button
                }()
                
                //Main Menu
                let mmButton: BDButton = {
                    let button = BDButton(buttonText: "MAIN MENU",screenWidth: scsize.width, buttonAction: {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "initAdMobBanner"), object: scself)
                        let reveal = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.3)
                        let scene = MainMenu(size: scsize)
                        scself?.view?.presentScene(scene, transition:reveal)
                    }, enabled:true)
                    button.zPosition = 1
                    return button
                }()
                
                //Try again
                let retryButton: BDButton = {
                    let button = BDButton(buttonText: "TRY AGAIN",screenWidth: scsize.width, buttonAction: {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "initAdMobBanner"), object: scself)
                        let reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.1)
                        let scene = ArcadeScene(size: scsize, stagID: stage, newScore: 0, newTimer: 30)
                        scself?.view?.presentScene(scene, transition:reveal)
                    }, enabled:true)
                    button.zPosition = 1
                    return button
                }()
                pause = true
                physicsWorld.speed = 0.0
                
                let title = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
                title.text = "GAME OVER"
                title.fontSize = size.width/11
                title.fontColor = SKColor.white
                title.position = CGPoint(x: 0, y: 0.35*size.height)
                title.alpha = 2
                overlay.addChild(title)
                
                nextButton.position = CGPoint(x: 0, y: 0)
                nextButton.alpha = 2
                overlay.addChild(nextButton)
                mmButton.position = CGPoint(x: 0, y: scsize.height*0.1)
                mmButton.alpha = 2
                overlay.addChild(mmButton)
                retryButton.position = CGPoint(x: 0, y: -scsize.height*0.1)
                retryButton.alpha = 2
                overlay.addChild(retryButton)
                pauseButton.removeFromParent()
                zoomButton.removeFromParent()
                scoreLabel.removeFromParent()
                
                
                
                if score > locks.integer(forKey: "hsstage"+String(stage)+"mission"+String(0))
                {
                    locks.set(score,forKey:"hsstage"+String(stage)+"mission"+String(0))
                    //new highscore
                    let hs = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
                    hs.text = String(format: "NEW HIGH SCORE: %d", score)
                    hs.fontSize = size.width/16
                    hs.fontColor = SKColor.white
                    hs.position = CGPoint(x: 0, y: 0.25*size.height)
                    hs.alpha = 2
                    overlay.addChild(hs)
                    
                }
                else
                {
                    //show old highscore and this score
                    let hs = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
                    hs.text = String(format: "HIGH SCORE: %d", locks.integer(forKey: "hsstage"+String(stage)+"mission"+String(0)))
                    hs.fontSize = size.width/16
                    hs.fontColor = SKColor.white
                    hs.position = CGPoint(x: 0, y: 0.25*size.height)
                    hs.alpha = 2
                    overlay.addChild(hs)
                    
                    let thisScore = SKLabelNode(fontNamed: "AppleSDGothicNeo-Thin")
                    thisScore.text = String(format: "SCORE: %d", score)
                    thisScore.fontSize = size.width/20
                    thisScore.fontColor = SKColor.white
                    thisScore.position = CGPoint(x: 0, y: 0.2*size.height)
                    thisScore.alpha = 2
                    overlay.addChild(thisScore)
                }
            }
        }
        run(SKAction.repeat(
            SKAction.sequence([
                SKAction.wait(forDuration: 1),SKAction.run(decTimer)
                ])
            ,count:32))
    }
    
    // adds a shield node to the view
    func addShield(shieldWidth:CGFloat,shieldX:CGFloat,shieldY:CGFloat,angle:CGFloat) {
        
        // Create shield
        let shield = SKShapeNode(rectOf: CGSize(width: shieldWidth, height: scsize.width*0.025))
        shield.fillColor = SKColor.clear
        shield.strokeColor = SKColor.clear
        shield.position = CGPoint(x: shieldX, y: shieldY)
        shield.run(SKAction.rotate(toAngle: CGFloat.pi*angle/180, duration: 0))
        
        let shield1 = SKEmitterNode(fileNamed: "shield")
        shield1?.particleSpeed = shieldWidth*0.5
        let shield2 = SKEmitterNode(fileNamed: "shield")
        shield2?.particleSpeed = shieldWidth*0.5
        shield2?.emissionAngle = CGFloat.pi
        
        shield.addChild(shield1!)
        shield.addChild(shield2!)
        // Add the target to the scene
        addChild(shield)
        //target.physicsBody = SKPhysicsBody(circleOfRadius: targetRad)
        shield.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shieldWidth, height: scsize.width*0.05))
        shield.physicsBody?.isDynamic = true
        shield.physicsBody?.categoryBitMask = PhysicsCategory.shield
        shield.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        shield.physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    // Called when a projectile hits a planet (gravity well)
    func projectileDidCollideWithPlanet(projectile: SKShapeNode, planet: SKShapeNode) {
        run(SKAction.playSoundFileNamed("suck.mp3", waitForCompletion: false))
        projectile.removeFromParent()
    }
    
    // Called when a projectile hits a shield
    func projectileDidCollideWithShield(projectile: SKShapeNode, shield: SKShapeNode) {
        run(SKAction.playSoundFileNamed("shieldclash.mp3", waitForCompletion: false))
        projectile.removeFromParent()
    }
    
    // Called when a projectile hits the Target
    func projectileDidCollideWithTarget(projectile: SKShapeNode, target: SKSpriteNode) {
        run(SKAction.playSoundFileNamed("boom.mp3", waitForCompletion: false))
        projectile.removeFromParent()
        let exp = SKEmitterNode(fileNamed: "Explosion")
        exp?.position = CGPoint(x:target.position.x,y:target.position.y)
        weak var scself = self
        run(SKAction.sequence([SKAction.run({scself?.addChild(exp!)}),SKAction.wait(forDuration: 2),SKAction.run({exp?.removeFromParent()})]))

        target.removeFromParent()
        
    }
    
    override public func willMove(from view: SKView) {
        //self.removeAllChildren()
        self.removeAllActions()
    }
    
    deinit {
        print("Deinit arcadescene")
    }
    
}

// Called for collisions of planet and projectile
extension ArcadeScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask == PhysicsCategory.planet) &&
            (secondBody.categoryBitMask == PhysicsCategory.projectile)) {
            if let planet = firstBody.node as? SKShapeNode,
                let projectile = secondBody.node as? SKShapeNode {
                projectileDidCollideWithPlanet(projectile: projectile, planet: planet)
            }
        }
        
        // 3
        else if ((firstBody.categoryBitMask == PhysicsCategory.target) &&
            (secondBody.categoryBitMask == PhysicsCategory.projectile)) {
            if let target = firstBody.node as? SKSpriteNode,
                let projectile = secondBody.node as? SKShapeNode {
                projectileDidCollideWithTarget(projectile: projectile, target: target)
            }
        }
            
        //4
        else if ((firstBody.categoryBitMask == PhysicsCategory.shield) &&
            (secondBody.categoryBitMask == PhysicsCategory.projectile)) {
            if let shield = firstBody.node as? SKShapeNode,
                let projectile = secondBody.node as? SKShapeNode {
                projectileDidCollideWithShield(projectile: projectile, shield:shield)
            }
        }
    }
}
