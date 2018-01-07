//
//  Settings.swift
//  Fantastretch
//
//  Created by François Mockers on 27/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import Foundation

class SettingsExerciseType: AutoSubSettings, AutoCopy {

    var timerActive = 30
    var timerRest = 10
    var musclePreferences = [Muscle: Int]()
    var nbOfExercises = 10
    var nbRepetitions = 1
    var advancedAbs = false

    init(timerActive: Int, timerRest: Int, musclePreferences: [Muscle: Int], nbOfExercises: Int, nbRepetitions: Int, advancedAbs: Bool) {
        self.timerActive = timerActive
        self.timerRest = timerRest
        self.musclePreferences = musclePreferences
        self.nbOfExercises = nbOfExercises
        self.nbRepetitions = nbRepetitions
        self.advancedAbs = advancedAbs
    }
}

class SettingsNotification: AutoSubSettings {

    var hasAsked = false
    var time: Date?
    var repeatEvery: Int?
    var repeatMonday = false
    var repeatTuesday = false
    var repeatWednesday = false
    var repeatThursday = false
    var repeatFriday = false
    var repeatSaturday = false
    var repeatSunday = false

    init(hasAsked: Bool, time: Date?, repeatEvery: Int?, repeatMonday: Bool, repeatTuesday: Bool, repeatWednesday: Bool, repeatThursday: Bool, repeatFriday: Bool, repeatSaturday: Bool, repeatSunday: Bool) {
        self.hasAsked = hasAsked
        self.time = time
        self.repeatEvery = repeatEvery
        self.repeatMonday = repeatMonday
        self.repeatTuesday = repeatTuesday
        self.repeatWednesday = repeatWednesday
        self.repeatThursday = repeatThursday
        self.repeatFriday = repeatFriday
        self.repeatSaturday = repeatSaturday
        self.repeatSunday = repeatSunday
    }

    init() {
    }
}

class Settings: AutoSettings {

    // MARK: properties

    var alertsVibration = false
    var alertsSound = true
    var healthKitPermsAsked = false
    var advancedAuto = false

    var autoStretchSettings = SettingsExerciseType(timerActive: 30, timerRest: 10, musclePreferences: [Muscle: Int](), nbOfExercises: 10, nbRepetitions: 1, advancedAbs: false)
    var autoExerciseSettings = SettingsExerciseType(timerActive: 30, timerRest: 10, musclePreferences: [Muscle: Int](), nbOfExercises: 5, nbRepetitions: 2, advancedAbs: false)

    var autoStretchNotification = SettingsNotification()
    var autoExerciseNotification = SettingsNotification()

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
            autoExerciseSettings = autoStretchSettings.copy()
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

    func timeFromRaw(_ raw: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: raw)
    }

    func timeToRaw(_ time: Date?) -> String {
        if let time = time {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .medium
            dateFormatter.locale = Locale(identifier: "en_US")
            return dateFormatter.string(from: time)
        }
        return ""
    }

    func repeatEveryFromRaw(_ raw: String) -> Int? {
        return Int(raw)
    }

    func repeatEveryToRaw(_ repeatEvery: Int?) -> String {
        if let repeatEvery = repeatEvery {
            return "\(repeatEvery)"
        }
        return ""
    }
}
