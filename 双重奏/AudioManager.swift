//
//  AudioManager.swift
//  双重奏
//
//  Created by 炫的macbook on 2023/11/26.
//  Copyright © 2023 CTEC. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()

    var backgroundMusic: AVAudioPlayer?

    private init() {}

    func playBackgroundMusic() {
        DispatchQueue.global(qos: .background).async {
            if let musicURL = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
                do {
                    self.backgroundMusic = try AVAudioPlayer(contentsOf: musicURL)
                    self.backgroundMusic?.numberOfLoops = -1
                    self.backgroundMusic?.volume = 0.1
                    self.backgroundMusic?.prepareToPlay()
                    self.backgroundMusic?.play()
                } catch {
                    print("Error loading background music: \(error.localizedDescription)")
                }
            } else {
                print("Error: Could not find background_music.mp3")
            }
        }
    }

    
    func stopBackgroundMusic() {
        if let backgroundMusic = backgroundMusic {
            backgroundMusic.stop()
        }
    }

}

