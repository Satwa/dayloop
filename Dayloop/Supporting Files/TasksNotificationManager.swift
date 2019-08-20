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
        
        
        func getDate() -> DateComponents {
            let date = Date()
            let calendar = Calendar.current
            
            return calendar.dateComponents([.day, .weekday, .hour, .minute, .second], from: date)
        }
        
        var date: Date
        var triggerer: DateComponents
        var trigger: UNCalendarNotificationTrigger
        
        // TODO: Replace offset-based to https://developer.apple.com/documentation/usernotifications/scheduling_a_notification_locally_from_your_app
        
        switch task.schedule {
            case .daily:
                print("daily")
                let offsetInSeconds = (task.run_hour - getDate().hour!) * 60 * 60
                
                date = Date(timeIntervalSinceNow: TimeInterval(offsetInSeconds))
                triggerer = Calendar.current.dateComponents([.hour], from: date)
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerer, repeats: true)
            case .weekly:
                print("weekly")
                let daysOffsetInSeconds  = (task.run_day! - getDate().weekday!) * 24 * 60 * 60
                let hoursOffsetInSeconds = (task.run_hour - getDate().hour!) * 60 * 60
                let offsetInSeconds = daysOffsetInSeconds + hoursOffsetInSeconds
                
                date = Date(timeIntervalSinceNow: TimeInterval(offsetInSeconds))
                
                triggerer = Calendar.current.dateComponents([.weekday, .hour], from: date)
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerer, repeats: true)
            case .monthly:
                print("monthly")
                let hoursOffsetInSeconds = (task.run_hour - getDate().hour!) * 60 * 60
                let daysOffsetInSeconds  = (task.run_day! - getDate().day!) * 24 * 60 * 60
                let offsetInSeconds = daysOffsetInSeconds + hoursOffsetInSeconds
                
                date = Date(timeIntervalSinceNow: TimeInterval(offsetInSeconds))
                triggerer = Calendar.current.dateComponents([.day, .hour], from: date)
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerer, repeats: true)
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
