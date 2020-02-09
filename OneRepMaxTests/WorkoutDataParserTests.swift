//
//  WorkoutDataParserTests.swift
//  OneRepMaxTests
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import XCTest
@testable import OneRepMax

class WorkoutDataParserTests: XCTestCase {

    let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter
    }()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testParsePath_invalidPath() {
        let path = "invalid path"
        let parser = WorkoutDataParser(dateFormatter: DateFormatter())
        XCTAssertThrowsError(try parser.parseReource(path))
    }
    
    func testParsePath_noError() {
        guard let path = Bundle.main.path(forResource: "workoutData", ofType: "txt") else {
            XCTFail("Could not create required path for test.")
            return
        }
        let parser = WorkoutDataParser(dateFormatter: dateFormatter)
        XCTAssertNoThrow(try parser.parseReource(path))
    }
}
