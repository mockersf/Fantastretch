//
//  StartController.swift
//  Fantastretch
//
//  Created by François Mockers on 28/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import CoreData
import UIKit

struct ExerciseWithMetadata {
    let exercise: Exercise
    let settings: ExerciseSettings
    let score: Int

    init(exercise: Exercise, userSettings _: Settings, exerciseTypeSettings: SettingsExerciseType) {
        let weight = exerciseTypeSettings.musclePreferences[exercise.muscle.getMuscle(settings: exerciseTypeSettings)] ?? 1
        let rating = exercise.rating

        let latestHistory = ExerciseHistory.loadLatest(exercise: exercise)
        let lastDone = latestHistory?.date ?? Date().addingTimeInterval(TimeInterval(-Settings.maxOldExerciseWeight * 24 * 60 * 60))
        let daysSinceLastDone = min(Calendar.current.dateComponents([.day], from: lastDone, to: Date()).day ?? Settings.maxOldExerciseWeight,
                                    Settings.maxOldExerciseWeight)

        self.exercise = exercise
        score = ExerciseWithMetadata.getScore(muscleWeight: weight, exerciseRating: rating, daysSinceLastDone: daysSinceLastDone)
        print("computing score for \(exercise): -rating \(rating), -muscle \(weight), -days \(daysSinceLastDone) --> \(score)")
        settings = ExerciseSettings.loadOrDefault(exercise: exercise)
    }

    static func getScore(muscleWeight: Int, exerciseRating: Int, daysSinceLastDone: Int) -> Int {
        return Int((Float(muscleWeight * (1 + exerciseRating))) + Float(daysSinceLastDone) * 1.5)
    }

    func updateHistory(durationDone: Int) {
        ExerciseHistory(exercise: exercise, date: Date(), duration: durationDone).save()
    }

    static func getSelectedExercisesByScore(filter: (Exercise) -> Bool, exerciseTypeSettings: SettingsExerciseType) -> [ExerciseWithMetadata] {
        let settings = Settings.sharedInstance

        let exercisesOfType = Exercise.load()?
            .filter(filter) ?? []

        return getSelectedExercisesByScore(exercises: exercisesOfType, userSettings: settings, exerciseTypeSettings: exerciseTypeSettings)
    }

    static func getSelectedExercisesByScore(exercises: [Exercise], userSettings: Settings, exerciseTypeSettings: SettingsExerciseType) -> [ExerciseWithMetadata] {
        let exercisesByScore = exercises
            .map({ ExerciseWithMetadata(exercise: $0, userSettings: userSettings, exerciseTypeSettings: exerciseTypeSettings) })
            .sorted(by: { $0.score > $1.score })
        print("\(exercisesByScore)")

        let scores = exercisesByScore.map({ $0.score })
        let maxScore = scores.max() ?? 0
        let meanScore = scores.reduce(0, +) / scores.count
        let mostAreOverScore = scores[scores.count * 3 / 4]
        print("scores: \(scores), max: \(maxScore), mean: \(meanScore), 3/4: \(mostAreOverScore)")

        let firstPass = exercisesByScore.reduce([ExerciseWithMetadata](), { (acc, exercise) -> [ExerciseWithMetadata] in

            if (!acc.map({ $0.exercise.muscle.getMuscle(settings: exerciseTypeSettings) }).contains(exercise.exercise.muscle.getMuscle(settings: exerciseTypeSettings))) && (exercise.score >= meanScore) {
                return acc + [exercise]
            }

            return acc
        })
        print("firstpass: \(firstPass)")

        let remaining = exercisesByScore.filter({ (exercise) -> Bool in !firstPass.contains(where: { exercise.exercise.id == $0.exercise.id }) })
        print("remaining: \(remaining)")

        let singleRun = Array(remaining.reduce(firstPass, { (acc, exercise) -> [ExerciseWithMetadata] in
            acc + [exercise]
        }).prefix(exerciseTypeSettings.nbOfExercises))

        var result = [ExerciseWithMetadata]()
        for _ in 1 ... exerciseTypeSettings.nbRepetitions {
            result += singleRun
        }
        return result
    }
}

class StartController: UIViewController {

    @IBOutlet var startAutoStretch: UIButton!
    @IBOutlet var startAutoExercise: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_: Bool) {
        let exercises = Exercise.load() ?? []
        if exercises.filter({ $0.getMetaType() == MetaExerciseType.Stretch }).count == 0 {
            startAutoStretch.isEnabled = false
        }
        if exercises.filter({ $0.getMetaType() == MetaExerciseType.Strength }).count == 0 {
            startAutoExercise.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {

        switch segue.identifier ?? "" {
        case "startAutoStretch":
            guard let activeExerciseTable = segue.destination as? ActiveExerciseTableController else {
                fatalError("zut")
            }
            let settings = Settings.sharedInstance
            activeExerciseTable.exercises = ExerciseWithMetadata.getSelectedExercisesByScore(filter: { $0.getMetaType() == MetaExerciseType.Stretch }, exerciseTypeSettings: settings.autoStretchSettings)

        case "startAutoExercise":
            guard let activeExerciseTable = segue.destination as? ActiveExerciseTableController else {
                fatalError("zut")
            }
            let settings = Settings.sharedInstance
            activeExerciseTable.exercises = ExerciseWithMetadata.getSelectedExercisesByScore(filter: { $0.getMetaType() == MetaExerciseType.Strength }, exerciseTypeSettings: settings.autoExerciseSettings)

        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "missing segue")")
        }
    }

    // MARK: Actions

    @IBAction func unwindToStart(sender _: UIStoryboardSegue) {
    }
}
