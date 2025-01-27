//
//  DDActivityTrackerApp.swift
//  DDActivityTracker
//
//  Created by joe on 1/27/25.
//

import SwiftUI
import SwiftData

@main
struct DDActivityTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ActivityView()
        }
        .modelContainer(for: Activity.self)
    }
}
