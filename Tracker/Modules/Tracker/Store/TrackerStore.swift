//
//  TrackerStore.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 18.09.2024.
//

import UIKit
import CoreData

final class TrackerStore {
    
    static let shared = TrackerStore()
    
    private let categoryStore = TrackerCategoryStore.shared
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func convertToTracker(coreDataTracker: TrackerCoreData) -> Tracker {
        let id = coreDataTracker.id!
        let name = coreDataTracker.name!
        let colour = UIColor(named: coreDataTracker.colour!)!.cgColor
        let emoji = coreDataTracker.emoji!
        let schedule = coreDataTracker.schedule?.schedule
        return  Tracker(id: id, name: name, color: colour, emoji: emoji, schedule: schedule)
    }

    func saveTrackerCoreData(_ tracker: Tracker, toCategory category: TrackerCategory) {
        let newTracker = TrackerCoreData(context: context)
        
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.colour = UIColor(cgColor: tracker.color).name!
        if let schedule = tracker.schedule {
            newTracker.schedule = DaysValue(schedule: schedule)
        }
        let fetchedCategory = categoryStore.fetchCategoryWithId(category.id)
        newTracker.category = fetchedCategory
        
        do {
            try self.context.save()
        }
        catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func fetchTrackerWithId(_ id: UUID) -> TrackerCoreData {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        request.returnsObjectsAsFaults = false
        let uuid = id.uuidString
        
        request.predicate = NSPredicate(format: "id == %@", uuid)
        let tracker = try! context.fetch(request)
        
        return tracker[0]
        
    }
    
    func fetchTrackersOfCategory(_ category: TrackerCategoryCoreData) -> [TrackerCoreData] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "category == %@", category)
        let trackers = try! context.fetch(request)
        
        return trackers
    }
    
    private func fetchTrackers() -> [TrackerCoreData] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        request.returnsObjectsAsFaults = false
        
        let trackers = try! context.fetch(request)
        
        return trackers
        
    }
    
    func convertToTrackers(_ coreData: [TrackerCoreData]) -> [Tracker] {
        var trackers: [Tracker] = []
        for tracker in coreData {
            let converted = convertToTracker(coreDataTracker: tracker)
            trackers.append(converted)
        }
        return trackers
    }
    
    func getTrackers() -> [Tracker] {
        return convertToTrackers(fetchTrackers())
    }
    
    func getNumberOfTrackers() -> Int {
        
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        request.resultType = .countResultType
        
        let trackers = try! context.execute(request) as! NSAsynchronousFetchResult<NSFetchRequestResult>
        
        return trackers.finalResult![0] as! Int
    }
    
    func deleteTracker(withId id: UUID) {
        
        let tracker = fetchTrackerWithId(id)
        
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
        context.delete(tracker)
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
