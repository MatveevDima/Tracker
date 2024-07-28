//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 23.07.2024.
//

import Foundation

struct TrackerCategory {
    
    let name: String
    let trackers: [Tracker]
    
    init(name: String, trackers: [Tracker]) {
        self.name = name
        self.trackers = trackers
    }
}
