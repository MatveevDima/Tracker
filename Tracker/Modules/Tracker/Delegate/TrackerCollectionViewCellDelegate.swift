//
//  TrackerCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 10.10.2024.
//

import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    
    func markComplete(with id: UUID)
    func undoMarkComplete(with id: UUID)
    func deleteTracker(withId id: UUID)
    func pinTracker(withId id: UUID)
    func editTracker(withId id: UUID)
}
