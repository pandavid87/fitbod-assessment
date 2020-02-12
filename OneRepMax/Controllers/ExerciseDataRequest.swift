//
//  ExerciseDataStore.swift
//  OneRepMax
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import Foundation
import Combine

final class ExerciseDataRequest {
    class func getExercisesForDataPoints(_ datapoints: [WorkoutDataPoint]) -> [Exercise] {
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
            }.sorted { $0.date > $1.date }
            return Exercise(name: name, sessions: sessions)
        }
        return exercises
    }
}
