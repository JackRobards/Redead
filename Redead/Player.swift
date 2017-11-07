//
//  Player.swift
//  Redead
//
//  Created by Jack Robards on 7/23/16.
//  Copyright © 2016 Matthew Genova. All rights reserved.
//
import SpriteKit

class Player: SKSpriteNode{
    var playerSize = CGSize()
    var health = 3
    var directionFacing = DirectionalPad.Direction.down
    var previousDirectionalInput = DirectionalPad.Direction.none
    var heartsArray: [SKSpriteNode] = [SKSpriteNode]()
    var moveSpeed: CGFloat = 150.0
    var sword = Sword()
    var projectile = Spell()
    var invinsibleTimer = 0.0
    let invinsibleTimeAfterDamage = 1.0
    var spellCount = 8
    var knockbackTimer = 0.0
    var knockbackDirectionVector = CGVector()
    let knockbackTime = 0.3
    let knockbackSpeed: CGFloat = 150.0
    var isKnockedBack = false
    var isInvinsible = false
    
    
    var walkUpTexture = [SKTexture]()
    var walkDownTexture = [SKTexture]()
    var walkRightTexture = [SKTexture]()
    let animationFrameTime = 0.1
    var upperBound: CGFloat = 0.0
    var lowerBound: CGFloat = 0.0
    var rightBound: CGFloat = 0.0
    var leftBound: CGFloat = 0.0

    init() {
        walkRightTexture.append(SKTexture(imageNamed: "Assets/player_01_large.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/player_02_large.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/player_03_large.png"))
        walkRightTexture.append(SKTexture(imageNamed: "Assets/player_02_large.png"))
        
        walkDownTexture.append(SKTexture(imageNamed: "Assets/player_04_large.png"))
        walkDownTexture.append(SKTexture(imageNamed: "Assets/player_05_large.png"))
        walkDownTexture.append(SKTexture(imageNamed: "Assets/player_06_large.png"))
        walkDownTexture.append(SKTexture(imageNamed: "Assets/player_05_large.png"))

        walkUpTexture.append(SKTexture(imageNamed: "Assets/player_07_large.png"))
        walkUpTexture.append(SKTexture(imageNamed: "Assets/player_08_large.png"))
        walkUpTexture.append(SKTexture(imageNamed: "Assets/player_09_large.png"))
        walkUpTexture.append(SKTexture(imageNamed: "Assets/player_08_large.png"))
        
        heartsArray.append(SKSpriteNode(imageNamed: "Assets/heart.png"))
        heartsArray.append(SKSpriteNode(imageNamed: "Assets/heart.png"))
        heartsArray.append(SKSpriteNode(imageNamed: "Assets/heart.png"))

        playerSize = walkDownTexture[1].size()
        super.init(texture: walkDownTexture[1], color: UIColor.clear, size: walkDownTexture[1].size())
        sword.position = self.position
        projectile.position = self.position
        self.addChild(projectile)
        self.addChild(sword)
        
        upperBound = self.position.y + playerSize.height/2
        lowerBound = self.position.y - playerSize.height/2
        rightBound = self.position.x + playerSize.width/3
        leftBound = self.position.x - playerSize.width/3
        
        setUpPhysics()
    }
    
    func setUpPhysics(){
        let physicsRectSize = CGSize(width: playerSize.width*2/3, height: playerSize.height*2/3)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: physicsRectSize)
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = 1
        self.physicsBody!.contactTestBitMask = 2
    }
    
    func removePhysics(){
        self.physicsBody = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func move(_ xMove: CGFloat, yMove: CGFloat) {
        var x = xMove
        var y = yMove
        
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

        
        self.position.x += x
        self.position.y += y
        upperBound = self.position.y + playerSize.height/2
        lowerBound = self.position.y - playerSize.height/2
        rightBound = self.position.x + playerSize.width/3
        leftBound = self.position.x - playerSize.width/3
    }
    
    func update(_ delta: CFTimeInterval){
        let direction = InputManager.instance.getDpadDirection()
        let directionVector = InputManager.instance.getDpadDirectionVector()
        
        if isInvinsible{
            if invinsibleTimer > 0{
                invinsibleTimer -= delta
            }else{
                isInvinsible = false
                setUpPhysics()
            }
        }
        
        if isKnockedBack{
            if knockbackTimer > 0{
                knockbackTimer -= delta
                let x: CGFloat = knockbackDirectionVector.dx * knockbackSpeed * CGFloat(delta)
                let y: CGFloat = knockbackDirectionVector.dy * knockbackSpeed * CGFloat(delta)
                
                move(x, yMove: y)
            }else{
                isKnockedBack = false
            }
        }else{
            if !sword.attacking && !projectile.attacking && direction != .none{
                let x: CGFloat = directionVector.dx * moveSpeed * CGFloat(delta)
                let y: CGFloat = directionVector.dy * moveSpeed * CGFloat(delta)
                
                move(x , yMove: y)
                directionFacing = direction
                
                if previousDirectionalInput != direction{
                    if direction == .right{
                        xScale = 1
                        self.run(SKAction.repeatForever(SKAction.animate(with: walkRightTexture, timePerFrame: animationFrameTime, resize: true, restore: false)), withKey: "moveAnimation")
                    }
                    else if direction == .left{
                        xScale = -1
                        self.run(SKAction.repeatForever(SKAction.animate(with: walkRightTexture, timePerFrame: animationFrameTime,resize: true, restore: false)), withKey: "moveAnimation")
                    }
                    else if direction == .up{
                        self.run(SKAction.repeatForever(SKAction.animate(with: walkUpTexture, timePerFrame: animationFrameTime,resize: true, restore: false)), withKey: "moveAnimation")
                    }
                    else if direction == .down{
                        self.run(SKAction.repeatForever(SKAction.animate(with: walkDownTexture, timePerFrame: animationFrameTime,resize: true, restore: false)), withKey: "moveAnimation")
                    }
                }
                
                previousDirectionalInput = direction
                
            }else{
                stopWalkingAnimation()
            }
            
            if InputManager.instance.xButtonPressedInFrame{
                print("x")
                attack()
            }else if InputManager.instance.zButtonPressedInFrame{
                print("z")
                projectileAttack()
            }
        }
        
        sword.update(delta)
        projectile.update(delta)
    }
    
    func projectileAttack(){
        if !projectile.attacking && !sword.attacking && spellCount > 0{
            spellCount -= 1
            switch directionFacing {
            case .down: projectile.position = CGPoint(x: 0, y: -playerSize.height/3)
            case .left: projectile.position = CGPoint(x: playerSize.width/3, y: 0)
            case .right: projectile.position = CGPoint(x: playerSize.width/3, y: 0)
            case .up: projectile.position = CGPoint(x: 0, y: playerSize.height/3)
            default: break
            }
            projectile.attack(directionFacing)
        }
    }
    
    func attack(){
        if !sword.attacking && !projectile.attacking{
            switch directionFacing {
            case .down: sword.position = CGPoint(x: 0, y: -playerSize.height/3)
            case .left: sword.position = CGPoint(x: playerSize.width/3, y: 0)
            case .right: sword.position = CGPoint(x: playerSize.width/3, y: 0)
            case .up: sword.position = CGPoint(x: 0, y: playerSize.height/3)
            default: break
            }
            sword.attack(directionFacing)
        }
    }
    
    func stopWalkingAnimation(){
        self.removeAction(forKey: "moveAnimation")
        previousDirectionalInput = .none
    }
    
    func takeDamage(_ enemy: Enemy) {
        if (health > 0 && !isInvinsible) {
            removePhysics()
            isKnockedBack = true
            isInvinsible = true
            knockbackTimer = knockbackTime
            invinsibleTimer = invinsibleTimeAfterDamage
            var direction = CGVector(dx:  position.x - enemy.position.x, dy: position.y - enemy.position.y)
            let magnitude = sqrt(direction.dx * direction.dx + direction.dy * direction.dy)
            direction.dx = direction.dx / magnitude
            direction.dy = direction.dy / magnitude
            
            knockbackDirectionVector = direction
            stopWalkingAnimation()
            
            enemy.attack()
            
            flash()
            heartsArray[health-1].texture = SKTexture(imageNamed: "Assets/empty_heart.png")
            health -= 1
        }
        
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
    
    
    
    
    
}
