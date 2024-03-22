//
//  UITableView+.swift
//  DesignSystem
//
//  Created by gnksbm on 2/14/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public extension UITableView {
    func loadingBackground() {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = DesignSystemAsset.accentColor.color
        backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
    }
}
