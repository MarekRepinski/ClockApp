//
//  ViewController.swift
//  ClockApp
//
//  Created by Marek Repinski on 2020-12-09.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var p2StopButton: UIButton!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var pauseTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var whiteDraws: UILabel!
    @IBOutlet weak var blackDraws: UILabel!
    
    let formatter = DateFormatter()
    var timer: Timer?
    var timerP: Timer?
    var stopTime = Date()
    var startTime = Date()
    var runTime: TimeInterval = 0.0
    var pauseTime: TimeInterval = 0.0
    var maxTime: Double = 0.0
    var whiteMoves = 0
    var blackMoves = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        p2StopButton.setTitle("", for: .normal)
        startStopButton.setTitle("Start New Game", for: .normal)
        formatter.timeStyle = .medium
        maxTime = 5.0 * 60.0
        runTimeLabel.text = converToTimeString(0.0)
        pauseTimeLabel.text = converToTimeString(0.0)
        whiteDraws.text = "(" + String(whiteMoves) + ")"
        blackDraws.text = "(" + String(blackMoves) + ")"
    }
    
    @IBAction func sliderChange(_ sender: Any) {
        if startStopButton.currentTitle == "Start New Game" {
            let minuteVal = Int(timeSlider.value * 115) + 5
            maxTime = Double(minuteVal) * 60
            runTimeLabel.text = converToTimeString(0.0)
            pauseTimeLabel.text = converToTimeString(0.0)
        }
    }
    
    @IBAction func p2Action(_ sender: Any) {
        if p2StopButton.currentTitle == "Stop" {
            blackMoves += 1
            blackDraws.text = "(" + String(blackMoves) + ")"
            p2StopButton.setTitle("", for: .normal)
            startStopButton.setTitle("Stop", for: .normal)
            if let timerP = timerP {
                timerP.invalidate()
                startTime = Date()
                pauseTime += startTime.timeIntervalSince(stopTime)
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: updateTimeLabel(t:))
            }
        }
    }
    
    @IBAction func startStopAction(_ sender: Any) {
        if startStopButton.currentTitle == "Stop" {
            whiteMoves += 1
            whiteDraws.text = "(" + String(whiteMoves) + ")"
            startStopButton.setTitle("", for: .normal)
            p2StopButton.setTitle("Stop", for: .normal)
            if let timer = timer {
                timer.invalidate()
                stopTime = Date()
                runTime += stopTime.timeIntervalSince(startTime)
                runTimeLabel.text = converToTimeString(runTime)
                timerP = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: updatePauseTimeLabel(t:))
            }
        } else if startStopButton.currentTitle == "Start New Game" {
            blackMoves = 0
            whiteMoves = 0
            whiteDraws.text = "(" + String(whiteMoves) + ")"
            blackDraws.text = "(" + String(blackMoves) + ")"
            runTimeLabel.text = converToTimeString(0.0)
            pauseTimeLabel.text = converToTimeString(0.0)
            startStopButton.setTitle("Stop", for: .normal)
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: updateTimeLabel(t:))
        }
    }
    
    func updateTimeLabel(t: Timer? = nil){
        var rTime = runTime
        rTime += Date().timeIntervalSince(startTime)
        if rTime < maxTime {
            runTimeLabel.text = converToTimeString(rTime)
        } else {
            runTimeLabel.text = "White Loses"
            startStopButton.setTitle("Start New Game", for: .normal)
            timer?.invalidate()
        }
    }

    func updatePauseTimeLabel(t: Timer? = nil){
        var rTime = pauseTime
        rTime += Date().timeIntervalSince(stopTime)
        if rTime < maxTime {
            pauseTimeLabel.text = converToTimeString(rTime)
        } else {
            pauseTimeLabel.text = "Black Loses"
            p2StopButton.setTitle("", for: .normal)
            startStopButton.setTitle("Start New Game", for: .normal)
            timerP?.invalidate()
        }
    }

    func converToTimeString(_ sek: Double) -> String {
        var rc = ""
        var sec = Int(maxTime - sek)
        var min = sec / 60
        sec = sec % 60
        let h = min / 60
        min = min % 60
        
        if sec < 10 {
            rc = ":0" + String(sec)
        } else {
            rc = ":" + String(sec)
        }
        
        if min < 10 {
            rc = String(h) + ":0" + String(min) + rc
        } else {
            rc = String(h) + ":" + String(min) + rc
        }
        
        return rc
    }
    
    deinit {
        timer?.invalidate()
        timerP?.invalidate()
    }
}

