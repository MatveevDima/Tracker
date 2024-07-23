//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 23.07.2024.
//

import Foundation

struct TrackerCategory {
    
    let header: String
    let trackers: [Tracker]
    
    init(header: String, trackers: [Tracker]) {
        self.header = header
        self.trackers = trackers
    }
}
