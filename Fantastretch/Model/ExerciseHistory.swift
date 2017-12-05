//
//  ExerciseHistory.swift
//  Fantastretch
//
//  Created by François Mockers on 04/12/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit
import CoreData

class ExerciseHistory {
    let exerciseId: UUID
    let date: Date
    let duration: Int

    init(exerciseId: UUID, date: Date, duration: Int) {
        self.exerciseId = exerciseId
        self.date = date
        self.duration = duration
    }

    convenience init(exercise: Exercise, date: Date, duration: Int) {
        self.init(exerciseId: exercise.id, date: date, duration: duration)
    }

    func save() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let exerciseHistoryMO = NSManagedObject(entity: ExerciseHistoryMO.entity(), insertInto: managedContext)
        exerciseHistoryMO.setValue(exerciseId, forKey: "id")
        exerciseHistoryMO.setValue(date, forKey: "date")
        exerciseHistoryMO.setValue(duration, forKey: "duration")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    convenience init?(exerciseHistoryMO: ExerciseHistoryMO) {
        if let id = exerciseHistoryMO.id,
            let date = exerciseHistoryMO.date {
            self.init(exerciseId: id, date: date, duration: Int(exerciseHistoryMO.duration))
        } else {
            return nil
        }
    }

    static func loadAll(exercise: Exercise) -> [ExerciseHistory] {
        var history = [ExerciseHistory]()
        if let appDelegate =
            UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fr: NSFetchRequest<ExerciseHistoryMO> = ExerciseHistoryMO.fetchRequest()
            let predicate = NSPredicate(format: "id==%@", argumentArray: [exercise.id])
            let sort = NSSortDescriptor(key: #keyPath(ExerciseHistoryMO.date), ascending: false)
            fr.predicate = predicate
            fr.sortDescriptors = [sort]
            do {
                let historyMOs = try managedContext.fetch(fr)
                history.append(contentsOf: historyMOs.map({ ExerciseHistory(exerciseHistoryMO: $0) })
                    .filter({ $0 != nil }).map({ $0! }))
            } catch {
                print("Cannot fetch history for exercise \(exercise.id)")
            }
        }
        return history
    }

    static func loadLatest(exercise: Exercise) -> ExerciseHistory? {
        var history: ExerciseHistory?
        if let appDelegate =
            UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fr: NSFetchRequest<ExerciseHistoryMO> = ExerciseHistoryMO.fetchRequest()
            let predicate = NSPredicate(format: "id==%@", argumentArray: [exercise.id])
            let sort = NSSortDescriptor(key: #keyPath(ExerciseHistoryMO.date), ascending: false)
            fr.predicate = predicate
            fr.fetchLimit = 1
            fr.sortDescriptors = [sort]
            do {
                let historyMOs = try managedContext.fetch(fr)
                history = historyMOs.first.flatMap({ ExerciseHistory(exerciseHistoryMO: $0) })
            } catch {
                print("Cannot fetch history for exercise \(exercise.id)")
            }
        }
        return history
    }
}
