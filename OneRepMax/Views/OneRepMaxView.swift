//
//  OneRepMaxView.swift
//  OneRepMax
//
//  Created by David Pan on 2/9/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import UIKit

protocol OneRepMaxViewModel {
    var exerciseName: String { get }
    var sublabel: String? { get }
    var maxWeight: Int { get }
    
}

class OneRepMaxView: UIView {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let nameSubLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .footnote )
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines = 0
        return label
    }()
    
    private let maxWeightLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .headline )
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.textAlignment = .right
        return label
    }()
    
    private var didSetupConstraints = false
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        
        if didSetupConstraints == false {

            addSubview(nameLabel)
            addSubview(nameSubLabel)
            addSubview(maxWeightLabel)
            
            let constraints = [
                nameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                nameSubLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                nameSubLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
                nameSubLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
                maxWeightLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                maxWeightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                maxWeightLabel.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor),
                maxWeightLabel.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor)
            ]
            
            NSLayoutConstraint.activate(constraints)
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func configureWith(viewModel: OneRepMaxViewModel) {
        nameLabel.text = viewModel.exerciseName
        nameSubLabel.text = viewModel.sublabel
        maxWeightLabel.text = "\(viewModel.maxWeight)"
    }
    
}
