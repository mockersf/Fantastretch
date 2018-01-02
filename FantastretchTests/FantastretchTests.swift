//
//  FantastretchTests.swift
//  FantastretchTests
//
//  Created by François Mockers on 19/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

@testable import Fantastretch
import XCTest

class FantastretchTests: XCTestCase {

    // MARK: Stretch Class Tests

    // Confirm that the Stretch initializer returns a Stretch object when passed valid parameters.
    func testStretchInitializationSucceeds() {
        // Zero rating
        let zeroRatingStretch = Exercise(name: "Zero", explanation: "", photo: nil, rating: 0, sides: Repeat.allCases.first!, muscle: Muscle.allCases.first!, type: ExerciseType.allCases.first!, id: nil)
        XCTAssertNotNil(zeroRatingStretch)

        // Highest positive rating
        let positiveRatingStretch = Exercise(name: "Positive", explanation: "", photo: nil, rating: 5, sides: Repeat.allCases.first!, muscle: Muscle.allCases.first!, type: ExerciseType.allCases.first!, id: nil)
        XCTAssertNotNil(positiveRatingStretch)
    }

    // Confirm that the Stretch initialier returns nil when passed a negative rating or an empty name.
    func testStretchInitializationFails() {
        // Negative rating
        let negativeRatingStretch = Exercise(name: "Negative", explanation: "", photo: nil, rating: -1, sides: Repeat.allCases.first!, muscle: Muscle.allCases.first!, type: ExerciseType.allCases.first!, id: nil)
        XCTAssertNil(negativeRatingStretch)

        // Empty String
        let emptyStringStretch = Exercise(name: "", explanation: "", photo: nil, rating: 1, sides: Repeat.allCases.first!, muscle: Muscle.allCases.first!, type: ExerciseType.allCases.first!, id: nil)
        XCTAssertNil(emptyStringStretch)

        // Rating exceeds maximum
        let largeRatingStretch = Exercise(name: "", explanation: "", photo: nil, rating: 6, sides: Repeat.allCases.first!, muscle: Muscle.allCases.first!, type: ExerciseType.allCases.first!, id: nil)
        XCTAssertNil(largeRatingStretch)
    }
}
