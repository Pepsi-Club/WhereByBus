//
//  CircleButton.swift
//  DesignSystem
//
//  Created by gnksbm on 2/2/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public final class CircleButton: UIButton {
    private let baseLine: BaseLine
    private let size: CGFloat?
    
    public init(
        baseLine: BaseLine,
        size: CGFloat? = nil
    ) {
        self.baseLine = baseLine
        self.size = size
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let baseLine: CGFloat
        switch size {
        case .some(let size):
            baseLine = size
        case .none:
            switch self.baseLine {
            case .width:
                baseLine = bounds.width
            case .height:
                baseLine = bounds.height
            }
        }
        let origin = bounds.origin
        bounds = .init(
            origin: origin,
            size: .init(
                width: baseLine,
                height: baseLine
            )
        )
        layer.cornerRadius = baseLine / 2
    }
}

extension CircleButton {
    public enum BaseLine {
        case width, height
    }
}
