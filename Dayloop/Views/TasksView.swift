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
            VStack{
                NavigationLink(destination: AddTaskView()){
                    Text("Add task")
                }
                List(tasksManager.tasks){ task in
                    HStack{
                        Text(task.name)
                        Spacer()
                    }
                }
            }
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
