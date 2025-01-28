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
    
    @State private var newName: String = ""
    @State private var hoursPerDay: Double = 0.0
    @State private var currentActivity: Activity? = nil
    
    @State private var selectCount: Int?
    
    var body: some View {
        NavigationStack {
            VStack {
                Chart {
                    let isSelected: Bool = true
                    
                    ForEach(activities) { activity in
                        SectorMark(
                            angle: .value("Activities", activity.hoursPerDay),
                            innerRadius: .ratio(0.6),
                            outerRadius: isSelected ? 1.05 : 0.95,
                            angularInset: 1
                        )
                        .foregroundStyle(Color.red)
                        .cornerRadius(20)
                    }
                    
                    SectorMark(
                        angle: .value("value", 5),
                        innerRadius: .ratio(0.6),
                        outerRadius: .ratio(0.95),
                        angularInset: 1)
                    .foregroundStyle(Color.red)
                    .cornerRadius(20)
                    
                    SectorMark(
                        angle: .value("value", 3),
                        innerRadius: .ratio(0.6),
                        outerRadius: .ratio(1.05),
                        angularInset: 1)
                    .foregroundStyle(Color.blue)
                    
                    SectorMark(
                        angle: .value("value", 17),
                        innerRadius: .ratio(0.6),
                        outerRadius: .ratio(0.95),
                        angularInset: 1)
                    .foregroundStyle(Color.green)
                }
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
