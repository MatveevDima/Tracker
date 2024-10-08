//
//  CreateNewHabitProtocol.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 26.07.2024.
//

import UIKit

protocol CreateNewHabitProtocol : AnyObject {
    
    func setPickedCategoy(_ category: TrackerCategory?)
    
    func setPickedSchedule(_ weekDays: Set<WeekDay>)
    
    func setPickedEmoji(_ emoji: String?)
    
    func setPickedColor(_ color: UIColor?)
}
