//
//  PushNotificationEndPoint.swift
//  NetworkService
//
//  Created by gnksbm on 3/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain

public struct PushNotificationEndPoint: EndPoint {
    private let requestModel: PushNotificationRequestable
    
    public var scheme: Scheme {
        .https
    }
    
    public var host: String {
        "fcm.googleapis.com"
    }
    
    public var port: String {
        ""
    }
    
    public var path: String {
        "/send"
    }
    
    public var query: [String: String] {
        [:]
    }
    
    public var header: [String: String] {
        [
            "application/json": "Content-Type",
            "key=\(String.fcmKey)": "Authorization",
        ]
    }
    
    public var body: [String: Any] {
        requestModel.payload
    }
    
    public var method: HTTPMethod {
        .post
    }
    
    public init(data: PushNotificationRequestable) {
        self.requestModel = data
    }
}
