//
//  ContentView.swift
//  Dayloop
//
//  Created by Joshua Tabakhoff on 16/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var tasksManager: TasksStorageManager
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    @State var name: String = ""
    @State var segment: Int = 0
    @State var hour: Int = 8
    @State var day: Int = 1
    
    var body: some View {
        Form {
            TextField("Task name", text: $name)
            Picker("Type", selection: $segment){
                Text("Daily").tag(0)
                Text("Weekly").tag(1)
                Text("Monthly").tag(2)
            }
            Stepper(value: $hour, in: 0...23) {
                Text("Run at \(hour)")
            }
            segment > 0 ?
                segment == 1 ? ViewBuilder.buildEither(first: Picker("Day", selection: $day){
                    Text("Monday").tag(0)
                    Text("Tuesday").tag(1)
                    Text("Wednesday").tag(2)
                    Text("Thursday").tag(3)
                    Text("Friday").tag(4)
                    Text("Saturday").tag(5)
                    Text("Sunday").tag(6)
                }) : ViewBuilder.buildEither(second: Stepper(value: $day, in: 1...31) {
                    Text("Run on \(day)")
                })
            : nil
        }
        .navigationBarItems(trailing: Button("Save"){
            var scheduleType: Schedule = .daily
            if self.segment == 1 {
                scheduleType = .weekly
            }else if self.segment == 2 {
                scheduleType = .monthly
            }
            self.tasksManager.addTask(task: Task(name: self.name, schedule: scheduleType, run_hour: self.hour, run_day: self.day))
            self.presentationMode.value.dismiss()
        })
    }
}

#if DEBUG
struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
#endif
