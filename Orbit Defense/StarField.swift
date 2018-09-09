//
//  StarField.swift
//  Orbit Defense
//
//  Created by jason kim on 8/17/18.
//  Copyright © 2018 jason kim. All rights reserved.
//

import Foundation
import SpriteKit

class StarField {
    //Creates a new star field
    static func starfieldEmitterNode(width: CGFloat, height: CGFloat) -> SKEmitterNode {
        
        let emitterNode = SKEmitterNode()
        emitterNode.particleTexture = SKTexture(imageNamed: "spark")
        //emitterNode.numParticlesToEmit = 100
        emitterNode.particleBirthRate = width/276
        emitterNode.particleColor = SKColor.white
        //emitterNode.particleColorRedRange = 10
        emitterNode.particleColorBlueRange = 20
        emitterNode.particleLifetime = 100
        emitterNode.particleLifetimeRange = 20
        emitterNode.particleSpeed = 0
        emitterNode.particleSpeedRange = 10
        //emitterNode.emissionAngle = 0
        //emitterNode.emissionAngleRange = 2*CGFloat.pi
        emitterNode.particleScale = width/4140
        emitterNode.particleScaleRange = width/2070
        emitterNode.particleAlpha = 0.7
        emitterNode.particleAlphaRange = 0.3
        //emitterNode.particleAlphaSequence = SKKeyframeSequence(keyframeValues: [0.3,1,0.3], times: [1.0,10,80])
        emitterNode.particleColorBlendFactor = 1
        emitterNode.position = CGPoint(x: width/2, y: height/2)
        emitterNode.particlePositionRange = CGVector(dx: width, dy: height)
        emitterNode.zPosition = -10
        emitterNode.advanceSimulationTime(100)
        
        
        return emitterNode
    }
}
