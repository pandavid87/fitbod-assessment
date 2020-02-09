//
//  ExerciseSetTests.swift
//  OneRepMaxTests
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import XCTest
@testable import OneRepMax

class ExerciseSetTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExerciseSet_comparableLessthan () {
        let set1 = Exercise.Set(reps: 8, weight: 100)
        let set2 = Exercise.Set(reps: 10, weight: 100)
        XCTAssertTrue(set2 < set1)
    }
    

}
