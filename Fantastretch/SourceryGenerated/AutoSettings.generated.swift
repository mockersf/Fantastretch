// Generated using Sourcery 0.10.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation

extension Settings {

    func load() {
        let defaults = UserDefaults.standard
        defaults.register(defaults: [
            "timerHold": 30,
            "timerRest": 10,
            "alertsVibration": false,
            "alertsSound": true,
            "musclePreferences": [:],
            "autoNbOfExercises": 10,
            "maxOldExerciseWeight": 30,
            "healthKitPermsAsked": false,
            "advancedAbs": false,
        ])

        timerHold = defaults.integer(forKey: "timerHold")
        timerRest = defaults.integer(forKey: "timerRest")
        alertsVibration = defaults.bool(forKey: "alertsVibration")
        alertsSound = defaults.bool(forKey: "alertsSound")
        musclePreferences = musclePreferencesFromRaw(defaults.dictionary(forKey: "musclePreferences") ?? [:])
        autoNbOfExercises = defaults.integer(forKey: "autoNbOfExercises")
        maxOldExerciseWeight = defaults.integer(forKey: "maxOldExerciseWeight")
        healthKitPermsAsked = defaults.bool(forKey: "healthKitPermsAsked")
        advancedAbs = defaults.bool(forKey: "advancedAbs")
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(timerHold, forKey: "timerHold")
        defaults.set(timerRest, forKey: "timerRest")
        defaults.set(alertsVibration, forKey: "alertsVibration")
        defaults.set(alertsSound, forKey: "alertsSound")
        defaults.set(musclePreferencesToRaw(musclePreferences), forKey: "musclePreferences")
        defaults.set(autoNbOfExercises, forKey: "autoNbOfExercises")
        defaults.set(maxOldExerciseWeight, forKey: "maxOldExerciseWeight")
        defaults.set(healthKitPermsAsked, forKey: "healthKitPermsAsked")
        defaults.set(advancedAbs, forKey: "advancedAbs")
    }
}
