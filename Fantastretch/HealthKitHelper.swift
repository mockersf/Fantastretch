//
//  HealthKit.swift
//  Fantastretch
//
//  Created by François Mockers on 06/12/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import Foundation
import HealthKit

enum WorkoutType {
    case Stretch
    case Strength
}

class HealthKitHelper {
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }

    class var sharedInstance: HealthKitHelper {
        struct Singleton {
            static let instance = HealthKitHelper()
        }

        return Singleton.instance
    }

    let healthStore = HKHealthStore()

    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }

        let healthKitTypesToWrite: Set<HKSampleType> = [HKObjectType.workoutType()]
        sharedInstance.healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: []) { success, error in
            completion(success, error)
        }
    }

    class func authorizeIfNeededAndThen(doSomething: @escaping () -> Void) {
        let settings = Settings()
        if !settings.healthKitPermsAsked {
            authorizeHealthKit { authorized, error in
                guard authorized else {
                    let baseMessage = "HealthKit Authorization Failed"
                    if let error = error {
                        print("\(baseMessage). Reason: \(error.localizedDescription)")
                    } else {
                        print(baseMessage)
                    }
                    return
                }
                print("HealthKit Successfully Authorized.")
                settings.healthKitPermsAsked = true
                settings.save()
                doSomething()
            }
        } else {
            doSomething()
        }
    }

    class func saveWorkoutDuration(duration: Int, workoutType: WorkoutType) {
        if HKHealthStore.isHealthDataAvailable() {
            authorizeIfNeededAndThen(doSomething: {
                HKWorkoutType.workoutType()
                let finish = Date()
                let start = finish.addingTimeInterval(TimeInterval(-duration))
                let type = workoutTypeToActivityType(workoutType: workoutType)
                let workout = HKWorkout(activityType: type, start: start, end: finish)
                sharedInstance.healthStore.save(workout, withCompletion: { _, error in
                    if let error = error {
                        print("Error Saving Workout: \(error.localizedDescription)")
                    } else {
                        print("Successfully saved Workout")
                    }
                })
            })
        }
    }

    private static func workoutTypeToActivityType(workoutType: WorkoutType) -> HKWorkoutActivityType {
        switch workoutType {
        case WorkoutType.Stretch:
            return HKWorkoutActivityType.preparationAndRecovery
        case WorkoutType.Strength:
            return HKWorkoutActivityType.functionalStrengthTraining
        }
    }
}
