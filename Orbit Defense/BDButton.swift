//
//  BDButton.swift
//  Orbit Defense
//
//  Created by jason kim on 8/16/18.
//  Copyright © 2018 jason kim. All rights reserved.
//

import Foundation
import SpriteKit


class BDButton: SKNode {
    var button: SKShapeNode
    private var mask: SKShapeNode
    //private var cropNode: SKCropNode
    private var action: () -> Void
    var isEnabled = true
    
    init(buttonText: String, screenWidth: CGFloat, buttonAction: @escaping() -> Void, enabled: Bool){
        button = SKShapeNode(rectOf: CGSize(width: screenWidth/4, height: scsize.height/14),cornerRadius: screenWidth/40)
        button.fillColor = SKColor.white
        
        let label = SKLabelNode(fontNamed: "AppleSDGothicNeo-Light")
        label.text = buttonText
        label.fontSize = screenWidth/40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: 0, y: -scsize.height/140)
        button.addChild(label)
        
        
        mask = SKShapeNode(rectOf: CGSize(width: screenWidth/4, height: scsize.height/14),cornerRadius: screenWidth/40)
        mask.fillColor = SKColor.black
        mask.alpha = 0
        
        mask.zPosition = 3
        //cropNode = SKCropNode()
        //cropNode.maskNode = button
        //cropNode.zPosition = 3
        //cropNode.addChild(mask)
        
        action = buttonAction

        super.init()
        
        isUserInteractionEnabled = true
        
        setupNode()
        addNodes()
        if(!enabled)
        {
            disable()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNode() {
        button.zPosition = 0
    }
    
    func addNodes() {
        addChild(button)
        //addChild(cropNode)
        addChild(mask)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            mask.alpha = 0.5
            run(SKAction.scale(by: 1.05, duration: 0.05))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location: CGPoint = touch.location(in: self)
                
                if button.contains(location) {
                    mask.alpha = 0.5
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location: CGPoint = touch.location(in: self)
                
                if button.contains(location) {
                    disable()
                    action()
                    run(SKAction.sequence([SKAction.wait(forDuration: 0.2), SKAction.run({
                        self.enable()
                    })]))
                    run(SKAction.scale(by: 1/1.05, duration: 0.05))
                }
                else{
                    mask.alpha = 0.0
                    run(SKAction.scale(by: 1/1.05, duration: 0.05))
                }
            }
        }
    }
    
    func disable() {
        isEnabled = false
        mask.alpha = 0.0
        button.alpha = 0.5
    }
    
    func enable() {
        isEnabled = true
        mask.alpha = 0.0
        button.alpha = 1.0
    }
    
    deinit{
        print("deinit bdbutton")
    }
}




