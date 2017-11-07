//
//  GameOverScene.swift
//  Redead
//
//  Created by Jack Robards on 8/2/16.
//  Copyright © 2016 Matthew Genova. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    let screenWidth = ScreenHelper.instance.visibleScreen.width
    let screenHeight = ScreenHelper.instance.visibleScreen.height
    let x = ScreenHelper.instance.visibleScreen.origin.x
    let y = ScreenHelper.instance.visibleScreen.origin.y

    
    override func didMove(to view: SKView) {
        addTextToScreen()
        addButtonsToScene()
    }
    
    func addTextToScreen() {
        let time = GameScene.gameEndVariables.currentTime
        
        let defaults = UserDefaults.standard
        let oldHighScore = defaults.object(forKey: "HighScore")
        var isANewHighScore: Bool?
        
        if oldHighScore == nil {
            if (GameScene.gameEndVariables.victory) {
                defaults.set(time, forKey: "HighScore")
                isANewHighScore = true
            }
            else {
                isANewHighScore = false
            }
        }
        else {
            if let stringOldScore = oldHighScore as? String {
                if stringOldScore >= time {
                    defaults.set(time, forKey: "HighScore")
                    isANewHighScore = true
                }
                isANewHighScore = false
            }
            else {
                isANewHighScore = false
            }
        }
        let gameOverLabel = SKLabelNode()
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY+screenHeight/8)
        gameOverLabel.fontSize = 60
        gameOverLabel.fontName = "Zapfino"
        
        if GameScene.gameEndVariables.victory {
            gameOverLabel.text = "A+!"
            
            gameOverLabel.fontColor = SKColor.green
            
            
            let highScoreLabel = SKLabelNode()
            
            
            if !isANewHighScore! {
                let labelText = "High Score: \(defaults.object(forKey: "HighScore")! as! String)"
                highScoreLabel.text = labelText
                highScoreLabel.fontColor = SKColor.brown
            }
            else {
                let labelText = "NEW HIGH SCORE: \(defaults.object(forKey: "HighScore")! as! String)"
                highScoreLabel.text = labelText
                highScoreLabel.fontColor = SKColor.magenta
            }
            highScoreLabel.fontSize = 30
            highScoreLabel.fontName = "Zapfino"
            highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - screenHeight/4)
            self.addChild(highScoreLabel)

        }
        else {
            gameOverLabel.text = "Game Over!"
            gameOverLabel.fontColor = SKColor.red
        }
        
        self.addChild(gameOverLabel)
    }
    
    func addButtonsToScene(){
        let screenWidth = ScreenHelper.instance.visibleScreen.width
        let screenHeight = ScreenHelper.instance.visibleScreen.height
        let x = ScreenHelper.instance.visibleScreen.origin.x
        let y = ScreenHelper.instance.visibleScreen.origin.y
        
        let buttonSize = CGSize(width: 500, height: 200)
        
        let zButton = SgButton(normalImageNamed: "Assets/buttonStock.png", highlightedImageNamed: "Assets/buttonStockPressed.png", buttonFunc: tappedPlayAgainButton)
        zButton.size = buttonSize
        zButton.position = CGPoint(x: x + screenWidth / 2, y: y + screenHeight / 2)
        
        self.addChild(zButton)
        let label = SKLabelNode(text: "Restart Redead")
        label.fontName = "AmericanTypewriter-Bold"
        label.fontColor = UIColor.yellow
        label.zPosition = 0.1
        zButton.addChild(label)
    }

    
    func tappedPlayAgainButton(_ button: SgButton){
        let newScene = GameScene(size: ScreenHelper.instance.sceneCoordinateSize)
        newScene.scaleMode = .aspectFill
        self.scene!.view!.presentScene(newScene)
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}

