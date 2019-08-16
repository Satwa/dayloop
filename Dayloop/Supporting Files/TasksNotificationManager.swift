//
//  TasksNotificationManager.swift
//  Dayloop
//
//  Created by Joshua Tabakhoff on 16/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import UserNotifications

class TasksNotificationManager: ObservableObject{
    class NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate{
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    let uncDelegate = NotificationCenterDelegate()
    
    init(){
        notificationCenter.delegate = uncDelegate
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                print("Not authorized")
                // Notifications not allowed
                // wip: do something
            }
        }
    }
    
    func scheduleNotification(task: Task){
        let content = UNMutableNotificationContent()
        content.title = "Task to complete now"
        content.body = task.name
        content.sound =  .default
        content.badge = 1
        
        let date = Date(timeIntervalSinceNow: 3600)
        var triggerer: DateComponents
        var trigger: UNCalendarNotificationTrigger
        
        switch task.schedule {
            case .daily:
                print("daily")
                triggerer = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerer, repeats: true)
            case .weekly:
                print("weekly")
                triggerer = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: date)
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerer, repeats: true)
            case .monthly:
                print("monthly")
                triggerer = Calendar.current.dateComponents([.day, .weekday, .hour, .minute, .second], from: date)
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerer, repeats: true)
            default:
                print("Missing case: default returned")
        }
        
        let identifier = "DLTaskNotification_\(task.id)"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print("error happened: \(error)")
            }
        })
    }
    
}
