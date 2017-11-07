//
//  Sword.swift
//  Redead
//
//  Created by Matthew Genova on 8/1/16.
//  Copyright © 2016 Matthew Genova. All rights reserved.
//

import Foundation

class Sword: Weapon{
    let totalSwingTime = 0.3
    let swingRotation:Float = 90.0
    let weaponSize = CGSize(width: 70.0,height: 12.0)

    
    init() {
        let texture = SKTexture(imageNamed: "Assets/sword.png")
        super.init(theTexture: texture, size: weaponSize)
        self.physicsSize = CGSize(width: 65.0, height: 10.0)
        self.anchorPoint = CGPoint(x: 0,y: 0.5)
        self.zPosition = 0.1
        isHidden = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func attack(_ direction: DirectionalPad.Direction) {
        setUpPhysics()
        isHidden = false
        attacking = true
        var initialAngle:Float = 0.0
        switch direction{
        case .up: initialAngle = 90
        case .down: initialAngle = 270
        case .left: initialAngle = 0 // left and right the same bc scale flips for animation
        case .right: initialAngle = 0
        case .upLeft: initialAngle = 135
        case .upRight: initialAngle = 45
        case .downLeft: initialAngle = 225
        case .downRight: initialAngle = 315
        default: initialAngle = 0
        }
        
        initialAngle -= swingRotation/2
        
        self.zRotation = CGFloat(GLKMathDegreesToRadians(initialAngle))
        
        let action = SKAction.rotate(byAngle: CGFloat(GLKMathDegreesToRadians(swingRotation)), duration: totalSwingTime)
        self.run(action, completion: {
            self.attacking = false
            self.isHidden = true
            self.removePhysics()
        })

    }
    
    
    
}
