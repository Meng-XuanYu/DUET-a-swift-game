//
//  selection.swift
//  双重奏
//
//  Created by 炫的macbook on 2023/11/24.
//  Copyright © 2023 CTEC. All rights reserved.
//

import Foundation
import SpriteKit
class selection: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate{
    //初始化
    var acceleratedLevelStatus: [Bool] = []
    // 通过 UserDefaults 保存和加载关卡通关状态
    var userDefaults = UserDefaults.standard
    var lastCompletedLevelNode: SKSpriteNode? // 用于跟踪最新通关的关卡图片
    var animationTime: TimeInterval = 0.0
    var rotateInterval: TimeInterval = 1.0 // 两秒旋转一次
    var isPanning = false
    var currentLevel: Int = 1
    //游戏场景镜头
    var gameCamera = SKCameraNode()
    var img1 = SKSpriteNode()
    var img2 = SKSpriteNode()
    var img3 = SKSpriteNode()
    var img4 = SKSpriteNode()
    var img5 = SKSpriteNode()
    var img6 = SKSpriteNode()
    var img7 = SKSpriteNode()
    var img8 = SKSpriteNode()
    var img9 = SKSpriteNode()
    var img10 = SKSpriteNode()
    var img1u = SKSpriteNode()
    var img2u = SKSpriteNode()
    var img3u = SKSpriteNode()
    var img4u = SKSpriteNode()
    var img5u = SKSpriteNode()
    var img6u = SKSpriteNode()
    var img7u = SKSpriteNode()
    var img8u = SKSpriteNode()
    var img9u = SKSpriteNode()
    var img10u = SKSpriteNode()
    var img1e = SKSpriteNode()
    var img2e = SKSpriteNode()
    var img3e = SKSpriteNode()
    var img4e = SKSpriteNode()
    var img5e = SKSpriteNode()
    var img6e = SKSpriteNode()
    var img7e = SKSpriteNode()
    var img8e = SKSpriteNode()
    var img9e = SKSpriteNode()
    var img10e = SKSpriteNode()
    let minY: CGFloat = -10
    let maxY: CGFloat = 800
    override func didMove(to view: SKView) {
        gameCamera = self.childNode(withName: "GameCamera") as! SKCameraNode
        img1 = gameCamera.childNode(withName: "img1_1") as! SKSpriteNode
        img2 = gameCamera.childNode(withName: "img1_2") as! SKSpriteNode
        img3 = gameCamera.childNode(withName: "img1_3") as! SKSpriteNode
        img4 = gameCamera.childNode(withName: "img2_1") as! SKSpriteNode
        img5 = gameCamera.childNode(withName: "img2_2") as! SKSpriteNode
        img6 = gameCamera.childNode(withName: "img2_3") as! SKSpriteNode
        img7 = gameCamera.childNode(withName: "img2_4") as! SKSpriteNode
        img8 = gameCamera.childNode(withName: "img3_1") as! SKSpriteNode
        img9 = gameCamera.childNode(withName: "img3_2") as! SKSpriteNode
        img10 = gameCamera.childNode(withName: "img3_3") as! SKSpriteNode
        img1u = gameCamera.childNode(withName: "img1_1_un") as! SKSpriteNode
        img2u = gameCamera.childNode(withName: "img1_2_un") as! SKSpriteNode
        img3u = gameCamera.childNode(withName: "img1_3_un") as! SKSpriteNode
        img4u = gameCamera.childNode(withName: "img2_1_un") as! SKSpriteNode
        img5u = gameCamera.childNode(withName: "img2_2_un") as! SKSpriteNode
        img6u = gameCamera.childNode(withName: "img2_3_un") as! SKSpriteNode
        img7u = gameCamera.childNode(withName: "img2_4_un") as! SKSpriteNode
        img8u = gameCamera.childNode(withName: "img3_1_un") as! SKSpriteNode
        img9u = gameCamera.childNode(withName: "img3_2_un") as! SKSpriteNode
        img10u = gameCamera.childNode(withName: "img3_3_un") as! SKSpriteNode
        img1e = gameCamera.childNode(withName: "img1_1_ex") as! SKSpriteNode
        img2e = gameCamera.childNode(withName: "img1_2_ex") as! SKSpriteNode
        img3e = gameCamera.childNode(withName: "img1_3_ex") as! SKSpriteNode
        img4e = gameCamera.childNode(withName: "img2_1_ex") as! SKSpriteNode
        img5e = gameCamera.childNode(withName: "img2_2_ex") as! SKSpriteNode
        img6e = gameCamera.childNode(withName: "img2_3_ex") as! SKSpriteNode
        img7e = gameCamera.childNode(withName: "img2_4_ex") as! SKSpriteNode
        img8e = gameCamera.childNode(withName: "img3_1_ex") as! SKSpriteNode
        img9e = gameCamera.childNode(withName: "img3_2_ex") as! SKSpriteNode
        img10e = gameCamera.childNode(withName: "img3_3_ex") as! SKSpriteNode
        // 添加手势识别器
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                view.addGestureRecognizer(panGesture)

        // 尝试从 UserDefaults 中加载当前关卡信息
        if let savedLevel = UserDefaults.standard.value(forKey: "currentLevel") as? Int {
                currentLevel = savedLevel
        }
        
        // 尝试从 UserDefaults 中加载加速版关卡状态数组
            if let savedAcceleratedLevelStatus = userDefaults.array(forKey: "acceleratedLevelStatus") as? [Bool] {
                acceleratedLevelStatus = savedAcceleratedLevelStatus
            } else {
                // 如果没有保存过，初始化为全部未通过
                acceleratedLevelStatus = Array(repeating: false, count: 10)
            }
        
        setupLevelIconsVisibility()
        // 根据当前关卡设置 lastCompletedLevelNode
        switch currentLevel {
        case 1:
            lastCompletedLevelNode = img1
        case 2:
            lastCompletedLevelNode = img2
        case 3:
            lastCompletedLevelNode = img3
        case 4:
            lastCompletedLevelNode = img4
        case 5:
            lastCompletedLevelNode = img5
        case 6:
            lastCompletedLevelNode = img6
        case 7:
            lastCompletedLevelNode = img7
        case 8:
            lastCompletedLevelNode = img8
        case 9:
            lastCompletedLevelNode = img9
        case 10:
            lastCompletedLevelNode = img10
        default:
            lastCompletedLevelNode = nil
        }
        // 缩放动画
        let scaleAction = SKAction.sequence([
            SKAction.scale(to: 1, duration: 0.2),
            SKAction.scale(to: 0.9, duration: 0.2)
        ])
        
        lastCompletedLevelNode?.run(SKAction.repeatForever(scaleAction))
        // 确保手势不与 SpriteKit 的手势冲突
        panGesture.delegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        // 更新动画状态
        guard let node = lastCompletedLevelNode else {
            return
        }
        // 旋转动画
        let rotateAction = SKAction.rotate(byAngle: CGFloat.pi / 2, duration: 0.2)

        // 每隔两秒执行一次动画
        if currentTime - animationTime >= rotateInterval {
            node.run(rotateAction)
            animationTime = currentTime
        }
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameCamera.removeAllActions() // 立即停止惯性移动
        // 在惯性移动时处理点击事件，你可以在这里添加点击后的逻辑
        isPanning = false
        // 在这里添加点击关卡按钮后的逻辑
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)

            for node in nodes {
                if (node.name == "img1_1")||(node.name == "img1_1_ex") {
                    load1_1()
                } else if (node.name == "img1_2")||(node.name == "img1_2_ex") {
                    load1_2()
                } else if (node.name == "img1_3")||(node.name == "img1_3_ex") {
                    load1_3()
                } else if (node.name == "img2_1")||(node.name == "img2_1_ex") {
                    load2_1()
                } else if (node.name == "img2_2")||(node.name == "img2_2_ex") {
                    load2_2()
                } else if (node.name == "img2_3")||(node.name == "img2_3_ex") {
                    load2_3()
                } else if (node.name == "img2_4")||(node.name == "img2_4_ex") {
                    load2_4()
                } else if (node.name == "img3_1")||(node.name == "img3_1_ex") {
                    load3_1()
                } else if (node.name == "img3_2")||(node.name == "img3_2_ex") {
                    load3_2()
                } else if (node.name == "img3_3")||(node.name == "img3_3_ex") {
                    load3_3()
                } else if node.name == "back" {
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
                // 添加其他关卡按钮的逻辑
            }
        }
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        gameCamera.removeAllActions() // 立即停止惯性移动
        guard let view = self.view else { return }

        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)

        if recognizer.state == .began {
            isPanning = true
        }

        if isPanning {
            moveCamera(dy: translation.y)

            recognizer.setTranslation(CGPoint.zero, in: view)

            // 惯性效果
            if recognizer.state == .ended {
                isPanning = false
                let decelerationRate: CGFloat = 0.1
                let duration = calculateDecelerationDuration(velocity: velocity.y, decelerationRate: decelerationRate)
                
                let targetY = gameCamera.position.y + project(initialVelocity: -velocity.y, decelerationRate: decelerationRate, duration: duration)
                
                // 确保targetY在界限内
                let finalPosition = CGPoint(x: gameCamera.position.x, y: max(min(targetY, maxY), minY))
                
                // 使用easeOut缓动函数实现平滑减速
                let decelerationAction = SKAction.move(to: finalPosition, duration: TimeInterval(duration))
                decelerationAction.timingMode = .easeOut

                gameCamera.run(decelerationAction)
            }
        }
    }

    func calculateDecelerationDuration(velocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
        return log(0.1) / log(decelerationRate)
    }

    func project(initialVelocity: CGFloat, decelerationRate: CGFloat, duration: CGFloat) -> CGFloat {
        return (initialVelocity / decelerationRate) * pow(decelerationRate, duration) * (1.0 - exp(-duration))
    }

    
    /*@objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let view = self.view else { return }

        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)

        moveCamera(dy: translation.y)

        recognizer.setTranslation(CGPoint.zero, in: view)

        // 在手势结束时添加减速动作
        if recognizer.state == .ended {
            // 计算减速的时间
            let decelerationTime: TimeInterval = 0.5

            // 计算减速位移
            let decelerationFactor = pow(decelerationRate, CGFloat(decelerationTime))
            let decelerationDistance = velocity.y * (1 - decelerationFactor) / (1 - decelerationRate)

            // 移动相机，确保在上下界内
            let targetY = max(min(gameCamera.position.y - decelerationDistance, maxY), minY)
            let finalPosition = CGPoint(x: gameCamera.position.x, y: targetY)

            // 使用 easeOut 动作实现减速
            let decelerationAction = SKAction.move(to: finalPosition, duration: decelerationTime)
            decelerationAction.timingMode = .easeOut

            gameCamera.run(decelerationAction)
        }
    }*/
    
    func moveCamera(dy: CGFloat) {
        // 根据手势的位移来调整相机的位置
        gameCamera.position.y -= dy
        // 确保相机不会移动得太高或太低
        gameCamera.position.y = max(minY, min(gameCamera.position.y, maxY))
    }
    
    // 设置关卡图标的可见性
        func setupLevelIconsVisibility() {
            if (currentLevel == 1) {
                self.img1.isHidden = false
                self.img2.isHidden = true
                self.img3.isHidden = true
                self.img4.isHidden = true
                self.img5.isHidden = true
                self.img6.isHidden = true
                self.img7.isHidden = true
                self.img8.isHidden = true
                self.img9.isHidden = true
                self.img10.isHidden = true
            }
            if (currentLevel == 2) {
                self.img1.isHidden = false
                self.img2.isHidden = false
                self.img3.isHidden = true
                self.img4.isHidden = true
                self.img5.isHidden = true
                self.img6.isHidden = true
                self.img7.isHidden = true
                self.img8.isHidden = true
                self.img9.isHidden = true
                self.img10.isHidden = true
            }
            if (currentLevel == 3) {
                self.img1.isHidden = false
                self.img2.isHidden = false
                self.img3.isHidden = false
                self.img4.isHidden = true
                self.img5.isHidden = true
                self.img6.isHidden = true
                self.img7.isHidden = true
                self.img8.isHidden = true
                self.img9.isHidden = true
                self.img10.isHidden = true
            }
            if (currentLevel == 4) {
                self.img1.isHidden = false
                self.img2.isHidden = false
                self.img3.isHidden = false
                self.img4.isHidden = false
                self.img5.isHidden = true
                self.img6.isHidden = true
                self.img7.isHidden = true
                self.img8.isHidden = true
                self.img9.isHidden = true
                self.img10.isHidden = true
            }
            if (currentLevel == 5) {
                self.img1.isHidden = false
                self.img2.isHidden = false
                self.img3.isHidden = false
                self.img4.isHidden = false
                self.img5.isHidden = false
                self.img6.isHidden = true
                self.img7.isHidden = true
                self.img8.isHidden = true
                self.img9.isHidden = true
                self.img10.isHidden = true
            }
            if (currentLevel == 6) {
                self.img1.isHidden = false
                self.img2.isHidden = false
                self.img3.isHidden = false
                self.img4.isHidden = false
                self.img5.isHidden = false
                self.img6.isHidden = false
                self.img7.isHidden = true
                self.img8.isHidden = true
                self.img9.isHidden = true
                self.img10.isHidden = true
            }
            if (currentLevel == 7) {
                self.img1.isHidden = false
                self.img2.isHidden = false
                self.img3.isHidden = false
                self.img4.isHidden = false
                self.img5.isHidden = false
                self.img6.isHidden = false
                self.img7.isHidden = false
                self.img8.isHidden = true
                self.img9.isHidden = true
                self.img10.isHidden = true
            }
            if (currentLevel == 8) {
                self.img1.isHidden = false
                self.img2.isHidden = false
                self.img3.isHidden = false
                self.img4.isHidden = false
                self.img5.isHidden = false
                self.img6.isHidden = false
                self.img7.isHidden = false
                self.img8.isHidden = false
                self.img9.isHidden = true
                self.img10.isHidden = true
            }
            if (currentLevel == 9) {
                self.img1.isHidden = false
                self.img2.isHidden = false
                self.img3.isHidden = false
                self.img4.isHidden = false
                self.img5.isHidden = false
                self.img6.isHidden = false
                self.img7.isHidden = false
                self.img8.isHidden = false
                self.img9.isHidden = false
                self.img10.isHidden = true
            }
            if (currentLevel == 10) {
                self.img1.isHidden = false
                self.img2.isHidden = false
                self.img3.isHidden = false
                self.img4.isHidden = false
                self.img5.isHidden = false
                self.img6.isHidden = false
                self.img7.isHidden = false
                self.img8.isHidden = false
                self.img9.isHidden = false
                self.img10.isHidden = false
            }
            self.img1e.isHidden = true
            self.img2e.isHidden = true
            self.img3e.isHidden = true
            self.img4e.isHidden = true
            self.img5e.isHidden = true
            self.img6e.isHidden = true
            self.img7e.isHidden = true
            self.img8e.isHidden = true
            self.img9e.isHidden = true
            self.img10e.isHidden = true
            self.img1u.isHidden = !self.img1.isHidden
            self.img2u.isHidden = !self.img2.isHidden
            self.img3u.isHidden = !self.img3.isHidden
            self.img4u.isHidden = !self.img4.isHidden
            self.img5u.isHidden = !self.img5.isHidden
            self.img6u.isHidden = !self.img6.isHidden
            self.img7u.isHidden = !self.img7.isHidden
            self.img8u.isHidden = !self.img8.isHidden
            self.img9u.isHidden = !self.img9.isHidden
            self.img10u.isHidden = !self.img10.isHidden
            if (currentLevel == 11 ) {
                if acceleratedLevelStatus[0] {
                    self.img1e.isHidden = false;
                    self.img1.isHidden = true;
                } else {
                    self.img1e.isHidden = true;
                    self.img1.isHidden = false;
                }
                if acceleratedLevelStatus[1] {
                    self.img2e.isHidden = false
                    self.img2.isHidden = true
                } else {
                    self.img2e.isHidden = true
                    self.img2.isHidden = false
                }
                if acceleratedLevelStatus[2] {
                    self.img3e.isHidden = false
                    self.img3.isHidden = true
                } else {
                    self.img3e.isHidden = true
                    self.img3.isHidden = false
                }
                if acceleratedLevelStatus[3] {
                    self.img4e.isHidden = false
                    self.img4.isHidden = true
                } else {
                    self.img4e.isHidden = true
                    self.img4.isHidden = false
                }
                if acceleratedLevelStatus[4] {
                    self.img5e.isHidden = false
                    self.img5.isHidden = true
                } else {
                    self.img5e.isHidden = true
                    self.img5.isHidden = false
                }
                if acceleratedLevelStatus[5] {
                    self.img6e.isHidden = false
                    self.img6.isHidden = true
                } else {
                    self.img6e.isHidden = true
                    self.img6.isHidden = false
                }
                if acceleratedLevelStatus[6] {
                    self.img7e.isHidden = false
                    self.img7.isHidden = true
                } else {
                    self.img7e.isHidden = true
                    self.img7.isHidden = false
                }
                if acceleratedLevelStatus[7] {
                    self.img8e.isHidden = false
                    self.img8.isHidden = true
                } else {
                    self.img8e.isHidden = true
                    self.img8.isHidden = false
                }
                if acceleratedLevelStatus[8] {
                    self.img9e.isHidden = false
                    self.img9.isHidden = true
                } else {
                    self.img9e.isHidden = true
                    self.img9.isHidden = false
                }
                if acceleratedLevelStatus[9] {
                    self.img10e.isHidden = false
                    self.img10.isHidden = true
                } else {
                    self.img10e.isHidden = true
                    self.img10.isHidden = false
                }
                self.img1u.isHidden = true
                self.img2u.isHidden = true
                self.img3u.isHidden = true
                self.img4u.isHidden = true
                self.img5u.isHidden = true
                self.img6u.isHidden = true
                self.img7u.isHidden = true
                self.img8u.isHidden = true
                self.img9u.isHidden = true
                self.img10u.isHidden = true
            }
        }

    func load1_1() {
        if currentLevel == 11 {
            if let view1_1ex = self.view {
                        // 创建主页面场景
                        if let game1_1ex = GameScene1_1ex(fileNamed: "GameScene1_1ex") {
                            game1_1ex.scaleMode = .aspectFill

                            // 显示主页面场景
                            view1_1ex.presentScene(game1_1ex)
                        }
                        view1_1ex.ignoresSiblingOrder = true
            }
        } else {
            if let view1_1 = self.view {
                        // 创建主页面场景
                        if let game1_1 = GameScene1_1(fileNamed: "GameScene1_1") {
                            game1_1.scaleMode = .aspectFill

                            // 显示主页面场景
                            view1_1.presentScene(game1_1)
                        }
                        view1_1.ignoresSiblingOrder = true
            }
        }
    }

    func load1_2() {
        if currentLevel == 11 {
            if let view1_2ex = self.view {
                        // 创建主页面场景
                        if let game1_2ex = GameScene1_2ex(fileNamed: "GameScene1_2ex") {
                            game1_2ex.scaleMode = .aspectFill

                            // 显示主页面场景
                            view1_2ex.presentScene(game1_2ex)
                        }
                        view1_2ex.ignoresSiblingOrder = true
            }
        } else {
            if let view1_2 = self.view {
                        // 创建主页面场景
                        if let game1_2 = GameScene1_2(fileNamed: "GameScene1_2") {
                            game1_2.scaleMode = .aspectFill

                            // 显示主页面场景
                            view1_2.presentScene(game1_2)
                        }
                        view1_2.ignoresSiblingOrder = true
            }
        }
    }
    
    func load1_3() {
        if currentLevel == 11 {
            if let view1_3ex = self.view {
                        // 创建主页面场景
                        if let game1_3ex = GameScene1_3ex(fileNamed: "GameScene1_3ex") {
                            game1_3ex.scaleMode = .aspectFill

                            // 显示主页面场景
                            view1_3ex.presentScene(game1_3ex)
                        }
                        view1_3ex.ignoresSiblingOrder = true
            }
        } else {
            if let view1_3 = self.view {
                        // 创建主页面场景
                        if let game1_3 = GameScene1_3(fileNamed: "GameScene1_3") {
                            game1_3.scaleMode = .aspectFill

                            // 显示主页面场景
                            view1_3.presentScene(game1_3)
                        }
                        view1_3.ignoresSiblingOrder = true
            }
        }
    }
    
    func load2_1() {
        if currentLevel == 11 {
            if let view2_1ex = self.view {
                        // 创建主页面场景
                        if let game2_1ex = GameScene2_1ex(fileNamed: "GameScene2_1ex") {
                            game2_1ex.scaleMode = .aspectFill

                            // 显示主页面场景
                            view2_1ex.presentScene(game2_1ex)
                        }
                        view2_1ex.ignoresSiblingOrder = true
            }
        } else {
            if let view2_1 = self.view {
                        // 创建主页面场景
                        if let game2_1 = GameScene2_1(fileNamed: "GameScene2_1") {
                            game2_1.scaleMode = .aspectFill

                            // 显示主页面场景
                            view2_1.presentScene(game2_1)
                        }
                        view2_1.ignoresSiblingOrder = true
            }
        }
    }
    
    func load2_2() {
        if currentLevel == 11 {
            if let view2_2ex = self.view {
                        // 创建主页面场景
                        if let game2_2ex = GameScene2_2ex(fileNamed: "GameScene2_2ex") {
                            game2_2ex.scaleMode = .aspectFill

                            // 显示主页面场景
                            view2_2ex.presentScene(game2_2ex)
                        }
                        view2_2ex.ignoresSiblingOrder = true
            }
        } else {
            if let view2_2 = self.view {
                        // 创建主页面场景
                        if let game2_2 = GameScene2_2(fileNamed: "GameScene2_2") {
                            game2_2.scaleMode = .aspectFill

                            // 显示主页面场景
                            view2_2.presentScene(game2_2)
                        }
                        view2_2.ignoresSiblingOrder = true
            }
        }
    }
    
    func load2_3() {
        if currentLevel == 11 {
            if let view2_3ex = self.view {
                        // 创建主页面场景
                        if let game2_3ex = GameScene2_3ex(fileNamed: "GameScene2_3ex") {
                            game2_3ex.scaleMode = .aspectFill

                            // 显示主页面场景
                            view2_3ex.presentScene(game2_3ex)
                        }
                        view2_3ex.ignoresSiblingOrder = true
            }
        } else {
            if let view2_3 = self.view {
                        // 创建主页面场景
                        if let game2_3 = GameScene2_3(fileNamed: "GameScene2_3") {
                            game2_3.scaleMode = .aspectFill

                            // 显示主页面场景
                            view2_3.presentScene(game2_3)
                        }
                        view2_3.ignoresSiblingOrder = true
            }
        }
    }
    
    func load2_4() {
        if currentLevel == 11 {
            if let view2_4ex = self.view {
                        // 创建主页面场景
                        if let game2_4ex = GameScene2_4ex(fileNamed: "GameScene2_4ex") {
                            game2_4ex.scaleMode = .aspectFill

                            // 显示主页面场景
                            view2_4ex.presentScene(game2_4ex)
                        }
                        view2_4ex.ignoresSiblingOrder = true
            }
        } else {
            if let view2_4 = self.view {
                        // 创建主页面场景
                        if let game2_4 = GameScene2_4(fileNamed: "GameScene2_4") {
                            game2_4.scaleMode = .aspectFill

                            // 显示主页面场景
                            view2_4.presentScene(game2_4)
                        }
                        view2_4.ignoresSiblingOrder = true
            }
        }
    }
    
    func load3_1() {
        if currentLevel == 11 {
            if let view3_1ex = self.view {
                        // 创建主页面场景
                        if let game3_1ex = GameScene3_1ex(fileNamed: "GameScene3_1ex") {
                            game3_1ex.scaleMode = .aspectFill

                            // 显示主页面场景
                            view3_1ex.presentScene(game3_1ex)
                        }
                        view3_1ex.ignoresSiblingOrder = true
            }
        } else {
            if let view3_1 = self.view {
                        // 创建主页面场景
                        if let game3_1 = GameScene3_1(fileNamed: "GameScene3_1") {
                            game3_1.scaleMode = .aspectFill

                            // 显示主页面场景
                            view3_1.presentScene(game3_1)
                        }
                        view3_1.ignoresSiblingOrder = true
            }
        }
    }

    func load3_2() {
        if currentLevel == 11 {
            if let view3_2ex = self.view {
                        // 创建主页面场景
                        if let game3_2ex = GameScene3_2ex(fileNamed: "GameScene3_2ex") {
                            game3_2ex.scaleMode = .aspectFill

                            // 显示主页面场景
                            view3_2ex.presentScene(game3_2ex)
                        }
                        view3_2ex.ignoresSiblingOrder = true
            }
        } else {
            if let view3_2 = self.view {
                        // 创建主页面场景
                        if let game3_2 = GameScene3_2(fileNamed: "GameScene3_2") {
                            game3_2.scaleMode = .aspectFill

                            // 显示主页面场景
                            view3_2.presentScene(game3_2)
                        }
                        view3_2.ignoresSiblingOrder = true
            }
        }
    }

    func load3_3() {
        if currentLevel == 11 {
            if let view3_3ex = self.view {
                        // 创建主页面场景
                        if let game3_3ex = GameScene3_3ex(fileNamed: "GameScene3_3ex") {
                            game3_3ex.scaleMode = .aspectFill

                            // 显示主页面场景
                            view3_3ex.presentScene(game3_3ex)
                        }
                        view3_3ex.ignoresSiblingOrder = true
            }
        } else {
            if let view3_3 = self.view {
                        // 创建主页面场景
                        if let game3_3 = GameScene3_3(fileNamed: "GameScene3_3") {
                            game3_3.scaleMode = .aspectFill

                            // 显示主页面场景
                            view3_3.presentScene(game3_3)
                        }
                        view3_3.ignoresSiblingOrder = true
            }
        }
    }

    func loadAcceleratedLevel(_ sceneName: String) {
        if let view = self.view {
            // 创建加速版关卡场景
            if let acceleratedLevelScene = SKScene(fileNamed: sceneName) {
                acceleratedLevelScene.scaleMode = .aspectFill

                // 显示加速版关卡场景
                view.presentScene(acceleratedLevelScene)
            }

            view.ignoresSiblingOrder = true
        }
    }
    
    
}
