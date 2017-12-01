//
//  DoingController.swift
//  Fantastretch
//
//  Created by François Mockers on 01/12/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

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

    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exercisePhoto: UIImageView!
    @IBOutlet weak var exerciseExplanation: UITextView!

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var currentStepLabel: UILabel!
    @IBOutlet weak var currentSideLabel: UILabel!

    @IBOutlet weak var runControlButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true

        settings = Settings()
        prepareExercise(index: 0)
        currentTimer = settings?.timerRest ?? 10
        currentStepLabel.text = Steps.Rest.rawValue
        runTimer()
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
        currentSideLabel.text = sides[currentSide].rawValue
    }

    func runTimer() {
        guard timer == nil else { return }
        print("starting timer")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(DoingController.updateStatus)), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        guard timer != nil else { return }
        print("stopping timer")
        timer?.invalidate()
        timer = nil
    }

    func done() {
        print("done exercising")
        UIApplication.shared.isIdleTimerDisabled = false
        performSegue(withIdentifier: "DoneExercising", sender: self)
    }

    @objc func updateStatus() {
        timerLabel.text = "\(currentTimer)"
        switch currentTimer {
        case 0:
            switch step {
            case Steps.Rest:
                currentTimer = settings?.timerHold ?? 10
                step = Steps.Hold
                currentStepLabel.text = step.rawValue
            case Steps.Hold:
                currentSide += 1
                if currentSide >= sides.count {
                    exercises[currentExercise].updateHistory(durationDone: settings?.timerHold ?? 10)
                    currentTimer = settings?.timerRest ?? 10
                    step = Steps.Rest
                    currentStepLabel.text = step.rawValue
                    currentExercise += 1
                    if currentExercise >= exercises.count {
                        stopTimer()
                        done()
                        return
                    }
                    prepareExercise(index: currentExercise)
                } else {
                    currentSideLabel.text = sides[currentSide].rawValue
                    currentTimer = settings?.timerRest ?? 10
                    step = Steps.Rest
                    currentStepLabel.text = step.rawValue
                }
            }
        default:
            currentTimer -= 1
        }
    }
}
