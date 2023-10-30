//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Forked by João Bergallo on 30/10/2023
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    let eggTimes = ["Soft": 300, "Medium": 420, "Hard": 720]
    
    var totalTime = 0
    var secondsPassed = 0
    var mainLabel = "How do you like your eggs?"

    var timer = Timer()
    
    @IBAction func buttons(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        
        
        stopButtonProp.isHidden = false
    
        totalTime = eggTimes[hardness]!
        secondsPassed = 0
        
        progressView.progress = 0.0
        titleLabel.text = hardness
        
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @IBOutlet weak var stopButtonProp: UIButton!
    
    @IBAction func stopButton(_ sender: UIButton) {
        timer.invalidate()
        progressView.progress = 0.0
        secondsPassed = 0
        stopButtonProp.isHidden = true
        titleLabel.text = mainLabel
    }
    
    @objc func updateTimer(){
        if secondsPassed < totalTime {
            secondsPassed += 1
            progressView.progress = Float(secondsPassed)/Float(totalTime)
        } else{
            stopButtonProp.isHidden = true
            timer.invalidate()
            titleLabel.text = "Done!"
            playSound()
            
            timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false){_ in
                self.titleLabel.text = self.mainLabel
                self.progressView.progress = 0.0
            }
        }
    }
    
    var player: AVAudioPlayer?

    func playSound() {
        if #available(iOS 14.5, *) {
             UIImpactFeedbackGenerator(style: .medium).impactOccurred()
          }
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


            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
