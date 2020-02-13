//
//  OneRepMaxDataController.swift
//  OneRepMax
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import Foundation
import Combine

class OneRepMaxDataController {
    let resourcePath: String
    let dateFormatter: DateFormatter
    
    private(set) var oneRepMaxData: [OneRepMax] = []
    
    init(resourcePath: String, dateFormatter: DateFormatter = DateFormatter.workoutDataDateFormatter) {
        self.resourcePath = resourcePath
        self.dateFormatter = dateFormatter
    }
    
    private var dataLoadSubscription: AnyCancellable?
    
    
    /// Number of exercises that have a One Rep Max
    var count: Int {
        return oneRepMaxData.count
    }

    /// Getter for reading one rep max data
    /// - Parameter index: index of the target exercise
    func getData(atIndex index: Int) -> OneRepMax? {
        guard (0..<count).contains(index) else {
            return nil
        }
        return oneRepMaxData[index]
    }
    
    /// Loads the data from the resourcePath passed in during initialziation
    ///
    /// - Parameter queue: queue to perform work asynchronously on, defaults ot DispatchQueue.global()
    @discardableResult
    func loadData(queue: DispatchQueue = DispatchQueue.global()) -> AnyPublisher<[OneRepMax], Error> {
        let future = Future<[OneRepMax], Error> { promise in
            do {
                let parser =  WorkoutDataParser(dateFormatter: self.dateFormatter)
                self.dataLoadSubscription = try parser.parseReource(self.resourcePath)
                    .publisher
                    .collect()
                    .map(ExerciseDataRequest.getExercisesForDataPoints(_:))
                    .tryMap(OneRepMaxDataRequest.getOneRepMaxDataForExercises(_:))
                    .sink(
                        receiveCompletion: ({ completion in
                            if case .failure(let error) = completion {
                                promise(.failure(error))
                            }
                        }),
                        receiveValue: ({ data in
                            promise(.success(data))
                        }))
            }
            catch (let error) {
                promise(.failure(error))
            }
        }
        
        dataLoadSubscription = future
            .sink(receiveCompletion: { _ in },
                  receiveValue: { self.oneRepMaxData = $0})
            
        return future.eraseToAnyPublisher()
        
    }
}
    

