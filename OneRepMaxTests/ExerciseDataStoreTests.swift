//
//  ExerciseDataStoreTests.swift
//  OneRepMaxTests
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import XCTest
@testable import OneRepMax

class ExerciseDataStoreTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_NoDataPoints() {
        let expect = expectation(description: "Data Store getExercises")
        let dataStore = ExerciseDataStore(dataPoints: [])
        dataStore.getExercises { (exercises) in
            XCTAssertEqual(exercises.count, 0)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_getExercisesWithSingleDataPoint() {
        let expect = expectation(description: "Data Store getExercises")
        let mockDataPoint = WorkoutDataPoint(date: Date(timeIntervalSince1970: 0), name: "mock exercise", sets: 2, reps: 5, weight: 1)
        let dataStore = ExerciseDataStore(dataPoints: [mockDataPoint])
        dataStore.getExercises { (exercises) in
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
            
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_getExercisesWithMultipleDataPoint() {
        let expect = expectation(description: "Data Store getExercises")
        let numMocks = 10
        let mockDataPoints = WorkoutDataPoint.createMocks(numMocks)
        
        let dataStore = ExerciseDataStore(dataPoints: mockDataPoints)
        dataStore.getExercises { (exercises) in
            XCTAssertEqual(exercises.count, numMocks)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
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
