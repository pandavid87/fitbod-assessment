//
//  OneRepMaxCalculatorTests.swift
//  OneRepMaxTests
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import XCTest
@testable import OneRepMax

class OneRepMaxCalculatorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCalculator_invalidWeight() {
        
        XCTAssertEqual(OneRepMaxCalculator.calculate(weight: -100, reps: 1), 0)
    }
    func testCalculator_invalidReps() {
        
        XCTAssertEqual(OneRepMaxCalculator.calculate(weight: 100, reps: -1), 0)
        
    }

    func testCalculator_validWeightAndHeight() {
        XCTAssertEqual(OneRepMaxCalculator.calculate(weight: 1, reps: 1), 1)
        XCTAssertEqual(OneRepMaxCalculator.calculate(weight: 100, reps: 6), 116)
    }
}
