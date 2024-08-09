//
//  GameScene.swift
//  TheDuetGame
//
//  Created by Ylst, Zachary on 5/22/18.
//  Copyright © 2018 CTEC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var gameCamera = SKCameraNode()
    
    var rotatePoint = SKSpriteNode()
    var rotatePathNode = SKShapeNode()
    var blueBall = SKSpriteNode()
    var blueEmitter = SKEmitterNode()
    var redBall = SKSpriteNode()
    var redEmitter = SKEmitterNode()
    
    var blocksNode = SKSpriteNode()
    var square = SKSpriteNode()
    var rectangle = SKSpriteNode()
    var movingRectangle = SKSpriteNode()
    var spinningRectangle = SKSpriteNode()
    
    var scoreLabel = SKLabelNode()
    var timer: Double = 0.0
    var startLabel = SKLabelNode()
    var arrow = SKSpriteNode()
    
    var isTouching: Bool = false
    var isMovable: Bool = true
    var isFast: Bool = false
    var canBoost: Bool = true
    var rotationDirection: Int = 0
    
    override func didMove(to view: SKView)
    {
        gameCamera = self.childNode(withName: "gameCamera") as! SKCameraNode
        gameCamera.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.975, duration: 1.0), SKAction.scale(to: 1.025, duration: 1.0)])))
        
        rotatePoint = self.childNode(withName: "rotatePoint") as! SKSpriteNode
        rotatePoint.position = CGPoint(x: 0.0, y: -300.0)
        blueBall = rotatePoint.childNode(withName: "blueBall") as! SKSpriteNode
        redBall = rotatePoint.childNode(withName: "redBall") as! SKSpriteNode
        
        blocksNode = self.childNode(withName: "blocksNode") as! SKSpriteNode
        blocksNode.run(SKAction.repeatForever(SKAction.moveBy(x: 0.0, y: -410.0, duration: 1.5)))
        square = blocksNode.childNode(withName: "square") as! SKSpriteNode
        rectangle = blocksNode.childNode(withName: "rectangle") as! SKSpriteNode
        movingRectangle = rectangle.copy() as! SKSpriteNode
        spinningRectangle = rectangle.copy() as! SKSpriteNode
        
        redEmitter = SKEmitterNode(fileNamed: "RedEmitter.sks")!
        redEmitter.particleSize = CGSize(width: 90.0, height: 90.0)
        redEmitter.targetNode = scene
        redBall.addChild(redEmitter)
        blueEmitter = SKEmitterNode(fileNamed: "BlueEmitter.sks")!
        blueEmitter.particleSize = CGSize(width: 90.0, height: 90.0)
        blueEmitter.targetNode = scene
        blueBall.addChild(blueEmitter)
        
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        startLabel = self.childNode(withName: "startLabel") as! SKLabelNode
        startLabel.run(SKAction.sequence([SKAction.fadeIn(withDuration: 1.0), SKAction.fadeOut(withDuration: 2.5)]))
        arrow = self.childNode(withName: "arrow") as! SKSpriteNode
        
        drawPath()
        
        self.physicsWorld.contactDelegate = self
    }
    
    func drawPath()
    {
        rotatePathNode.path = UIBezierPath(arcCenter: CGPoint(x: 0.0, y: 0.917),
                                           radius: 140.0,
                                           startAngle: 0.0,
                                           endAngle: CGFloat(Double.pi * 2),
                                           clockwise: true).cgPath
        rotatePathNode.strokeColor = UIColor.white
        rotatePathNode.lineWidth = 1.5
        rotatePathNode.alpha = 0.3
        rotatePathNode.zPosition = -1
        rotatePoint.addChild(rotatePathNode)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        isTouching = true
        
        for touch in touches
        {
            let location = touch.location(in: self)
            
            if (location.x < frame.midX)
            {
                rotationDirection = -1
            }
            else if (location.x > frame.midX)
            {
                rotationDirection = 1
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in:self)
            
            if (location.x < frame.midX)
            {
                rotationDirection = -1
            }
            else if (location.x > frame.midX)
            {
                rotationDirection = 1
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        isTouching = false
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if (contact.bodyA.node == blueBall || contact.bodyB.node == blueBall)
        {
            die(ball: blueBall)
        }
        else if (contact.bodyA.node == redBall || contact.bodyB.node == redBall)
        {
            die(ball: redBall)
        }
    }
    
    override public func update(_ currentTime: TimeInterval)
    {
        if (isMovable)
        {
            timer += 1/36
            scoreLabel.text = String(Int(timer))
            
            if (isTouching && !isFast)
            {
                if (rotationDirection == -1)
                {
                    rotateNode(node: rotatePoint, clockwise: false, speed: 0.1)
                }
                else if (rotationDirection == 1)
                {
                    rotateNode(node: rotatePoint, clockwise: true, speed: 0.1)
                }
            }
            if (isTouching && isFast)
            {
                if (rotationDirection == -1)
                {
                    rotateNode(node: rotatePoint, clockwise: false, speed: 0.15)
                }
                else if (rotationDirection == 1)
                {
                    rotateNode(node: rotatePoint, clockwise: true, speed: 0.15)
                }
            }
        }
        
        if (timer >= 22)
        {
            if (canBoost)
            {
                gameCamera.run(SKAction.sequence([SKAction.scale(to: 1.2, duration: 0.6), SKAction.scale(to: 1.0, duration: 1.5)]))
                canBoost = false
            }
            isFast = true
            self.speed = 1.5
        }
        
        if (Int(timer) == 30)
        {
            reverseDirection()
        }
    }
    
    func rotateNode(node: SKNode, clockwise: Bool, speed: CGFloat)
    {
        switch clockwise
        {
        case true:
            node.zRotation = node.zRotation - speed
        default:
            node.zRotation = node.zRotation + speed
        }
    }
    
    func reverseDirection()
    {
        let rotatePointRotate = SKAction.rotate(toAngle: CGFloat(Double.pi * 3), duration: 1.0)
        let rotatePointMove = SKAction.move(to: CGPoint(x: 0, y: 300), duration: 0.5)
        let blocksNodeReverse = SKAction.moveBy(x: 0.0, y: 410.0, duration: 1.5)
        
        rotatePoint.run(rotatePointRotate)
        rotatePoint.run(rotatePointMove)
        scoreLabel.run(SKAction.move(to: CGPoint(x: 0, y: 285), duration: 0.5))
        blocksNode.removeAllActions()
        blocksNode.run(SKAction.repeatForever(blocksNodeReverse))
    }
    
    func die(ball: SKSpriteNode)
    {
        isMovable = false
        
        gameCamera.removeAllActions()
        blocksNode.removeAllActions()
        blueEmitter.particleBirthRate = 0
        redEmitter.particleBirthRate = 0
        
        let scene = GameScene(fileNamed: "GameScene")
        scene!.scaleMode = .aspectFill
        
        ball.run(SKAction.sequence([SKAction.resize(toWidth: 0.0, height: 0.0, duration: 1.5), SKAction.wait(forDuration: 1.0), SKAction.run {
            self.view!.presentScene(scene) }]))
    }
}
