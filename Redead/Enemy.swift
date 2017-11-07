//
//  Enemy.swift
//  Redead
//
//  Created by Matthew Genova on 7/25/16.
//  Copyright © 2016 Matthew Genova. All rights reserved.
//

import SpriteKit

enum Difficulty{
    case boss, hard, medium, easy
}

class Enemy: SKSpriteNode {
    var health = 2
    var directionFacing = Direction.none
    var previousDirectionalInput = Direction.none
    var moveSpeed: CGFloat = 100.0
    var walkLeftTexture = [SKTexture]()
    var attackTexture = [SKTexture]()
    var appearTexture = [SKTexture]()
    var idleTexture = [SKTexture]()
    var deathTexture = [SKTexture]()
    let player: Player
    let animationFrameTime = 0.1
    var dead = false
    var attacking = false
    let distanceToNoticePlayer: CGFloat = 350.0
    let difficulty: Difficulty
    
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
        case none, upLeft, upRight, downLeft, downRight, up, down, left, right
    }
    
    init(level: Difficulty, thePlayer: Player) {
        if (level != .boss) {
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/walk/go_1.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/walk/go_2.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/walk/go_3.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/walk/go_4.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/walk/go_5.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/walk/go_6.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/walk/go_7.png"))
        
            attackTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/attack/hit_1.png"))
            attackTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/attack/hit_2.png"))
            attackTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/attack/hit_3.png"))
            attackTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/attack/hit_4.png"))
            attackTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/attack/hit_5.png"))
            attackTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/attack/hit_6.png"))
            attackTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/attack/hit_7.png"))
        
            appearTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/appear/appear_1.png"))
            appearTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/appear/appear_2.png"))
            appearTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/appear/appear_3.png"))
            appearTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/appear/appear_4.png"))
            appearTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/appear/appear_5.png"))
            appearTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/appear/appear_6.png"))
            appearTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/appear/appear_7.png"))
            appearTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/appear/appear_8.png"))
            appearTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/appear/appear_9.png"))
            appearTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/appear/appear_10.png"))
            appearTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/appear/appear_11.png"))
        
            deathTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/die/die_1.png"))
            deathTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/die/die_2.png"))
            deathTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/die/die_3.png"))
            deathTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/die/die_4.png"))
            deathTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/die/die_5.png"))
            deathTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/die/die_6.png"))
            deathTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/die/die_7.png"))
            deathTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/die/die_8.png"))
        
            idleTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/idle/idle_1.png"))
            idleTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/idle/idle_2.png"))
            idleTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/idle/idle_3.png"))
            idleTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/idle/idle_4.png"))
            idleTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/idle/idle_5.png"))
            idleTexture.append(SKTexture(imageNamed: "Assets/CuteZombieSprite/idle/idle_6.png"))
        }
        else {
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/Boss/walk0.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/Boss/walk1.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/Boss/walk2.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/Boss/walk3.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/Boss/walk4.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/Boss/walk5.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/Boss/walk6.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/Boss/walk7.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/Boss/walk8.png"))
            walkLeftTexture.append(SKTexture(imageNamed: "Assets/Boss/walk9.png"))
            
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
        }
        let enemySize = CGSize(width: walkLeftTexture[1].size().width, height: walkLeftTexture[1].size().height)
        
        
        player = thePlayer
        difficulty = level
        
        super.init(texture: appearTexture[0], color: UIColor.clear, size: enemySize)
        
        upperBound = self.position.y + self.size.height/2 - 10
        lowerBound = self.position.y - self.size.height/2 + 10
        rightBound = self.position.x + self.size.width/3 - 10
        leftBound = self.position.x - self.size.width/3 + 10
        
        setUpPhysics()

        
        switch level {
        case .boss:
            health = 6
            moveSpeed = 225.0
        case .hard:
            health = 4
            moveSpeed = 150.0
        case .medium:
            moveSpeed = 125.0
        case .easy:
            moveSpeed = 85.0
        }
    }
    
    func setUpPhysics(){
        let physicsRectSize = CGSize(width: size.width*2/3, height: size.height*2/3)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: physicsRectSize)
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
    
    func takeDamage(_ weapon: Weapon) {
        if health > 0 {
            health -= 1
            flash()
            removePhysics()
            
            
            if health == 0 {
                dead = true
                self.removeAction(forKey: "moveAnimation")
                self.run(SKAction.animate(with: deathTexture, timePerFrame: animationFrameTime*1.2, resize: true, restore: false), completion: {
                    if self.difficulty == .boss {
                        GameScene.gameEndVariables.victory = true
                    }
                    self.removeFromParent()
                })
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
        weapon.onEnemyHit()
    }
    
    func flash(){
        let turnRedColor = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0.2)
        let turnNormalColor = SKAction.colorize(with: UIColor.clear, colorBlendFactor: 0, duration: 0.2)
        self.run(turnRedColor, completion: {
            self.run(turnNormalColor, completion: {
                self.run(turnRedColor, completion: {
                    self.run(turnNormalColor)
                })
            })
            
        })
    }

    
    func move(_ xMove: CGFloat, yMove: CGFloat) {
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
            gidTopRightX = (layer?.tileGid(at: CGPoint(x: rightBound + x, y: upperBound)))!
            gidTopLeftX = (layer?.tileGid(at: CGPoint(x: leftBound + x, y: upperBound)))!
            gidBottomRightX = (layer?.tileGid(at: CGPoint(x: rightBound + x, y: lowerBound)))!
            gidBottomLeftX = (layer?.tileGid(at: CGPoint(x: leftBound + x, y: lowerBound)))!
            gidTopRightY = (layer?.tileGid(at: CGPoint(x: rightBound, y: upperBound + y)))!
            gidTopLeftY = (layer?.tileGid(at: CGPoint(x: leftBound, y: upperBound + y)))!
            gidBottomRightY = (layer?.tileGid(at: CGPoint(x: rightBound, y: lowerBound + y)))!
            gidBottomLeftY = (layer?.tileGid(at: CGPoint(x: leftBound, y: lowerBound + y)))!
            
            
            //Checks if the tile the player is moving to is part of the movableMap
            if gidTopRightX == 0 || gidTopLeftX == 0 || gidBottomLeftX == 0 || gidBottomRightX == 0 {
                x = 0.0
            }
            if gidTopRightY == 0 || gidTopLeftY == 0 || gidBottomLeftY == 0 || gidBottomRightY == 0 {
                y = 0.0
            }
        }

        
        //Moves the enemy
        self.position.x += x * moveSpeed / 100.0
        self.position.y += y * moveSpeed / 100.0
        upperBound = self.position.y + self.size.height/2 - 10
        lowerBound = self.position.y - self.size.height/2 + 10
        rightBound = self.position.x + self.size.width/3 - 10
        leftBound = self.position.x - self.size.width/3 + 10
    }
    
    func getDirectionVector() -> (CGVector){
        var diagnolDistance = distanceFromPlayer()/distanceToNoticePlayer
        //So the zombie's diagnol movespeed will never be that slow, and they'll be a bit faster the farther away the player is
        if (diagnolDistance < 0.5) {
            diagnolDistance = 0.5
        }
        switch directionFacing{
            case .none: return CGVector(dx: 0,dy: 0)
            case .up: return CGVector(dx: 0, dy: 1)
            case .down: return CGVector(dx: 0, dy: -1)
            case .left: return CGVector(dx: -1, dy: 0)
            case .right: return CGVector(dx: 1, dy: 0)
            case .upRight: return CGVector(dx: diagnolDistance,dy: diagnolDistance)
            case .downLeft: return CGVector(dx: -diagnolDistance, dy: -diagnolDistance)
            case .upLeft: return CGVector(dx: -diagnolDistance, dy: diagnolDistance)
            case .downRight: return CGVector(dx: diagnolDistance, dy: -diagnolDistance)
        }
    }
    
    
    
    func attack() {
        attacking = true
        self.run(SKAction.animate(with: attackTexture, timePerFrame: animationFrameTime, resize: true, restore: false), completion: {
            self.attacking = false
            if (self.player.health <= 0) {
                let scene = self.scene! as! GameScene
                scene.gameOver()
            }
        })
    }
    
    func distanceFromPlayer() -> CGFloat  {
        return sqrt(pow(player.position.x - self.position.x, 2) + pow(player.position.y - self.position.y, 2))
    }
    
    func update(_ delta: CFTimeInterval) {
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
            else if !attacking{
                //400 is the distance for the enemy to appear
                if !hasAppeared && distanceFromPlayer() <= 450 {
                    self.run(SKAction.animate(with: appearTexture, timePerFrame: animationFrameTime, resize: true, restore: false), completion: {
                        if self.distanceFromPlayer() > self.distanceToNoticePlayer {
                            self.run(SKAction.repeatForever(SKAction.animate(with: self.idleTexture, timePerFrame: self.animationFrameTime, resize: true, restore: false)), withKey: "idleAnimation")
                        }
                        })
                    hasAppeared = true
                }
                if player.position.x <= self.position.x + 1.5 && player.position.x >= self.position.x - 1.5  && distanceFromPlayer() < distanceToNoticePlayer {
                    if player.position.y > self.position.y {
                        directionFacing = .up
                    }
                    else {
                        directionFacing = .down
                    }
                }
                else if player.position.y <= self.position.y + 1.5 && player.position.y >= self.position.y - 1.5 && distanceFromPlayer() < distanceToNoticePlayer {
                    if player.position.x > self.position.x {
                        directionFacing = .right
                    }
                    else {
                        directionFacing = .left
                    }
                }
                else if player.position.x <= self.position.x && distanceFromPlayer() < distanceToNoticePlayer && player.position.y > self.position.y {
                    directionFacing = .upLeft
                }
                else if player.position.x <= self.position.x && distanceFromPlayer() < distanceToNoticePlayer && player.position.y <= self.position.y {
                    directionFacing = .downLeft
                }
                else if player.position.x > self.position.x && distanceFromPlayer() < distanceToNoticePlayer && player.position.y > self.position.y {
                    directionFacing = .upRight
                }
                else if player.position.x > self.position.x && distanceFromPlayer() < distanceToNoticePlayer && player.position.y <= self.position.y {
                    directionFacing = .downRight
                }
                else {
                    directionFacing = .none
                }
                let directionVector = getDirectionVector()
                
                
                if directionFacing != .none{
                    let x: CGFloat = directionVector.dx * moveSpeed * CGFloat(delta)
                    let y: CGFloat = directionVector.dy * moveSpeed * CGFloat(delta)
                    //Checks the map bounds and moves
                    move(x, yMove: y)
                    
                    
                    if (previousDirectionalInput == .none) {
                        self.removeAction(forKey: "idleAnimation")
                    }
                    
                    if previousDirectionalInput != directionFacing {
                        if directionFacing == .upRight || directionFacing == .downRight || directionFacing == .right || directionFacing == .down {
                            if (difficulty == .boss) {
                                xScale = 1
                            }
                            else {
                                xScale = -1
                            }
                            self.run(SKAction.repeatForever(SKAction.animate(with: walkLeftTexture, timePerFrame: animationFrameTime, resize: true, restore: false)), withKey: "moveAnimation")
                        }
                        else if directionFacing == .upLeft || directionFacing == .downLeft || directionFacing == .left || directionFacing == .up {
                            if (difficulty == .boss) {
                                xScale = -1
                            }
                            else {
                                xScale = 1
                            }
                            self.run(SKAction.repeatForever(SKAction.animate(with: walkLeftTexture, timePerFrame: animationFrameTime,resize: true, restore: false)), withKey: "moveAnimation")
                        }
                    }
                    previousDirectionalInput = directionFacing
                }
                else{
                    self.removeAction(forKey: "moveAnimation")
                    if (previousDirectionalInput != .none) {
                        self.run(SKAction.repeatForever(SKAction.animate(with: idleTexture, timePerFrame: animationFrameTime, resize: true, restore: false)), withKey: "idleAnimation")
                    }
                    previousDirectionalInput = .none
                    
                }
                

            }
        }
    }
}
