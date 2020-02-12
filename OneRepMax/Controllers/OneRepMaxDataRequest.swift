//
//  OneRepMaxDataStore.swift
//  OneRepMax
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import Foundation
import Combine

struct OneRepMax {
    let weight: Int
    let exercise: Exercise
}

final class OneRepMaxDataRequest {
    
    enum DataError: Error{
        case couldNotCalculateMax(Exercise)
    }
    
    class func getOneRepMaxDataForExercises(_ exercises: [Exercise]) throws -> [OneRepMax] {
        let oneRepMaxData = try exercises.map { (exercise) -> OneRepMax in
            let allSets = exercise.sessions.map({ $0.sets}).flatMap { $0 }
            guard let maxWeight = allSets.map({OneRepMaxCalculator.calculate(weight: $0.weight, reps: $0.reps)}).max() else {
                throw DataError.couldNotCalculateMax(exercise)
            }
            return OneRepMax(weight: maxWeight, exercise: exercise)
        }
        return oneRepMaxData
    }
}

class OneRepMaxCalculator {
    
    
    /// Calculate the one rep max given a number of weights and reps
    /// This func uses the Brzycki method
    /// - Parameters:
    ///   - weight: Weight used for the exercise
    ///   - reps: Number of reps for the given weight
    class func calculate(weight: Int, reps: Int) -> Int {
        guard weight > 0 && (0..<37).contains(reps) else {
            return 0
        }
        
        return Int( Double(weight) * (36.0 / (37.0 - Double(reps))) )
    }
}
