//
//  CreateNewTrackerProtocol.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 25.07.2024.
//

import UIKit

protocol CreateNewTrackerProtocol : AnyObject{
    
    func didCreateNewHabit()
    
    func didCancelCreatingNewHabit()
}
