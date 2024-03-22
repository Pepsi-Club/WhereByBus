//
//  MockRegualrAlarmEditingService.swift
//  FeatureDependency
//
//  Created by Jisoo HAM on 3/14/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxRelay

#if DEBUG
public final class MockRegualrAlarmEditingService: RegularAlarmEditingService {
    public var managedAlarm: BehaviorRelay<RegularAlarmResponse> = .init(
        value: .init(
            busStopId: "",
            busStopName: "",
            busId: "",
            busName: "",
            time: .now,
            weekDay: []
        )
    )
    public init() { }
    
    public func update(busStopId: String, busStopName: String, busId: String, busName: String) {
        
    }
    
    public func update(time: Date) {
        
    }
    
    public func update(weekday: [Int]) {
        
    }
    
    public func update(response: Domain.RegularAlarmResponse) {
        
    }
    
    public func resetManagedObject() {
        
    }
}
#endif
