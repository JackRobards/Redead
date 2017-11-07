//
//  Weapon.swift
//  Redead
//
//  Created by Matthew Genova on 7/25/16.
//  Copyright © 2016 Matthew Genova. All rights reserved.
//

import SpriteKit


class Weapon: SKSpriteNode{
    var physicsSize = CGSize()
    var attacking = false
    
    init(theTexture: SKTexture, size: CGSize) {
        super.init(texture: theTexture, color: UIColor.clear, size: size)
    }
    
    func setUpPhysics(){
        
        self.physicsBody = SKPhysicsBody(rectangleOf: physicsSize)
        
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = 2
        self.physicsBody!.contactTestBitMask = 4
    }
    
    func removePhysics(){
        self.physicsBody = nil
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    func update(_ delta: CFTimeInterval){
        
    }
    
    func attack(_ direction: DirectionalPad.Direction){
    
    }
    
    func onEnemyHit(){
        
    }
    
}
