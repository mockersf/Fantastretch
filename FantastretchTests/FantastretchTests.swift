//
//  FantastretchTests.swift
//  FantastretchTests
//
//  Created by François Mockers on 19/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import XCTest
@testable import Fantastretch

class FantastretchTests: XCTestCase {

    // MARK: Stretch Class Tests

    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testStretchInitializationSucceeds() {
        // Zero rating
        let zeroRatingStretch = Stretch(name: "Zero", description: "", photo: nil, rating: 0, sides: Side.allCases.first!, target: Target.allCases.first!, id: nil)
        XCTAssertNotNil(zeroRatingStretch)

        // Highest positive rating
        let positiveRatingStretch = Stretch(name: "Positive", description: "", photo: nil, rating: 5, sides: Side.allCases.first!, target: Target.allCases.first!, id: nil)
        XCTAssertNotNil(positiveRatingStretch)
    }

    // Confirm that the Meal initialier returns nil when passed a negative rating or an empty name.
    func testStretchInitializationFails() {
        // Negative rating
        let negativeRatingStretch = Stretch(name: "Negative", description: "", photo: nil, rating: -1, sides: Side.allCases.first!, target: Target.allCases.first!, id: nil)
        XCTAssertNil(negativeRatingStretch)

        // Empty String
        let emptyStringStretch = Stretch(name: "", description: "", photo: nil, rating: 1, sides: Side.allCases.first!, target: Target.allCases.first!, id: nil)
        XCTAssertNil(emptyStringStretch)

        // Rating exceeds maximum
        let largeRatingStretch = Stretch(name: "", description: "", photo: nil, rating: 6, sides: Side.allCases.first!, target: Target.allCases.first!, id: nil)
        XCTAssertNil(largeRatingStretch)
    }
}
