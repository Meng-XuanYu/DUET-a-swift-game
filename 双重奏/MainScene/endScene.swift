//
//  endScene.swift
//  双重奏
//
//  Created by 炫的macbook on 2023/11/26.
//  Copyright © 2023 CTEC. All rights reserved.
//

import Foundation
import SpriteKit
class endScene: SKScene, SKPhysicsContactDelegate {
    //初始化
    //游戏场景镜头
    var gameCamera = SKCameraNode()
    //小球
    var rotatePoint = SKSpriteNode()
    var rotatePathNode = SKShapeNode()
    var blueBall = SKSpriteNode()
    var blueEmitter = SKEmitterNode()
    var redBall = SKSpriteNode()
    var redEmitter = SKEmitterNode()
    override func didMove(to view: SKView)
    {
        //镜头
        gameCamera = self.childNode(withName: "mainmenugamera") as! SKCameraNode
        //获取旋转点（中心）节点和其子节点，两个小球
        rotatePoint = self.childNode(withName: "rotatePoint") as! SKSpriteNode
        blueBall = rotatePoint.childNode(withName: "blueBall") as! SKSpriteNode
        redBall = rotatePoint.childNode(withName: "redBall") as! SKSpriteNode

        //红色和蓝色小球的粒子效果，劣质版
        redEmitter = SKEmitterNode(fileNamed: "RedEmitter.sks")!
        redEmitter.particleSize = CGSize(width: 90.0, height: 90.0)
        redEmitter.targetNode = scene
        redBall.addChild(redEmitter)
        blueEmitter = SKEmitterNode(fileNamed: "BlueEmitter.sks")!
        blueEmitter.particleSize = CGSize(width: 90.0, height: 90.0)
        blueEmitter.targetNode = scene
        blueBall.addChild(blueEmitter)
        
        self.physicsWorld.contactDelegate = self
    }
    
    override public func update(_ currentTime: TimeInterval){
        //主页面一直自动旋转
        rotateNode(node: rotatePoint, clockwise: false, speed: 0.2)
    }
    
    //旋转函数
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = self.view {
                    // 创建主页面场景
                    if let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene") {
                        mainMenuScene.scaleMode = .aspectFill

                        // 显示主页面场景
                        view.presentScene(mainMenuScene)
                    }

                    view.ignoresSiblingOrder = true
        }
    }
}
