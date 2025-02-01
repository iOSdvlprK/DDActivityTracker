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
    
    var totalHours: Double {
        var hours = 0.0
        for activity in activities {
            hours += activity.hoursPerDay
        }
        return hours
    }
    
    var remainingHours: Double {
        24 - totalHours
    }
    
    var maxHoursOfSelected: Double {
        remainingHours + hoursPerDay
    }
    
    let step = 1.0
    
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
                .chartAngleSelection(value: $selectCount)
                
                List(activities) { activity in
                    ActivityRow(activity: activity)
                        .onTapGesture {
                            withAnimation {
                                currentActivity = activity
                                hoursPerDay = activity.hoursPerDay
                            }
                        }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                
                // text field
                TextField("Enter new activity", text: $newName)
                    .padding()
                    .background(Color.blue.gradient.opacity(0.3))
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                
                // slider
                if let currentActivity {
                    Slider(value: $hoursPerDay, in: 0...maxHoursOfSelected, step: step)
                        .onChange(of: hoursPerDay) { oldValue, newValue in
                            // TODO: implement
                            
                        }
                }
                
                Button("Add") {
                    addActivity()
                }
                .buttonStyle(.borderedProminent)
                .disabled(remainingHours <= 0)
            }
            .padding()
            .navigationTitle("Activity Tracker")
        }
    }
    
    private func addActivity() {
        if newName.count > 2 && !activities.contains(where: { $0.name.lowercased() == newName.lowercased() }) {
            // go ahead and add activity
            let activity = Activity(name: newName, hoursPerDay: hoursPerDay)
            
            // add new activity
            context.insert(activity)
            
            // reset new name
            newName = ""
            
            currentActivity = activity
        }
    }
    
    private func deleteActivity(at offsets: IndexSet) {
        // TODO: deleteActivity
    }
}

#Preview {
    ActivityView()
        .modelContainer(for: Activity.self)
}
