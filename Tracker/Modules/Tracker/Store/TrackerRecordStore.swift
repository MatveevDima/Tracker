//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 18.09.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
}
