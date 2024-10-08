//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 23.07.2024.
//

import Foundation

struct TrackerCategory : Equatable {
    
    let id: UUID
    let name: String
    var trackers: [Tracker]
    
    init(id: UUID, name: String, trackers: [Tracker]) {
        self.id = id
        self.name = name
        self.trackers = trackers
    }
    
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
