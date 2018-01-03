//
//  Settings.swift
//  Fantastretch
//
//  Created by François Mockers on 27/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import Foundation

class Settings: AutoSettings {

    // MARK: properties

    var timerHold = 30
    var timerRest = 10
    var alertsVibration = false
    var alertsSound = true
    var musclePreferences = [Muscle: Int]()
    var autoNbOfExercises = 10
    var maxOldExerciseWeight = 30
    var healthKitPermsAsked = false
    var advancedAbs = false

    static let defaultTimerHold = 30
    static let defaultTimerRest = 10

    init() {
        load()
    }

    func musclePreferencesToRaw(_ musclePreferences: [Muscle: Int]) -> [String: Int] {
        return Dictionary(uniqueKeysWithValues: musclePreferences.map({ (key: Muscle, value: Int) -> (String, Int) in
            (key.rawValue, value)
        }))
    }

    func musclePreferencesFromRaw(_ raw: [String: Any]) -> [Muscle: Int] {
        return Dictionary(uniqueKeysWithValues: Muscle.allCases.map({ (muscle: Muscle) -> (Muscle, Int) in
            let savedValue: Any? = raw[muscle.rawValue]
            let savedValueInt: Int? = savedValue as? Int
            return (muscle, savedValueInt ?? 1)
        }))
    }
}
