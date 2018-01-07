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
            "advancedAuto": self.advancedAuto,

            "autoStretchSettings.timerActive": self.autoStretchSettings.timerActive,
            "autoStretchSettings.timerRest": self.autoStretchSettings.timerRest,
            "autoStretchSettings.musclePreferences": [:],
            "autoStretchSettings.nbOfExercises": self.autoStretchSettings.nbOfExercises,
            "autoStretchSettings.nbRepetitions": self.autoStretchSettings.nbRepetitions,
            "autoStretchSettings.advancedAbs": self.autoStretchSettings.advancedAbs,

            "autoExerciseSettings.timerActive": self.autoExerciseSettings.timerActive,
            "autoExerciseSettings.timerRest": self.autoExerciseSettings.timerRest,
            "autoExerciseSettings.musclePreferences": [:],
            "autoExerciseSettings.nbOfExercises": self.autoExerciseSettings.nbOfExercises,
            "autoExerciseSettings.nbRepetitions": self.autoExerciseSettings.nbRepetitions,
            "autoExerciseSettings.advancedAbs": self.autoExerciseSettings.advancedAbs,

            "autoStretchNotification.hasAsked": self.autoStretchNotification.hasAsked,
            "autoStretchNotification.time": "",
            "autoStretchNotification.repeatEvery": "",
            "autoStretchNotification.repeatMonday": self.autoStretchNotification.repeatMonday,
            "autoStretchNotification.repeatTuesday": self.autoStretchNotification.repeatTuesday,
            "autoStretchNotification.repeatWednesday": self.autoStretchNotification.repeatWednesday,
            "autoStretchNotification.repeatThursday": self.autoStretchNotification.repeatThursday,
            "autoStretchNotification.repeatFriday": self.autoStretchNotification.repeatFriday,
            "autoStretchNotification.repeatSaturday": self.autoStretchNotification.repeatSaturday,
            "autoStretchNotification.repeatSunday": self.autoStretchNotification.repeatSunday,

            "autoExerciseNotification.hasAsked": self.autoExerciseNotification.hasAsked,
            "autoExerciseNotification.time": "",
            "autoExerciseNotification.repeatEvery": "",
            "autoExerciseNotification.repeatMonday": self.autoExerciseNotification.repeatMonday,
            "autoExerciseNotification.repeatTuesday": self.autoExerciseNotification.repeatTuesday,
            "autoExerciseNotification.repeatWednesday": self.autoExerciseNotification.repeatWednesday,
            "autoExerciseNotification.repeatThursday": self.autoExerciseNotification.repeatThursday,
            "autoExerciseNotification.repeatFriday": self.autoExerciseNotification.repeatFriday,
            "autoExerciseNotification.repeatSaturday": self.autoExerciseNotification.repeatSaturday,
            "autoExerciseNotification.repeatSunday": self.autoExerciseNotification.repeatSunday,

        ])

        alertsVibration = defaults.bool(forKey: "alertsVibration")
        alertsSound = defaults.bool(forKey: "alertsSound")
        healthKitPermsAsked = defaults.bool(forKey: "healthKitPermsAsked")
        advancedAuto = defaults.bool(forKey: "advancedAuto")

        let autoStretchSettingstimerActive = defaults.integer(forKey: "autoStretchSettings.timerActive")
        let autoStretchSettingstimerRest = defaults.integer(forKey: "autoStretchSettings.timerRest")
        let autoStretchSettingsmusclePreferences = musclePreferencesFromRaw(defaults.dictionary(forKey: "autoStretchSettings.musclePreferences") ?? [:])
        let autoStretchSettingsnbOfExercises = defaults.integer(forKey: "autoStretchSettings.nbOfExercises")
        let autoStretchSettingsnbRepetitions = defaults.integer(forKey: "autoStretchSettings.nbRepetitions")
        let autoStretchSettingsadvancedAbs = defaults.bool(forKey: "autoStretchSettings.advancedAbs")
        autoStretchSettings = SettingsExerciseType(
            timerActive: autoStretchSettingstimerActive,
            timerRest: autoStretchSettingstimerRest,
            musclePreferences: autoStretchSettingsmusclePreferences,
            nbOfExercises: autoStretchSettingsnbOfExercises,
            nbRepetitions: autoStretchSettingsnbRepetitions,
            advancedAbs: autoStretchSettingsadvancedAbs
        )

        let autoExerciseSettingstimerActive = defaults.integer(forKey: "autoExerciseSettings.timerActive")
        let autoExerciseSettingstimerRest = defaults.integer(forKey: "autoExerciseSettings.timerRest")
        let autoExerciseSettingsmusclePreferences = musclePreferencesFromRaw(defaults.dictionary(forKey: "autoExerciseSettings.musclePreferences") ?? [:])
        let autoExerciseSettingsnbOfExercises = defaults.integer(forKey: "autoExerciseSettings.nbOfExercises")
        let autoExerciseSettingsnbRepetitions = defaults.integer(forKey: "autoExerciseSettings.nbRepetitions")
        let autoExerciseSettingsadvancedAbs = defaults.bool(forKey: "autoExerciseSettings.advancedAbs")
        autoExerciseSettings = SettingsExerciseType(
            timerActive: autoExerciseSettingstimerActive,
            timerRest: autoExerciseSettingstimerRest,
            musclePreferences: autoExerciseSettingsmusclePreferences,
            nbOfExercises: autoExerciseSettingsnbOfExercises,
            nbRepetitions: autoExerciseSettingsnbRepetitions,
            advancedAbs: autoExerciseSettingsadvancedAbs
        )

        let autoStretchNotificationhasAsked = defaults.bool(forKey: "autoStretchNotification.hasAsked")
        let autoStretchNotificationtime = timeFromRaw(defaults.string(forKey: "autoStretchNotification.time") ?? "")
        let autoStretchNotificationrepeatEvery = repeatEveryFromRaw(defaults.string(forKey: "autoStretchNotification.repeatEvery") ?? "")
        let autoStretchNotificationrepeatMonday = defaults.bool(forKey: "autoStretchNotification.repeatMonday")
        let autoStretchNotificationrepeatTuesday = defaults.bool(forKey: "autoStretchNotification.repeatTuesday")
        let autoStretchNotificationrepeatWednesday = defaults.bool(forKey: "autoStretchNotification.repeatWednesday")
        let autoStretchNotificationrepeatThursday = defaults.bool(forKey: "autoStretchNotification.repeatThursday")
        let autoStretchNotificationrepeatFriday = defaults.bool(forKey: "autoStretchNotification.repeatFriday")
        let autoStretchNotificationrepeatSaturday = defaults.bool(forKey: "autoStretchNotification.repeatSaturday")
        let autoStretchNotificationrepeatSunday = defaults.bool(forKey: "autoStretchNotification.repeatSunday")
        autoStretchNotification = SettingsNotification(
            hasAsked: autoStretchNotificationhasAsked,
            time: autoStretchNotificationtime,
            repeatEvery: autoStretchNotificationrepeatEvery,
            repeatMonday: autoStretchNotificationrepeatMonday,
            repeatTuesday: autoStretchNotificationrepeatTuesday,
            repeatWednesday: autoStretchNotificationrepeatWednesday,
            repeatThursday: autoStretchNotificationrepeatThursday,
            repeatFriday: autoStretchNotificationrepeatFriday,
            repeatSaturday: autoStretchNotificationrepeatSaturday,
            repeatSunday: autoStretchNotificationrepeatSunday
        )

        let autoExerciseNotificationhasAsked = defaults.bool(forKey: "autoExerciseNotification.hasAsked")
        let autoExerciseNotificationtime = timeFromRaw(defaults.string(forKey: "autoExerciseNotification.time") ?? "")
        let autoExerciseNotificationrepeatEvery = repeatEveryFromRaw(defaults.string(forKey: "autoExerciseNotification.repeatEvery") ?? "")
        let autoExerciseNotificationrepeatMonday = defaults.bool(forKey: "autoExerciseNotification.repeatMonday")
        let autoExerciseNotificationrepeatTuesday = defaults.bool(forKey: "autoExerciseNotification.repeatTuesday")
        let autoExerciseNotificationrepeatWednesday = defaults.bool(forKey: "autoExerciseNotification.repeatWednesday")
        let autoExerciseNotificationrepeatThursday = defaults.bool(forKey: "autoExerciseNotification.repeatThursday")
        let autoExerciseNotificationrepeatFriday = defaults.bool(forKey: "autoExerciseNotification.repeatFriday")
        let autoExerciseNotificationrepeatSaturday = defaults.bool(forKey: "autoExerciseNotification.repeatSaturday")
        let autoExerciseNotificationrepeatSunday = defaults.bool(forKey: "autoExerciseNotification.repeatSunday")
        autoExerciseNotification = SettingsNotification(
            hasAsked: autoExerciseNotificationhasAsked,
            time: autoExerciseNotificationtime,
            repeatEvery: autoExerciseNotificationrepeatEvery,
            repeatMonday: autoExerciseNotificationrepeatMonday,
            repeatTuesday: autoExerciseNotificationrepeatTuesday,
            repeatWednesday: autoExerciseNotificationrepeatWednesday,
            repeatThursday: autoExerciseNotificationrepeatThursday,
            repeatFriday: autoExerciseNotificationrepeatFriday,
            repeatSaturday: autoExerciseNotificationrepeatSaturday,
            repeatSunday: autoExerciseNotificationrepeatSunday
        )
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(alertsVibration, forKey: "alertsVibration")
        defaults.set(alertsSound, forKey: "alertsSound")
        defaults.set(healthKitPermsAsked, forKey: "healthKitPermsAsked")
        defaults.set(advancedAuto, forKey: "advancedAuto")

        defaults.set(autoStretchSettings.timerActive, forKey: "autoStretchSettings.timerActive")
        defaults.set(autoStretchSettings.timerRest, forKey: "autoStretchSettings.timerRest")
        defaults.set(musclePreferencesToRaw(autoStretchSettings.musclePreferences), forKey: "autoStretchSettings.musclePreferences")
        defaults.set(autoStretchSettings.nbOfExercises, forKey: "autoStretchSettings.nbOfExercises")
        defaults.set(autoStretchSettings.nbRepetitions, forKey: "autoStretchSettings.nbRepetitions")
        defaults.set(autoStretchSettings.advancedAbs, forKey: "autoStretchSettings.advancedAbs")

        defaults.set(autoExerciseSettings.timerActive, forKey: "autoExerciseSettings.timerActive")
        defaults.set(autoExerciseSettings.timerRest, forKey: "autoExerciseSettings.timerRest")
        defaults.set(musclePreferencesToRaw(autoExerciseSettings.musclePreferences), forKey: "autoExerciseSettings.musclePreferences")
        defaults.set(autoExerciseSettings.nbOfExercises, forKey: "autoExerciseSettings.nbOfExercises")
        defaults.set(autoExerciseSettings.nbRepetitions, forKey: "autoExerciseSettings.nbRepetitions")
        defaults.set(autoExerciseSettings.advancedAbs, forKey: "autoExerciseSettings.advancedAbs")

        defaults.set(autoStretchNotification.hasAsked, forKey: "autoStretchNotification.hasAsked")
        defaults.set(timeToRaw(autoStretchNotification.time), forKey: "autoStretchNotification.time")
        defaults.set(repeatEveryToRaw(autoStretchNotification.repeatEvery), forKey: "autoStretchNotification.repeatEvery")
        defaults.set(autoStretchNotification.repeatMonday, forKey: "autoStretchNotification.repeatMonday")
        defaults.set(autoStretchNotification.repeatTuesday, forKey: "autoStretchNotification.repeatTuesday")
        defaults.set(autoStretchNotification.repeatWednesday, forKey: "autoStretchNotification.repeatWednesday")
        defaults.set(autoStretchNotification.repeatThursday, forKey: "autoStretchNotification.repeatThursday")
        defaults.set(autoStretchNotification.repeatFriday, forKey: "autoStretchNotification.repeatFriday")
        defaults.set(autoStretchNotification.repeatSaturday, forKey: "autoStretchNotification.repeatSaturday")
        defaults.set(autoStretchNotification.repeatSunday, forKey: "autoStretchNotification.repeatSunday")

        defaults.set(autoExerciseNotification.hasAsked, forKey: "autoExerciseNotification.hasAsked")
        defaults.set(timeToRaw(autoExerciseNotification.time), forKey: "autoExerciseNotification.time")
        defaults.set(repeatEveryToRaw(autoExerciseNotification.repeatEvery), forKey: "autoExerciseNotification.repeatEvery")
        defaults.set(autoExerciseNotification.repeatMonday, forKey: "autoExerciseNotification.repeatMonday")
        defaults.set(autoExerciseNotification.repeatTuesday, forKey: "autoExerciseNotification.repeatTuesday")
        defaults.set(autoExerciseNotification.repeatWednesday, forKey: "autoExerciseNotification.repeatWednesday")
        defaults.set(autoExerciseNotification.repeatThursday, forKey: "autoExerciseNotification.repeatThursday")
        defaults.set(autoExerciseNotification.repeatFriday, forKey: "autoExerciseNotification.repeatFriday")
        defaults.set(autoExerciseNotification.repeatSaturday, forKey: "autoExerciseNotification.repeatSaturday")
        defaults.set(autoExerciseNotification.repeatSunday, forKey: "autoExerciseNotification.repeatSunday")
    }
}
