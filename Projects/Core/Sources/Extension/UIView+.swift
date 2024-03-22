//
//  UIView+.swift
//  Core
//
//  Created by gnksbm on 1/24/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public extension UIView {
    func addCornerRadius(
        corners: UIRectCorner,
        radius: Int = 10
    ) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }
    
    func addBorder(
        edges: UIRectEdge,
        color: UIColor = .black,
        thickness: CGFloat = 1
    ) {
        let border = CALayer()
        
        switch edges {
        case .top:
            border.frame = CGRect(
                x: 0, 
                y: 0, 
                width: frame.size.width,
                height: thickness
            )
        case .bottom:
            border.frame = CGRect(
                x: 0, 
                y: frame.size.height - thickness,
                width: frame.size.width,
                height: thickness
            )
        case .left:
            border.frame = CGRect(
                x: 0, 
                y: 0,
                width: thickness,
                height: frame.size.height
            )
        case .right:
            border.frame = CGRect(
                x: frame.size.width - thickness, 
                y: 0,
                width: thickness, 
                height: frame.size.height
            )
        default:
            break
        }
        border.backgroundColor = color.cgColor
        layer.addSublayer(border)
    }
}
