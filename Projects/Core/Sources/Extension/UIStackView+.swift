//
//  UIStackView+.swift
//  Core
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public extension UIStackView {
    func addDivider(
        color: UIColor,
        hasPadding: Bool = false,
        dividerRatio: Double = 1
    ) {
        let subViewCount = arrangedSubviews.count
        var insertAt = 1
        if subViewCount > 1 {
            for _ in 1...subViewCount - 1 {
                let separator = UIView()
                separator.backgroundColor = color
                insertArrangedSubview(separator, at: insertAt)
                insertAt += 2
                switch axis {
                case .vertical:
                    NSLayoutConstraint.activate([
                        separator.heightAnchor.constraint(equalToConstant: 1),
                        separator.widthAnchor.constraint(
                            equalTo: self.widthAnchor, 
                            multiplier: dividerRatio
                        )
                    ])
                case .horizontal:
                    NSLayoutConstraint.activate([
                        separator.widthAnchor.constraint(equalToConstant: 1),
                        separator.heightAnchor.constraint(
                            equalTo: self.heightAnchor, 
                            multiplier: dividerRatio
                        )
                    ])
                @unknown default:
                    break
                }
            }
        }
        if hasPadding {
            insertArrangedSubview(UIView(), at: 0)
            insertArrangedSubview(UIView(), at: arrangedSubviews.count)
        }
    }
}
