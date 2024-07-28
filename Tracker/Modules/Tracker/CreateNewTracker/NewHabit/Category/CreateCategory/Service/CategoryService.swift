//
//  CategoryService.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 27.07.2024.
//

import UIKit

final class CategoryService {
    
    static let shared: CategoryService = CategoryService()
    
    var categories: [TrackerCategory] = []
    
    private init() {}
    
    func createNewCategory(category name: String) {
        guard !categories.contains(where: { $0.name == name }) else { return }
        let category = TrackerCategory(name: name, trackers: [])
        categories.append(category)
    }
    
    func addTrackerToCategory(_ tracker: Tracker, categoryName: String) {
        
        if let index = categories.firstIndex(where: { $0.name == categoryName }) {
            categories[index].trackers.append(tracker)
        } else {
            let newCategory = TrackerCategory(name: categoryName, trackers: [tracker])
            categories.append(newCategory)
        }
    }
    
    func fetchCategories() -> [TrackerCategory] {
        return categories
    }
}
