//
//  OneRepMaxDetailRequest.swift
//  OneRepMax
//
//  Created by David Pan on 2/12/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import Foundation

final class OneRepMaxDetailDataRequest {
    enum DataError: Error{
        case couldNotCalculateOneRepMax(Exercise, Exercise.Session)
    }
    
    struct HistoricalDataPoint {
        let date: Date
        let weight: Int
    }

    class func getHistoricalDataPointsFor(_ exercise: Exercise) throws -> [HistoricalDataPoint] {
        let dataPoints = try exercise.sessions.map { (session) -> HistoricalDataPoint in
            if let max = session.sets.map({OneRepMaxCalculator.calculate(weight: $0.weight, reps: $0.reps)}).max() {
                return HistoricalDataPoint(date: session.date, weight: max)
            }
            else {
                throw DataError.couldNotCalculateOneRepMax(exercise, session)
            }
        }
        return dataPoints
    }
}
