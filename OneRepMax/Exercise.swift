//
//  Exercise.swift
//  OneRepMax
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import Foundation

struct OneRepMaxDetails {
    
}

struct OneRepMax {
    let weight: Int
    let exercise: Exercise
}

class OneRepMaxDataStore {
    
    private let exercises: [Exercise]
    private let oneRepMaxCache: [String: OneRepMax] = [:]
    
    private lazy var oneRepMaxData: [OneRepMax] = { [unowned self] in
        return self.getOneRepMaxFromExercises(self.exercises)
    }()
    
    init(exercises: [Exercise]) {
        self.exercises = exercises
    }
    
    func getOneRepMax(queue: DispatchQueue = DispatchQueue.global(), completion: @escaping (([OneRepMax]) -> Void)) {
        queue.async {
            completion(self.oneRepMaxData)
        }
    }
    
    private func getOneRepMaxFromExercises(_ exercises: [Exercise]) -> [OneRepMax] {
        return exercises.compactMap { (exercise) -> OneRepMax? in
            let allSets = exercise.sessions.map({ $0.sets}).flatMap { $0 }
            if let maxWeight = allSets.map({OneRepMaxCalculator.calculate(weight: $0.weight, reps: $0.reps)}).max() {
                return OneRepMax(weight: maxWeight, exercise: exercise)
            }
            return nil
        }
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

struct Exercise {
    let name: String
    let sessions: [Session]
}

extension Exercise {
    struct Session {
        let date: Date
        let sets: [Set]
    }
    
    struct Set {
        let reps: Int
        let weight: Int
    }
}

extension Exercise.Set: Comparable {
    static func < (lhs: Exercise.Set, rhs: Exercise.Set) -> Bool {
        return OneRepMaxCalculator.calculate(weight: lhs.weight, reps: lhs.reps) > OneRepMaxCalculator.calculate(weight: rhs.weight, reps: rhs.reps)
    }
    
    
}
class ExerciseDataStore {
    private let datapoints: [WorkoutDataPoint]
    private lazy var exercises: [Exercise] = { [unowned self] in
        return self.getExercisesFromDataPoints(self.datapoints)
    }()
    
    init(dataPoints: [WorkoutDataPoint]) {
        self.datapoints = dataPoints
    }
    
    func getExercises(queue: DispatchQueue = DispatchQueue.global(), completion: @escaping ([Exercise]) -> Void) {
        queue.async {
            completion(self.exercises)
        }
    }
    
    private func getExercisesFromDataPoints(_ datapoints: [WorkoutDataPoint]) -> [Exercise]{
        let groupedByExerciseName = Dictionary(grouping: datapoints ) { $0.name }
        let exercises = groupedByExerciseName.map { (group) -> Exercise in
            let name = group.key
            let groupedByDate = Dictionary(grouping: group.value) { $0.date }
            let sessions = groupedByDate.map { (group) -> Exercise.Session in
                let date = group.key
                let sets = group.value.map {
                    Exercise.Set(reps: $0.reps, weight: $0.weight)
                }
                return Exercise.Session(date: date, sets: sets)
            }
            return Exercise(name: name, sessions: sessions)
        }
        return exercises
    }
}

