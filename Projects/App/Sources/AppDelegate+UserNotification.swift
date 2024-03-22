//
//  AppDelegate+UserNotification.swift
//  App
//
//  Created by gnksbm on 2/27/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate {
    func configureNotification(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        completionHandler([.banner, .badge, .sound, .list])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
