//
//  UIViewController+.swift
//  Core
//
//  Created by gnksbm on 3/15/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public extension UIViewController {
    func hideKeyboard() {
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(UIViewController.dismissKeyboard)
            )
        )
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
