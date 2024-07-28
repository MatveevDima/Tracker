//
//  CategoryDelegate.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 27.07.2024.
//

import UIKit

protocol CategoryDelegate {
    
    var delegate: CategoryViewControllerProtocol? { get set }
    
    func didCreatedNewCategory()
}
