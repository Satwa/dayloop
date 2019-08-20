//
//  TaskModel.swift
//  Dayloop
//
//  Created by Joshua Tabakhoff on 16/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation

struct Task: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var schedule: Schedule
    var run_hour: Int
    var run_day: Int?
    var done: Bool? = false
}


enum Schedule: String, Codable {
    case daily // +hr
    case weekly // +day+hr
    case monthly // +day+hr
}

struct DailyCache: Codable {
    var day: String
    var tasks: [Task]
}
