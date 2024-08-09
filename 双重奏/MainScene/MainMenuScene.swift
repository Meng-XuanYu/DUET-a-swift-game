//
//  MainMenuScene.swift
//  双重奏
//
//  Created by 炫的macbook on 2023/11/24.
//  Copyright © 2023 CTEC. All rights reserved.

import Foundation
import SpriteKit
import AVFAudio
class MainMenuScene: SKScene, SKPhysicsContactDelegate {
    //初始化
    var musicOnButton = SKSpriteNode()
    var musicOffButton = SKSpriteNode()
    //游戏场景镜头
    var gameCamera = SKCameraNode()
    //小球
    var rotatePoint = SKSpriteNode()
    var rotatePathNode = SKShapeNode()
    var blueBall = SKSpriteNode()
    var blueEmitter = SKEmitterNode()
    var redBall = SKSpriteNode()
    var redEmitter = SKEmitterNode()
    var direction = false
    var backgroundMusic: AVAudioPlayer?
    var startLabel_0 = SKLabelNode()
    override func didMove(to view: SKView)
    {
        //镜头
        gameCamera = self.childNode(withName: "mainmenugamera") as! SKCameraNode
        //获取旋转点（中心）节点和其子节点，两个小球
        rotatePoint = self.childNode(withName: "rotatePoint") as! SKSpriteNode
        rotatePoint.position = CGPoint(x: 0.0, y: 0.0)
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
        
        // 添加音乐控制按钮
        musicOnButton = self.childNode(withName: "on") as! SKSpriteNode
        musicOffButton = self.childNode(withName: "off") as! SKSpriteNode

        // 从 UserDefaults 检索音乐开关状态，默认为开启
        let musicOn = UserDefaults.standard.bool(forKey: "musicOn")
        updateMusicButtonState(isMusicOn: musicOn)
        if !musicOn {
            AudioManager.shared.playBackgroundMusic()
        }
        
        startLabel_0 = self.childNode(withName: "startLabel_0") as! SKLabelNode
        startLabel_0.run(SKAction.sequence([SKAction.fadeIn(withDuration: 1.0), SKAction.fadeOut(withDuration: 2.5)]))
    }
    
    override public func update(_ currentTime: TimeInterval){
        //主页面一直自动旋转
        rotateNode(node: rotatePoint, clockwise: direction, speed: 0.05)
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
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)

            for node in nodes {
                if node.name == "startNode" {
                    if let view = self.view {
                                // 创建选择场景
                                if let selectionScreen = selection(fileNamed: "selection") {
                                    selectionScreen.scaleMode = .aspectFill

                                    // 显示选择场景
                                    view.presentScene(selectionScreen)
                                }

                                view.ignoresSiblingOrder = true
                    }
                } else if node.name == "on" {
                    AudioManager.shared.stopBackgroundMusic()
                    updateMusicButtonState(isMusicOn: true)
                    UserDefaults.standard.set(true, forKey: "musicOn")
                } else if node.name == "off" {
                    AudioManager.shared.playBackgroundMusic()
                    updateMusicButtonState(isMusicOn: false)
                    UserDefaults.standard.set(false, forKey: "musicOn")
                } else {
                    let location = touch.location(in: self)
                    
                    if (location.x < frame.midX)
                    {
                        direction = false
                    }
                    else if (location.x > frame.midX)
                    {
                        direction = true
                    }
                }
                
            }
        }
    }
    // 辅助方法：根据音乐开关状态更新按钮显示
        func updateMusicButtonState(isMusicOn: Bool) {
            musicOnButton.isHidden = isMusicOn
            musicOffButton.isHidden = !isMusicOn
        }
}

