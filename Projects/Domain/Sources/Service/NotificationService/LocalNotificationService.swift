//
//  LocalNotificationService.swift
//  Domain
//
//  Created by gnksbm on 2/27/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import UserNotifications

import RxSwift

public protocol LocalNotificationService {
    var authState: BehaviorSubject<UNAuthorizationStatus> { get }
    
    func authorize()
    func fetchRegularAlarm() -> Observable<[RegularAlarmResponse]>
    func registNewRegularAlarm(response: RegularAlarmResponse) throws
    func editRegularAlarm(response: RegularAlarmResponse) throws
    func removeRegularAlarm(response: RegularAlarmResponse) throws
}
