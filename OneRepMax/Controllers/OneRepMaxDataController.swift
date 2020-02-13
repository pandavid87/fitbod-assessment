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
    
    private(set) var oneRepMaxData: CurrentValueSubject<[OneRepMax], Error> = CurrentValueSubject([])    
    
    init(resourcePath: String, dateFormatter: DateFormatter = DateFormatter.workoutDataDateFormatter) {
        self.resourcePath = resourcePath
        self.dateFormatter = dateFormatter
    }
    
    private var dataLoadSubscription: AnyCancellable?
    
    
    /// Number of exercises that have a One Rep Max
    var count: Int {
        return oneRepMaxData.value.count
    }
    
    
    /// Getter for reading one rep max data
    /// - Parameter index: index of the target exercise
    func getData(atIndex index: Int) -> OneRepMax? {
        guard (0..<count).contains(index) else {
            return nil
        }
        return oneRepMaxData.value[index]
    }
    
    /// Loads the data from the resourcePath passed in during initialziation
    ///
    /// - Parameter queue: queue to perform work asynchronously on, defaults ot DispatchQueue.global()
    @discardableResult
    func loadData(queue: DispatchQueue = DispatchQueue.global()) -> AnyPublisher<[OneRepMax], Error> {
        queue.async {
            do {
                let parser =  WorkoutDataParser(dateFormatter: self.dateFormatter)
                self.dataLoadSubscription = try parser.parseReource(self.resourcePath)
                    .publisher
                    .collect()
                    .map(ExerciseDataRequest.getExercisesForDataPoints(_:))
                    .tryMap(OneRepMaxDataRequest.getOneRepMaxDataForExercises(_:))
                    .sink(receiveCompletion: { self.oneRepMaxData.send(completion: $0)},
                          receiveValue: ( { self.oneRepMaxData.value = $0 }))
            }
            catch (let error) {
                self.oneRepMaxData.send(completion: .failure(error))
            }
        }
        return oneRepMaxData.eraseToAnyPublisher()
    }
}
    

