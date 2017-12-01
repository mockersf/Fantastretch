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

    func updateHistory() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let exerciseHistoryMO = NSManagedObject(entity: ExerciseHistoryMO.entity(), insertInto: managedContext)
        exerciseHistoryMO.setValue(exercise.id, forKey: "id")
        exerciseHistoryMO.setValue(Date(), forKey: "date")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let activeExerciseTable = segue.destination as? ActiveExerciseTableController else {
            fatalError("zut")
        }
        let settings = Settings()

        activeExerciseTable.exercises = Exercise.load()?
            .map({ ExerciseWithMetadata(exercise: $0, settings: settings) })
            .sorted(by: { $0.score > $1.score })
    }
}
