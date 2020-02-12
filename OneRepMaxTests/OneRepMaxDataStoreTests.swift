//
//  OneRepMaxDataStoreTests.swift
//  OneRepMaxTests
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import XCTest
@testable import OneRepMax
import Combine


class OneRepMaxDataStoreTests: XCTestCase {

    var subscriptions: [AnyCancellable] = []
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataStore_empty() {
        let data = try! OneRepMaxDataRequest.getOneRepMaxDataForExercises([])
        XCTAssertTrue(data.isEmpty)
    }
    
    func testDataStore_getSingleExercise() {
        
        let sets = [
            Exercise.Set(reps: 5, weight: 100),
            Exercise.Set(reps: 6, weight: 100)
        ]
        let session = Exercise.Session(date: Date(), sets: sets)
        let exercise = Exercise(name: "Mock exercise", sessions: [session])
        let data = try! OneRepMaxDataRequest.getOneRepMaxDataForExercises([exercise])
        XCTAssertEqual(data.count, 1)
        let oneRepMax = data[0]
        XCTAssertEqual(oneRepMax.weight, 116)
    }

}
