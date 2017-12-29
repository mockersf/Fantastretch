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

    init(exercise: Exercise, settings: Settings) {
        let weight = settings.musclePreferences[exercise.muscle] ?? 1
        let rating = exercise.rating

        let latestHistory = ExerciseHistory.loadLatest(exercise: exercise)
        let lastDone = latestHistory?.date ?? Date().addingTimeInterval(TimeInterval(-settings.maxOldExerciseWeight * 24 * 60 * 60))
        let daysSinceLastDone = min(Calendar.current.dateComponents([.day], from: lastDone, to: Date()).day ?? settings.maxOldExerciseWeight,
                                    settings.maxOldExerciseWeight)

        self.exercise = exercise
        score = ExerciseWithMetadata.getScore(muscleWeight: weight, exerciseRating: rating, daysSinceLastDone: daysSinceLastDone)
        self.settings = ExerciseSettings.loadOrDefault(exercise: exercise)
    }

    static func getScore(muscleWeight: Int, exerciseRating: Int, daysSinceLastDone: Int) -> Int {
        return (muscleWeight * (1 + exerciseRating)) + (daysSinceLastDone * 2)
    }

    func updateHistory(durationDone: Int) {
        ExerciseHistory(exercise: exercise, date: Date(), duration: durationDone).save()
    }

    static func getSelectedExercisesByScore(type: ExerciseType) -> [ExerciseWithMetadata] {
        let settings = Settings()

        let exercisesOfType = Exercise.load()?
            .filter({ $0.type == type }) ?? []

        return getSelectedExercisesByScore(exercises: exercisesOfType, settings: settings)
    }

    static func getSelectedExercisesByScore(exercises: [Exercise], settings: Settings) -> [ExerciseWithMetadata] {
        let exercisesByScore = exercises
            .map({ ExerciseWithMetadata(exercise: $0, settings: settings) })
            .sorted(by: { $0.score > $1.score })

        let scores = exercisesByScore.map({ $0.score })
//        let maxScore = scores.max() ?? 0
//        let meanScore = scores.reduce(0, +) / scores.count
        let mostAreOverScore = scores[scores.count * 3 / 4]

        let firstPass = exercisesByScore.reduce([ExerciseWithMetadata](), { (acc, exercise) -> [ExerciseWithMetadata] in

            if acc.count != settings.autoNbOfExercises {
                if (!acc.map({ $0.exercise.muscle }).contains(exercise.exercise.muscle)) && (exercise.score >= mostAreOverScore) {
                    return acc + [exercise]
                }
            }

            return acc
        })

        let remaining = exercisesByScore.filter({ (exercise) -> Bool in !firstPass.contains(where: { exercise.exercise.id == $0.exercise.id }) })

        return Array(remaining.reduce(firstPass, { (acc, exercise) -> [ExerciseWithMetadata] in
            acc + [exercise]
        }).prefix(settings.autoNbOfExercises))
    }
}

class StartController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            activeExerciseTable.exercises = ExerciseWithMetadata.getSelectedExercisesByScore(type: ExerciseType.Stretch)

        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "missing segue")")
        }
    }

    // MARK: Actions

    @IBAction func unwindToStart(sender _: UIStoryboardSegue) {
    }
}
