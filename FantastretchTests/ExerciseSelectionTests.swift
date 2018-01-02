//
//  ExerciseSelectionTests.swift
//  FantastretchTests
//
//  Created by François Mockers on 28/12/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

@testable import Fantastretch
import Nimble
import XCTest

class ExerciseSelectionTests: XCTestCase {

    func testOneExercise() {
        let exercises = [
            Exercise(name: "1", explanation: "", photo: nil, rating: 1, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
        ]
        let settings = Settings()

        let result = ExerciseWithMetadata.getSelectedExercisesByScore(exercises: exercises, settings: settings)
        // expect(result.map({ $0.exercise })).to(satisfyAllOf(contain(exercises[0]), haveCount(1)))
        expect(result.map({ $0.exercise.id })).to(equal([exercises[0].id]))
    }

    func testOrderUsingRating() {
        let exercises = [
            Exercise(name: "1", explanation: "", photo: nil, rating: 1, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
            Exercise(name: "2", explanation: "", photo: nil, rating: 2, sides: Repeat.Once, muscle: Muscle.Back, type: ExerciseType.allCases.first!, id: nil)!,
        ]
        let settings = Settings()

        let result = ExerciseWithMetadata.getSelectedExercisesByScore(exercises: exercises, settings: settings)
        expect(result.map({ $0.exercise.id })).to(equal([exercises[1].id, exercises[0].id])).to(haveCount(2))
    }

    func testOrderUsingSettings() {
        let exercises = [
            Exercise(name: "1", explanation: "", photo: nil, rating: 1, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
            Exercise(name: "2", explanation: "", photo: nil, rating: 1, sides: Repeat.Once, muscle: Muscle.Back, type: ExerciseType.allCases.first!, id: nil)!,
        ]
        let settings = Settings()
        settings.musclePreferences.updateValue(1, forKey: Muscle.Abs)
        settings.musclePreferences.updateValue(5, forKey: Muscle.Back)

        let result = ExerciseWithMetadata.getSelectedExercisesByScore(exercises: exercises, settings: settings)
        expect(result.map({ $0.exercise.id })).to(equal([exercises[1].id, exercises[0].id])).to(haveCount(2))
    }

    func testOrderUsingHistory() {
        let exercises = [
            Exercise(name: "1", explanation: "", photo: nil, rating: 1, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
            Exercise(name: "2", explanation: "", photo: nil, rating: 1, sides: Repeat.Once, muscle: Muscle.Back, type: ExerciseType.allCases.first!, id: nil)!,
        ]
        let settings = Settings()
        ExerciseHistory(exercise: exercises[0], date: Date(), duration: 10).save()
        ExerciseHistory(exercise: exercises[0], date: Date().addingTimeInterval(TimeInterval(-60)), duration: 10).save()

        let result = ExerciseWithMetadata.getSelectedExercisesByScore(exercises: exercises, settings: settings)
        expect(result.map({ $0.exercise.id })).to(equal([exercises[1].id, exercises[0].id])).to(haveCount(2))
    }

    func testOrderSeveralOfSameMuscle() {
        let exercises = [
            Exercise(name: "1", explanation: "", photo: nil, rating: 1, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
            Exercise(name: "2", explanation: "", photo: nil, rating: 2, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
        ]
        let settings = Settings()

        let result = ExerciseWithMetadata.getSelectedExercisesByScore(exercises: exercises, settings: settings)
        expect(result.map({ $0.exercise.id })).to(equal([exercises[1].id, exercises[0].id])).to(haveCount(2))
    }

    func testMoreThanMaxNumber() {
        let exercises = [
            Exercise(name: "1", explanation: "", photo: nil, rating: 1, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
            Exercise(name: "2", explanation: "", photo: nil, rating: 2, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
            Exercise(name: "3", explanation: "", photo: nil, rating: 1, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
            Exercise(name: "4", explanation: "", photo: nil, rating: 2, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
        ]
        let settings = Settings()
        settings.autoNbOfExercises = 3

        let result = ExerciseWithMetadata.getSelectedExercisesByScore(exercises: exercises, settings: settings)
        expect(result.map({ $0.exercise.id })).to(equal([exercises[1].id, exercises[3].id, exercises[0].id]))
    }

    func testMixedMuscles() {
        let exercises = [
            Exercise(name: "1", explanation: "", photo: nil, rating: 1, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
            Exercise(name: "2", explanation: "", photo: nil, rating: 2, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
            Exercise(name: "3", explanation: "", photo: nil, rating: 1, sides: Repeat.Once, muscle: Muscle.Back, type: ExerciseType.allCases.first!, id: nil)!,
            Exercise(name: "4", explanation: "", photo: nil, rating: 2, sides: Repeat.Once, muscle: Muscle.Abs, type: ExerciseType.allCases.first!, id: nil)!,
        ]
        let settings = Settings()
        settings.autoNbOfExercises = 3

        let result = ExerciseWithMetadata.getSelectedExercisesByScore(exercises: exercises, settings: settings)
        expect(result.map({ $0.exercise.id })).to(equal([exercises[1].id, exercises[2].id, exercises[3].id]))
    }
}
