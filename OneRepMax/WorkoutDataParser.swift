//
//  WorkoutDataParser.swift
//  OneRepMax
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import Foundation


enum WorkoutDataParserError: Error {
    case invalidFormat
}

protocol DataParser {
    associatedtype ParsedData
    func parseReource(_ path: String) throws -> [ParsedData]
}

class WorkoutDataParser: DataParser {
    typealias ParsedData = WorkoutDataPoint

    enum DataIndices: Int, CaseIterable {
        case date, name, sets, reps, weight
    }
    let dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    func parseReource(_ path: String) throws -> [WorkoutDataPoint] {
        let stringData = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        return try parseString(stringData)
    }
    
    func parseString(_ data: String) throws -> [WorkoutDataPoint] {
        let lines = data.split(separator: "\n")
        let parsed = try lines.map { (line) -> WorkoutDataPoint in
            
            let csvData = line.split(separator: ",").map({ String($0 )})
            
            guard csvData.count == WorkoutDataParser.DataIndices.allCases.count else {
                throw WorkoutDataParserError.invalidFormat
            }
            
            var builder = WorkoutDataPointBuilder(dateFormatter: dateFormatter)
            
            for index in WorkoutDataParser.DataIndices.allCases {
                let data = csvData[index.rawValue]
                switch index {
                case .date:
                    builder.date = data
                case .name:
                    builder.name = data
                case .reps:
                    builder.reps = Int(data)
                case .sets:
                    builder.sets = Int(data)
                case .weight:
                    builder.weight = Int(data)
                }
            }
            
            return try builder.build()
        }
        
        return parsed
    }
}
