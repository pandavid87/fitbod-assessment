//
//  UIViewController+Extensions.swift
//  OneRepMax
//
//  Created by David Pan on 2/12/20.
//  Copyright © 2020 David Pan. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlertForError(_ error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

