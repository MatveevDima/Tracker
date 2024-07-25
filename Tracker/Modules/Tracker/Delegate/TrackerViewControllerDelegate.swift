//
//  TrackerViewControllerDelegate.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 24.07.2024.
//

import UIKit

protocol TrackerViewControllerDelegate : AnyObject {
    
    var trackerViewController: TrackerViewControllerProtocol? { get set }
}
