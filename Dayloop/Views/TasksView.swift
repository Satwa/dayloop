//
//  ContentView.swift
//  Dayloop
//
//  Created by Joshua Tabakhoff on 16/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct TasksView: View {
    @EnvironmentObject var tasksManager: TasksStorageManager
    
    @State var showTasksType: Int = 0
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: AddTaskView()){
                    Text("Add task")
                }
                
                Picker("Options", selection: $showTasksType) {
                    Text("Today's tasks").tag(0)
                    Text("All tasks").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                List{ // TODO: Switch tags to some kind of enum w/ logic inside to reduce filter statement [this is causing memory leaks]
                    ForEach(self.tasksManager.tasks.filter{ showTasksType == 0 ? ($0.schedule == .daily || ($0.schedule == .weekly && $0.run_day! == tasksManager.tasksNotificationManager.getDate().weekday!) || ($0.schedule == .monthly && $0.run_day! == tasksManager.tasksNotificationManager.getDate().day!)) : true }){ task in
                        TaskRowComponent(task: self.$tasksManager.tasks[self.tasksManager.tasks.firstIndex(where: { $0.id == task.id })!])
                        .onTapGesture{
                            self.tasksManager.toggleDone(at: self.tasksManager.tasks.firstIndex(where: { $0.id == task.id })!)
                        }
                    }
                    .onDelete(perform: self.deleteTask)
                }
            }
            
            .navigationBarTitle("Dayloop")
        }
        .accentColor(.init("accentColor"))
    }
    
    func deleteTask(at offsets: IndexSet){
        if let first = offsets.first {
            tasksManager.removeTask(index: first)
        }
    }
}

#if DEBUG
struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
#endif
