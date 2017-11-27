//
//  Stretch.swift
//  Fantastretch
//
//  Created by François Mockers on 19/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit
import os.log
import CoreData

enum Repeat: String, AutoEnumAllCases {
    case Once
    case EachSide = "Each Side"

    static let defaultCase = Once
}

enum Target: String, AutoEnumAllCases {
    case Triceps
    case Biceps
    case Forearms
    case Shoulders
    case Back
    case Chest
    case Abs
    case Glutes
    case Quads
    case HipFlexors = "Hip Flexors"
    case Hamstrings
    case Calves
    case Global

    static let defaultCase = Global
}

enum ExerciseType: String {
    case WarmUp
    case Stretch
    case Exercise
}

class Exercise: NSObject {

    // MARK: Properties
    var name: String
    var explanation: String
    var photo: UIImage?
    var rating: Int
    var sides: Repeat
    var target: Target
    var id: UUID
    var type: ExerciseType

    // MARK: Initialization
    init?(name: String, explanation: String, photo: UIImage?, rating: Int, sides: Repeat, target: Target, id: UUID?) {

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
        self.target = target
        self.id = id ?? UUID()
        type = ExerciseType.Stretch
    }

    convenience init?(mo exerciseMO: ExerciseMO) {
        self.init(name: exerciseMO.name ?? "", explanation: exerciseMO.explanation ?? "",
                  photo: exerciseMO.image.flatMap({ (data) -> UIImage in UIImage(data: data)! }), rating: Int(exerciseMO.rating),
                  sides: Repeat(rawValue: exerciseMO.sides ?? "") ?? Repeat.defaultCase,
                  target: Target(rawValue: exerciseMO.target ?? "") ?? Target.defaultCase, id: exerciseMO.id)
    }

    static func load() -> [Exercise]? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ExerciseMO")

        do {
            let exerciseMOs = try managedContext.fetch(fetchRequest)
            return exerciseMOs.map({ Exercise(mo: $0 as! ExerciseMO)! })
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
        let entity = NSEntityDescription.entity(forEntityName: "ExerciseMO", in: managedContext)!
        let exerciseMO = NSManagedObject(entity: entity, insertInto: managedContext)
        exerciseMO.setValue(id, forKey: "id")
        exerciseMO.setValue(name, forKey: "name")
        exerciseMO.setValue(explanation, forKey: "explanation")
        exerciseMO.setValue(target.rawValue, forKey: "target")
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
            exerciseMO.setValue(target.rawValue, forKey: "target")
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