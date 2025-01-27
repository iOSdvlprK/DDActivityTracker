//
//  ActivityModel.swift
//  DDActivityTracker
//
//  Created by joe on 1/27/25.
//

import Foundation
import SwiftData

@Model
class Activity {
    @Attribute(.unique) var id: String = UUID().uuidString
    
    var name: String
    var hoursPerDay: Double
    
    init(id: String, name: String, hoursPerDay: Double = 0.0) {
        self.id = id
        self.name = name
        self.hoursPerDay = hoursPerDay
    }
}
