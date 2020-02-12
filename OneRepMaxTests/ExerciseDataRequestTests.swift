//
//  ExerciseDataStoreTests.swift
//  OneRepMaxTests
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import XCTest
import Combine

@testable import OneRepMax

class ExerciseDataRequestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_NoDataPoints() {
        let results = ExerciseDataRequest.getExercisesForDataPoints([])
        XCTAssertTrue(results.isEmpty)
    }

    func test_getExercisesWithSingleDataPoint() {
        let mockDataPoint = WorkoutDataPoint(date: Date(timeIntervalSince1970: 0), name: "mock exercise", sets: 2, reps: 5, weight: 1)
        let exercises = ExerciseDataRequest.getExercisesForDataPoints([mockDataPoint])
        XCTAssertEqual(exercises.count, 1)
        let exercise = exercises[0]
        XCTAssertEqual(exercise.name, mockDataPoint.name)
        XCTAssertEqual(exercise.sessions.count, 1)
        let session = exercise.sessions[0]
        XCTAssertEqual(session.date, mockDataPoint.date)
        XCTAssertEqual(session.sets.count, 1)
        let set = session.sets[0]
        XCTAssertEqual(set.reps, mockDataPoint.reps)
        XCTAssertEqual(set.weight, mockDataPoint.weight)
    }
    
    func test_getExercisesWithMultipleDataPoint() {
        let numMocks = 10
        let mockDataPoints = WorkoutDataPoint.createMocks(numMocks)
        let exercises = ExerciseDataRequest.getExercisesForDataPoints(mockDataPoints)
        
        XCTAssertEqual(exercises.count, numMocks)
    }
    
}

extension WorkoutDataPoint {
    static func createMocks(_ n: Int) -> [WorkoutDataPoint] {
        guard n >= 0 else { return [] }
        
        return (0..<n).map { i in
            let mockDate = Date()
            let name = "mock exercise \(i)"
            let sets = Int.random(in: 1..<10)
            let reps = Int.random(in: 1..<20)
            let weight = Int.random(in: 5..<500)
            return WorkoutDataPoint(date: mockDate, name: name, sets: sets, reps: reps, weight: weight)
        }
    }
}
