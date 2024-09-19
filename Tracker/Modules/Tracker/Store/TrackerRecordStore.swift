//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 18.09.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    
    static let shared = TrackerRecordStore()
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore.shared
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getCompletedTrackers() -> [TrackerRecord] {
        return convertToTrackerRecord(coreDataRecords: fetchCompletedRecords())
    }
    
    private func fetchCompletedRecordsForDate(_ date: Date) -> [TrackerRecordCoreData] {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        do {
            records = try context.fetch(request)
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return records
    }
    
    func fetchCompletedRecordsForTracker(_ tracker: TrackerCoreData) -> [TrackerRecordCoreData] {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        let idString = tracker.id?.uuidString
        request.predicate = NSPredicate(format: "trackerId == %@", idString!)
        do {
            records = try context.fetch(request)
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return records
    }
    
    func deleteCompletedRecordsForTracker(_ tracker: TrackerCoreData) {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        let idString = tracker.id?.uuidString
        request.predicate = NSPredicate(format: "trackerId == %@", idString!)
        do {
            records = try context.fetch(request)
            for record in records {
                context.delete(record)
                do {
                    try self.context.save()
                }
                catch {
                    
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func fetchCompletedRecords() -> [TrackerRecordCoreData] {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        
        do {
            records = try context.fetch(request)
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return records
    }
    
    func getNumberOfCompletedTrackers() -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.resultType = .countResultType
        let trackers = try! context.execute(request) as! NSAsynchronousFetchResult<NSFetchRequestResult>
       
        guard let count = trackers.finalResult else { return 0 }
        return count[0] as! Int
    }
    
    private func convertToTrackerRecord(coreDataRecords: [TrackerRecordCoreData]) -> [TrackerRecord] {
        
        var trackerRecords: [TrackerRecord] = []
        for trackerRecord in coreDataRecords {
            let tracker = trackerStore.convertToTracker(coreDataTracker: trackerStore.fetchTrackerWithId(trackerRecord.trackerId!))
            let newRecord = TrackerRecord(trackerId: tracker.id, date: trackerRecord.date!)
            trackerRecords.append(newRecord)
        }
        return trackerRecords
    }
    
    func saveTrackerRecordCoreData(_ trackerRecord: TrackerRecord) {
        
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        
        newTrackerRecord.trackerId = trackerRecord.trackerId
        newTrackerRecord.date = trackerRecord.date
        
        
        do {
            try self.context.save()
        }
        catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteTrackerRecord(with id: UUID, on date: Date) {
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        let idString = id.uuidString
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@ AND %K BETWEEN {%@, %@}",
                                        #keyPath(TrackerRecordCoreData.trackerId), idString,
                                        #keyPath(TrackerRecordCoreData.date), startOfDay as NSDate,
                                        Date() as NSDate
        )
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object)
            }
        }
        
        do {
            try context.save()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func getSortedrecords() -> [[String: Any]] {
        let keypathExp = NSExpression(forKeyPath: "date") // can be any column
        let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
        
        let countDesc = NSExpressionDescription()
        countDesc.expression = expression
        countDesc.name = "count"
        countDesc.expressionResultType = .integer64AttributeType
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.propertiesToGroupBy = ["date"]
        request.propertiesToFetch = ["date", countDesc]
        request.resultType = .dictionaryResultType
        
        let trackerRecords = try! context.execute(request) as! NSAsynchronousFetchResult<NSFetchRequestResult>
        guard let records = trackerRecords.finalResult else { return [] }
        return records as! [[String: Any]]
    }
    
    private func checkStreak(of dateArray: [Date]) -> Int{
        let dates = dateArray.sorted()
        guard dates.count > 0 else { return 0 }
        let referenceDate = Calendar.current.startOfDay(for: dates.first!)
        let dayDiffs = dates.map { (date) -> Int in
                Calendar.current.dateComponents([.day], from: referenceDate, to: date).day!
            }
        return maximalConsecutiveNumbers(in: dayDiffs)
    }
    
    private func maximalConsecutiveNumbers(in array: [Int]) -> Int{
        
        var longest = 0
        var current = 1
        for (prev, next) in zip(array, array.dropFirst()) {
        
            if next > prev + 1 {
                    current = 1
                } else if next == prev + 1 {
                    current += 1
                }
        
            if current > longest {
                    longest = current
                }
            }
        return longest
    }
}
