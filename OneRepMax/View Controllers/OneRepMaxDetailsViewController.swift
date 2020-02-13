//
//  OneRepMaxDetailsViewController.swift
//  OneRepMax
//
//  Created by David Pan on 2/10/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import UIKit
import Combine
import Charts

class OneRepMaxDetailsViewController: UIViewController {
    
    private var subscriptions: [AnyCancellable] = []
    
    private lazy var lineChartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.valueFormatter = DateValueFormatter()
        return chart
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let oneRepMax: OneRepMax
    
    private lazy var dataController: OneRepMaxDetailsDataController = { [unowned self] in
        return OneRepMaxDetailsDataController(oneRepMax: self.oneRepMax)
    }()
    
    init(oneRepMax: OneRepMax) {
        self.oneRepMax = oneRepMax
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = oneRepMax.exercise.name
        view.backgroundColor = UIColor.white
        configureChartView()
        configureLoadingIndicator()
        loadHistoricalData()

        
    }
    
    private func configureLoadingIndicator() {
        view.addSubview(loadingIndicator)
        
        let constraints = [
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureChartView() {
        
        view.addSubview(lineChartView)
        let constraints = [
            lineChartView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func loadHistoricalData() {
        loadingIndicator.startAnimating()
        dataController.loadHistoricalData()
            .sink(
                receiveCompletion: ({ [weak self] completion in
                    DispatchQueue.main.async {
                        if case .failure(let error) = completion {
                            self?.presentAlertForError(error)
                        }
                        self?.loadingIndicator.stopAnimating()
                    }
                }),
                receiveValue: ({ [weak self] lineChartData in
                    DispatchQueue.main.async {
                        self?.lineChartView.data = lineChartData
                        self?.lineChartView.notifyDataSetChanged()
                    }
                }))
            .store(in: &subscriptions)
        

    }
}

class DateValueFormatter: IAxisValueFormatter {
    let dateFormatter: DateFormatter
    init(dateFormatter: DateFormatter = DateFormatter.workoutDataDateFormatter){
        self.dateFormatter = dateFormatter
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

class IntValueFormatter: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return Int(value).description
    }
}
