//
//  RegularAlarmUseCase.swift
//  Domain
//
//  Created by gnksbm on 3/10/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol RegularAlarmUseCase {
    var fetchedAlarm: PublishSubject<[RegularAlarmResponse]> { get }
    
    func fetchAlarm()
    func removeAlarm(response: RegularAlarmResponse) throws
}
