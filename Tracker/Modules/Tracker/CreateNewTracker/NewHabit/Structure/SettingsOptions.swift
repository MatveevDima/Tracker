//
//  SettingsOptions.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 25.07.2024.
//

import Foundation

struct SettingsOptions {
    
    let name: String
    var pickedParameter: String?
    let complete: () -> Void
}
