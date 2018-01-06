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
    case Move
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

    var restTime = Settings.defaultTimerRest
    var holdTime = Settings.defaultTimerHold
    var defaultHoldTime = Settings.defaultTimerHold

    @IBOutlet var exerciseNameLabel: UILabel!
    @IBOutlet var exercisePhoto: UIImageView!
    @IBOutlet var exerciseExplanation: UITextView!

    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var currentStepLabel: UILabel!
    @IBOutlet var currentSideLabel: UILabel!
    @IBOutlet var currentProgress: UIProgressView!

    @IBOutlet var runControlButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var stopButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true

        settings = Settings.sharedInstance
        prepareExercise(index: 0)
        currentTimer = (settings?.timerRest ?? Settings.defaultTimerRest) * 10
        currentStepLabel.text = Steps.Rest.rawValue
        runTimer()
        durationDone = 0
        currentProgress.progress = 0
        restTime = settings?.timerRest ?? Settings.defaultTimerRest
        holdTime = settings?.timerHold ?? Settings.defaultTimerHold
        defaultHoldTime = settings?.timerHold ?? Settings.defaultTimerHold
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
        if exercises.filter({ $0.exercise.getMetaType() == MetaExerciseType.Stretch }).count > exercises.filter({ $0.exercise.getMetaType() == MetaExerciseType.Strength }).count {
            HealthKitHelper.saveWorkoutDuration(duration: durationDone, workoutType: .Stretch)
        } else {
            HealthKitHelper.saveWorkoutDuration(duration: durationDone, workoutType: .Strength)
        }
        performSegue(withIdentifier: "DoneExercising", sender: self)
    }

    @objc func updateStatus() {
        timerLabel.text = timeString(time: currentTimer)
        currentTimer -= 1
        switch step {
        case Steps.Rest:
            currentProgress.progress = 1 - Float(currentTimer) / (Float(restTime) * 10)
            if currentTimer == 10 || currentTimer == 20 || currentTimer == 30 {
                Sound.play(file: "sounds/1000Hz.wav")
            } else if currentTimer == 0 {
                durationDone += restTime
                holdTime = exercises[currentExercise].settings.duration ?? defaultHoldTime
                currentTimer = holdTime * 10
                switch exercises[currentExercise].exercise.type {
                case ExerciseType.Isometric, ExerciseType.Stretch:
                    step = Steps.Hold
                case ExerciseType.Exercise, ExerciseType.WarmUp:
                    step = Steps.Move
                }
                currentStepLabel.text = step.rawValue
                Sound.play(file: "sounds/2000Hz.wav")
            }
        case Steps.Hold, Steps.Move:
            currentProgress.progress = 1 - Float(currentTimer) / (Float(holdTime) * 10)
            if currentTimer == 0 {
                Sound.play(file: "sounds/800Hz.wav")

                currentSide += 1
                durationDone += holdTime
                step = Steps.Rest
                currentStepLabel.text = step.rawValue
                currentTimer = restTime * 10
                if currentSide >= sides.count {
                    exercises[currentExercise].updateHistory(durationDone: exercises[currentExercise].settings.duration ?? (settings?.timerHold ?? Settings.defaultTimerHold))
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
        currentTimer = (settings?.timerRest ?? Settings.defaultTimerRest) * 10
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

        stretchTableController.exercises = exercises.reduce([Exercise](), { acc, exercise in
            if acc.map({ $0.id }).contains(exercise.exercise.id) {
                return acc
            }
            return acc + [exercise.exercise]
        }).reduce([:], { acc, exercise in
            acc?.merging([exercise.type: [exercise]], uniquingKeysWith: { $0 + $1 })
        })!
        stretchTableController.fixedSet = true
    }
}
