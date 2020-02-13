//
//  OneRepMaxDetailsViewController.swift
//  OneRepMax
//
//  Created by David Pan on 2/12/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import Foundation
import Combine
import Charts

final class OneRepMaxDetailsDataController {

    private var subscription: AnyCancellable?
    private let oneRepMax: OneRepMax
    
    init(oneRepMax: OneRepMax) {
        self.oneRepMax = oneRepMax
    }
    
    @discardableResult
    func loadHistoricalData(queue: DispatchQueue = DispatchQueue.global()) -> AnyPublisher<LineChartData, Error> {
        return Future<LineChartData, Error> { promise in
            queue.async {
                do {
                    let historicalData = try OneRepMaxDetailDataRequest.getHistoricalDataPointsFor(self.oneRepMax.exercise).reversed()
                    let chartEntries = historicalData.map({ ChartDataEntry(x: Double($0.date.timeIntervalSince1970), y: Double($0.weight)) })
                    let chartDataSet = LineChartDataSet(entries: chartEntries, label: "One Rep Max • lbs")
                    chartDataSet.valueFormatter = IntValueFormatter()
                    let chartData = LineChartData(dataSet: chartDataSet)
                    promise(.success(chartData))
                }
                catch (let error) {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()

        
    }
}

