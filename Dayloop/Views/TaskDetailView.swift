//
//  TaskDetailView.swift
//  Dayloop
//
//  Created by Joshua Tabakhoff on 26/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct TaskDetailView: View {
    @Binding var task: Task
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    internal var tasksManager: TasksStorageManager = (UIApplication.shared.delegate as! AppDelegate).tasksManager
    
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $task.name)
                
                TextField("Description", text: $task.content)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
            
            Section {
                VStack{
                    Spacer()
                    Button("Delete task (irreversible - no confirmation)"){
                        self.tasksManager.removeTask(index: self.tasksManager.tasks.firstIndex(where: { $0.id == self.task.id })!)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                    Spacer()
                }
            }
        }
        
        .navigationBarTitle(task.name)
        .navigationBarItems(trailing: Button("Save"){
            let task_id = self.tasksManager.tasks.firstIndex(where: { $0.id == self.task.id })! // not crash-proof
            self.tasksManager.tasks[task_id] = self.task
            self.tasksManager.saveTasks()
            
            self.presentationMode.wrappedValue.dismiss()
        })
    }
}
//
//struct TaskDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskDetailView(task: .constant(Task(name: "Task #1", schedule: .daily, run_hour: 8)))
//    }
//}
