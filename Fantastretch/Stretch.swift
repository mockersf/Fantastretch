//
//  Stretch.swift
//  Fantastretch
//
//  Created by François Mockers on 19/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit
import os.log

enum Side: String {
    case Center
    case Sides
    case Both
}

enum Muscle: String {
    case Legs
    case Arms
    case Back
}

class Stretch: NSObject, NSCoding {

    // MARK: Properties
    var name: String
    var stretch_description: String
    var photo: UIImage?
    var rating: Int
    var sides: Side
    var muscle: Muscle
    var id: UUID

    struct PropertyKey {
        static let name = "name"
        static let description = "stretch_description"
        static let photo = "photo"
        static let rating = "rating"
        static let sides = "sides"
        static let muscle = "muscle"
        static let id = "id"
    }

    // MARK: Archiving Paths

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("stretches")

    // MARK: Initialization
    init?(name: String, description: String, photo: UIImage?, rating: Int, sides: Side, muscle: Muscle) {

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
        self.muscle = muscle
        id = UUID()
    }

    init?(name: String, description: String, photo: UIImage?, rating: Int, sides: Side, muscle: Muscle, id: UUID) {

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
        self.muscle = muscle
        self.id = id
    }

    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(stretch_description, forKey: PropertyKey.description)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(sides.rawValue, forKey: PropertyKey.sides)
        aCoder.encode(muscle.rawValue, forKey: PropertyKey.muscle)
        aCoder.encode(id.uuidString, forKey: PropertyKey.id)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Stretch object.", log: OSLog.default, type: .debug)
            return nil
        }
        let description = aDecoder.decodeObject(forKey: PropertyKey.description) as? String ?? ""

        // Because photo is an optional property of Stretch, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage

        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        let sides = Side(rawValue: aDecoder.decodeObject(forKey: PropertyKey.sides) as? String ?? "") ?? Side.Center
        let muscle = Muscle(rawValue: aDecoder.decodeObject(forKey: PropertyKey.muscle) as? String ?? "") ?? Muscle.Back
        guard let id = ((aDecoder.decodeObject(forKey: PropertyKey.id) as? String).flatMap { (ida) -> UUID? in UUID(uuidString: ida) }) else {
            os_log("Unable to decode the id for a Stretch object.", log: OSLog.default, type: .debug)
            return nil
        }

        // Must call designated initializer.
        self.init(name: name, description: description, photo: photo, rating: rating, sides: sides, muscle: muscle, id: id)
    }
}
