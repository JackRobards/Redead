//
//  GameScene.swift
//  Redead
//
//  Created by Matthew Genova on 7/18/16.
//  Copyright (c) 2016 Matthew Genova. All rights reserved.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
    var directionalPad:DirectionalPad? = nil
    var player:Player? = nil
    var tileMap:JSTileMap? = nil
    var enemiesOnScreen: [Enemy] = [Enemy]()
    
    var lastInterval: CFTimeInterval?
    var elapsedTime: Float = 0.0
    var timerLabel: SKLabelNode? = nil
    var projectileLabel: SKLabelNode? = nil
    var initialized = false
    var waitOneFrame = false
    let maps: [String: String] = ["FirstMap.tmx": "secondMap.tmx", "secondMap.tmx": "ThirdMap.tmx", "ThirdMap.tmx": "FourthMap.tmx", "FourthMap.tmx": "FinalMap.tmx"]
    let totalRooms = 5
    var isGameOver = false
    
    fileprivate var yCameraAdjust: CGFloat = 0.0
    fileprivate var xCameraAdjust: CGFloat = 0.0
    fileprivate let screenWidth = ScreenHelper.instance.visibleScreen.width
    fileprivate let screenHeight = ScreenHelper.instance.visibleScreen.height
    fileprivate let originX = ScreenHelper.instance.visibleScreen.origin.x
    fileprivate let originY = ScreenHelper.instance.visibleScreen.origin.y
    fileprivate let sceneCoordinatesX = ScreenHelper.instance.sceneCoordinateSize.width
    fileprivate let sceneCoordinatesY = ScreenHelper.instance.sceneCoordinateSize.height
    
    fileprivate let sound = Sounds()
    fileprivate var roomCount = 1
    
    override func didMove(to view: SKView) {
        yCameraAdjust = -self.frame.midY + screenHeight/6
        xCameraAdjust = -self.frame.midX
        addCameraToScene()
        addPlayerToScene()
        addButtonsToScene()
        addMapToScene("FirstMap.tmx")
        addHeartsToScene()
        addTimerToScene()
        sound.setBackgroundMusic(sound.dungeonMusic, ofType: sound.dungeonMusicExt)
        self.camera!.position = CGPoint(x: -xCameraAdjust - screenWidth/9, y: tileMap!.tileSize.height * 2.2)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        
        gameEndVariables.victory = false
        gameEndVariables.currentTime = ""
        
        initialized = true
    }
    
    func addCameraToScene() {
        let cam: SKCameraNode! = SKCameraNode()
        
        self.camera = cam
        self.addChild(cam)
        
        cam.position = CGPoint(x: originX, y: originY)
    }
    
    func addTimerToScene(){
        timerLabel = SKLabelNode(text: "00:00")
        timerLabel!.position = CGPoint(x: originX + screenWidth * 18/20.0 + xCameraAdjust, y: originY + screenHeight * 18/20.0 + yCameraAdjust)
        timerLabel!.fontName = "AmericanTypewriter-Bold"
        self.camera!.addChild(timerLabel!)
    }
    
    func addButtonsToScene(){
        let buttonSize = CGSize(width: screenWidth/9, height: screenWidth/9)
        let zButton = SgButton(normalImageNamed: "Assets/blueButton.png", highlightedImageNamed: "Assets/bluePushed.png", buttonFunc: InputManager.instance.pushedZButton)
        zButton.size = buttonSize
        zButton.position = CGPoint(x: originX + screenWidth * 16/20.0 + xCameraAdjust, y: originY + screenHeight * 4/16.0 + yCameraAdjust)
        zButton.zPosition = 0.2
        
        projectileLabel = SKLabelNode(text: "\(player!.spellCount)")
        projectileLabel!.position = zButton.position
        projectileLabel!.zPosition = 0.2
        projectileLabel!.fontName = "AmericanTypewriter-Bold"
        projectileLabel!.position.y -= zButton.size.width * 3/4
        
        let xButton = SgButton(normalImageNamed: "Assets/redButton.png", highlightedImageNamed: "Assets/redPushed.png", buttonFunc: InputManager.instance.pushedXButton)
        xButton.size = buttonSize
        xButton.position = CGPoint(x: originX + screenWidth * 18/20.0 + xCameraAdjust, y: originY + screenHeight * 2/16.0 + yCameraAdjust)
        xButton.zPosition = 0.2
        
        self.camera!.addChild(zButton)
        self.camera!.addChild(projectileLabel!)
        self.camera!.addChild(xButton)
        
        let dPadSize = CGSize(width: screenWidth/4.5, height: screenWidth/4.5)

        directionalPad = DirectionalPad(imageName: "Assets/flatDark08.png", size: dPadSize)
        
        directionalPad!.position = CGPoint(x: originX + screenWidth * 1/8.0 + xCameraAdjust, y: originY + screenHeight * 5/22.0 + yCameraAdjust)
        self.camera!.addChild(directionalPad!)
        directionalPad!.zPosition = 0.2
        InputManager.instance.setDirectionalPad(directionalPad!)
    }
    
    func addMapToScene(_ mapName: String) {
        if (tileMap != nil) {
            player!.removeFromParent()
            for enemy in enemiesOnScreen {
                if enemy.parent != nil {
                    enemy.removeFromParent()
                }
            }
            enemiesOnScreen = [Enemy]()
            self.camera!.position = CGPoint(x: -xCameraAdjust - screenWidth/10, y: tileMap!.tileSize.height * 2.2)
            tileMap!.removeFromParent()
        }
        tileMap = JSTileMap(named: mapName)
        TileManager.instance.setTileMap(tileMap!)
        tileMap!.position = CGPoint(x: originX + screenWidth/4, y: originY + screenHeight/12)
        tileMap!.name = mapName
        
        //Made it so the player is a child of the map, not the scene
        tileMap!.addChild(player!)
        player!.position = CGPoint(x: tileMap!.tileSize.width * 1.5, y: tileMap!.tileSize.height * 2)
        
        addEnemiesToScene()
        
        self.addChild(tileMap!)
    }
    
    func addHeartsToScene() {
        let heartSize = CGSize(width: screenWidth/9, height: screenWidth/9)
        
        var counter : CGFloat = 0.0
        for heart in player!.heartsArray {
            heart.size = heartSize
            heart.position = CGPoint(x: originX + screenWidth/20 + xCameraAdjust + (screenWidth/12) * counter, y: originY + yCameraAdjust + screenHeight * 12/13.0)
            self.camera!.addChild(heart)
            counter+=1.0
        }
    }
    
    func addPlayerToScene() {
        player = Player()
    }
    
    func addEnemiesToScene() {
        var x = 0
        var y = 0
        let enemyLocLayer = tileMap!.layerNamed("EnemyLocs")
        while x <  Int(tileMap!.mapSize.width){
            while y < Int(tileMap!.mapSize.height) {
                let point = CGPoint(x: x, y: y)
                let gid = enemyLocLayer?.tileGid(at: (enemyLocLayer?.point(forCoord: point))!)
                if gid != 0 {
                    var enemy: Enemy? = nil
                    if gid == 1 {
                        enemy = Enemy(level: Difficulty.boss, thePlayer: player!)
                    }
                    else if gid == 2 {
                        enemy = Enemy(level: Difficulty.easy, thePlayer: player!)
                    }
                    else if gid == 3 {
                        enemy = Enemy(level: Difficulty.medium, thePlayer: player!)
                    }
                    else if gid == 4 {
                        enemy = Enemy(level: Difficulty.hard, thePlayer: player!)
                    }
                    enemiesOnScreen.append(enemy!)
                    let enemyGridCoord = enemyLocLayer?.point(forCoord: point)
                    enemy!.position = enemyGridCoord!
                    
                    tileMap!.addChild(enemy!)
                }
                y+=1
            }
            y = 0
            x += 1
        }
    }
       
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        //Controls the players movement
        
        if initialized && waitOneFrame && !gameEndVariables.victory {
            if lastInterval == nil {
                lastInterval = currentTime
            }
            
            var delta: CFTimeInterval = currentTime - lastInterval!
            
            if (delta > 0.02) {
                delta = 0.02;
            }
            
            elapsedTime += Float(delta)
            let seconds = Int(elapsedTime.truncatingRemainder(dividingBy: 60))
            let minutes = Int((elapsedTime / 60).truncatingRemainder(dividingBy: 60))
            timerLabel!.text = NSString(format: "%0.2d:%0.2d", minutes, seconds) as String
            
            lastInterval = currentTime
            
            player!.update(delta)
            for enemy in enemiesOnScreen {
                enemy.update(delta)
            }
            
            let layer = tileMap!.layerNamed("MovableMap")
            let gid = layer?.tileGid(at: player!.position)
            if gid == 3 {
                addMapToScene(maps[tileMap!.name!]!)
                roomCount += 1
                if roomCount == totalRooms {
                    sound.setBackgroundMusic(sound.bossMusic, ofType: sound.bossMusicExt)
                }
            }

            
            //Handles the scrolling of the map vertically.
            let cameraSpeed: CGFloat = 3.0
            if player!.position.y > self.camera!.position.y + 20 {
                self.camera!.position = CGPoint(x: self.camera!.position.x, y: self.camera!.position.y + cameraSpeed)
            }
            else if player!.position.y < self.camera!.position.y - 20 {
                self.camera!.position = CGPoint(x: self.camera!.position.x, y: self.camera!.position.y - cameraSpeed)
            }
            
            //Handles the scrolling of the map horizontally.
            if player!.position.x - xCameraAdjust > self.camera!.position.x + 280  {
                self.camera!.position = CGPoint(x: self.camera!.position.x + cameraSpeed, y: self.camera!.position.y)
            } //account for camera adjust
            else if player!.position.x - xCameraAdjust < self.camera!.position.x + 200 {
                self.camera!.position = CGPoint(x: self.camera!.position.x - cameraSpeed, y: self.camera!.position.y)
            }
            
            InputManager.instance.update()
            projectileLabel!.text = "\(player!.spellCount)"
        }else{
            if gameEndVariables.victory {
                gameOver()
            }
            waitOneFrame = true
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let firstNode = contact.bodyA.node as? SKSpriteNode{
            if let secondNode = contact.bodyB.node as? SKSpriteNode{
                if firstNode is Player && secondNode is Enemy{
                    // hurt player
                    player!.takeDamage(secondNode as! Enemy)
                    //play hit sound
                    if player!.health <= 0 {
                        sound.playTempSound(sound.deathSound, ofType: sound.deathSoundExt)
                        sound.setBackgroundMusic(sound.deathMusic, ofType: sound.deathMusicExt)
                        
                    }else{
                        sound.playTempSound(sound.hitSound, ofType: sound.hitSoundExt)
                    }
                }else if firstNode is Enemy && secondNode is Player{
                    // hurt player
                    player!.takeDamage(firstNode as! Enemy)
                    //play hit sound, death sound if necessary
                    //play death music if necessary
                    if player!.health <= 0 {
                        sound.playTempSound(sound.deathSound, ofType: sound.deathSoundExt)
                        sound.setBackgroundMusic(sound.deathMusic, ofType: sound.deathMusicExt)
                    }else{
                        sound.playTempSound(sound.hitSound, ofType: sound.hitSoundExt)
                    }
                    
                }else if firstNode is Weapon && secondNode is Enemy{
                    // hurt enemy if weapon is attacking
                    if let weapon = firstNode as? Weapon{
                        if weapon.attacking{
                            let e = secondNode as! Enemy
                            e.takeDamage(weapon)
                            //play hit sound
                            sound.playTempSound(sound.hitSound, ofType: sound.hitSoundExt)
                            if e.health <= 0 {
                                sound.playTempSound(sound.zombieDeathSound, ofType: sound.zombieDeathSoundExt)
                            }
                        }
                    }
                }else if firstNode is Enemy && secondNode is Weapon{
                    // hurt enemy if weapon is attacking
                    if let weapon = secondNode as? Weapon{
                        if weapon.attacking{
                            let e = firstNode as! Enemy
                            e.takeDamage(weapon)
                            //play hit sound, death sound if necessary
                            sound.playTempSound(sound.hitSound, ofType: sound.hitSoundExt)
                            if e.health <= 0 {
                                sound.playTempSound(sound.zombieDeathSound, ofType: sound.zombieDeathSoundExt)
                            }
                        }
                    }
                }
        
            }
        }
        
    
    }
    
    func gameOver() {
        gameEndVariables.currentTime = timerLabel!.text!
        let transition = SKTransition.fade(withDuration: 5)
        let newScene = GameOverScene(size: ScreenHelper.instance.sceneCoordinateSize)
        newScene.scaleMode = .aspectFill
        self.scene!.view!.presentScene(newScene, transition: transition)
    }
    
    func gameOverColorize(){
        let turnDark = SKAction.colorize(with: UIColor.black, colorBlendFactor: 1, duration: 0.2)
        self.run(turnDark)
    }
    
    struct gameEndVariables {
        static var currentTime = ""
        static var victory = false
    }

    
    
}
