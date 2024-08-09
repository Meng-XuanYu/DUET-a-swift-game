//
//  双重奏
//
//  Created by 炫的macbook on 2023/11/21.
//  version 0.9
import SpriteKit
import GameplayKit
class GameScene3_1ex: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate
{
    //声明游戏场景中的各个属性和节点
    var acceleratedLevelStatus: [Bool] = []
    var userDefaults = UserDefaults.standard
    // 添加一个 UIPanGestureRecognizer 对象
    var panGestureRecognizer: UIPanGestureRecognizer!
    //游戏场景镜头
    var gameCamera = SKCameraNode()
    //蓝红两球
    var rotatePoint = SKSpriteNode()
    var rotatePathNode = SKShapeNode()
    var blueBall = SKSpriteNode()
    var blueEmitter = SKEmitterNode()
    var redBall = SKSpriteNode()
    var redEmitter = SKEmitterNode()
    //阻挡物
    var blocksNode = SKSpriteNode()
    var square = SKSpriteNode()
    var rectangle = SKSpriteNode()
    var movingRectangle = SKSpriteNode()
    var spinningRectangle = SKSpriteNode()
    //labels（提示语）
    var scoreLabel = SKLabelNode()
    var timer: Double = 0.0
    var startLabel_0 = SKLabelNode()
    var startLabel_1 = SKLabelNode()
    var arrow = SKSpriteNode()
    //状态
    var isTouching: Bool = false
    var isMovable: Bool = true
    var isFast: Bool = false
    var canBoost: Bool = true
    var rotationDirection: Int = 0
    
    //初始化
    override func didMove(to view: SKView)
    {
        // 添加背景填充
        // 想实现动态背景但是没有
        let backgroundImage = SKSpriteNode(imageNamed: "sky")
        backgroundImage.position = CGPoint(x: 0, y: 0)
        backgroundImage.zPosition = -1 // 将背景放在最底层
        backgroundImage.scale(to: CGSize(width: size.width, height: size.height))
        addChild(backgroundImage)
        //获取游戏相机节点，并设置缩放动画
        gameCamera = self.childNode(withName: "gameCamera") as! SKCameraNode
        gameCamera.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.98, duration: 0.7), SKAction.scale(to: 1.02, duration: 0.7)])))
        
        //获取旋转点（中心）节点和其子节点，两个小球
        rotatePoint = self.childNode(withName: "rotatePoint") as! SKSpriteNode
        rotatePoint.position = CGPoint(x: 0.0, y: -300.0)
        blueBall = rotatePoint.childNode(withName: "blueBall") as! SKSpriteNode
        redBall = rotatePoint.childNode(withName: "redBall") as! SKSpriteNode
        
        //获取包含方块的节点，设置方块的移动动画
        blocksNode = self.childNode(withName: "blocksNode") as! SKSpriteNode
        blocksNode.run(SKAction.repeatForever(SKAction.moveBy(x: 0.0, y: -880.0, duration: 1.5)))
        //square = blocksNode.childNode(withName: "square") as! SKSpriteNode
        //rectangle = blocksNode.childNode(withName: "rectangle") as! SKSpriteNode
        //复制矩形节点，用于创建移动和旋转的矩形
        //movingRectangle = rectangle.copy() as! SKSpriteNode
        //spinningRectangle = rectangle.copy() as! SKSpriteNode
        
        //红色和蓝色小球的粒子效果，劣质版
        redEmitter = SKEmitterNode(fileNamed: "RedEmitter.sks")!
        redEmitter.particleSize = CGSize(width: 90.0, height: 90.0)
        redEmitter.targetNode = scene
        redBall.addChild(redEmitter)
        blueEmitter = SKEmitterNode(fileNamed: "BlueEmitter.sks")!
        blueEmitter.particleSize = CGSize(width: 90.0, height: 90.0)
        blueEmitter.targetNode = scene
        blueBall.addChild(blueEmitter)
        
        //分数标签的设置，开始标签和箭头标签
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        startLabel_0 = self.childNode(withName: "startLabel_0") as! SKLabelNode
        startLabel_1 = self.childNode(withName: "startLabel_1") as! SKLabelNode
        startLabel_0.run(SKAction.sequence([SKAction.fadeIn(withDuration: 1.0), SKAction.fadeOut(withDuration: 2.5)]))
        startLabel_1.run(SKAction.sequence([SKAction.fadeIn(withDuration: 1.0), SKAction.fadeOut(withDuration: 2.5)]))
        //arrow = self.childNode(withName: "arrow") as! SKSpriteNode
        
        drawPath()
        // 初始化 UIPanGestureRecognizer
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        
        // 尝试从 UserDefaults 中加载加速版关卡状态数组
            if let savedAcceleratedLevelStatus = userDefaults.array(forKey: "acceleratedLevelStatus") as? [Bool] {
                acceleratedLevelStatus = savedAcceleratedLevelStatus
            } else {
                // 如果没有保存过，初始化为全部未通过
                acceleratedLevelStatus = Array(repeating: false, count: 10)
            }
        self.physicsWorld.contactDelegate = self
    }
    
    // 处理拖动手势
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            // 拖动结束，执行处理逻辑
            isTouching = false
        }
    }

    //创建一个旋转路径的形状节点，显示旋转的轨迹
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
    
    //处理开始触碰的事件
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
    
    //处理玩家滑动手指事件
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in:self)
            //左边逆时针，右边顺时针，旋转方向控制
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
    
    //松开屏幕
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        isTouching = false
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes {
                if node.name == "back" {
                    if let view = self.view {
                                // 创建选择场景
                                if let selectionScreen = selection(fileNamed: "selection") {
                                    selectionScreen.scaleMode = .aspectFill

                                    // 显示选择场景
                                    view.presentScene(selectionScreen)
                                }

                                view.ignoresSiblingOrder = true
                    }
                }
            }
        }
    }
    
    //处理物理碰撞事件,碰上之后会死亡
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
    
    //每一帧更新游戏状态
    override public func update(_ currentTime: TimeInterval)
    {
        if (isMovable)
        {
            timer += 1/36
            scoreLabel.text = String(Int(timer))
            //非加速部分
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
            //加速部分
            if (isTouching && isFast)
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
        }
        //判定游戏结束
        if (Int(timer) == 12)
        {
            victory()//游戏结束
        }
        if (Int(timer) == 16)
        {
            levelCompleted(level: 7, isAccelerated: true)
            if let view3_2 = self.view {
                        // 创建主页面场景
                        if let game3_2 = GameScene3_2ex(fileNamed: "GameScene3_2ex") {
                            game3_2.scaleMode = .aspectFill

                            // 显示主页面场景
                            view3_2.presentScene(game3_2)
                        }
                        view3_2.ignoresSiblingOrder = true
            }
        }
    }
    
    // 在通关时调用此方法
    func levelCompleted(level: Int, isAccelerated: Bool) {
        // 确保数组长度足够，避免越界
        while acceleratedLevelStatus.count <= level {
            acceleratedLevelStatus.append(false)
        }
        
        // 更新对应关卡的加速版状态
        acceleratedLevelStatus[level] = isAccelerated
        
        // 保存加速版状态到 UserDefaults
        UserDefaults.standard.set(acceleratedLevelStatus, forKey: "acceleratedLevelStatus")
    }
    
    //旋转逻辑
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
    
    //胜利动画
    func victory() {
        let rotatePointRotate = SKAction.rotate(toAngle: CGFloat(Double.pi * 3), duration: 1.0)
        let rotatePointMoveUp = SKAction.move(to: CGPoint(x: 0, y: 300), duration: 0.5)
        let rotatePointMoveDown = SKAction.move(to: CGPoint(x: 0, y: -300), duration: 0.5)
        
        // 上升和下降的动作序列
        let moveSequence = SKAction.sequence([rotatePointMoveUp, SKAction.wait(forDuration: 1.0), rotatePointMoveDown])
        
        // 旋转和上升的动作并行执行
        let combinedMoveAction = SKAction.group([rotatePointRotate, moveSequence])
        
        // 上升、旋转和缩小的动作并行执行
        let combinedAction = SKAction.group([combinedMoveAction])
        
        rotatePoint.run(combinedAction)
        blocksNode.removeAllActions()
        
        // 放大并显示小球和粒子效果的动作序列
        let restoreAction = SKAction.group([
            SKAction.sequence([
                SKAction.wait(forDuration: 1.5),
                SKAction.run {
                    self.redBall.isHidden = false
                    self.blueBall.isHidden = false
                },
                SKAction.resize(toWidth: 1.0, height: 1.0, duration: 1.5),
            ]),
        ])
        
        // 下降、放大和显示的动作序列
        let combinedRestoreAction = SKAction.sequence([SKAction.wait(forDuration: 1.0), restoreAction])
        
        redBall.run(combinedRestoreAction)
        blueBall.run(combinedRestoreAction)
        redEmitter.run(combinedRestoreAction)
        blueEmitter.run(combinedRestoreAction)
    }
    
    //处理游戏的死亡情况
    func die(ball: SKSpriteNode)
    {
        isMovable = false
        //暂停粒子效果和动画
        gameCamera.removeAllActions()
        blocksNode.removeAllActions()
        blueEmitter.particleBirthRate = 0
        redEmitter.particleBirthRate = 0
        //创建一个新的游戏场景
        let scene = GameScene3_1ex(fileNamed: "GameScene3_1ex")
        scene!.scaleMode = .aspectFill
        //重置动画
        ball.run(SKAction.sequence([
            SKAction.resize(toWidth: 0.0, height: 0.0, duration: 1.5),
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                if let view = self.view {
                    view.presentScene(scene)
                }
            }
        ]))
    }
}
