//
//  Settings.swift
//  Fantastretch
//
//  Created by François Mockers on 27/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import Foundation

class SettingsExerciseType: AutoSubSettings {
    var timerActive = 30
    var timerRest = 10
    var musclePreferences = [Muscle: Int]()
    var nbOfExercises = 10
    var nbRepetitions = 1

    init(timerActive: Int, timerRest: Int, musclePreferences: [Muscle: Int], nbOfExercises: Int, nbRepetitions: Int) {
        self.timerActive = timerActive
        self.timerRest = timerRest
        self.musclePreferences = musclePreferences
        self.nbOfExercises = nbOfExercises
        self.nbRepetitions = nbRepetitions
    }
}

class Settings: AutoSettings {

    // MARK: properties

    var alertsVibration = false
    var alertsSound = true
    var healthKitPermsAsked = false
    var advancedAbs = false
    var advancedAuto = false

    var autoStretchSettings = SettingsExerciseType(timerActive: 30, timerRest: 10, musclePreferences: [Muscle: Int](), nbOfExercises: 10, nbRepetitions: 1)
    var autoExerciseSettings = SettingsExerciseType(timerActive: 30, timerRest: 10, musclePreferences: [Muscle: Int](), nbOfExercises: 5, nbRepetitions: 2)

    static let defaultTimerHold = 30
    static let defaultTimerRest = 10
    static let maxOldExerciseWeight = 30

    private static let activeBySeconds: [String] = Array(10 ... 14).flatMap({ "\($0) seconds" })
    private static let activeBy5Seconds: [String] = Array(3 ... 6).flatMap({ "\($0 * 5) seconds" })
    private static let activeBy15Seconds: [String] = Array(3 ... 12).flatMap({ "\($0 * 15) seconds" })
    static let activeTimerOptions: [String] = Settings.activeBySeconds + Settings.activeBy5Seconds + Settings.activeBy15Seconds
    static let restTimerOptions: [String] = Array(5 ... 15).flatMap({ "\($0) seconds" })

    static let sharedInstance = Settings()

    private init() {
        load()
    }

    func saveExerciseTypeSettings() {
        if !advancedAuto {
            autoExerciseSettings = autoStretchSettings
        }
        save()
    }

    func musclePreferencesFromRaw(_ raw: [String: Any]) -> [Muscle: Int] {
        return Dictionary(uniqueKeysWithValues: Muscle.allCases.map({ (muscle: Muscle) -> (Muscle, Int) in
            let savedValue: Any? = raw[muscle.rawValue]
            let savedValueInt: Int? = savedValue as? Int
            return (muscle, savedValueInt ?? 1)
        }))
    }

    func musclePreferencesToRaw(_ musclePreferences: [Muscle: Int]) -> [String: Int] {
        return Dictionary(uniqueKeysWithValues: musclePreferences.map({ (key: Muscle, value: Int) -> (String, Int) in
            (key.rawValue, value)
        }))
    }
}
