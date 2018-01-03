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
            "autoStretchMusclePreferences": [:],
            "autoStretchNbOfExercises": 10,
            "autoStretchNbRepetitions": 1,
            "autoExerciseMusclePreferences": [:],
            "autoExerciseNbOfExercises": 5,
            "autoExerciseNbRepetitions": 2,
            "healthKitPermsAsked": false,
            "advancedAbs": false,
        ])

        timerHold = defaults.integer(forKey: "timerHold")
        timerRest = defaults.integer(forKey: "timerRest")
        alertsVibration = defaults.bool(forKey: "alertsVibration")
        alertsSound = defaults.bool(forKey: "alertsSound")
        autoStretchMusclePreferences = autoStretchMusclePreferencesFromRaw(defaults.dictionary(forKey: "autoStretchMusclePreferences") ?? [:])
        autoStretchNbOfExercises = defaults.integer(forKey: "autoStretchNbOfExercises")
        autoStretchNbRepetitions = defaults.integer(forKey: "autoStretchNbRepetitions")
        autoExerciseMusclePreferences = autoExerciseMusclePreferencesFromRaw(defaults.dictionary(forKey: "autoExerciseMusclePreferences") ?? [:])
        autoExerciseNbOfExercises = defaults.integer(forKey: "autoExerciseNbOfExercises")
        autoExerciseNbRepetitions = defaults.integer(forKey: "autoExerciseNbRepetitions")
        healthKitPermsAsked = defaults.bool(forKey: "healthKitPermsAsked")
        advancedAbs = defaults.bool(forKey: "advancedAbs")
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(timerHold, forKey: "timerHold")
        defaults.set(timerRest, forKey: "timerRest")
        defaults.set(alertsVibration, forKey: "alertsVibration")
        defaults.set(alertsSound, forKey: "alertsSound")
        defaults.set(autoStretchMusclePreferencesToRaw(autoStretchMusclePreferences), forKey: "autoStretchMusclePreferences")
        defaults.set(autoStretchNbOfExercises, forKey: "autoStretchNbOfExercises")
        defaults.set(autoStretchNbRepetitions, forKey: "autoStretchNbRepetitions")
        defaults.set(autoExerciseMusclePreferencesToRaw(autoExerciseMusclePreferences), forKey: "autoExerciseMusclePreferences")
        defaults.set(autoExerciseNbOfExercises, forKey: "autoExerciseNbOfExercises")
        defaults.set(autoExerciseNbRepetitions, forKey: "autoExerciseNbRepetitions")
        defaults.set(healthKitPermsAsked, forKey: "healthKitPermsAsked")
        defaults.set(advancedAbs, forKey: "advancedAbs")
    }
}
