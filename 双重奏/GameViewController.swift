//
//  双重奏
//
//  Created by 炫的macbook on 2023/11/21.
//  负责管理游戏场景的视图控制器
//  version 0.9
import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
class GameViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
                    // 创建主页面场景
                    if let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene") {
                        mainMenuScene.scaleMode = .aspectFill

                        // 显示主页面场景
                        view.presentScene(mainMenuScene)
                    }

                    view.ignoresSiblingOrder = true
        }
        //配置SKView
        /*if let view = self.view as! SKView?
        {
            // 从"gamescene.sks"加载SKScene
            if let scene = GameScene(fileNamed: "GameScene1")
            {
                // 设置scene的缩放模式
                scene.scaleMode = .aspectFill
                
                // 呈现场景
                view.presentScene(scene)
            }
            
            //view.ignoresSiblingOrder = true
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }*/
        
        /* 设置音频文件的路径
                if let backgroundMusicURL = Bundle.main.url(forResource: "your_background_music_file", withExtension: "mp3") {
                    do {
                        // 初始化音频播放器
                        backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL)
                        
                        // 设置音乐循环播放
                        backgroundMusicPlayer?.numberOfLoops = -1
                        
                        // 播放音频
                        backgroundMusicPlayer?.play()
                    } catch {
                        // 处理错误
                        print("Error loading background music: \(error)")
                    }*/
        //音乐正在找，代码应该没问题
    }

    //不允许视图自动旋转
    override var shouldAutorotate: Bool
    {
        return false
    }
    
    /*
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            return .allButUpsideDown
        }
        else
        {
            return .all
        }
    }
    */

     

    /*override var prefersStatusBarHidden: Bool
    {
        return false
    }*/
}
