//
//  CreateNewHabitViewController.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 25.07.2024.
//

import UIKit

final class CreateNewHabitViewController : UIViewController {
    
    weak var delegate: CreateNewTrackerProtocol? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

    // MARK: CreateNewTrackerDelegate
extension CreateNewHabitViewController: CreateNewTrackerDelegate {
  
    
}
