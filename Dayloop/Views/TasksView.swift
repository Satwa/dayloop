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
    
    var body: some View {
        NavigationView{
            ZStack{
//                Color.init("backgroundColor").edgesIgnoringSafeArea(.all)
                VStack{
                    NavigationLink(destination: AddTaskView()){
                        Text("Add task")
                    }
                    // TODO: Picker: Show today's tasks | Show all tasks
                    List{
                        ForEach(self.tasksManager.tasks){ task in
                            HStack{
                                VStack{
                                    Text(task.name)
                                        .font(.body)
                                    Text(task.schedule.rawValue)
                                        .font(.caption)
                                }
                                Spacer()
                                Text("\(task.run_hour)")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete(perform: self.deleteTask)
                    }
                }
            }
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
