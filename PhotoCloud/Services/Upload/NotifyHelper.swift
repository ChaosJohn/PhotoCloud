//
//  NotifyHelper.swift
//  PhotoCloud
//
//  Created by liupeng on 01/09/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation

struct NotifyHelper {
    
   static func showNotify(_ title:String, desc:String = ""){
        if !Preferences.SharedPreferences().isNotifyEnable {
            return
        }
        NSApp.activate(ignoringOtherApps: true)
        let notification = NSUserNotification.init()
        notification.title = title
        notification.informativeText = desc
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
}
