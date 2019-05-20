//
//  SoundControlsExtension.swift
//  2048 for VK
//
//  Created by Влад Дьяков on 20/05/2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import AVFoundation

extension GameViewController {
    
    ///
    /**
        Plays sound
     */
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "bump", withExtension: "wav") else { return }
        
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            } else {
                // Fallback on earlier versions
            }
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = player else { return }
            
            player.stop()
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
