//
//  UITableView+.swift
//  Core
//
//  Created by gnksbm on 1/23/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public extension UITableView {
    func register(_ cellType: UITableViewCell.Type) {
        register(
            cellType,
            forCellReuseIdentifier: cellType.identifier
        )
    }
    
    func register(_ viewType: UITableViewHeaderFooterView.Type) {
        register(
            viewType,
            forHeaderFooterViewReuseIdentifier: viewType.identifier
        )
    }
}
