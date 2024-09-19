//
//  TrackerRecordCoreData+CoreDataProperties.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 19.09.2024.
//

import Foundation
import CoreData


extension TrackerRecordCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        return NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var trackerId: UUID?

}

extension TrackerRecordCoreData : Identifiable {

}
