//
//  RegularAlarmEditingService.swift
//  Domain
//
//  Created by gnksbm on 3/13/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxRelay

public protocol RegularAlarmEditingService {
    var managedAlarm: BehaviorRelay<RegularAlarmResponse> { get }
    func update(
        busStopId: String,
        busStopName: String,
        busId: String,
        busName: String
    )
    func update(time: Date)
    func update(weekday: [Int])
    func update(response: RegularAlarmResponse)
    func resetManagedObject()
}
