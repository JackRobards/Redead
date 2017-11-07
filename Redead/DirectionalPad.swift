//
//  DirectionalPad.swift
//  Redead
//
//  Created by Matthew Genova on 7/20/16.
//  Copyright © 2016 Matthew Genova. All rights reserved.
//

import SpriteKit

class DirectionalPad: SKSpriteNode{
    let diagonal = 0.71
    
    enum Direction {
        case none, up, down, left, right, upLeft, upRight, downLeft, downRight
    }
    
    struct DirectionZone{
        var direction: Direction
        var zone: CGRect
    }
    
    var direction = Direction.none
    var zones = [DirectionZone]()
    
    
    init(imageName: String, size: CGSize) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clear, size: size)
        
        setUpZones()
        isUserInteractionEnabled = true
    }
    
    func getDirectionVector() -> (CGVector){
        switch direction{
        case .none: return CGVector(dx: 0,dy: 0)
        case .up: return CGVector(dx: 0,dy: 1)
        case .down: return CGVector(dx: 0, dy: -1)
        case .left: return CGVector(dx: -1, dy: 0)
        case .right: return CGVector(dx: 1, dy: 0)
        case .upLeft: return CGVector(dx: -diagonal, dy: diagonal)
        case .upRight: return CGVector(dx: diagonal, dy: diagonal)
        case .downLeft: return CGVector(dx: -diagonal, dy: -diagonal)
        case .downRight: return CGVector(dx: diagonal, dy: -diagonal)
        }
    }
    
    fileprivate func setUpZones(){
        let zoneSize = CGSize(width: size.width/3.0, height: size.height/3.0)
        
        var zoneOrigin = CGPoint(x: -zoneSize.width * 1.5, y: zoneSize.height * 0.5)
        //zones.append(DirectionZone(direction: .UpLeft, zone: CGRect(origin: zoneOrigin, size: zoneSize)))
        
        zoneOrigin = CGPoint(x: -zoneSize.width * 0.5, y: zoneSize.height * 0.5)
        zones.append(DirectionZone(direction: .up, zone: CGRect(origin: zoneOrigin, size: zoneSize)))
        
        zoneOrigin = CGPoint(x: zoneSize.width * 0.5 , y: zoneSize.height * 0.5)
        //zones.append(DirectionZone(direction: .UpRight, zone: CGRect(origin: zoneOrigin, size: zoneSize)))
        
        zoneOrigin = CGPoint(x: -zoneSize.width * 1.5, y: -zoneSize.height * 0.5)
        zones.append(DirectionZone(direction: .left, zone: CGRect(origin: zoneOrigin, size: zoneSize)))
        
        zoneOrigin = CGPoint(x: -zoneSize.width * 0.5, y: -zoneSize.height * 0.5)
        zones.append(DirectionZone(direction: .none, zone: CGRect(origin: zoneOrigin, size: zoneSize)))
        
        zoneOrigin = CGPoint(x: zoneSize.width * 0.5, y: -zoneSize.height * 0.5)
        zones.append(DirectionZone(direction: .right, zone: CGRect(origin: zoneOrigin, size: zoneSize)))
        
        zoneOrigin = CGPoint(x: -zoneSize.width * 1.5, y: -zoneSize.height * 1.5)
        //zones.append(DirectionZone(direction: .DownLeft, zone: CGRect(origin: zoneOrigin, size: zoneSize)))
        
        zoneOrigin = CGPoint(x: -zoneSize.width * 0.5, y: -zoneSize.height * 1.5)
        zones.append(DirectionZone(direction: .down, zone: CGRect(origin: zoneOrigin, size: zoneSize)))
        
        zoneOrigin = CGPoint(x: zoneSize.width * 0.5, y: -zoneSize.height * 1.5)
        //zones.append(DirectionZone(direction: .DownRight, zone: CGRect(origin: zoneOrigin, size: zoneSize)))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            let location = touch.location(in: self)
            
            direction = .none
            for z in zones{
                if z.zone.contains(location){
                    direction = z.direction
                    break
                }
            }
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            let location = touch.location(in: self)
            
            direction = .none
            for z in zones{
                if z.zone.contains(location){
                    direction = z.direction
                    break
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       direction = .none
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        direction = .none
    }

    
}
