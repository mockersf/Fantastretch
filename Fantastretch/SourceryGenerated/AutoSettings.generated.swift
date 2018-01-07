// Generated using Sourcery 0.10.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation

extension Settings {

    func load() {
        let defaults = UserDefaults.standard
        defaults.register(defaults: [
            "alertsVibration": self.alertsVibration,
            "alertsSound": self.alertsSound,
            "healthKitPermsAsked": self.healthKitPermsAsked,
            "advancedAbs": self.advancedAbs,
            "advancedAuto": self.advancedAuto,

            "autoStretchSettings.timerActive": self.autoStretchSettings.timerActive,
            "autoStretchSettings.timerRest": self.autoStretchSettings.timerRest,
            "autoStretchSettings.musclePreferences": [:],
            "autoStretchSettings.nbOfExercises": self.autoStretchSettings.nbOfExercises,
            "autoStretchSettings.nbRepetitions": self.autoStretchSettings.nbRepetitions,

            "autoExerciseSettings.timerActive": self.autoExerciseSettings.timerActive,
            "autoExerciseSettings.timerRest": self.autoExerciseSettings.timerRest,
            "autoExerciseSettings.musclePreferences": [:],
            "autoExerciseSettings.nbOfExercises": self.autoExerciseSettings.nbOfExercises,
            "autoExerciseSettings.nbRepetitions": self.autoExerciseSettings.nbRepetitions,

        ])

        alertsVibration = defaults.bool(forKey: "alertsVibration")
        alertsSound = defaults.bool(forKey: "alertsSound")
        healthKitPermsAsked = defaults.bool(forKey: "healthKitPermsAsked")
        advancedAbs = defaults.bool(forKey: "advancedAbs")
        advancedAuto = defaults.bool(forKey: "advancedAuto")

        let autoStretchSettingstimerActive = defaults.integer(forKey: "autoStretchSettings.timerActive")
        let autoStretchSettingstimerRest = defaults.integer(forKey: "autoStretchSettings.timerRest")
        let autoStretchSettingsmusclePreferences = musclePreferencesFromRaw(defaults.dictionary(forKey: "autoStretchSettings.musclePreferences") ?? [:])
        let autoStretchSettingsnbOfExercises = defaults.integer(forKey: "autoStretchSettings.nbOfExercises")
        let autoStretchSettingsnbRepetitions = defaults.integer(forKey: "autoStretchSettings.nbRepetitions")
        autoStretchSettings = SettingsExerciseType(
            timerActive: autoStretchSettingstimerActive,
            timerRest: autoStretchSettingstimerRest,
            musclePreferences: autoStretchSettingsmusclePreferences,
            nbOfExercises: autoStretchSettingsnbOfExercises,
            nbRepetitions: autoStretchSettingsnbRepetitions
        )

        let autoExerciseSettingstimerActive = defaults.integer(forKey: "autoExerciseSettings.timerActive")
        let autoExerciseSettingstimerRest = defaults.integer(forKey: "autoExerciseSettings.timerRest")
        let autoExerciseSettingsmusclePreferences = musclePreferencesFromRaw(defaults.dictionary(forKey: "autoExerciseSettings.musclePreferences") ?? [:])
        let autoExerciseSettingsnbOfExercises = defaults.integer(forKey: "autoExerciseSettings.nbOfExercises")
        let autoExerciseSettingsnbRepetitions = defaults.integer(forKey: "autoExerciseSettings.nbRepetitions")
        autoExerciseSettings = SettingsExerciseType(
            timerActive: autoExerciseSettingstimerActive,
            timerRest: autoExerciseSettingstimerRest,
            musclePreferences: autoExerciseSettingsmusclePreferences,
            nbOfExercises: autoExerciseSettingsnbOfExercises,
            nbRepetitions: autoExerciseSettingsnbRepetitions
        )
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(alertsVibration, forKey: "alertsVibration")
        defaults.set(alertsSound, forKey: "alertsSound")
        defaults.set(healthKitPermsAsked, forKey: "healthKitPermsAsked")
        defaults.set(advancedAbs, forKey: "advancedAbs")
        defaults.set(advancedAuto, forKey: "advancedAuto")

        defaults.set(autoStretchSettings.timerActive, forKey: "autoStretchSettings.timerActive")
        defaults.set(autoStretchSettings.timerRest, forKey: "autoStretchSettings.timerRest")
        defaults.set(musclePreferencesToRaw(autoStretchSettings.musclePreferences), forKey: "autoStretchSettings.musclePreferences")
        defaults.set(autoStretchSettings.nbOfExercises, forKey: "autoStretchSettings.nbOfExercises")
        defaults.set(autoStretchSettings.nbRepetitions, forKey: "autoStretchSettings.nbRepetitions")

        defaults.set(autoExerciseSettings.timerActive, forKey: "autoExerciseSettings.timerActive")
        defaults.set(autoExerciseSettings.timerRest, forKey: "autoExerciseSettings.timerRest")
        defaults.set(musclePreferencesToRaw(autoExerciseSettings.musclePreferences), forKey: "autoExerciseSettings.musclePreferences")
        defaults.set(autoExerciseSettings.nbOfExercises, forKey: "autoExerciseSettings.nbOfExercises")
        defaults.set(autoExerciseSettings.nbRepetitions, forKey: "autoExerciseSettings.nbRepetitions")
    }
}
