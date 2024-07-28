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
        
        let category = TrackerCategory(name: name, trackers: [])
        categories.append(category)
    }
}
