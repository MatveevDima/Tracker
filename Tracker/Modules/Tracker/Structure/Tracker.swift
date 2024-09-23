//
//  Tracker.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 23.07.2024.
//

import UIKit

struct Tracker {
    
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDay>?
    
    init(id: UUID, name: String, color: UIColor, emoji: String, schedule: Set<WeekDay>?) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}
