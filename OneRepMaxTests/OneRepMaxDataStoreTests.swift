//
//  OneRepMaxDataStoreTests.swift
//  OneRepMaxTests
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import XCTest
@testable import OneRepMax

class OneRepMaxDataStoreTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataStore_empty() {
        let expect = expectation(description: "OneRepMaxDataStore getOneRepMaxExercises")
        let store = OneRepMaxDataStore(exercises: [])
        
        store.getOneRepMax { (data) in
            XCTAssertTrue(data.isEmpty)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testDataStore_getSingleExercise() {
        let expect = expectation(description: "OneRepMaxDataStore getOneRepMaxExercises")
        let sets = [
            Exercise.Set(reps: 5, weight: 100),
            Exercise.Set(reps: 6, weight: 100)
        ]
        let session = Exercise.Session(date: Date(), sets: sets)
        let exercise = Exercise(name: "Mock exercise", sessions: [session])
        let store = OneRepMaxDataStore(exercises: [exercise])
        
        store.getOneRepMax { (data) in
            print(data)
            XCTAssertEqual(data.count, 1)
            let oneRepMax = data[0]
            XCTAssertEqual(oneRepMax.weight, 116)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

}
