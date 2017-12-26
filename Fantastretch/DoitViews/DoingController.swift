//
//  DoingController.swift
//  Fantastretch
//
//  Created by François Mockers on 01/12/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import SwiftySound
import UIKit

enum Steps: String {
    case Rest
    case Hold
}

enum Sides: String {
    case Left
    case Right
    case Center
    static let forEachSide = [Left, Right]
    static let once = [Center]
}

class DoingController: UIViewController {

    var exercises = [ExerciseWithMetadata]()

    var settings: Settings?

    var timer: Timer?
    var isTimerRunning = false

    var currentTimer = 0
    var currentExercise = 0
    var step = Steps.Rest
    var sides = [Sides]()
    var currentSide = 0
    var durationDone = 0

    @IBOutlet var exerciseNameLabel: UILabel!
    @IBOutlet var exercisePhoto: UIImageView!
    @IBOutlet var exerciseExplanation: UITextView!

    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var currentStepLabel: UILabel!
    @IBOutlet var currentSideLabel: UILabel!

    @IBOutlet var runControlButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var stopButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true

        settings = Settings()
        prepareExercise(index: 0)
        currentTimer = (settings?.timerRest ?? 10) * 10
        currentStepLabel.text = Steps.Rest.rawValue
        runTimer()
        durationDone = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: private functions

    func prepareExercise(index: Int) {
        let exercise = exercises[index]

        exerciseNameLabel.text = exercise.exercise.name
        exercisePhoto.image = exercise.exercise.photo
        exerciseExplanation.text = exercise.exercise.explanation

        progressLabel.text = "\(index + 1) / \(exercises.count)"

        switch exercise.exercise.sides {
        case Repeat.Once:
            sides = Sides.once
        case Repeat.EachSide:
            sides = Sides.forEachSide
        }
        currentSide = 0
        displaySide(side: sides[currentSide])
    }

    func runTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(DoingController.updateStatus)), userInfo: nil, repeats: true)
        runControlButton.setTitle("Pause", for: .normal)
        resetButton.isEnabled = false
        stopButton.isEnabled = false
    }

    func stopTimer() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
        runControlButton.setTitle("Start", for: .normal)
        resetButton.isEnabled = true
        stopButton.isEnabled = true
    }

    func done() {
        UIApplication.shared.isIdleTimerDisabled = false
        HealthKitHelper.saveWorkoutDuration(duration: durationDone)
        performSegue(withIdentifier: "DoneExercising", sender: self)
    }

    @objc func updateStatus() {
        timerLabel.text = timeString(time: currentTimer)
        currentTimer -= 1
        switch step {
        case Steps.Rest:
            if currentTimer == 10 || currentTimer == 20 || currentTimer == 30 {
                Sound.play(file: "sounds/1000Hz.wav")
            } else if currentTimer == 0 {
                durationDone += settings?.timerRest ?? 10
                currentTimer = (exercises[currentExercise].settings.duration ?? (settings?.timerHold ?? 10)) * 10
                step = Steps.Hold
                currentStepLabel.text = step.rawValue
                Sound.play(file: "sounds/2000Hz.wav")
            }
        case Steps.Hold:
            if currentTimer == 0 {
                Sound.play(file: "sounds/800Hz.wav")

                currentSide += 1
                durationDone += exercises[currentExercise].settings.duration ?? (settings?.timerHold ?? 10)
                step = Steps.Rest
                currentStepLabel.text = step.rawValue
                currentTimer = (settings?.timerRest ?? 10) * 10
                if currentSide >= sides.count {
                    exercises[currentExercise].updateHistory(durationDone: exercises[currentExercise].settings.duration ?? (settings?.timerHold ?? 10))
                    currentExercise += 1
                    if currentExercise >= exercises.count {
                        stopTimer()
                        done()
                        return
                    }
                    prepareExercise(index: currentExercise)
                } else {
                    displaySide(side: sides[currentSide])
                }
            }
        }
    }

    private func displaySide(side: Sides) {
        switch side {
        case Sides.Left:
            currentSideLabel.isEnabled = true
            currentSideLabel.text = side.rawValue
        case Sides.Right:
            currentSideLabel.isEnabled = true
            currentSideLabel.text = side.rawValue
        case Sides.Center:
            currentSideLabel.isEnabled = false
            currentSideLabel.text = ""
        }
    }

    @IBAction func runControlAction(_: UIButton) {
        switch timer {
        case nil:
            runTimer()
        default:
            stopTimer()
        }
    }

    @IBAction func resetAction(_: UIButton) {
        currentTimer = (settings?.timerRest ?? 10) * 10
        step = Steps.Rest
        currentStepLabel.text = step.rawValue
        timerLabel.text = timeString(time: currentTimer)
    }

    @IBAction func stopAction(_: UIButton) {
        stopTimer()
        done()
    }

    func timeString(time: Int) -> String {
        let minutes = time / 600
        let seconds = time / 10 % 60
        let milliseconds = time % 10
        return String(format: "%02i:%02i.%01i", minutes, seconds, milliseconds)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard let navigationController = segue.destination as? UINavigationController else {
            fatalError("Unexpected controller: \(segue.destination)")
        }
        guard let stretchTableController = navigationController.childViewControllers[0] as? StretchTableViewController else {
            fatalError("Unexpected controller: \(segue.destination)")
        }

        stretchTableController.stretches = exercises.map({ $0.exercise })
        stretchTableController.fixedSet = true
    }
}
