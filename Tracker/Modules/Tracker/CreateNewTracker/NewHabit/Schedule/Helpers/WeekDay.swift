//
//  WeekDay.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 28.07.2024.
//

import Foundation

enum WeekDay: String, CaseIterable, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var order: Int {
        switch self {
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        case .sunday: return 7
        }
    }
}

class DaysValue: NSObject, Codable {
    let schedule: Set<WeekDay>
    
    init(schedule: Set<WeekDay>) {
        self.schedule = schedule
        super.init()
    }
}

@objc
final class DaysValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? DaysValue else { return nil }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode(DaysValue.self, from: data as Data)
    }
    
    static func register() {
        let name = NSValueTransformerName(String(describing: DaysValueTransformer.self))
        ValueTransformer.setValueTransformer(DaysValueTransformer(), forName: name)
        print("DaysValueTransformer registered with name: \(name)")
    }
}


extension Set where Element == WeekDay {
    func sortedByOrder() -> [WeekDay] {
        return self.sorted { $0.order < $1.order }
    }
}
