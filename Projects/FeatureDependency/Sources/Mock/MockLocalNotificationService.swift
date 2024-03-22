//
//  MockLocalNotificationService.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import NotificationCenter

import Domain

import RxSwift

#if DEBUG
public final class MockLocalNotificationService: LocalNotificationService {
    
    public var authState = BehaviorSubject<UNAuthorizationStatus>(
        value: .denied
    )
    
    public init() { }
    
    public func authorize() {
    }
    
    public func fetchRegularAlarm() -> Observable<[RegularAlarmResponse]> {
        .just(
            [
                .init(
                    busStopId: "테스트",
                    busStopName: "영등포역",
                    busId: "테스트",
                    busName: "영등포02",
                    time: .now,
                    weekDay: [0, 5]
                ),
                .init(
                    busStopId: "테스트",
                    busStopName: "영등포역",
                    busId: "테스트",
                    busName: "영등포02",
                    time: .now,
                    weekDay: [0, 5]
                ),
                .init(
                    busStopId: "테스트",
                    busStopName: "영등포역",
                    busId: "테스트",
                    busName: "영등포02",
                    time: .now,
                    weekDay: [0, 5]
                ),
            ]
        )
    }
    
    public func registNewRegularAlarm(response: Domain.RegularAlarmResponse) throws {
        
    }
    
    public func editRegularAlarm(response: Domain.RegularAlarmResponse) throws {
        
    }
    
    public func removeRegularAlarm(response: Domain.RegularAlarmResponse) throws {
        
    }
}
#endif
