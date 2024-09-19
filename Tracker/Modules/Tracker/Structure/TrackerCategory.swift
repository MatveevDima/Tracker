//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 23.07.2024.
//

import Foundation

struct TrackerCategory {
    
    let id: UUID
    let name: String
    var trackers: [Tracker]
    
    init(id: UUID, name: String, trackers: [Tracker]) {
        self.id = id
        self.name = name
        self.trackers = trackers
    }
}
