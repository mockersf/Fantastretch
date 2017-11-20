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
        let zeroRatingStretch = Stretch(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingStretch)

        // Highest positive rating
        let positiveRatingStretch = Stretch(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingStretch)
    }

    // Confirm that the Meal initialier returns nil when passed a negative rating or an empty name.
    func testStretchInitializationFails() {
        // Negative rating
        let negativeRatingStretch = Stretch(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingStretch)

        // Empty String
        let emptyStringStretch = Stretch(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringStretch)

        // Rating exceeds maximum
        let largeRatingStretch = Stretch(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingStretch)
    }
}
