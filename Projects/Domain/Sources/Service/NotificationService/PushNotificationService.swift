//
//  PushNotificationService.swift
//  Domain
//
//  Created by gnksbm on 3/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public protocol PushNotificationService {
    func makeNotification(data: PushNotificationRequestable)
}
