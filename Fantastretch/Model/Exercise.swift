//
//  Stretch.swift
//  Fantastretch
//
//  Created by François Mockers on 19/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import CoreData
import os.log
import UIKit

enum Repeat: String, AutoEnumAllCases {
    case Once
    case EachSide = "For Each Side"

    static let defaultCase = Once
}

enum Muscle: String, AutoEnumAllCases {
    case Triceps
    case Biceps
    case Forearms
    case Shoulders
    case Back
    case Chest
    case Abs
    case AbsExternalOblique = "Abs - External Oblique"
    case AbsInternalOblique = "Abs - Internal Oblique"
    case AbsRectus = "Abs - Rectus"
    case AbsTransverse = "Abs - Transverse"
    case Glutes
    case Quads
    case HipFlexors = "Hip Flexors"
    case Hamstrings
    case Calves
    case Global

    static let defaultCase = Global
}

extension Muscle {
    static func getAllMuscles(settings: SettingsExerciseType) -> [Muscle] {
        return Muscle.allCases.filter({ muscle -> Bool in
            if !settings.advancedAbs {
                return ![.AbsExternalOblique, .AbsInternalOblique, .AbsTransverse, .AbsRectus].contains(muscle)
            }
            return true
        })
    }

    func getMuscle(settings: SettingsExerciseType) -> Muscle {
        switch self {
        case .AbsExternalOblique: return settings.advancedAbs ? self : .Abs
        case .AbsInternalOblique: return settings.advancedAbs ? self : .Abs
        case .AbsTransverse: return settings.advancedAbs ? self : .Abs
        case .AbsRectus: return settings.advancedAbs ? self : .Abs
        default: return self
        }
    }
}

enum ExerciseType: String, AutoEnumAllCases {
    case WarmUp = "Warm Up"
    case Stretch
    case Exercise
    case Isometric

    static let defaultCase = Stretch
}

enum MetaExerciseType {
    case Stretch
    case Strength
    case WarmUp
}

class Exercise: CustomStringConvertible {

    // MARK: Properties

    var name: String
    var explanation: String
    var photo: UIImage?
    var rating: Int
    var sides: Repeat
    var muscle: Muscle
    var id: UUID
    var type: ExerciseType

    var description: String {
        return "<\(name) (\(muscle) - \(sides))>"
    }

    // MARK: Initialization

    init?(name: String, explanation: String, photo: UIImage?, rating: Int, sides: Repeat, muscle: Muscle, type: ExerciseType, id: UUID?) {

        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }

        // Initialize stored properties.
        self.name = name
        self.explanation = explanation
        self.photo = photo
        self.rating = rating
        self.sides = sides
        self.muscle = muscle
        self.id = id ?? UUID()
        self.type = type
    }

    convenience init?(mo exerciseMO: ExerciseMO) {
        self.init(name: exerciseMO.name ?? "", explanation: exerciseMO.explanation ?? "",
                  photo: exerciseMO.image.flatMap({ (data) -> UIImage in UIImage(data: data)! }), rating: Int(exerciseMO.rating),
                  sides: Repeat(rawValue: exerciseMO.sides ?? "") ?? Repeat.defaultCase,
                  muscle: Muscle(rawValue: exerciseMO.muscle ?? "") ?? Muscle.defaultCase,
                  type: ExerciseType(rawValue: exerciseMO.type ?? "") ?? ExerciseType.defaultCase, id: exerciseMO.id)
    }

    func getMetaType() -> MetaExerciseType {
        switch type {
        case .Stretch: return MetaExerciseType.Stretch
        case .Exercise, .Isometric: return MetaExerciseType.Strength
        case .WarmUp: return MetaExerciseType.WarmUp
        }
    }

    func getSettings() -> ExerciseSettings {
        return ExerciseSettings.loadOrDefault(exercise: self)
    }

    static func load() -> [Exercise]? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<ExerciseMO> = ExerciseMO.fetchRequest()

        do {
            let exerciseMOs = try managedContext.fetch(fetchRequest)
            return exerciseMOs.map({ Exercise(mo: $0)! })
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }

    func save() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let exerciseMO = NSManagedObject(entity: ExerciseMO.entity(), insertInto: managedContext)
        exerciseMO.setValue(id, forKey: "id")
        exerciseMO.setValue(name, forKey: "name")
        exerciseMO.setValue(explanation, forKey: "explanation")
        exerciseMO.setValue(muscle.rawValue, forKey: "muscle")
        exerciseMO.setValue(sides.rawValue, forKey: "sides")
        exerciseMO.setValue(photo.flatMap { UIImagePNGRepresentation($0) }, forKey: "image")
        exerciseMO.setValue(rating, forKey: "rating")
        exerciseMO.setValue(type.rawValue, forKey: "type")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func update() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fr: NSFetchRequest<ExerciseMO> = ExerciseMO.fetchRequest()
        let predicate = NSPredicate(format: "id==%@", argumentArray: [self.id])
        fr.predicate = predicate
        do {
            let exerciseMOs = try managedContext.fetch(fr)
            let exerciseMO = exerciseMOs[0]
            exerciseMO.setValue(name, forKey: "name")
            exerciseMO.setValue(explanation, forKey: "explanation")
            exerciseMO.setValue(muscle.rawValue, forKey: "muscle")
            exerciseMO.setValue(sides.rawValue, forKey: "sides")
            exerciseMO.setValue(photo.flatMap { UIImagePNGRepresentation($0) }, forKey: "image")
            exerciseMO.setValue(rating, forKey: "rating")
            exerciseMO.setValue(type.rawValue, forKey: "type")
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch {
            print("Could not save. \(error)")
        }
    }

    func delete() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fr: NSFetchRequest<ExerciseMO> = ExerciseMO.fetchRequest()
        let predicate = NSPredicate(format: "id==%@", argumentArray: [self.id])
        fr.predicate = predicate
        do {
            let exerciseMOs = try managedContext.fetch(fr)
            let exerciseMO = exerciseMOs[0]
            managedContext.delete(exerciseMO)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        } catch {
            print("Could not delete. \(error)")
        }
    }
}
