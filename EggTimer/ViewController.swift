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
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    let eggTimes = ["Soft": 300, "Medium": 420, "Hard": 720]
    
    var remainingTime: TimeInterval = 0
    var secondsPassed = 0
    var totalTime = 0
    var mainLabel = "How do you like your eggs?"
    
    var isTimerRunning = false
    

    var timer = Timer()
    var sound = PlaySound()
    
    @IBAction func buttons(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        
        stopButtonProp.isHidden = false
    
        remainingTime = Double(eggTimes[hardness]!)
        totalTime = eggTimes[hardness]!
        
        progressView.progress = 0.0
        titleLabel.text = hardness
        
        timer.invalidate()
        
        startTimer(withDuration: remainingTime)
    }
    
    @IBOutlet weak var stopButtonProp: UIButton!
    
    @IBAction func stopButton(_ sender: UIButton) {
        timer.invalidate()
        progressView.progress = 0.0
        stopButtonProp.isHidden = true
        titleLabel.text = mainLabel
    }
    
    @objc func updateTimer(){
        if remainingTime > 0 {
            remainingTime -= 1
            secondsPassed += 1
            progressView.progress = Float(secondsPassed)/Float(totalTime)
            isTimerRunning = true
        } else{
            isTimerRunning = false
            stopButtonProp.isHidden = true
            timer.invalidate()
            titleLabel.text = "Done!"
            sound.playSound()
        
            
            timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false){_ in
                self.titleLabel.text = self.mainLabel
                self.progressView.progress = 0.0
            }
        }
    }
    
    func startBackgroundTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // Save the timer state
    func saveTimerState() {
        // Save the remaining time and timer state
        UserDefaults.standard.set(remainingTime, forKey: "RemainingTime")
        UserDefaults.standard.set(isTimerRunning, forKey: "IsTimerRunning")
    }

    // Restore the timer state
    func restoreTimerState() {
        // Retrieve the saved remaining time and timer state
        
        if let savedRemainingTime = UserDefaults.standard.value(forKey: "RemainingTime") as? TimeInterval,
            let savedIsTimerRunning = UserDefaults.standard.value(forKey: "IsTimerRunning") as? Bool {
            remainingTime = savedRemainingTime
            isTimerRunning = savedIsTimerRunning
            if isTimerRunning {
                startBackgroundTimer()
            }
        }
    }
    
    func startTimer(withDuration duration: TimeInterval) {
        if !isTimerRunning {
            isTimerRunning = true
            remainingTime = duration

            // Create and schedule a timer that fires every second
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                updateTimer()
            }
        }
    }
}
