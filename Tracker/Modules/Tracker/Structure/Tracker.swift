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
    let color: CGColor
    let emoji: String
    let schedule: Dictionary<String, String>
    
    init(id: UUID, name: String, color: CGColor, emoji: String, schedule: Dictionary<String, String>) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}
