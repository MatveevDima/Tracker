//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 18.09.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    
    private let context: NSManagedObjectContext
    
    var coreDataCategories: [TrackerCategoryCoreData]?
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getCategories() -> [TrackerCategory] {
        return transformCoreDataCategories(fetchCoreDataCategories())
    }
    
    func transformCoreDatacategory(_ category: TrackerCategoryCoreData) -> TrackerCategory {
        let id = category.id!
        let name = category.name!
        var trackers: [Tracker] = []
        let alltrackers = category.trackers?.allObjects as! [TrackerCoreData]
        for tracker in alltrackers {
            if let id = tracker.id, let name = tracker.name, let emoji = tracker.emoji, let colour = UIColor(named: tracker.colour!), let schedule = tracker.schedule?.schedule  {
                let newTracker = Tracker(id: id, name: name, color: colour, emoji: emoji, schedule: schedule)
                trackers.append(newTracker)
            }
            
        }
        return TrackerCategory(id: id, name: name, trackers: trackers)
    }
    
    func transformCoreDataCategories(_ categories: [TrackerCategoryCoreData]) -> [TrackerCategory] {
        var trackerCategories: [TrackerCategory] = []
        for category in categories {
            let id = category.id!
            let name = category.name!
            var trackers: [Tracker] = []
            let allTrackers = category.trackers?.allObjects as? [TrackerCoreData]
            
            for tracker in allTrackers! {
                let id = tracker.id!
                let name = tracker.name!
                let emoji = tracker.emoji!
                let colour = UIColor(named: tracker.colour!)!
                let schedule = tracker.schedule?.schedule
                let newTracker = Tracker(id: id, name: name, color: colour, emoji: emoji, schedule: schedule)
                trackers.append(newTracker)
            }
            let newCategory = TrackerCategory(id: id, name: name, trackers: trackers)
            trackerCategories.append(newCategory)
        }
        return trackerCategories
    }
    
    func fetchCoreDataCategories() -> [TrackerCategoryCoreData] {
        var categories: [TrackerCategoryCoreData] = []
        do {
            categories = try context.fetch(TrackerCategoryCoreData.fetchRequest())
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return categories
    }
    
    func saveCategoryToCoreData(_ category: TrackerCategory) {
        
        if !isCategoryInCoreData(category) {
            
            let newCategory = TrackerCategoryCoreData(context: context)
            
            newCategory.id = category.id
            newCategory.name = category.name
            
            do {
                try self.context.save()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func isCategoryInCoreData(_ category: TrackerCategory) -> Bool {
        var categories: [TrackerCategoryCoreData] = []
        do {
            categories = try context.fetch(TrackerCategoryCoreData.fetchRequest())
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        if categories.contains(where: { $0.id == category.id}) {
            return true
        } else {
            return false
        }
    }
    
    func fetchCategoryWithId(_ id: UUID) -> TrackerCategoryCoreData {
        
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        let uuid = id.uuidString
        
        request.predicate = NSPredicate(format: "id == %@", uuid)
        let category = try! context.fetch(request)
        
        return category.first!
    }
    
    func fetchCategoryWithName(_ name: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "name == %@", name)
        let category = try! context.fetch(request)
        
        if category.count > 0 {
            return category[0]
        } else {
            return nil
        }
    }
    
    func renameCategory(_ id: UUID, newName: String) {
        let category = fetchCategoryWithId(id)
        category.name = newName
        
        do {
            try self.context.save()
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteCategory(_ id: UUID) {
        let category = fetchCategoryWithId(id)
        
        if let trackers = category.trackers?.allObjects as? [TrackerCoreData] {
            for tracker in trackers {
                var records: [TrackerRecordCoreData] = []
                let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
                request.returnsObjectsAsFaults = false
                request.predicate = NSPredicate(format: "tracker == %@", tracker)
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

            }
        }
        context.delete(category)
        do {
            try context.save()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
