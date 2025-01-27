//
//  ActivityView.swift
//  DDActivityTracker
//
//  Created by joe on 1/27/25.
//

import SwiftUI
import Charts
import SwiftData

struct ActivityView: View {
    @Query(sort: \Activity.name, order: .forward)
    var activities: [Activity]
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Activity Tracker")
            }
            .padding()
            .navigationTitle("Activity Tracker")
        }
    }
}

#Preview {
    ActivityView()
        .modelContainer(for: Activity.self)
}
