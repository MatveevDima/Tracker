//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 23.07.2024.
//

import Foundation

// - сущность для хранения записи о том, что некий трекер был выполнен на некоторую дату
struct TrackerRecord {
    
    let trackerId: UUID
    let date: Date
}
