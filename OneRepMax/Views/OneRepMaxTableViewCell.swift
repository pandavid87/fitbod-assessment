//
//  OneRepMaxTableViewCell.swift
//  OneRepMax
//
//  Created by David Pan on 2/12/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import UIKit

class OneRepMaxTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing:OneRepMaxTableViewCell.self)
    private let maxRepView: OneRepMaxView = {
        let view = OneRepMaxView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var didSetupConstraints = false
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        if didSetupConstraints == false {
            contentView.addSubview(maxRepView)
            
            let guides = contentView.layoutMarginsGuide
            let constraints = [
                maxRepView.topAnchor.constraint(equalTo: guides.topAnchor),
                maxRepView.bottomAnchor.constraint(equalTo: guides.bottomAnchor),
                maxRepView.leadingAnchor.constraint(equalTo: guides.leadingAnchor),
                maxRepView.trailingAnchor.constraint(equalTo: guides.trailingAnchor)
            ]
            
            NSLayoutConstraint.activate(constraints)
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    func configureWith(viewModel: OneRepMaxViewModel) {
        maxRepView.configureWith(viewModel: viewModel)
    }
}
