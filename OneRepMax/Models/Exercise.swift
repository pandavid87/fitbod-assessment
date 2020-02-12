//
//  Exercise.swift
//  OneRepMax
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import Foundation

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


