//
//  Settings.swift
//  Fantastretch
//
//  Created by François Mockers on 27/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import Foundation

class Settings {

    // MARK: properties
    var timerHold: Int
    var timerRest: Int
    var alertsVibration: Bool
    var alertsSound: Bool
    var musclePreferences: [Muscle: Int]

    init() {
        let defaults = UserDefaults.standard
        defaults.register(defaults: [
            "timerHold": 30,
            "timerRest": 5,
            "alertsVibration": false,
            "alertsSound": true,
            "musclePreferences": [:],
        ])
        timerHold = defaults.integer(forKey: "timerHold")
        timerRest = defaults.integer(forKey: "timerRest")
        alertsVibration = defaults.bool(forKey: "alertsVibration")
        alertsSound = defaults.bool(forKey: "alertsSound")

        let musclePreferencesRaw = defaults.dictionary(forKey: "musclePreferences")
        musclePreferences = Dictionary(uniqueKeysWithValues: Muscle.allCases.map({ (muscle: Muscle) -> (Muscle, Int) in
            let savedValue: Any? = musclePreferencesRaw?[muscle.rawValue]
            let savedValueInt: Int? = savedValue as? Int
            return (muscle, savedValueInt ?? 1)
        }))
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(timerHold, forKey: "timerHold")
        defaults.set(timerRest, forKey: "timerRest")
        defaults.set(alertsVibration, forKey: "alertsVibration")
        defaults.set(alertsSound, forKey: "alertsSound")
        defaults.set(musclePreferences, forKey: "musclePreferences")
    }
}
