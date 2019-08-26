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
        
        override init(){
            super.init()
            
            // Declare notification category (and actions related)
            let doneAction = UNNotificationAction(identifier: "DONE_ACTION",
                  title: "Mark as Done",
                  options: .init())
            
            let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                  title: "Snooze for 30mn",
                  options: .init())
            
            let taskCategory =
                  UNNotificationCategory(identifier: "TASK_NOW_CAT",
                  actions: [doneAction, snoozeAction],
                  intentIdentifiers: [],
                  hiddenPreviewsBodyPlaceholder: "",
                  options: .customDismissAction)
            
            notificationCenter.setNotificationCategories([taskCategory]) // later: summaryCategory?
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .badge, .sound])
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let notification = response.notification.request.content
            
            if notification.categoryIdentifier == "TASK_NOW_CAT" {
                let taskId = notification.userInfo["task_id"] as! String
                let tasksManager = (UIApplication.shared.delegate as! AppDelegate).tasksManager
                
                switch response.actionIdentifier {
                    case "DONE_ACTION":
                        tasksManager.toggleDone(for: UUID(uuidString: taskId)!)
                    break
                    
                    case "SNOOZE_ACTION":
                        let redeschuledTask = tasksManager.tasks.first{ $0.id == UUID(uuidString: taskId)! }!
                        
                        let content = UNMutableNotificationContent()
                        content.title = "Task delayed to complete now"
                        content.body = redeschuledTask.name
                        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "notification.caf"))
                        content.categoryIdentifier = "TASK_NOW_CAT"
                        content.badge = 1
                        content.userInfo = ["task_id": taskId]
                        
                        let identifier = "DLTaskNotification_\(taskId)_rescheduled"
                        let date = Date(timeIntervalSinceNow: 1800)
                        let triggerer: DateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
                        let trigger: UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: triggerer, repeats: false)
                        
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        
                        notificationCenter.add(request, withCompletionHandler: { (error) in
                            if let error = error {
                                // Something went wrong
                                print("error happened: \(error)")
                            }
                        })
                    break
                    
                    default:
                    break
                }
            }
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
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "notification.caf"))
        content.categoryIdentifier = "TASK_NOW_CAT"
        content.badge = 1
        content.userInfo = ["task_id": task.id.uuidString]
        
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
    
    func deactivateNotification(task: Task){
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["DLTaskNotification_\(task.id)"])
    }
    
    func getDate() -> DateComponents {
        let date = Date()
        let calendar = Calendar.current
        
        return calendar.dateComponents([.day, .weekday, .hour, .minute, .second], from: date)
    }
    
}
