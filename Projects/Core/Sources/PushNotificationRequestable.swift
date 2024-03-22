//
//  PushNotificationRequestable.swift
//  Core
//
//  Created by gnksbm on 3/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol PushNotificationRequestable {
    var payload: [String: Any] { get }
}
