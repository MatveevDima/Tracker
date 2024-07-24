//
//  CollectionParameters.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 24.07.2024.
//

import Foundation

struct CollectionParameters {
    let cellsNumber: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let interCellSpacing: CGFloat

    var widthInsets: CGFloat {
        return interCellSpacing * CGFloat(cellsNumber - 1) + leftInset + rightInset
    }
}
