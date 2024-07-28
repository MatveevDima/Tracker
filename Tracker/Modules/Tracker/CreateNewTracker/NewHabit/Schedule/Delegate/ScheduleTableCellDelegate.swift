//
//  ScheduleTableCellDelegate.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 28.07.2024.
//

import UIKit

protocol ScheduleTableCellDelegate: AnyObject {
    func didToggleSwitch(day: WeekDay, isOn: Bool)
}
