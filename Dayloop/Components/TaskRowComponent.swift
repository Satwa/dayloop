//
//  TaskRowComponent.swift
//  Dayloop
//
//  Created by Joshua Tabakhoff on 20/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct TaskRowComponent: View {
    @Binding var task: Task
    
    var body: some View {
        HStack{
            CheckboxComponent(checked: $task.done)
            VStack(alignment: .leading){
                Text(task.name)
                    .layoutPriority(1)
                    .font(.body)
                Text("\(task.schedule.rawValue)")
                    .font(.caption)
            }
            .layoutPriority(1)
            Spacer()
            Text("\(task.run_hour)hr")
                .foregroundColor(.gray)
        }
    }
}

struct TaskRowComponent_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowComponent(task: .constant(Task(name: "Demo task", schedule: .daily, run_hour: 8)))
    }
}
