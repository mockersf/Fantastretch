//
//  ExerciseSettings.swift
//  Fantastretch
//
//  Created by François Mockers on 25/12/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import CoreData
import UIKit

class ExerciseSettings {
    let exerciseId: UUID
    var duration: Int?

    init(exerciseId: UUID, duration: Int?) {
        self.exerciseId = exerciseId
        if let duration = duration {
            if duration != 0 {
                self.duration = duration
            } else {
                self.duration = nil
            }
        } else {
            self.duration = nil
        }
    }

    convenience init(exercise: Exercise, duration: Int?) {
        self.init(exerciseId: exercise.id, duration: duration)
    }

    func save() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        let exerciseSettingsMO = NSManagedObject(entity: ExerciseSettingsMO.entity(), insertInto: managedContext)
        exerciseSettingsMO.setValue(exerciseId, forKey: "id")
        exerciseSettingsMO.setValue(duration, forKey: "duration")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    convenience init?(exerciseSettingsMO: ExerciseSettingsMO) {
        if let id = exerciseSettingsMO.id {
            self.init(exerciseId: id, duration: Int(exerciseSettingsMO.duration))
        } else {
            return nil
        }
    }

    static func loadAll() -> [ExerciseSettings] {
        var settings = [ExerciseSettings]()
        if let appDelegate =
            UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fr: NSFetchRequest<ExerciseSettingsMO> = ExerciseSettingsMO.fetchRequest()
            do {
                let settingsMOs = try managedContext.fetch(fr)
                settings.append(contentsOf: settingsMOs.map({ ExerciseSettings(exerciseSettingsMO: $0) })
                    .filter({ $0 != nil }).map({ $0! }))
            } catch {
                print("Cannot fetch settings")
            }
        }
        return settings
    }

    static func load(exercise: Exercise) -> ExerciseSettings? {
        var settings: ExerciseSettings?
        if let appDelegate =
            UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fr: NSFetchRequest<ExerciseSettingsMO> = ExerciseSettingsMO.fetchRequest()
            let predicate = NSPredicate(format: "id==%@", argumentArray: [exercise.id])
            fr.predicate = predicate
            do {
                let settingsMOs = try managedContext.fetch(fr)
                settings = settingsMOs.first.flatMap({ ExerciseSettings(exerciseSettingsMO: $0) })
            } catch {
                print("Cannot fetch settings for exercise \(exercise.id)")
            }
        }
        return settings
    }

    static func loadOrDefault(exercise: Exercise) -> ExerciseSettings {
        return load(exercise: exercise) ?? ExerciseSettings(exercise: exercise, duration: nil)
    }
}
