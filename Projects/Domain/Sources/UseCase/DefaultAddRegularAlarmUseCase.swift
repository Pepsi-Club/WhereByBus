//
//  DefaultAddRegularAlarmUseCase.swift
//  Domain
//
//  Created by gnksbm on 2/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public final class DefaultAddRegularAlarmUseCase: AddRegularAlarmUseCase {
    private let localNotificationService: LocalNotificationService
    
    public init(
        localNotificationService: LocalNotificationService
    ) {
        self.localNotificationService = localNotificationService
    }
    
    public func checkNotificationAuth() {
        localNotificationService.authorize()
    }
    
    public func addNewAlarm(response: RegularAlarmResponse) {
        do {
            try localNotificationService.registNewRegularAlarm(
                response: response
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func editAlarm(response: RegularAlarmResponse) {
        do {
            try localNotificationService.editRegularAlarm(response: response)
        } catch {
            print(error.localizedDescription)
        }
    }
}
