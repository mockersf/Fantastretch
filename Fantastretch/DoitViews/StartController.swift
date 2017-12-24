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
    }

    static func getScore(muscleWeight: Int, exerciseRating: Int, daysSinceLastDone: Int) -> Int {
        return (muscleWeight * (1 + exerciseRating)) + (daysSinceLastDone * 2)
    }

    func updateHistory(durationDone: Int) {
        ExerciseHistory(exercise: exercise, date: Date(), duration: durationDone).save()
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
        guard let activeExerciseTable = segue.destination as? ActiveExerciseTableController else {
            fatalError("zut")
        }
        let settings = Settings()

        let exercisesByScore = Exercise.load()?
            .map({ ExerciseWithMetadata(exercise: $0, settings: settings) })
            .sorted(by: { $0.score > $1.score }) ?? []

        activeExerciseTable.exercises = exercisesByScore.choose(settings.autoNbOfExercises, outOf: Int(Double(settings.autoNbOfExercises) * 1.5))
    }

    // MARK: Actions

    @IBAction func unwindToStart(sender _: UIStoryboardSegue) {
    }
}
