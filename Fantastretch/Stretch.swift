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

enum Side: String {
    case Center
    case Sides
    case Both
    static let allValues = [Center, Sides, Both]
}

enum Target: String {
    case Legs
    case Arms
    case Back
    static let allValues = [Legs, Arms, Back]
}

class Stretch: NSObject {

    // MARK: Properties
    var name: String
    var stretch_description: String
    var photo: UIImage?
    var rating: Int
    var sides: Side
    var target: Target
    var id: UUID

    // MARK: Initialization
    init?(name: String, description: String, photo: UIImage?, rating: Int, sides: Side, target: Target, id: UUID?) {

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
        stretch_description = description
        self.photo = photo
        self.rating = rating
        self.sides = sides
        self.target = target
        self.id = id ?? UUID()
    }

    convenience init?(mo stretchMO: StretchMO) {
        self.init(name: stretchMO.name ?? "", description: stretchMO.description_field ?? "",
                  photo: stretchMO.image.flatMap({ (data) -> UIImage in UIImage(data: data)! }), rating: Int(stretchMO.rating),
                  sides: Side(rawValue: stretchMO.sides!)!, target: Target(rawValue: stretchMO.target!)!, id: stretchMO.id)
    }

    static func load() -> [Stretch]? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StretchMO")

        do {
            let stretchesMO = try managedContext.fetch(fetchRequest)
            return stretchesMO.map({ (stretchMO) -> Stretch in Stretch(mo: stretchMO as! StretchMO)! })
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
        let entity = NSEntityDescription.entity(forEntityName: "StretchMO", in: managedContext)!
        let stretchMO = NSManagedObject(entity: entity, insertInto: managedContext)
        stretchMO.setValue(id, forKey: "id")
        stretchMO.setValue(name, forKey: "name")
        stretchMO.setValue(stretch_description, forKey: "description_field")
        stretchMO.setValue(target.rawValue, forKey: "target")
        stretchMO.setValue(sides.rawValue, forKey: "sides")
        stretchMO.setValue(photo.flatMap { UIImagePNGRepresentation($0) }, forKey: "image")
        stretchMO.setValue(rating, forKey: "rating")
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
        let fr: NSFetchRequest<StretchMO> = StretchMO.fetchRequest()
        let predicate = NSPredicate(format: "id==%@", argumentArray: [self.id])
        fr.predicate = predicate
        do {
            let stretchMOs = try managedContext.fetch(fr)
            let stretchMO = stretchMOs[0]
            stretchMO.setValue(name, forKey: "name")
            stretchMO.setValue(stretch_description, forKey: "description_field")
            stretchMO.setValue(target.rawValue, forKey: "target")
            stretchMO.setValue(sides.rawValue, forKey: "sides")
            stretchMO.setValue(photo.flatMap { UIImagePNGRepresentation($0) }, forKey: "image")
            stretchMO.setValue(rating, forKey: "rating")
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
        let fr: NSFetchRequest<StretchMO> = StretchMO.fetchRequest()
        let predicate = NSPredicate(format: "id==%@", argumentArray: [self.id])
        fr.predicate = predicate
        do {
            let stretchMOs = try managedContext.fetch(fr)
            let stretchMO = stretchMOs[0]
            managedContext.delete(stretchMO)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch {
            print("Could not save. \(error)")
        }
    }
}
