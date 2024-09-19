//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 30.07.2024.
//

import UIKit

extension UIColor {
    
    static var ccRed: UIColor { UIColor(named: "collection_color_red") ?? UIColor.collectionColorRed }
    static var ccOrange: UIColor { UIColor(named: "collection_color_orange") ?? UIColor.collectionColorOrange }
    static var ccBlue: UIColor { UIColor(named: "collection_color_blue") ?? UIColor.collectionColorBlue }
    static var ccPurple: UIColor { UIColor(named: "collection_color_purple") ?? UIColor.collectionColorPurple }
    static var ccGreen: UIColor { UIColor(named: "collection_color_green") ?? UIColor.collectionColorGreen }
    static var ccPink: UIColor { UIColor(named: "collection_color_pink") ?? UIColor.collectionColorPink }
    static var ccNude: UIColor { UIColor(named: "collection_color_nude") ?? UIColor.collectionColorNude }
    static var ccLightBlue: UIColor { UIColor(named: "collection_color_light_blue") ?? UIColor.collectionColorLightBlue }
    static var ccLightGreen: UIColor { UIColor(named: "collection_color_light_green") ?? UIColor.collectionColorLightGreen }
    static var ccDarkPurple: UIColor { UIColor(named: "collection_color_dark_purple") ?? UIColor.collectionColorDarkPurple }
    static var ccDarkOrange: UIColor { UIColor(named: "collection_color_dark_orange") ?? UIColor.collectionColorDarkOrange }
    static var ccLightPink: UIColor { UIColor(named: "collection_color_light_pink") ?? UIColor.collectionColorLightPink }
    static var ccBeige: UIColor { UIColor(named: "collection_color_beige") ?? UIColor.collectionColorBeige }
    static var ccLilo: UIColor { UIColor(named: "collection_color_lilo") ?? UIColor.collectionColorLilo }
    static var ccDarkLilo: UIColor { UIColor(named: "collection_color_dark_lilo") ?? UIColor.collectionColorDarkLilo }
    static var ccDarkPink: UIColor { UIColor(named: "collection_color_dark_pink") ?? UIColor.collectionColorDarkPink }
    static var ccLightPurple: UIColor { UIColor(named: "collection_color_light_purple") ?? UIColor.collectionColorLightPurple }
    static var ccDarkGreen: UIColor { UIColor(named: "collection_color_dark_green") ?? UIColor.collectionColorDarkGreen }
}

extension UIColor {
    var name: String? {
        switch self {
        case UIColor(named: "collection_color_red"): return "collection_color_red"
        case UIColor(named: "collection_color_orange"): return "collection_color_orange"
        case UIColor(named: "collection_color_blue"): return "collection_color_blue"
        case UIColor(named: "collection_color_purple"): return "collection_color_purple"
        case UIColor(named: "collection_color_green"): return "collection_color_green"
        case UIColor(named: "collection_color_pink"): return "collection_color_pink"
        case UIColor(named: "collection_color_nude"): return "collection_color_nude"
        case UIColor(named: "collection_color_light_blue"): return "collection_color_light_blue"
        case UIColor(named: "collection_color_light_green"): return "collection_color_light_green"
        case UIColor(named: "collection_color_dark_purple"): return "collection_color_dark_purple"
        case UIColor(named: "collection_color_dark_orange"): return "collection_color_dark_orange"
        case UIColor(named: "collection_color_light_pink"): return "collection_color_light_pink"
        case UIColor(named: "collection_color_beige"): return "collection_color_beige"
        case UIColor(named: "collection_color_lilo"): return "collection_color_lilo"
        case UIColor(named: "collection_color_dark_lilo"): return "collection_color_dark_lilo"
        case UIColor(named: "collection_color_dark_pink"): return "collection_color_dark_pink"
        case UIColor(named: "collection_color_light_purple"): return "collection_color_light_purple"
        case UIColor(named: "collection_color_dark_green"): return "collection_color_dark_green"
    
        default: return nil
        }
    }
}
