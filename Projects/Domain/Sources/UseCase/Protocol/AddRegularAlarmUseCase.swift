//
//  AddRegularAlarmUseCase.swift
//  Domain
//
//  Created by gnksbm on 2/14/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol AddRegularAlarmUseCase {
    func checkNotificationAuth()
    func addNewAlarm(response: RegularAlarmResponse)
    func editAlarm(response: RegularAlarmResponse)
}
