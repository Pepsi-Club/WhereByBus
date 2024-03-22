//
//  BCTimer.swift
//  Core
//
//  Created by gnksbm on 3/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxRelay

public final class BCTimer {
    private var timer: Timer?
    public var distanceFromStart = BehaviorRelay<Int>(value: 0)
    
    public init() { }
    
    public func start(interval: TimeInterval = 1) {
        let startDate = Date()
        timer = .scheduledTimer(
            withTimeInterval: interval,
            repeats: true
        ) { [weak self] timer in
            self?.distanceFromStart.accept(
                Int(
                    startDate.distance(to: timer.fireDate)
                )
            )
        }
    }
    
    public func stop() {
        distanceFromStart.accept(0)
        timer?.invalidate()
        timer = nil
    }
}
