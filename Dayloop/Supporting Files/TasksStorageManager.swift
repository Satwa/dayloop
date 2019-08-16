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
    @Published var tasks: [Task] = []
    
    init(){
//        Storage.remove("tasks.json", from: .documents)
        if Storage.fileExists("tasks.json", in: .documents) {
            tasks = Storage.retrieve("tasks.json", from: .documents, as: [Task].self)
        }
    }
    
    func addTask(task: Task){
        tasks.append(task)
        
        saveTasks() // wip
    }
    
    func saveTasks(){
        Storage.store(tasks, to: .documents, as: "tasks.json")
    }
}
