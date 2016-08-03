//
//  Enemy.swift
//  Redead
//
//  Created by Matthew Genova on 7/25/16.
//  Copyright © 2016 Matthew Genova. All rights reserved.
//

import SpriteKit

class Boss: SKSpriteNode{
    var health = 3
    var directionFacing = Direction.None
    var previousDirectionalInput = Direction.None
    var moveSpeed: CGFloat = 100.0
    var walkRightTexture = [SKTexture]()
    var attackTexture = [SKTexture]()
    var appearTexture = [SKTexture]()
    var idleTexture = [SKTexture]()
    var deathTexture = [SKTexture]()
    var gestureTexture = [SKTexture]()
    let player: Player
    let animationFrameTime = 0.1
    var dead = false
    
    var knockbackTimer = 0.0
    var knockbackDirectionVector = CGVector()
    let knockbackTime = 0.3
    let knockbackSpeed: CGFloat = 150.0
    var isKnockedBack = false
    var hasAppeared = false
    
    
    var upperBound: CGFloat = 0.0
    var lowerBound: CGFloat = 0.0
    var leftBound: CGFloat = 0.0
    var rightBound: CGFloat = 0.0
    
    enum Direction {
        case None, UpLeft, UpRight, DownLeft, DownRight, Up, Down, Left, Right
    }
    
    init(level: Difficulty, thePlayer: Player) {
        walkRightTexture.append(SKTexture(imageNamed: "Assets/Boss/walk0.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/Boss/walk1.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/Boss/walk2.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/Boss/walk3.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/Boss/walk4.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/Boss/walk5.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/Boss/walk6.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/Boss/walk7.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/Boss/walk8.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/Boss/walk9.png"))
        
        attackTexture.append(SKTexture(imageNamed: "Assets/Boss/attack0.png"))
        attackTexture.append(SKTexture(imageNamed: "Assets/Boss/attack1.png"))
        attackTexture.append(SKTexture(imageNamed: "Assets/Boss/attack2.png"))
        attackTexture.append(SKTexture(imageNamed: "Assets/Boss/attack3.png"))
        attackTexture.append(SKTexture(imageNamed: "Assets/Boss/attack4.png"))
        attackTexture.append(SKTexture(imageNamed: "Assets/Boss/attack5.png"))
        attackTexture.append(SKTexture(imageNamed: "Assets/Boss/attack6.png"))
        attackTexture.append(SKTexture(imageNamed: "Assets/Boss/attack7.png"))
        attackTexture.append(SKTexture(imageNamed: "Assets/Boss/attack8.png"))
        attackTexture.append(SKTexture(imageNamed: "Assets/Boss/attack9.png"))
        
        appearTexture.append(SKTexture(imageNamed: "Assets/Boss/death9.png"))
        appearTexture.append(SKTexture(imageNamed: "Assets/Boss/death8.png"))
        appearTexture.append(SKTexture(imageNamed: "Assets/Boss/death7.png"))
        appearTexture.append(SKTexture(imageNamed: "Assets/Boss/death6.png"))
        appearTexture.append(SKTexture(imageNamed: "Assets/Boss/death5.png"))
        appearTexture.append(SKTexture(imageNamed: "Assets/Boss/death4.png"))
        appearTexture.append(SKTexture(imageNamed: "Assets/Boss/death3.png"))
        appearTexture.append(SKTexture(imageNamed: "Assets/Boss/death2.png"))
        appearTexture.append(SKTexture(imageNamed: "Assets/Boss/death1.png"))
        appearTexture.append(SKTexture(imageNamed: "Assets/Boss/death0.png"))
        
        deathTexture.append(SKTexture(imageNamed: "Assets/Boss/death0.png"))
        deathTexture.append(SKTexture(imageNamed: "Assets/Boss/death1.png"))
        deathTexture.append(SKTexture(imageNamed: "Assets/Boss/death2.png"))
        deathTexture.append(SKTexture(imageNamed: "Assets/Boss/death3.png"))
        deathTexture.append(SKTexture(imageNamed: "Assets/Boss/death4.png"))
        deathTexture.append(SKTexture(imageNamed: "Assets/Boss/death5.png"))
        deathTexture.append(SKTexture(imageNamed: "Assets/Boss/death6.png"))
        deathTexture.append(SKTexture(imageNamed: "Assets/Boss/death7.png"))
        deathTexture.append(SKTexture(imageNamed: "Assets/Boss/death8.png"))
        deathTexture.append(SKTexture(imageNamed: "Assets/Boss/death9.png"))
        
        idleTexture.append(SKTexture(imageNamed: "Assets/Boss/idle0.png"))
        idleTexture.append(SKTexture(imageNamed: "Assets/Boss/idle1.png"))
        idleTexture.append(SKTexture(imageNamed: "Assets/Boss/idle2.png"))
        idleTexture.append(SKTexture(imageNamed: "Assets/Boss/idle3.png"))
        idleTexture.append(SKTexture(imageNamed: "Assets/Boss/idle4.png"))
        idleTexture.append(SKTexture(imageNamed: "Assets/Boss/idle5.png"))
        idleTexture.append(SKTexture(imageNamed: "Assets/Boss/idle6.png"))
        idleTexture.append(SKTexture(imageNamed: "Assets/Boss/idle7.png"))
        idleTexture.append(SKTexture(imageNamed: "Assets/Boss/idle8.png"))
        idleTexture.append(SKTexture(imageNamed: "Assets/Boss/idle9.png"))
        
        gestureTexture.append(SKTexture(imageNamed: "Assets/Boss/gesture0.png"))
        gestureTexture.append(SKTexture(imageNamed: "Assets/Boss/gesture1.png"))
        gestureTexture.append(SKTexture(imageNamed: "Assets/Boss/gesture2.png"))
        gestureTexture.append(SKTexture(imageNamed: "Assets/Boss/gesture3.png"))
        gestureTexture.append(SKTexture(imageNamed: "Assets/Boss/gesture4.png"))
        gestureTexture.append(SKTexture(imageNamed: "Assets/Boss/gesture5.png"))
        gestureTexture.append(SKTexture(imageNamed: "Assets/Boss/gesture6.png"))
        gestureTexture.append(SKTexture(imageNamed: "Assets/Boss/gesture7.png"))
        gestureTexture.append(SKTexture(imageNamed: "Assets/Boss/gesture8.png"))
        gestureTexture.append(SKTexture(imageNamed: "Assets/Boss/gesture9.png"))
        
        let enemySize = CGSizeMake(walkRightTexture[1].size().width, walkRightTexture[1].size().height)
        
        
        player = thePlayer
        
        super.init(texture: appearTexture[0], color: UIColor.clearColor(), size: enemySize)
        
        upperBound = self.position.y + self.size.height/2 - 10
        lowerBound = self.position.y - self.size.height/2 + 10
        rightBound = self.position.x + self.size.width/3 - 10
        leftBound = self.position.x - self.size.width/3 + 10
        
        setUpPhysics()
        
        
        switch level{
        case .Boss:
            moveSpeed = 300.0
        case .Hard:
            moveSpeed = 200.0
        case .Medium:
            moveSpeed = 150.0
        case .Easy:
            moveSpeed = 100.0
        }
    }
    
    func setUpPhysics(){
        let physicsRectSize = CGSize(width: size.width*2/3, height: size.height*2/3)
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: physicsRectSize)
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = 4
        self.physicsBody!.contactTestBitMask = 1 | 2
    }
    
    func removePhysics(){
        self.physicsBody = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func takeDamage(weapon: Weapon) {
        if health > 0 {
            health -= 1
            flash()
            removePhysics()
            
            
            if health == 0 {
                dead = true
                self.removeActionForKey("moveAnimation")
                self.runAction(SKAction.animateWithTextures(deathTexture, timePerFrame: animationFrameTime*1.2, resize: true, restore: false), completion: {self.removeFromParent()})
            }else{
                isKnockedBack = true
                knockbackTimer = knockbackTime
                var direction = CGVector(dx:  position.x - player.position.x, dy: position.y - player.position.y)
                let magnitude = sqrt(direction.dx * direction.dx + direction.dy * direction.dy)
                direction.dx = direction.dx / magnitude
                direction.dy = direction.dy / magnitude
                
                knockbackDirectionVector = direction
            }
        }
        print("Enemy Health: \(health)")
    }
    
    func flash(){
        let turnRedColor = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1, duration: 0.2)
        let turnNormalColor = SKAction.colorizeWithColor(UIColor.clearColor(), colorBlendFactor: 0, duration: 0.2)
        self.runAction(turnRedColor, completion: {
            self.runAction(turnNormalColor, completion: {
                self.runAction(turnRedColor, completion: {
                    self.runAction(turnNormalColor)
                })
            })
            
        })
    }
    
    
    func move(xMove: CGFloat, yMove: CGFloat) {
        var x = xMove
        var y = yMove
        //Checks the wall boundaries
        if let tileMap = TileManager.instance.tileMap {
            let layer = tileMap.layerNamed("MovableMap")
            var gidTopRightX: Int32
            var gidTopLeftX: Int32
            var gidBottomRightX: Int32
            var gidBottomLeftX: Int32
            var gidTopRightY: Int32
            var gidTopLeftY: Int32
            var gidBottomRightY: Int32
            var gidBottomLeftY: Int32
            
            
            //Checks the player bounds
            gidTopRightX = layer.tileGidAt(CGPointMake(rightBound + x, upperBound))
            gidTopLeftX = layer.tileGidAt(CGPointMake(leftBound + x, upperBound))
            gidBottomRightX = layer.tileGidAt(CGPointMake(rightBound + x, lowerBound))
            gidBottomLeftX = layer.tileGidAt(CGPointMake(leftBound + x, lowerBound))
            gidTopRightY = layer.tileGidAt(CGPointMake(rightBound, upperBound + y))
            gidTopLeftY = layer.tileGidAt(CGPointMake(leftBound, upperBound + y))
            gidBottomRightY = layer.tileGidAt(CGPointMake(rightBound, lowerBound + y))
            gidBottomLeftY = layer.tileGidAt(CGPointMake(leftBound, lowerBound + y))
            
            
            //Checks if the tile the player is moving to is part of the movableMap
            if gidTopRightX == 0 || gidTopLeftX == 0 || gidBottomLeftX == 0 || gidBottomRightX == 0 {
                x = 0.0
            }
            if gidTopRightY == 0 || gidTopLeftY == 0 || gidBottomLeftY == 0 || gidBottomRightY == 0 {
                y = 0.0
            }
        }

        
        self.position.x += x * moveSpeed / 100.0
        self.position.y += y * moveSpeed / 100.0
        upperBound = self.position.y + self.size.height/2 - 10
        lowerBound = self.position.y - self.size.height/2 + 10
        rightBound = self.position.x + self.size.width/3 - 10
        leftBound = self.position.x - self.size.width/3 + 10
    }
    
    func getDirectionVector() -> (CGVector){
        switch directionFacing{
        case .None: return CGVector(dx: 0,dy: 0)
        case .Up: return CGVector(dx: 0, dy: distanceFromPlayer()/200.0)
        case .Down: return CGVector(dx: 0, dy: -distanceFromPlayer()/200.0)
        case .Left: return CGVector(dx: -distanceFromPlayer()/200.0, dy: 0)
        case .Right: return CGVector(dx: distanceFromPlayer()/200.0, dy: 0)
        case .UpRight: return CGVector(dx: distanceFromPlayer()/200.0,dy: distanceFromPlayer()/200)
        case .DownLeft: return CGVector(dx: -distanceFromPlayer()/200.0, dy: -distanceFromPlayer()/200)
        case .UpLeft: return CGVector(dx: -distanceFromPlayer()/200.0, dy: distanceFromPlayer()/200.0)
        case .DownRight: return CGVector(dx: distanceFromPlayer()/200.0, dy: -distanceFromPlayer()/200.0)
        }
    }
    
    
    
    func attack() {
        self.runAction(SKAction.animateWithTextures(attackTexture, timePerFrame: animationFrameTime, resize: true, restore: false))
    }
    
    func distanceFromPlayer() -> CGFloat  {
        return sqrt(pow(player.position.x - self.position.x, 2) + pow(player.position.y - self.position.y, 2))
    }
    
    func update(delta: CFTimeInterval) {
        if !dead{
            if isKnockedBack{
                if knockbackTimer > 0{
                    knockbackTimer -= delta
                    let x: CGFloat = knockbackDirectionVector.dx * knockbackSpeed * CGFloat(delta)
                    let y: CGFloat = knockbackDirectionVector.dy * knockbackSpeed * CGFloat(delta)
                    
                    move(x, yMove: y)
                }else{
                    isKnockedBack = false
                    setUpPhysics()
                }
            }
            else{
                
                if !hasAppeared && distanceFromPlayer() <= 400 {
                    self.runAction(SKAction.animateWithTextures(appearTexture, timePerFrame: animationFrameTime, resize: true, restore: false), completion: {
                        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(self.idleTexture, timePerFrame: self.animationFrameTime, resize: true, restore: false)), withKey: "idleAnimation")
                    })
                    hasAppeared = true
                }
                if player.position.x <= self.position.x + 1.5 && player.position.x >= self.position.x - 1.5  && distanceFromPlayer() < 350.0 {
                    if player.position.y > self.position.y {
                        directionFacing = .Up
                    }
                    else {
                        directionFacing = .Down
                    }
                }
                else if player.position.y <= self.position.y + 1.5 && player.position.y >= self.position.y - 1.5 && distanceFromPlayer() < 350.0 {
                    if player.position.x > self.position.x {
                        directionFacing = .Right
                    }
                    else {
                        directionFacing = .Left
                    }
                }
                else if player.position.x <= self.position.x && distanceFromPlayer() < 350.0 && player.position.y > self.position.y {
                    directionFacing = .UpLeft
                }
                else if player.position.x <= self.position.x && distanceFromPlayer() < 350.0 && player.position.y <= self.position.y {
                    directionFacing = .DownLeft
                }
                else if player.position.x > self.position.x && distanceFromPlayer() < 350.0 && player.position.y > self.position.y {
                    directionFacing = .UpRight
                }
                else if player.position.x > self.position.x && distanceFromPlayer() < 350.0 && player.position.y <= self.position.y {
                    directionFacing = .DownRight
                }
                else {
                    directionFacing = .None
                }
                let directionVector = getDirectionVector()
                
                
                if directionFacing != .None{
                    var x: CGFloat = directionVector.dx * moveSpeed * CGFloat(delta)
                    var y: CGFloat = directionVector.dy * moveSpeed * CGFloat(delta)
                    if player.position.x == self.position.x {
                        x = 0.0
                        y = 0.0
                    }
                    if player.position.y == self.position.y {
                        x = 0.0
                        y = 0.0
                    }
                    //Checks the map bounds
                    if let tileMap = TileManager.instance.tileMap {
                        let layer = tileMap.layerNamed("MovableMap")
                        var gidTopRightX: Int32
                        var gidTopLeftX: Int32
                        var gidBottomRightX: Int32
                        var gidBottomLeftX: Int32
                        var gidTopRightY: Int32
                        var gidTopLeftY: Int32
                        var gidBottomRightY: Int32
                        var gidBottomLeftY: Int32
                        
                        
                        //Checks the player bounds
                        gidTopRightX = layer.tileGidAt(CGPointMake(rightBound + x, upperBound))
                        gidTopLeftX = layer.tileGidAt(CGPointMake(leftBound + x, upperBound))
                        gidBottomRightX = layer.tileGidAt(CGPointMake(rightBound + x, lowerBound))
                        gidBottomLeftX = layer.tileGidAt(CGPointMake(leftBound + x, lowerBound))
                        gidTopRightY = layer.tileGidAt(CGPointMake(rightBound, upperBound + y))
                        gidTopLeftY = layer.tileGidAt(CGPointMake(leftBound, upperBound + y))
                        gidBottomRightY = layer.tileGidAt(CGPointMake(rightBound, lowerBound + y))
                        gidBottomLeftY = layer.tileGidAt(CGPointMake(leftBound, lowerBound + y))
                        
                        
                        //Checks if the tile the player is moving to is part of the movableMap
                        if gidTopRightX == 0 || gidTopLeftX == 0 || gidBottomLeftX == 0 || gidBottomRightX == 0 {
                            x = 0.0
                        }
                        if gidTopRightY == 0 || gidTopLeftY == 0 || gidBottomLeftY == 0 || gidBottomRightY == 0 {
                            y = 0.0
                        }                }
                    
                    move(x , yMove: y)
                    
                    if (previousDirectionalInput == .None) {
                        self.removeActionForKey("idleAnimation")
                    }
                    
                    if previousDirectionalInput != directionFacing {
                        if directionFacing == .UpRight || directionFacing == .DownRight || directionFacing == .Left || directionFacing == .Down {
                            xScale = -1
                            self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(walkRightTexture, timePerFrame: animationFrameTime, resize: true, restore: false)), withKey: "moveAnimation")
                        }
                        else if directionFacing == .UpLeft || directionFacing == .DownLeft || directionFacing == .Right || directionFacing == .Up {
                            xScale = 1
                            self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(walkRightTexture, timePerFrame: animationFrameTime,resize: true, restore: false)), withKey: "moveAnimation")
                        }
                    }
                    
                    previousDirectionalInput = directionFacing
                }
                else{
                    self.removeActionForKey("moveAnimation")
                    if (previousDirectionalInput != .None) {
                        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(idleTexture, timePerFrame: animationFrameTime, resize: true, restore: false)), withKey: "idleAnimation")
                    }
                    previousDirectionalInput = .None
                    
                }
                
                
            }
        }
    }
}