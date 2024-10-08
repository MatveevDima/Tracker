//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 01.10.2024.
//

import UIKit

final class CategoryViewModel {
    
    weak var delegate: CreateNewHabitProtocol?
    private let categoryStore = TrackerCategoryStore.shared
    var selectedCategory: TrackerCategory?
    var onChange: (() -> Void)?
    
    private (set) var categories: [TrackerCategory] = [] {
        didSet {
            onChange?()
        }
    }
    
    func getCategories() {
        categories = categoryStore.getCategories()
    }
    
    func categoriesNumber() -> Int {
        
        categories.count
    }
    
    func deleteCategory(_ item: TrackerCategory) {
        self.categoryStore.deleteCategory(item.id)
        getCategories()
    }
    
    func didSelectCategoryAt(indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        delegate?.setPickedCategoy(selectedCategory!)
    }
}
