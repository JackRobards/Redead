//
//  MenuScene.swift
//  Redead
//
//  Created by Matthew Genova on 7/20/16.
//  Copyright © 2016 Matthew Genova. All rights reserved.
//


import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        addButtonsToScene()
        addScoreToScene()
    }
    
    func addButtonsToScene(){
        let screenWidth = ScreenHelper.instance.visibleScreen.width
        let screenHeight = ScreenHelper.instance.visibleScreen.height
        let x = ScreenHelper.instance.visibleScreen.origin.x
        let y = ScreenHelper.instance.visibleScreen.origin.y

        let buttonSize = CGSize(width: 500, height: 200)
        
        let zButton = SgButton(normalImageNamed: "Assets/buttonStock.png", highlightedImageNamed: "Assets/buttonStockPressed.png", buttonFunc: tappedStartButton)
        zButton.size = buttonSize
        zButton.position = CGPoint(x: x + screenWidth / 2, y: y + screenHeight / 2)
        
        
        
        self.addChild(zButton)
        let label = SKLabelNode(text: "Start Redead")
        label.fontName = "AmericanTypewriter-Bold"
        label.fontColor = UIColor.yellow
        label.zPosition = 0.1
        zButton.addChild(label)
    }
    
    func addScoreToScene() {
        
        
        let defaults = UserDefaults()
        
        if defaults.object(forKey: "HighScore") != nil {
            let labelText = "High Score: \(defaults.object(forKey: "HighScore")! as! String)"
            let highScoreLabel = SKLabelNode()
            highScoreLabel.text = labelText
            highScoreLabel.fontColor = SKColor.brown
        
            highScoreLabel.fontSize = 30
            highScoreLabel.fontName = "Zapfino"
            let screenHeight = ScreenHelper.instance.visibleScreen.height
            highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - screenHeight/4)
            self.addChild(highScoreLabel)
        }

    }
    
    func tappedStartButton(_ button: SgButton){
        let newScene = GameScene(size: ScreenHelper.instance.sceneCoordinateSize)
        newScene.scaleMode = .aspectFill
        self.scene!.view!.presentScene(newScene)
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}

