//
//  DefaultPushNotificationService.swift
//  Data
//
//  Created by gnksbm on 3/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain
import NetworkService

import RxSwift

public final class DefaultPushNotificationService: PushNotificationService {
    private let networkService: NetworkService
    private let disposeBag = DisposeBag()
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func makeNotification(data: PushNotificationRequestable) {
        networkService.request(
            endPoint: PushNotificationEndPoint(data: data)
        )
        .subscribe()
        .disposed(by: disposeBag)
    }
}
