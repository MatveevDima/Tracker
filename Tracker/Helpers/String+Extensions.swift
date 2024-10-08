//
//  String+Extensions.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 08.10.2024.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.dropFirst()
    }
}
