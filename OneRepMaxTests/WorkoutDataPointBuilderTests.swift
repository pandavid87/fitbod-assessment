//
//  WorkoutDataPointBuilderTests.swift
//  OneRepMaxTests
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

@testable import OneRepMax
import XCTest


class WorkoutDataPointBuilderTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testBuild_throwsInvalidFormat() {
        
        let builder = WorkoutDataPointBuilder(dateFormatter: DateFormatter())
        XCTAssertThrowsError(try builder.build())
                
    }
    
    func testBuild_throwsInvalidValueDate() {
        
        var builder = WorkoutDataPointBuilder.withTestingDefaults()
        builder.date = "invalid date format"
        XCTAssertThrowsError(try builder.build())
    }
    
    func testBuild_throwsInvalidSets() {
        
        var builder = WorkoutDataPointBuilder.withTestingDefaults()
        builder.sets = -1
        XCTAssertThrowsError(try builder.build())
    }
    
    
    func testBuild_throwsInvalidReps() {
        
        var builder = WorkoutDataPointBuilder.withTestingDefaults()
        builder.reps = -1
        XCTAssertThrowsError(try builder.build())
    }
    
    
    func testBuild_throwsInvalidWeight() {
        
        var builder = WorkoutDataPointBuilder.withTestingDefaults()
        builder.weight = -1
        XCTAssertThrowsError(try builder.build())
    }
    
    func testBuild_success(){
        XCTAssertNoThrow(try WorkoutDataPointBuilder.withTestingDefaults().build())
    }
}

extension WorkoutDataPointBuilder {
    static func withTestingDefaults() -> WorkoutDataPointBuilder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return WorkoutDataPointBuilder(dateFormatter: dateFormatter, date: "1/1/20", name: "mock name", sets: 1, reps: 1, weight: 1)
    }
}
