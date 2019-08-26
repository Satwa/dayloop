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
    @State var content: String = ""
    @State var segment: Int = 0
    @State var hour: Int = 8
    @State var day: Int = 1
    @State var showError: Bool = false
    
    var body: some View {
        Form {
            Section{
                TextField("Task name", text: $name)
                    .alert(isPresented: $showError){
                        Alert(title: Text("Error occured"), message: Text("You should fill the name field first!"), dismissButton: .default(Text("OK")))
                    }

                
                Picker("Type", selection: $segment){
                    Text("Daily").tag(0)
                    Text("Weekly").tag(1)
                    Text("Monthly").tag(2)
                    // TODO: run on weekdays
                    // TODO: run every X days
                    // TODO: run on weekend
                    // TODO: change in multiple day selection for weekly
                }
                Stepper(value: $hour, in: 0...23) {
                    Text("Run at \(hour)")
                }
                segment > 0 ?
                    segment == 1 ? ViewBuilder.buildEither(first: Picker("Run on", selection: $day){
                        Text("Monday").tag(2)
                        Text("Tuesday").tag(3)
                        Text("Wednesday").tag(4)
                        Text("Thursday").tag(5)
                        Text("Friday").tag(6)
                        Text("Saturday").tag(7)
                        Text("Sunday").tag(1)
                    }) : ViewBuilder.buildEither(second: Stepper(value: $day, in: 1...31) {
                        Text("Run on \(day)")
                    })
                : nil
            }
            
            Section{
                TextField("Description", text: $content)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
        }
        
        .navigationBarItems(trailing: Button("Save"){
            var scheduleType: Schedule = .daily
            if self.segment == 1 {
                scheduleType = .weekly
            }else if self.segment == 2 {
                scheduleType = .monthly
            }
            if self.name != "" {
                self.tasksManager.addTask(task: Task(name: self.name, schedule: scheduleType, run_hour: self.hour, run_day: self.day, content: self.content))
                self.presentationMode.wrappedValue.dismiss()
            } else {
                self.showError = true
            }
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
