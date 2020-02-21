//
//  NotificationManager.swift
//  Financial Assistant
//
//  Created by Andrew on 2/21/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Foundation

struct NotificationManager {
    static func createNotification(name: Notification.Name) {
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
