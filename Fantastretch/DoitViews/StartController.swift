//
//  StartController.swift
//  Fantastretch
//
//  Created by François Mockers on 28/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit
import CoreData

struct ExerciseWithMetadata {
    let exercise: Exercise
    let daysSinceLastDone: Int
    let score: Int

    init(exercise: Exercise, settings: Settings) {
        let weight = settings.musclePreferences[exercise.muscle] ?? 1
        let rating = exercise.rating

        var daysSinceLastDone = settings.maxOldExerciseWeight
        if let appDelegate =
            UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fr: NSFetchRequest<ExerciseHistoryMO> = ExerciseHistoryMO.fetchRequest()
            let predicate = NSPredicate(format: "id==%@", argumentArray: [exercise.id])
            let sort = NSSortDescriptor(key: #keyPath(ExerciseHistoryMO.date), ascending: false)
            fr.predicate = predicate
            fr.sortDescriptors = [sort]
            do {
                let history = try managedContext.fetch(fr)
                let lastDone = history.first?.date ?? Date().addingTimeInterval(TimeInterval(-settings.maxOldExerciseWeight * 24 * 60 * 60))
                daysSinceLastDone = min(Calendar.current.dateComponents([.day], from: lastDone, to: Date()).day ?? settings.maxOldExerciseWeight,
                                        settings.maxOldExerciseWeight)
            } catch {
                print("Cannot fetch history for exercise \(exercise.id)")
            }
        }

        self.exercise = exercise
        self.daysSinceLastDone = daysSinceLastDone
        score = ExerciseWithMetadata.getScore(muscleWeight: weight, exerciseRating: rating, daysSinceLastDone: daysSinceLastDone)
    }

    static func getScore(muscleWeight: Int, exerciseRating: Int, daysSinceLastDone: Int) -> Int {
        return (muscleWeight * (1 + exerciseRating)) + (daysSinceLastDone * 2)
    }

    func updateHistory(durationDone: Int) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let exerciseHistoryMO = NSManagedObject(entity: ExerciseHistoryMO.entity(), insertInto: managedContext)
        exerciseHistoryMO.setValue(exercise.id, forKey: "id")
        exerciseHistoryMO.setValue(Date(), forKey: "date")
        exerciseHistoryMO.setValue(durationDone, forKey: "duration")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension Array {
    /// Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }

    /// Shuffles this sequence in place
    @discardableResult
    mutating func shuffle() -> Array {
        let count = self.count
        indices.lazy.dropLast().forEach {
            swapAt($0, Int(arc4random_uniform(UInt32(count - $0))) + $0)
        }
        return self
    }

    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int, outOf m: Int) -> Array { return Array(Array(prefix(m)).shuffled.prefix(n)) }
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
