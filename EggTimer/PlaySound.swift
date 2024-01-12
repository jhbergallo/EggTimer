//
//  playSound.swift
//  EggTimer
//
//  Created by João Bergallo on 31/10/23.
//  
//

import Foundation
import AVFoundation

final class PlaySound{
    
    var player: AVAudioPlayer?
    
    func playSound() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player?.numberOfLoops = 1
            
            if #available(iOS 14.0, *) {
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                startRepeatingVibration()
                Timer.scheduledTimer(withTimeInterval: ((player?.duration)! * 2.0), repeats: false){_ in
                    self.stopRepeatingVibration()
                }
            }
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    var vibrationTimer: Timer?
    
    func startRepeatingVibration() {
        let vibrationInterval = 0.89
        
        vibrationTimer = Timer.scheduledTimer(timeInterval: vibrationInterval, target: self, selector: #selector(triggerVibration), userInfo: nil, repeats: true)
    }
    
    @objc func triggerVibration() {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
    }
    
    func stopRepeatingVibration() {
        vibrationTimer?.invalidate()
        vibrationTimer = nil
    }
}
