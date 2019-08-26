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
    var content: String = ""
    var is_active: Bool = true
    
    enum TaskKeys: CodingKey{
        case id
        case name
        case schedule
        case run_hour
        case run_day
        case done
        case content
        case is_active
    }
    
}

extension Task {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TaskKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        schedule = try container.decode(Schedule.self, forKey: .schedule)
        run_hour = try container.decode(Int.self, forKey: .run_hour)
        run_day = try container.decodeIfPresent(Int.self, forKey: .run_day) ?? nil
        done = try container.decodeIfPresent(Bool.self, forKey: .done) ?? false
        content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        is_active = try container.decodeIfPresent(Bool.self, forKey: .is_active) ?? true
    }
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
