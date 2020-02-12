//
//  ViewController.swift
//  OneRepMax
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import UIKit
import Combine

class OneRepMaxTableViewController: UITableViewController {

    private(set) var dataController: OneRepMaxDataController?
    private(set) var dataSubscription: AnyCancellable?
    
    private lazy var loadingIndicator: UIActivityIndicatorView = { [unowned self] in
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        return indicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoadingIndicator()
        configureTableView()
        
        loadData()
    }
    
    private func loadData() {
        
        if let path = Bundle.main.path(forResource: "workoutData", ofType: "txt") {
            
            let dataController = OneRepMaxDataController(resourcePath: path)
            dataSubscription = dataController.oneRepMaxData
                .sink(receiveCompletion: { [weak self] (completion) in
                    
                    DispatchQueue.main.async {
                        self?.loadingIndicator.stopAnimating()
                        if case .failure(let error) = completion {
                            self?.presentAlertForError(error)
                        }
                    }
                    
                    },
                      receiveValue: { [weak self]  _ in
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                          
                })
            
            loadingIndicator.startAnimating()
            dataController.loadData()
            
            
            self.dataController = dataController
        }
    }
    
    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(OneRepMaxTableViewCell.self, forCellReuseIdentifier: OneRepMaxTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    private func configureLoadingIndicator() {
        view.addSubview(loadingIndicator)
        let constraints = [
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension OneRepMaxTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataController?.oneRepMaxData.value.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OneRepMaxTableViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? OneRepMaxTableViewCell, let cellData = dataController?.getData(atIndex: indexPath.row) {
            cell.configureWith(viewModel: cellData)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let dataController = dataController, let selected = dataController.getData(atIndex: indexPath.row) {
            
            let detailVC = OneRepMaxDetailsViewController(oneRepMax: selected)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}



extension OneRepMax: OneRepMaxViewModel {
    var maxWeight: Int {
        return weight
    }
    
    var exerciseName: String {
        return exercise.name
    }
    
    var sublabel: String? {
        return "One Rep Max • lbs"
    }
}
