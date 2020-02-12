//
//  WorkoutDataPoint.swift
//  OneRepMax
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import Foundation

struct WorkoutDataPoint: Codable {
    let date: Date
    let name: String
    let sets: Int
    let reps: Int
    let weight: Int
}

struct WorkoutDataPointBuilder {
    enum BuilderError: Error {
        case invalidFormat, invalidDateValue(String, DateFormatter), invalidValue
    }
    
    let dateFormatter: DateFormatter
    
    var date: String?
    var name: String?
    var sets: Int?
    var reps: Int?
    var weight: Int?
    
    func build() throws -> WorkoutDataPoint {
        
        guard let date = date,
            let name = name,
            let sets = sets,
            let reps = reps,
            let weight = weight else {
                
            throw BuilderError.invalidFormat
                
        }
        
        guard let dateFormatted = dateFormatter.date(from: date) else {
            throw BuilderError.invalidDateValue(date, dateFormatter)
        }
        guard sets > 0 &&
            reps > 0 &&
            weight >= 0  else {
                throw BuilderError.invalidValue
        }
        
        return WorkoutDataPoint(date: dateFormatted,
                                name: name,
                                sets: sets,
                                reps: reps,
                                weight: weight)
    }
}
