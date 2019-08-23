//
//  TasksStorageManager.swift
//  Dayloop
//
//  Created by Joshua Tabakhoff on 16/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class TasksStorageManager: ObservableObject {
    var tasksNotificationManager: TasksNotificationManager = TasksNotificationManager()
    
    @Published var tasks: [Task] = []
    
    init(){
//        Storage.remove("tasks.json", from: .documents) // execute when model changes
        if Storage.fileExists("tasks.json", in: .documents) {
            tasks = Storage.retrieve("tasks.json", from: .documents, as: [Task].self)
            
            if Storage.fileExists("dailytasks.json", in: .caches) {
                let cache = Storage.retrieve("dailytasks.json", from: .caches, as: DailyCache.self)
                
                if cache.day == "\(tasksNotificationManager.getDate().day)\(tasksNotificationManager.getDate().month)" {
                    print("Retrieving today's cache")
                    
                    for i in 0..<cache.tasks.count {
                        if let findIndex = tasks.firstIndex(where: { $0.id == cache.tasks[i].id }){
                            tasks[findIndex].done = cache.tasks[i].done
                        }
                    }
                }
            }
        }
    }
    
    func addTask(task: Task){
        tasks.append(task)
        
        tasksNotificationManager.scheduleNotification(task: task)
        
        saveTasks()
    }
    
    func saveTasks(){
        var copyTasks = tasks // Save tasks as undone, which makes sense
        for i in 0..<copyTasks.count {
            copyTasks[i].done = false
        }
        Storage.store(copyTasks, to: .documents, as: "tasks.json")
    }
    
    func removeTask(index: Int){
        // TODO: Ask twice?
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["DLTaskNotification_\(tasks[index].id)"])
        tasks.remove(at: index)
        saveTasks()
    }
    
    func saveTasksDaily(){
        let cache = DailyCache(day: "\(tasksNotificationManager.getDate().day)\(tasksNotificationManager.getDate().month)", tasks: tasks)
        Storage.store(cache, to: .caches, as: "dailytasks.json")
    }
    
    func toggleDone(at pos: Int){
        tasks[pos].done = tasks[pos].done != nil ? !tasks[pos].done! : true
        saveTasksDaily()
    }
    
    func toggleDone(for id: UUID){
        let taskIndex = tasks.firstIndex(where: { $0.id == id })!
        tasks[taskIndex].done = tasks[taskIndex].done != nil ? !tasks[taskIndex].done! : true
        saveTasksDaily()
    }
}
